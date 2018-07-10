// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKOverlayLayoutBuilder.h"

#import <LayoutKitObjC/LayoutKitObjC-Swift.h>

@interface LOKOverlayLayoutBuilder ()

@property (nonatomic, nullable) LOKAlignment *privateAlignment;
@property (nonatomic, nullable) LOKFlexibility *privateFlexibility;
@property (nonatomic, nullable) NSString *privateViewReuseId;
@property (nonatomic, nullable) Class privateViewClass;

@property (nonatomic, nonnull) NSArray< id<LOKLayout> > *privatePrimary;
@property (nonatomic, nonnull) NSArray< id<LOKLayout> > *privateOverlay;
@property (nonatomic, nonnull) NSArray< id<LOKLayout> > *privateBackground;
@property (nonatomic, nullable) void (^ privateConfigure)(LOKView * _Nonnull);

@end

@implementation LOKOverlayLayoutBuilder

- (instancetype)initWithPrimaryLayouts:(NSArray< id<LOKLayout> > *)primaryLayouts {
    self = [super init];
    _privatePrimary = primaryLayouts;
    _privateBackground = @[];
    _privateOverlay = @[];
    return self;
}

- (instancetype)initWithPrimaryLayout:(id<LOKLayout>)primaryLayout {
    return [self initWithPrimaryLayouts:@[primaryLayout]];
}

+ (instancetype)withPrimaryLayouts:(NSArray< id<LOKLayout> > *)primaryLayouts {
    return [[self alloc] initWithPrimaryLayouts:primaryLayouts];
}

+ (instancetype)withPrimaryLayout:(id<LOKLayout>)primaryLayout {
    return [[self alloc] initWithPrimaryLayout:primaryLayout];
}

- (LOKOverlayLayout *)layout {
    return [[LOKOverlayLayout alloc] initWithPrimaries:self.privatePrimary
                                            background:self.privateBackground
                                               overlay:self.privateOverlay
                                             alignment:self.privateAlignment
                                           viewReuseId:self.privateViewReuseId
                                             viewClass:self.privateViewClass
                                             configure:self.privateConfigure];
}

- (LOKOverlayLayoutBuilder * _Nonnull (^)(NSArray< id<LOKLayout> > * _Nullable))overlay {
    return ^LOKOverlayLayoutBuilder *(NSArray< id<LOKLayout> > * _Nullable overlay){
        self.privateOverlay = overlay;
        return self;
    };
}

- (LOKOverlayLayoutBuilder * _Nonnull (^)(NSArray< id<LOKLayout> > * _Nullable))background {
    return ^LOKOverlayLayoutBuilder *(NSArray< id<LOKLayout> > * _Nullable background){
        self.privateBackground = background;
        return self;
    };
}

- (LOKOverlayLayoutBuilder * _Nonnull (^)(LOKAlignment * _Nonnull))alignment {
    return ^LOKOverlayLayoutBuilder *(LOKAlignment * alignment){
        self.privateAlignment = alignment;
        return self;
    };
}

- (LOKOverlayLayoutBuilder * _Nonnull (^)(LOKFlexibility * _Nonnull))flexibility {
    return ^LOKOverlayLayoutBuilder *(LOKFlexibility * flexibility){
        self.privateFlexibility = flexibility;
        return self;
    };
}

- (LOKOverlayLayoutBuilder * _Nonnull (^)(NSString * _Nonnull))viewReuseId {
    return ^LOKOverlayLayoutBuilder *(NSString * viewReuseId){
        self.privateViewReuseId = viewReuseId;
        return self;
    };
}

- (LOKOverlayLayoutBuilder * _Nonnull (^)(Class _Nonnull))viewClass {
    return ^LOKOverlayLayoutBuilder *(Class viewClass){
        self.privateViewClass = viewClass;
        return self;
    };
}

- (LOKOverlayLayoutBuilder * _Nonnull (^)(void(^ _Nullable)(LOKView *_Nonnull)))config {
    return ^LOKOverlayLayoutBuilder *(void(^ _Nullable config)(LOKView *_Nonnull)){
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
