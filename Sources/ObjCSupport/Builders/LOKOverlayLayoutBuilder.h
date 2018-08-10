// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <Foundation/Foundation.h>

#import "LOKLayoutBuilder.h"

@class LOKOverlayLayout;

/**
 Builder for @c LOKOverlayLayout class.
 */
@interface LOKOverlayLayoutBuilder: NSObject<LOKLayoutBuilder>

/**
 Creates a @c LOKOverlayLayoutBuilder with the given collection of primary layouts.
 @param primaryLayouts The collection of layouts used inside the @c LOKOverlayLayout.
 */
- (nonnull instancetype)initWithPrimaryLayouts:(nonnull NSArray< id<LOKLayout> > *)primaryLayouts;
+ (nonnull instancetype)withPrimaryLayouts:(nonnull NSArray< id<LOKLayout> > *)primaryLayouts;

/**
 The layouts to put in front of the primary layout. They will be at most as large as the primary layout.
 */
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder * _Nonnull(^overlay)(NSArray< id<LOKLayout> > * _Nullable);

/**
 The layouts to put behind the primary layout. They will be at most as large as the primary layout.
 */
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder * _Nonnull(^background)(NSArray< id<LOKLayout> > * _Nullable);

/**
 @c LOKOverlayLayoutBuilder block for defining how this layout is positioned inside its parent layout.
 */
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder * _Nonnull(^alignment)(LOKAlignment * _Nullable);

/**
 @c LOKOverlayLayoutBuilder block for setting flexibility of the @c LOKOverlayLayout.
 */
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder * _Nonnull(^flexibility)(LOKFlexibility * _Nullable);

/**
 @c LOKOverlayLayoutBuilder block for setting the viewReuseId used by LayoutKit.
 */
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder * _Nonnull(^viewReuseId)(NSString * _Nullable);

/**
 @c LOKOverlayLayoutBuilder block for setting the view class of the @c LOKOverlayLayout.
 */
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder * _Nonnull(^viewClass)(Class _Nullable);

/**
 Layoutkit configuration block called with the created @c LOKView.
 */
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder * _Nonnull(^config)( void(^ _Nullable)(LOKView *_Nonnull));

/**
 @c LOKOverlayLayoutBuilder block for setting edge inset (positive) for the layout.
 */
@property (nonatomic, nonnull, readonly) LOKInsetLayoutBuilder * _Nonnull(^insets)(LOKEdgeInsets);

/**
 Calling this builds and returns the @c LOKOverlayLayout
 */
@property (nonatomic, nonnull, readonly) LOKOverlayLayout *layout;

@end
