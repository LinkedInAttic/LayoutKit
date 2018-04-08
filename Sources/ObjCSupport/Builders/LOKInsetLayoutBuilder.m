// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKInsetLayoutBuilder.h"

#import <LayoutKitObjC/LayoutKitObjC-Swift.h>

@implementation LOKInsetLayoutBuilder

+ (nonnull instancetype)withInsets:(EdgeInsets)insets around:(nonnull id<LOKLayout>)sublayout {
    LOKInsetLayoutBuilder *builder = [[self alloc] init];
    builder.insets = insets;
    builder.sublayout = sublayout;
    return builder;
}

- (nonnull LOKInsetLayout *)build {
    return [[LOKInsetLayout alloc] initWithInsets:self.insets
                                        alignment:self.alignment
                                      viewReuseId:self.viewReuseId
                                        viewClass:self.viewClass
                                        sublayout:self.sublayout
                                        configure:self.configure];
}

- (LOKInsetLayoutBuilder *)center {
    self.alignment = LOKAlignment.center;
    return self;
}

- (LOKInsetLayoutBuilder *)fill {
    self.alignment = LOKAlignment.fill;
    return self;
}

- (LOKInsetLayoutBuilder *)topCenter {
    self.alignment = LOKAlignment.topCenter;
    return self;
}

- (LOKInsetLayoutBuilder *)topFill {
    self.alignment = LOKAlignment.topFill;
    return self;
}

- (LOKInsetLayoutBuilder *)topLeading {
    self.alignment = LOKAlignment.topLeading;
    return self;
}

- (LOKInsetLayoutBuilder *)topTrailing {
    self.alignment = LOKAlignment.topTrailing;
    return self;
}

- (LOKInsetLayoutBuilder *)bottomCenter {
    self.alignment = LOKAlignment.bottomCenter;
    return self;
}

- (LOKInsetLayoutBuilder *)bottomFill {
    self.alignment = LOKAlignment.bottomFill;
    return self;
}

- (LOKInsetLayoutBuilder *)bottomLeading {
    self.alignment = LOKAlignment.bottomLeading;
    return self;
}

- (LOKInsetLayoutBuilder *)bottomTrailing {
    self.alignment = LOKAlignment.bottomTrailing;
    return self;
}

- (LOKInsetLayoutBuilder *)centerFill {
    self.alignment = LOKAlignment.centerFill;
    return self;
}

- (LOKInsetLayoutBuilder *)centerLeading {
    self.alignment = LOKAlignment.centerLeading;
    return self;
}

- (LOKInsetLayoutBuilder *)centerTrailing {
    self.alignment = LOKAlignment.centerTrailing;
    return self;
}

- (LOKInsetLayoutBuilder *)fillLeading {
    self.alignment = LOKAlignment.fillLeading;
    return self;
}

- (LOKInsetLayoutBuilder *)fillTrailing {
    self.alignment = LOKAlignment.fillTrailing;
    return self;
}

- (LOKInsetLayoutBuilder *)fillCenter {
    self.alignment = LOKAlignment.fillCenter;
    return self;
}

- (LOKInsetLayoutBuilder * _Nonnull (^)(LOKAlignment * _Nonnull))withAlignment {
    return ^LOKInsetLayoutBuilder *(LOKAlignment * alignment){
        self.alignment = alignment;
        return self;
    };
}

- (LOKInsetLayoutBuilder * _Nonnull (^)(LOKFlexibility * _Nonnull))withFlexibility {
    return ^LOKInsetLayoutBuilder *(LOKFlexibility * flexibility){
        self.flexibility = flexibility;
        return self;
    };
}

- (LOKInsetLayoutBuilder * _Nonnull (^)(NSString * _Nonnull))withViewReuseId {
    return ^LOKInsetLayoutBuilder *(NSString * viewReuseId){
        self.viewReuseId = viewReuseId;
        return self;
    };
}

- (LOKInsetLayoutBuilder * _Nonnull (^)(Class _Nonnull))withViewClass {
    return ^LOKInsetLayoutBuilder *(Class viewClass){
        self.viewClass = viewClass;
        return self;
    };
}

- (LOKInsetLayoutBuilder * _Nonnull (^)(void(^ _Nonnull)(View *_Nonnull)))withConfig {
    return ^LOKInsetLayoutBuilder *(void(^ _Nonnull config)(View *_Nonnull)){
        self.configure = config;
        return self;
    };
}

@end
