// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <LayoutKitObjC/LayoutKitObjC.h>
#import "ComponentHost.h"
#import "Component+Internal.h"

@interface ComponentHost ()
@property (nonatomic, assign, readwrite) BOOL needsUpdate;
@end

@implementation ComponentHost

- (void)notifyUpdateFromComponent:(nonnull Component *)component {
    NSAssert(NSThread.isMainThread, @"");
    NSAssert(component.owner == self, @"");
    [self setNeedsLayoutUpdate];
}

- (void)registerComponent:(nonnull Component *)component {
    NSAssert(NSThread.isMainThread, @"");
    NSAssert(component.owner == self, @"");
    self.component.owner = nil;
    self.component = component;
    self.component.owner = self;
    if (self.view != nil && self.component != nil) {
        [self setNeedsLayoutUpdate];
    }
}

- (void)registerComponents:(nonnull NSArray<Component *> *)components {
    NSAssert(components.count <= 1, @"Can only host one component at a time.");
    for (Component *component in components) {
        [self registerComponent:component];
    }
}

- (void)unregisterComponent:(nonnull Component *)component {
    NSAssert(NSThread.isMainThread, @"");
    NSAssert(component.owner != self, @"");
    self.component = nil;
    [self setNeedsLayoutUpdate];
}

- (void)hostInView:(UIView *)view {
    NSAssert(NSThread.isMainThread, @"");
    NSAssert(self.view == nil, @"");
    _view = view;
    [self setNeedsLayoutUpdate];
}

- (void)viewDidChangeSize {
    NSAssert(NSThread.isMainThread, @"");
    NSAssert(self.view != nil, @"");
    [self setNeedsLayoutUpdate];
}

-(void)viewWillChangeSizeTo:(CGSize)size {
    NSAssert(NSThread.isMainThread, @"");
    NSAssert(self.view != nil, @"");
    [self updateLayoutSynchronouslyForSize:size];
}

- (void)setInsets:(UIEdgeInsets)insets {
    _insets = insets;
    [self setNeedsLayoutUpdate];
}

/// Schedules layout and arrangement to be regenerated, if it's not already scheduled.
- (void)setNeedsLayoutUpdate {
    NSAssert(NSThread.isMainThread, @"");
    if (self.needsUpdate) {
        // An update must have already been scheduled.
        return;
    }
    self.needsUpdate = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.needsUpdate) {
            [self updateLayoutAsynchronouslyForSize:self.view.frame.size];
        }
    });
}


/// Produces an array of three tasks to execute to update the layout.
/// First and last task must be executed on the main queue.
/// Second task should be executed off the main queue if @c synchronous
/// parameter is set to NO.
/// All the produced tasks should be executed in order, or not at all.
- (NSArray<VoidVoidBlock>*)makeLayoutTasksForViewSize:(CGSize)size
                                          synchronous:(BOOL)synchronous
                                           completion:(nullable VoidVoidBlock)completion {

    // These variables transfer layout data data to the tasks.
    __block LayoutFunction _Nullable makeLayout = nil;
    __block LOKLayoutArrangement * _Nullable layoutArrangement = nil;
    __block UIEdgeInsets insets = self.insets;

    // These variables are for verifying that the hosting situation
    // hasn't radically changed since the layout request was issued.
    __block UIView * _Nullable startingView = nil;
    __block Component * _Nullable startingComponent = nil;

    // For the timing printout:
//    __block CFTimeInterval task0Time;
//    __block CFTimeInterval task1Time;
//    __block CFAbsoluteTime overallStartTime = CFAbsoluteTimeGetCurrent();

    VoidVoidBlock prepare = ^{
//        CFAbsoluteTime task0StartTime = CFAbsoluteTimeGetCurrent();
        NSAssert(NSThread.isMainThread, @"");
        NSAssert(self.view != nil, @"");
        NSAssert(self.component != nil, @"");
        self.needsUpdate = NO;
        if (self.view == nil || self.component == nil || size.width == 0 || size.height == 0) {
            makeLayout = nil;
            return;
        }
        startingView = self.view;
        startingComponent = self.component;
        if (synchronous) {
            makeLayout = ^id<LOKLayout> _Nonnull(){ return startingComponent.layout; };
        } else {
            makeLayout = [self.component prepareRootForWorkerThread];
        }
//        task0Time = CFAbsoluteTimeGetCurrent() - task0StartTime;
    };

    VoidVoidBlock constructLayout = ^{
//        CFAbsoluteTime task1StartTime = CFAbsoluteTimeGetCurrent();
        NSAssert(NSThread.isMainThread == synchronous, @"");
        NSAssert(makeLayout != nil, @"");
        if (!makeLayout) {
            return;
        }
        id<LOKLayout> layout = makeLayout();
        NSAssert(layout != nil, @"");
        if (!layout) {
            return;
        }
        id<LOKLayout> layoutWithInsets = [LOKInsetLayout insetBy:insets sublayout:layout];
        layoutArrangement = [LOKLayoutArrangement arrangeLayout:layoutWithInsets
                                                          width:size.width
                                                         height:size.height];
//        task1Time = CFAbsoluteTimeGetCurrent() - task1StartTime;
    };

    VoidVoidBlock applyLayout = ^{
        // Input: layoutArrangement
        // Also captured: startingView, startingComponent, insets and the timing values.
//        CFAbsoluteTime task2StartTime = CFAbsoluteTimeGetCurrent();
        NSAssert(NSThread.isMainThread, @"");
        NSAssert(layoutArrangement != nil, @"");
        NSAssert(self.component == startingComponent, @"");
        NSAssert(self.view == startingView, @"");
        NSAssert(UIEdgeInsetsEqualToEdgeInsets(self.insets, insets), @"");
        if (self.component == startingComponent && self.view == startingView) {
            // TODO verify that there haven't been subsequent requests
            if (self.view != nil) {
                [layoutArrangement makeViewsIn:self.view];
            }
        }
//        CFAbsoluteTime task2EndTime = CFAbsoluteTimeGetCurrent();
//        CFTimeInterval task2Time = task2EndTime - task2StartTime;
//        CFTimeInterval overallTime = task2EndTime - overallStartTime;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"%@\nprep: %0.1fms\nlayout: %0.1fms\nviews: %0.1fms\noverall:%0.1fms",
//                  NSStringFromClass([self.component class]),
//                  task0Time * 1000, task1Time * 1000, task2Time * 1000, overallTime * 1000);
//        });
        if (completion) {
            completion();
        }
    };

    return @[prepare, constructLayout, applyLayout];
}

- (void)updateLayoutSynchronouslyForSize:(CGSize)size {
    __auto_type tasks = [self makeLayoutTasksForViewSize:size synchronous:YES completion:nil];
    tasks[0]();
    tasks[1]();
    tasks[2]();
}

- (void)updateLayoutAsynchronouslyForSize:(CGSize)size {
    static dispatch_queue_t background_worker_queue = 0;
    background_worker_queue = background_worker_queue ?: dispatch_queue_create("layout component queue", DISPATCH_QUEUE_SERIAL);

    __auto_type tasks = [self makeLayoutTasksForViewSize:size synchronous:NO completion:nil];

    tasks[0]();
    dispatch_async(background_worker_queue, ^{
        tasks[1]();
        dispatch_async(dispatch_get_main_queue(), ^{
            tasks[2]();
        });
    });
}

- (NSArray<VoidVoidBlock> *)makeAsyncLayoutTasksForViewSize:(CGSize)size
                                                 completion:(VoidVoidBlock)completion {
    return [self makeLayoutTasksForViewSize:size synchronous:NO completion:completion];
}

@end
