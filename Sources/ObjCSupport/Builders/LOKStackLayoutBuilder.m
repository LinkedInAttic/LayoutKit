// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKStackLayoutBuilder.h"

#import <LayoutKitObjC/LayoutKitObjC-Swift.h>

@interface LOKStackLayoutBuilder ()

@property (nonatomic, nullable) LOKAlignment *privateAlignment;
@property (nonatomic, nullable) LOKFlexibility *privateFlexibility;
@property (nonatomic, nullable) NSString *privateViewReuseId;
@property (nonatomic, nullable) Class privateViewClass;

@property (nonatomic, nonnull) NSArray< id<LOKLayout> > *privateSublayouts;
@property (nonatomic) LOKAxis privateAxis;
@property (nonatomic) CGFloat privateSpacing;
@property (nonatomic) LOKStackLayoutDistribution privateDistribution;
@property (nonatomic, nullable) void (^ privateConfigure)(LOKView * _Nonnull);

@end

@implementation LOKStackLayoutBuilder

- (instancetype)initWithSublayouts:(NSArray<id<LOKLayout>> *)sublayouts {
    self = [super init];
    _privateAxis = LOKAxisVertical;
    _privateSublayouts = sublayouts;
    return self;
}

+ (instancetype)withSublayouts:(NSArray<id<LOKLayout>> *)sublayouts {
    return [[self alloc] initWithSublayouts:sublayouts];
}

- (LOKStackLayout *)layout {
    return [[LOKStackLayout alloc] initWithAxis:self.privateAxis
                                        spacing:self.privateSpacing
                                   distribution:self.privateDistribution
                                      alignment:self.privateAlignment
                                    flexibility:self.privateFlexibility
                                      viewClass:self.privateViewClass
                                    viewReuseId:self.privateViewReuseId
                                     sublayouts:self.privateSublayouts
                                      configure:self.privateConfigure];
}

- (LOKStackLayoutBuilder * _Nonnull (^)(LOKAxis))axis {
    return ^LOKStackLayoutBuilder *(LOKAxis axis){
        self.privateAxis = axis;
        return self;
    };
}

- (LOKStackLayoutBuilder * _Nonnull (^)(CGFloat))spacing {
    return ^LOKStackLayoutBuilder *(CGFloat spacing){
        self.privateSpacing = spacing;
        return self;
    };
}

- (LOKStackLayoutBuilder * _Nonnull (^)(LOKStackLayoutDistribution))distribution {
    return ^LOKStackLayoutBuilder *(LOKStackLayoutDistribution distribution){
        self.privateDistribution = distribution;
        return self;
    };
}

- (LOKStackLayoutBuilder * _Nonnull (^)(LOKAlignment * _Nonnull))alignment {
    return ^LOKStackLayoutBuilder *(LOKAlignment * alignment){
        self.privateAlignment = alignment;
        return self;
    };
}

- (LOKStackLayoutBuilder * _Nonnull (^)(LOKFlexibility * _Nonnull))flexibility {
    return ^LOKStackLayoutBuilder *(LOKFlexibility * flexibility){
        self.privateFlexibility = flexibility;
        return self;
    };
}

- (LOKStackLayoutBuilder * _Nonnull (^)(NSString * _Nonnull))viewReuseId {
    return ^LOKStackLayoutBuilder *(NSString * viewReuseId){
        self.privateViewReuseId = viewReuseId;
        return self;
    };
}

- (LOKStackLayoutBuilder * _Nonnull (^)(Class _Nonnull))viewClass {
    return ^LOKStackLayoutBuilder *(Class viewClass){
        self.privateViewClass = viewClass;
        return self;
    };
}

- (LOKStackLayoutBuilder * _Nonnull (^)(void(^ _Nullable)(LOKView *_Nonnull)))config {
    return ^LOKStackLayoutBuilder *(void(^ _Nullable config)(LOKView *_Nonnull)){
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
