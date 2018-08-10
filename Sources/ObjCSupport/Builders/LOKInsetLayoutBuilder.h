// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <Foundation/Foundation.h>

#import "LOKLayoutBuilder.h"

@class LOKInsetLayout;
/**
 A layout builder for @c LOKInsetLayout.
 */
@interface LOKInsetLayoutBuilder: NSObject<LOKLayoutBuilder>

/**
 Creates a @c LOKInsetLayoutBuilder with the given insets and sublayout.
 @param insets      The @c LOKEdgeInsets for layout.
 @param sublayout   The layout placed inside the @c LOKInsetLayout.
 */
- (nonnull instancetype)initWithInsets:(LOKEdgeInsets)insets around:(nonnull id<LOKLayout>)sublayout;
+ (nonnull instancetype)withInsets:(LOKEdgeInsets)insets around:(nonnull id<LOKLayout>)sublayout;

/**
 @c LOKInsetLayoutBuilder block for defining how this layout is positioned inside its parent layout.
 */
@property (nonatomic, nonnull, readonly) LOKInsetLayoutBuilder * _Nonnull(^alignment)(LOKAlignment * _Nullable);

/**
 @c LOKInsetLayoutBuilder block for setting flexibility of the @c LOKInsetLayout.
 */
@property (nonatomic, nonnull, readonly) LOKInsetLayoutBuilder * _Nonnull(^flexibility)(LOKFlexibility * _Nullable);

/**
 @c LOKInsetLayoutBuilder block for setting the viewReuseId used by LayoutKit.
 */
@property (nonatomic, nonnull, readonly) LOKInsetLayoutBuilder * _Nonnull(^viewReuseId)(NSString * _Nullable);

/**
 @c LOKInsetLayoutBuilder block for setting the view class for the @c LOKInsetLayout.
 */
@property (nonatomic, nonnull, readonly) LOKInsetLayoutBuilder * _Nonnull(^viewClass)(Class _Nullable);

/**
 Layoutkit configuration block called with created @c LOKView.
 */
@property (nonatomic, nonnull, readonly) LOKInsetLayoutBuilder * _Nonnull(^config)( void(^ _Nullable)(LOKView *_Nonnull));

/**
 @c LOKInsetLayoutBuilder block for setting edge inset for the @c LOKInsetLayout.
 */
@property (nonatomic, nonnull, readonly) LOKInsetLayoutBuilder * _Nonnull(^insets)(LOKEdgeInsets);

/**
 Calling this builds and returns the @c LOKInsetLayout
 */
@property (nonatomic, nonnull, readonly) LOKInsetLayout *layout;

@end
