// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKBaseLayoutBuilder.h"

@class LOKTextViewLayout;

@interface LOKTextViewLayoutBuilder : LOKBaseLayoutBuilder

+ (nonnull instancetype)withString:(nullable NSString *)string;
+ (nonnull instancetype)withAttributedString:(nullable NSAttributedString *)attributedString;

@property (nonatomic, nullable) NSString *string;
@property (nonatomic, nullable) NSAttributedString *attributedString;
@property (nonatomic, nullable) UIFont *font;
@property (nonatomic) UIEdgeInsets textContainerInset;
@property (nonatomic) CGFloat lineFragmentPadding;
@property (nonatomic, nullable) void (^ configure)(UITextView * _Nonnull);


@property (nonatomic, nonnull, readonly) LOKTextViewLayoutBuilder * _Nonnull(^withFont)(UIFont * _Nullable);
@property (nonatomic, nonnull, readonly) LOKTextViewLayoutBuilder * _Nonnull(^withTextContainerInset)(UIEdgeInsets);
@property (nonatomic, nonnull, readonly) LOKTextViewLayoutBuilder * _Nonnull(^withLineFragmentPadding)(CGFloat);

@property (nonatomic, nonnull, readonly) LOKTextViewLayoutBuilder * _Nonnull(^withAlignment)(LOKAlignment * _Nonnull);
@property (nonatomic, nonnull, readonly) LOKTextViewLayoutBuilder * _Nonnull(^withFlexibility)(LOKFlexibility * _Nonnull);
@property (nonatomic, nonnull, readonly) LOKTextViewLayoutBuilder * _Nonnull(^withViewReuseId)(NSString * _Nonnull);
@property (nonatomic, nonnull, readonly) LOKTextViewLayoutBuilder * _Nonnull(^withViewClass)(Class _Nonnull);

@property (nonatomic, nonnull, readonly) LOKTextViewLayoutBuilder * _Nonnull(^withConfig)( void(^ _Nonnull)(UITextView *_Nonnull));

- (nonnull LOKTextViewLayout *)build;

@end
