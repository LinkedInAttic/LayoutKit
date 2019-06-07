// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <Foundation/Foundation.h>

#import "LOKLayoutBuilder.h"

@class LOKLabelLayout;

/**
 Layout builder for a @c LOKLabelLayout.
 */
@interface LOKLabelLayoutBuilder: NSObject<LOKLayoutBuilder>

/**
 Creates a @c LOKLabelLayoutBuilder with the given string.
 @param string The string to be used for label.
 */
- (nonnull instancetype)initWithString:(nullable NSString *)string;

/**
 Creates a @c LOKLabelLayoutBuilder with the given attributed string.
 @param attributedString The attributed string to set as the attributedText.
 */
- (nonnull instancetype)initWithAttributedString:(nullable NSAttributedString *)attributedString;

+ (nonnull instancetype)withString:(nullable NSString *)string;
+ (nonnull instancetype)withAttributedString:(nullable NSAttributedString *)attributedString;

/**
 @c LOKLabelLayoutBuilder block for setting font of the @c LOKLabelLayout.
 */
@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder * _Nonnull(^font)(UIFont * _Nullable);

/**
 @c LOKLabelLayoutBuilder block for setting the number of lines the label can have.
 */
@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder * _Nonnull(^numberOfLines)(NSInteger);

/**
 @c LOKLabelLayoutBuilder block for setting line break mode of the label.
 */
@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder * _Nonnull(^lineBreakMode)(NSLineBreakMode);

/**
 @c LOKLabelLayoutBuilder block for setting line height of the label.
 */
@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder * _Nonnull(^lineHeight)(CGFloat);

/**
 @c LOKLabelLayoutBuilder block for defining how this layout is positioned inside its parent layout.
 */
@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder * _Nonnull(^alignment)(LOKAlignment * _Nullable);

/**
 @c LOKLabelLayoutBuilder block for setting flexibility of the @c LOKLabelLayout.
 */
@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder * _Nonnull(^flexibility)(LOKFlexibility * _Nullable);

/**
 @c LOKLabelLayoutBuilder block for setting the viewReuseId used by LayoutKit.
 */
@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder * _Nonnull(^viewReuseId)(NSString * _Nullable);

/**
 @c LOKLabelLayoutBuilder block for setting the view class of the @c LOKLabelLayout (should be UILabel or subclass).
 */
@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder * _Nonnull(^viewClass)(Class _Nullable);

/**
 Layoutkit configuration block called with the created @c UILabel (or subclass).
 */
@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder * _Nonnull(^config)( void(^ _Nullable)(UILabel *_Nonnull));

/**
 @c LOKLabelLayoutBuilder block for setting edge insets (positive) for the layout.
 */
@property (nonatomic, nonnull, readonly) LOKInsetLayoutBuilder * _Nonnull(^insets)(LOKEdgeInsets);

/**
 Calling this builds and returns the @c LOKLabelLayout
 */
@property (nonatomic, nonnull, readonly) LOKLabelLayout *layout;

@end
