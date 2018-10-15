// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKInsetLayoutBuilder.h"

#import <LayoutKitObjC/LayoutKitObjC-Swift.h>

@interface LOKInsetLayoutBuilder()

@property (nonatomic, nullable) LOKAlignment *privateAlignment;
@property (nonatomic, nullable) LOKFlexibility *privateFlexibility;
@property (nonatomic, nullable) NSString *privateViewReuseId;
@property (nonatomic, nullable) Class privateViewClass;

@property (nonatomic) LOKEdgeInsets privateInsets;
@property (nonatomic, nonnull) id<LOKLayout> privateSublayout;
@property (nonatomic, nullable) void (^ privateConfigure)(LOKView * _Nonnull);

@end

@implementation LOKInsetLayoutBuilder

- (instancetype)initWithInsets:(LOKEdgeInsets)insets around:(id<LOKLayout>)sublayout {
    self = [super init];
    _privateInsets = insets;
    _privateSublayout = sublayout;
    return self;
}

+ (nonnull instancetype)withInsets:(LOKEdgeInsets)insets around:(nonnull id<LOKLayout>)sublayout {
    return [[self alloc] initWithInsets:insets around:sublayout];
}

- (nonnull LOKInsetLayout *)layout {
    return [[LOKInsetLayout alloc] initWithInsets:self.privateInsets
                                        alignment:self.privateAlignment
                                      flexibility:self.privateFlexibility
                                      viewReuseId:self.privateViewReuseId
                                        viewClass:self.privateViewClass
                                        sublayout:self.privateSublayout
                                        configure:self.privateConfigure];
}

- (LOKInsetLayoutBuilder * _Nonnull (^)(LOKAlignment * _Nonnull))alignment {
    return ^LOKInsetLayoutBuilder *(LOKAlignment * alignment){
        self.privateAlignment = alignment;
        return self;
    };
}

- (LOKInsetLayoutBuilder * _Nonnull (^)(LOKFlexibility * _Nonnull))flexibility {
    return ^LOKInsetLayoutBuilder *(LOKFlexibility * flexibility){
        self.privateFlexibility = flexibility;
        return self;
    };
}

- (LOKInsetLayoutBuilder * _Nonnull (^)(NSString * _Nonnull))viewReuseId {
    return ^LOKInsetLayoutBuilder *(NSString * viewReuseId){
        self.privateViewReuseId = viewReuseId;
        return self;
    };
}

- (LOKInsetLayoutBuilder * _Nonnull (^)(Class _Nonnull))viewClass {
    return ^LOKInsetLayoutBuilder *(Class viewClass){
        self.privateViewClass = viewClass;
        return self;
    };
}

- (LOKInsetLayoutBuilder * _Nonnull (^)(void(^ _Nullable)(LOKView *_Nonnull)))config {
    return ^LOKInsetLayoutBuilder *(void(^ _Nullable config)(LOKView *_Nonnull)){
        self.privateConfigure = config;
        return self;
    };
}

- (LOKInsetLayoutBuilder * _Nonnull (^)(LOKEdgeInsets))insets {
    return ^LOKInsetLayoutBuilder *(LOKEdgeInsets insets){
        return [LOKInsetLayoutBuilder withInsets:insets around:self.layout];
    };
}

@end
