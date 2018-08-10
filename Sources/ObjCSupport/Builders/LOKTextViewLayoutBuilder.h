// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKLayoutBuilder.h"

@class LOKTextViewLayout;
/**
 LayoutBuilder for @c LOKTextViewLayout.
 */
@interface LOKTextViewLayoutBuilder: NSObject<LOKLayoutBuilder>

/**
 Creates a @c LOKTextViewLayoutBuilder with the given string.
 @param string The string set to the underlying @c UITextView's text.
 */
- (nonnull instancetype)initWithString:(nullable NSString *)string;

/**
 Creates a @c LOKTextViewLayoutBuilder with the given attributed string.
 @param attributedString The attributed string set as the underlying @c UITextView's attributedText.
 */
- (nonnull instancetype)initWithAttributedString:(nullable NSAttributedString *)attributedString;

+ (nonnull instancetype)withString:(nullable NSString *)string;
+ (nonnull instancetype)withAttributedString:(nullable NSAttributedString *)attributedString;

/**
 @c LOKTextViewLayoutBuilder block for setting font of the @c LOKTextViewLayout.
 */
@property (nonatomic, nonnull, readonly) LOKTextViewLayoutBuilder * _Nonnull(^font)(UIFont * _Nullable);

/**
 @c LOKTextViewLayoutBuilder block for setting insets for the text container of @c UITextViewLayout.
 */
@property (nonatomic, nonnull, readonly) LOKTextViewLayoutBuilder * _Nonnull(^textContainerInset)(UIEdgeInsets);

/**
 @c LOKTextViewLayoutBuilder block for setting line padding between text container and actual text in @c LOKTextViewLayout.
 */
@property (nonatomic, nonnull, readonly) LOKTextViewLayoutBuilder * _Nonnull(^lineFragmentPadding)(CGFloat);

/**
 @c LOKTextViewLayoutBuilder block for defining how this layout is positioned inside its parent layout.
 */
@property (nonatomic, nonnull, readonly) LOKTextViewLayoutBuilder * _Nonnull(^alignment)(LOKAlignment * _Nullable);

/**
 @c LOKTextViewLayoutBuilder block for setting flexibility of the @c LOKTextViewLayout.
 */
@property (nonatomic, nonnull, readonly) LOKTextViewLayoutBuilder * _Nonnull(^flexibility)(LOKFlexibility * _Nullable);

/**
 @c LOKTextViewLayoutBuilder block for setting the viewReuseId used by LayoutKit.
 */
@property (nonatomic, nonnull, readonly) LOKTextViewLayoutBuilder * _Nonnull(^viewReuseId)(NSString * _Nullable);

/**
 @c LOKTextViewLayoutBuilder block for setting the view class of the @c LOKTextViewLayout(should be @c UITextView
 */
@property (nonatomic, nonnull, readonly) LOKTextViewLayoutBuilder * _Nonnull(^viewClass)(Class _Nullable);

/**
 Layoutkit configuration block called with the created @c UITextView (or subclass).
 */
@property (nonatomic, nonnull, readonly) LOKTextViewLayoutBuilder * _Nonnull(^config)( void(^ _Nullable)(UITextView *_Nonnull));

/**
 @c LOKTextViewLayoutBuilder block for setting edge inset (positive) for the @c LOKTextViewLayout.
 */
@property (nonatomic, nonnull, readonly) LOKInsetLayoutBuilder * _Nonnull(^insets)(LOKEdgeInsets);

/**
 Calling this builds and returns the @c LOKTextViewLayout.
 */
@property (nonatomic, nonnull, readonly) LOKTextViewLayout *layout;

@end
