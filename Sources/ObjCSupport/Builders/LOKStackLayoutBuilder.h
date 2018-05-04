// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKBaseLayoutBuilder.h"

typedef NS_ENUM(NSInteger, LOKStackLayoutDistribution) {
    LOKStackLayoutDistributionDefault,
    LOKStackLayoutDistributionLeading,
    LOKStackLayoutDistributionTrailing,
    LOKStackLayoutDistributionCenter,
    LOKStackLayoutDistributionFillEqualSpacing,
    LOKStackLayoutDistributionFillEqualSize,
    LOKStackLayoutDistributionFillFlexing
};

typedef NS_ENUM(NSInteger, LOKAxis) {
    LOKAxisVertical,
    LOKAxisHorizontal
};

@class LOKStackLayout;

@interface LOKStackLayoutBuilder : LOKBaseLayoutBuilder

+ (nonnull instancetype)withSublayouts:(nonnull NSArray< id<LOKLayout> > *)sublayouts;

@property (nonatomic, nonnull) NSArray< id<LOKLayout> > *sublayouts;
@property (nonatomic) LOKAxis axis;
@property (nonatomic) CGFloat spacing;
@property (nonatomic) LOKStackLayoutDistribution distribution;
@property (nonatomic, nullable) void (^ configure)(View * _Nonnull);

@property (nonatomic, nonnull, readonly) LOKStackLayoutBuilder * _Nonnull(^withAxis)(LOKAxis);
@property (nonatomic, nonnull, readonly) LOKStackLayoutBuilder * _Nonnull(^withSpacing)(CGFloat);
@property (nonatomic, nonnull, readonly) LOKStackLayoutBuilder * _Nonnull(^withDistribution)(LOKStackLayoutDistribution);

@property (nonatomic, nonnull, readonly) LOKStackLayoutBuilder * _Nonnull(^withAlignment)(LOKAlignment * _Nullable);
@property (nonatomic, nonnull, readonly) LOKStackLayoutBuilder * _Nonnull(^withFlexibility)(LOKFlexibility * _Nullable);
@property (nonatomic, nonnull, readonly) LOKStackLayoutBuilder * _Nonnull(^withViewReuseId)(NSString * _Nullable);
@property (nonatomic, nonnull, readonly) LOKStackLayoutBuilder * _Nonnull(^withViewClass)(Class _Nullable);

@property (nonatomic, nonnull, readonly) LOKStackLayoutBuilder * _Nonnull(^withConfig)( void(^ _Nullable)(View *_Nonnull));


- (nonnull LOKStackLayout *)build;

@end
