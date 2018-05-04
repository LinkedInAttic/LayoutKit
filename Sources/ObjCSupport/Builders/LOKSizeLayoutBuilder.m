// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKSizeLayoutBuilder.h"

#import <LayoutKitObjC/LayoutKitObjC-Swift.h>

@implementation LOKSizeLayoutBuilder

+ (instancetype)withSublayout:(id<LOKLayout>)sublayout {
    LOKSizeLayoutBuilder *builder = [[self alloc] init];
    builder.sublayout = sublayout;
    builder.minWidth = 0;
    builder.minHeight = 0;
    builder.maxWidth = INFINITY;
    builder.maxHeight = INFINITY;
    return builder;
}

- (CGFloat)width {
    NSAssert(self.maxWidth == self.minWidth, @"Can't retrieve a single width property when there's a range set.");
    return self.maxWidth;
}

- (void)setWidth:(CGFloat)width {
    self.minWidth = width;
    self.maxWidth = width;
}

- (CGFloat)height {
    NSAssert(self.maxHeight == self.minHeight, @"Can't retrieve a singular height property when there's a range set.");
    return self.maxHeight;
}

- (void)setHeight:(CGFloat)height {
    self.minHeight = height;
    self.maxHeight = height;
}

- (LOKSizeLayout *)build {
    return [[LOKSizeLayout alloc] initWithMinWidth:self.minWidth
                                          maxWidth:self.maxWidth
                                         minHeight:self.minHeight
                                         maxHeight:self.maxHeight
                                         alignment:self.alignment
                                       flexibility:self.flexibility
                                       viewReuseId:self.viewReuseId
                                         viewClass:self.viewClass
                                         sublayout:self.sublayout
                                         configure:self.configure];
}

- (LOKSizeLayoutBuilder * _Nonnull (^)(CGFloat))withWidth {
    return ^LOKSizeLayoutBuilder *(CGFloat width){
        self.width = width;
        return self;
    };
}

- (LOKSizeLayoutBuilder * _Nonnull (^)(CGFloat))withHeight {
    return ^LOKSizeLayoutBuilder *(CGFloat height){
        self.height = height;
        return self;
    };
}

- (LOKSizeLayoutBuilder * _Nonnull (^)(CGFloat))withMinWidth {
    return ^LOKSizeLayoutBuilder *(CGFloat minWidth){
        self.minWidth = minWidth;
        return self;
    };
}

- (LOKSizeLayoutBuilder * _Nonnull (^)(CGFloat))withMinHeight {
    return ^LOKSizeLayoutBuilder *(CGFloat minHeight){
        self.minHeight = minHeight;
        return self;
    };
}

- (LOKSizeLayoutBuilder * _Nonnull (^)(CGFloat))withMaxWidth {
    return ^LOKSizeLayoutBuilder *(CGFloat maxWidth){
        self.maxWidth = maxWidth;
        return self;
    };
}

- (LOKSizeLayoutBuilder * _Nonnull (^)(CGFloat))withMaxHeight {
    return ^LOKSizeLayoutBuilder *(CGFloat maxHeight){
        self.maxHeight = maxHeight;
        return self;
    };
}

- (LOKSizeLayoutBuilder * _Nonnull (^)(LOKAlignment * _Nonnull))withAlignment {
    return ^LOKSizeLayoutBuilder *(LOKAlignment * alignment){
        self.alignment = alignment;
        return self;
    };
}

- (LOKSizeLayoutBuilder * _Nonnull (^)(LOKFlexibility * _Nonnull))withFlexibility {
    return ^LOKSizeLayoutBuilder *(LOKFlexibility * flexibility){
        self.flexibility = flexibility;
        return self;
    };
}

- (LOKSizeLayoutBuilder * _Nonnull (^)(NSString * _Nonnull))withViewReuseId {
    return ^LOKSizeLayoutBuilder *(NSString * viewReuseId){
        self.viewReuseId = viewReuseId;
        return self;
    };
}

- (LOKSizeLayoutBuilder * _Nonnull (^)(Class _Nonnull))withViewClass {
    return ^LOKSizeLayoutBuilder *(Class viewClass){
        self.viewClass = viewClass;
        return self;
    };
}

- (LOKSizeLayoutBuilder * _Nonnull (^)(void(^ _Nullable)(View *_Nonnull)))withConfig {
    return ^LOKSizeLayoutBuilder *(void(^ _Nullable config)(View *_Nonnull)){
        self.configure = config;
        return self;
    };
}

@end
