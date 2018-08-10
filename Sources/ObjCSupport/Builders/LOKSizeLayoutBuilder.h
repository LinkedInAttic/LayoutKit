// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKLayoutBuilder.h"

@class LOKSizeLayout;
/**
 A layout builder for @c LOKSizeLayout.
 */
@interface LOKSizeLayoutBuilder: NSObject<LOKLayoutBuilder>

/**
 Creates a @c LOKSizeLayoutBuilder with the given sublayout.
 @param sublayout The layout for which size layout is being created.
 */
- (nonnull instancetype)initWithSublayout:(nullable id<LOKLayout>)sublayout;
+ (nonnull instancetype)withSublayout:(nullable id<LOKLayout>)sublayout;

/**
 @c LOKSizeLayoutBuilder block for setting width of the @c LOKSizeLayout.
 */
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^width)(CGFloat);

/**
 @c LOKSizeLayoutBuilder block for setting height of the @c LOKSizeLayout.
 */
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^height)(CGFloat);

/**
 @c LOKSizeLayoutBuilder block for setting the minimum width of the @c LOKSizeLayout.
 */
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^minWidth)(CGFloat);

/**
 @c LOKSizeLayoutBuilder block for setting minimum height of the @c LOKSizeLayout.
 */
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^minHeight)(CGFloat);

/**
 @c LOKSizeLayoutBuilder block for setting maximum width of the @c LOKSizeLayout.
 */
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^maxWidth)(CGFloat);

/**
 @c LOKSizeLayoutBuilder block for setting maximum height of the @c LOKSizeLayout.
 */
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^maxHeight)(CGFloat);

/**
 @c LOKSizeLayoutBuilder block for defining how this layout is positioned inside its parent layout.
 */
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^alignment)(LOKAlignment * _Nullable);

/**
 @c LOKSizeLayoutBuilder block for setting flexibility of the @c LOKSizeLayout.
 */
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^flexibility)(LOKFlexibility * _Nullable);

/**
 @c LOKSizeLayoutBuilder block for setting the viewReuseId used by LayoutKit.
 */
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^viewReuseId)(NSString * _Nullable);

/**
 @c LOKSizeLayoutBuilder block for setting the view class of the @c LOKSizeLayout.
 */
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^viewClass)(Class _Nullable);

/**
 Layoutkit configuration block called with the created @c LOKView.
 */
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^config)( void(^ _Nullable)(LOKView *_Nonnull));

/**
 @c LOKSizeLayoutBuilder block for setting edge inset (positive) for the layout.
 */
@property (nonatomic, nonnull, readonly) LOKInsetLayoutBuilder * _Nonnull(^insets)(LOKEdgeInsets);

/**
 Calling this builds and returns the @c LOKSizeLayout.
 */
@property (nonatomic, nonnull, readonly) LOKSizeLayout *layout;

@end
