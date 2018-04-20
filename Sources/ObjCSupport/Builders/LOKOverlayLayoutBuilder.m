// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKOverlayLayoutBuilder.h"

#import <LayoutKitObjC/LayoutKitObjC-Swift.h>

@implementation LOKOverlayLayoutBuilder

+ (instancetype)withPrimaryLayout:(id<LOKLayout>)primaryLayout {
    LOKOverlayLayoutBuilder *builder = [[self alloc] init];
    builder.primary = primaryLayout;
    builder.background = @[];
    builder.overlay = @[];
    return builder;
}

- (LOKOverlayLayout *)build {
    return [[LOKOverlayLayout alloc] initWithPrimary:self.primary
                                          background:self.background
                                             overlay:self.overlay
                                           alignment:self.alignment
                                         viewReuseId:self.viewReuseId
                                           viewClass:self.viewClass
                                           configure:self.configure];
}

- (LOKOverlayLayoutBuilder * _Nonnull (^)(NSArray< id<LOKLayout> > * _Nullable))withOverlay {
    return ^LOKOverlayLayoutBuilder *(NSArray< id<LOKLayout> > * _Nullable overlay){
        self.overlay = overlay;
        return self;
    };
}

- (LOKOverlayLayoutBuilder * _Nonnull (^)(NSArray< id<LOKLayout> > * _Nullable))withBackground {
    return ^LOKOverlayLayoutBuilder *(NSArray< id<LOKLayout> > * _Nullable background){
        self.background = background;
        return self;
    };
}

- (LOKOverlayLayoutBuilder * _Nonnull (^)(LOKAlignment * _Nonnull))withAlignment {
    return ^LOKOverlayLayoutBuilder *(LOKAlignment * alignment){
        self.alignment = alignment;
        return self;
    };
}

- (LOKOverlayLayoutBuilder * _Nonnull (^)(LOKFlexibility * _Nonnull))withFlexibility {
    return ^LOKOverlayLayoutBuilder *(LOKFlexibility * flexibility){
        self.flexibility = flexibility;
        return self;
    };
}

- (LOKOverlayLayoutBuilder * _Nonnull (^)(NSString * _Nonnull))withViewReuseId {
    return ^LOKOverlayLayoutBuilder *(NSString * viewReuseId){
        self.viewReuseId = viewReuseId;
        return self;
    };
}

- (LOKOverlayLayoutBuilder * _Nonnull (^)(Class _Nonnull))withViewClass {
    return ^LOKOverlayLayoutBuilder *(Class viewClass){
        self.viewClass = viewClass;
        return self;
    };
}

- (LOKOverlayLayoutBuilder * _Nonnull (^)(void(^ _Nonnull)(View *_Nonnull)))withConfig {
    return ^LOKOverlayLayoutBuilder *(void(^ _Nonnull config)(View *_Nonnull)){
        self.configure = config;
        return self;
    };
}

@end
