// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKLayoutBuilder.h"

/**
 Specifies how excess space along the axis is allocated.
 */
typedef NS_CLOSED_ENUM(NSInteger, LOKStackLayoutDistribution) {
    LOKStackLayoutDistributionDefault,
    LOKStackLayoutDistributionLeading,
    LOKStackLayoutDistributionTrailing,
    LOKStackLayoutDistributionCenter,
    LOKStackLayoutDistributionFillEqualSpacing,
    LOKStackLayoutDistributionFillEqualSize,
    LOKStackLayoutDistributionFillFlexing
};

/**
 Specifies a horizontal or vertical layout along which sublayouts are stacked.
 */
typedef NS_CLOSED_ENUM(NSInteger, LOKAxis) {
    LOKAxisVertical,
    LOKAxisHorizontal
};

@class LOKStackLayout;

/**
 A layout builder that builds @c LOKStackLayout using sublayouts along the specified axis.
 */
@interface LOKStackLayoutBuilder: NSObject<LOKLayoutBuilder>

/**
 Creates a @c LOKStackLayoutBuilder with the given sublayouts.
 @param sublayouts The array of layouts to be push in @c LOKStackLayout.
 */
- (nonnull instancetype)initWithSublayouts:(nonnull NSArray< id<LOKLayout> > *)sublayouts;
+ (nonnull instancetype)withSublayouts:(nonnull NSArray< id<LOKLayout> > *)sublayouts;

/**
 @c LOKStackLayoutBuilder block for setting the axis along which sublayouts are stacked.
 */
@property (nonatomic, nonnull, readonly) LOKStackLayoutBuilder * _Nonnull(^axis)(LOKAxis);

/**
 The distance in points between adjacent edges of sublayouts along the @c LOKStackLayout axis.
 For Distribution.EqualSpacing, this is the minimum spacing. For all other distributions it is the exact spacing.
 */
@property (nonatomic, nonnull, readonly) LOKStackLayoutBuilder * _Nonnull(^spacing)(CGFloat);

/**
 @c LOKStackLayoutBuilder block for setting distribution of space along the @c LOKStackLayout's axis.
 */
@property (nonatomic, nonnull, readonly) LOKStackLayoutBuilder * _Nonnull(^distribution)(LOKStackLayoutDistribution);

/**
 @c LOKStackLayoutBuilder block for defining how this layout is positioned inside its parent layout.
 */
@property (nonatomic, nonnull, readonly) LOKStackLayoutBuilder * _Nonnull(^alignment)(LOKAlignment * _Nullable);

/**
 @c LOKStackLayoutBuilder block for setting flexibility of the @c LOKStackLayout.
 */
@property (nonatomic, nonnull, readonly) LOKStackLayoutBuilder * _Nonnull(^flexibility)(LOKFlexibility * _Nullable);

/**
 @c LOKStackLayoutBuilder block for setting the viewReuseId used by LayoutKit.
 */
@property (nonatomic, nonnull, readonly) LOKStackLayoutBuilder * _Nonnull(^viewReuseId)(NSString * _Nullable);

/**
 @c LOKStackLayoutBuilder block for setting the view class of the @c LOKStackLayout.
 */
@property (nonatomic, nonnull, readonly) LOKStackLayoutBuilder * _Nonnull(^viewClass)(Class _Nullable);

/**
 Layoutkit configuration block called with the created @c LOKView.
 */
@property (nonatomic, nonnull, readonly) LOKStackLayoutBuilder * _Nonnull(^config)( void(^ _Nullable)(LOKView *_Nonnull));

/**
 @c LOKStackLayoutBuilder block for setting edge insets (positive) of the @c LOKStackLayout.
 */
@property (nonatomic, nonnull, readonly) LOKInsetLayoutBuilder * _Nonnull(^insets)(LOKEdgeInsets);

/**
 Calling this builds and returns the @c LOKStackLayout.
 */
@property (nonatomic, nonnull, readonly) LOKStackLayout *layout;

@end
