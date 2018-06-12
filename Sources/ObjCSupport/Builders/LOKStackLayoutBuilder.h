// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKLayoutBuilder.h"

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

@interface LOKStackLayoutBuilder: NSObject<LOKLayoutBuilder>

- (nonnull instancetype)initWithSublayouts:(nonnull NSArray< id<LOKLayout> > *)sublayouts;
+ (nonnull instancetype)withSublayouts:(nonnull NSArray< id<LOKLayout> > *)sublayouts;

@property (nonatomic, nonnull, readonly) LOKStackLayoutBuilder * _Nonnull(^axis)(LOKAxis);
@property (nonatomic, nonnull, readonly) LOKStackLayoutBuilder * _Nonnull(^spacing)(CGFloat);
@property (nonatomic, nonnull, readonly) LOKStackLayoutBuilder * _Nonnull(^distribution)(LOKStackLayoutDistribution);

@property (nonatomic, nonnull, readonly) LOKStackLayoutBuilder * _Nonnull(^alignment)(LOKAlignment * _Nullable);
@property (nonatomic, nonnull, readonly) LOKStackLayoutBuilder * _Nonnull(^flexibility)(LOKFlexibility * _Nullable);
@property (nonatomic, nonnull, readonly) LOKStackLayoutBuilder * _Nonnull(^viewReuseId)(NSString * _Nullable);
@property (nonatomic, nonnull, readonly) LOKStackLayoutBuilder * _Nonnull(^viewClass)(Class _Nullable);

@property (nonatomic, nonnull, readonly) LOKStackLayoutBuilder * _Nonnull(^config)( void(^ _Nullable)(LOKView *_Nonnull));
@property (nonatomic, nonnull, readonly) LOKInsetLayoutBuilder * _Nonnull(^insets)(LOKEdgeInsets);

@property (nonatomic, nonnull, readonly) LOKStackLayout *layout;

@end
