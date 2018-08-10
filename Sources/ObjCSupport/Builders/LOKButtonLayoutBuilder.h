// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKLayoutBuilder.h"

@class LOKButtonLayout;

typedef NS_CLOSED_ENUM(NSInteger, LOKButtonLayoutType) {
    LOKButtonLayoutTypeCustom,
    LOKButtonLayoutTypeSystem,
    LOKButtonLayoutTypeDetailDisclosure,
    LOKButtonLayoutTypeInfoLight,
    LOKButtonLayoutTypeInfoDark,
    LOKButtonLayoutTypeContactAdd
};

/**
 A layout builder for @c LOKButtonLayout.
 */
@interface LOKButtonLayoutBuilder: NSObject<LOKLayoutBuilder>

/**
 Creates a @c LOKButtonLayoutBuilder with the given title.
 @param title The button title.
 */
- (nonnull instancetype)initWithTitle:(nullable NSString *)title;
+ (nonnull instancetype)withTitle:(nullable NSString *)title;

/**
 @c LOKButtonLayoutBuilder block for setting the button type of the @c LOKButtonLayout.
 */
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^type)(LOKButtonLayoutType);

/**
 @c LOKButtonLayoutBuilder block for setting title font of the @c LOKButtonLayout.
 */
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^font)(UIFont * _Nullable);

/**
 @c LOKButtonLayoutBuilder block for setting button image of the @c LOKButtonLayout.
 */
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^image)(UIImage * _Nullable);

/**
 @c LOKButtonLayoutBuilder block for setting image size of the @c LOKButtonLayout.
 */
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^imageSize)(CGSize);

/**
 @c LOKButtonLayoutBuilder block for setting edge inset of the @c LOKButtonLayout.
 */
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^contentEdgeInsets)(NSValue * _Nullable);

/**
 @c LOKButtonLayoutBuilder block for defining how this layout is positioned inside its parent layout.
 */
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^alignment)(LOKAlignment * _Nullable);

/**
 @c LOKButtonLayoutBuilder block for setting flexibility of the @c LOKButtonLayout.
 */
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^flexibility)(LOKFlexibility * _Nullable);

/**
 @c LOKButtonLayoutBuilder block for setting the viewReuseId used by LayoutKit.
 */
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^viewReuseId)(NSString * _Nullable);

/**
 @c LOKButtonLayoutBuilder block for setting the view class of the @c LOKButtonLayout (should be @c UIButton or subclass).
 */
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^viewClass)(Class _Nullable);

/**
 Layoutkit configuration block called with the created @c UIButton (or subclass).
 */
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^config)( void(^ _Nullable)(UIButton *_Nonnull));

/**
 @c LOKButtonLayoutBuilder block for setting edge insets (positive) of the @c LOKButtonLayout.
 */
@property (nonatomic, nonnull, readonly) LOKInsetLayoutBuilder * _Nonnull(^insets)(LOKEdgeInsets);

/**
 Calling this builds and returns the @c LOKButtonLayout
 */
@property (nonatomic, nonnull, readonly) LOKButtonLayout *layout;

@end
