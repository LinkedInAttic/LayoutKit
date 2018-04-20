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
