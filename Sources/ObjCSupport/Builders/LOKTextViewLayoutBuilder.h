// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKLayoutBuilder.h"

@class LOKTextViewLayout;

@interface LOKTextViewLayoutBuilder: NSObject<LOKLayoutBuilder>

- (nonnull instancetype)initWithString:(nullable NSString *)string;
- (nonnull instancetype)initWithAttributedString:(nullable NSAttributedString *)attributedString;

+ (nonnull instancetype)withString:(nullable NSString *)string;
+ (nonnull instancetype)withAttributedString:(nullable NSAttributedString *)attributedString;

@property (nonatomic, nonnull, readonly) LOKTextViewLayoutBuilder * _Nonnull(^font)(UIFont * _Nullable);
@property (nonatomic, nonnull, readonly) LOKTextViewLayoutBuilder * _Nonnull(^textContainerInset)(UIEdgeInsets);
@property (nonatomic, nonnull, readonly) LOKTextViewLayoutBuilder * _Nonnull(^lineFragmentPadding)(CGFloat);

@property (nonatomic, nonnull, readonly) LOKTextViewLayoutBuilder * _Nonnull(^alignment)(LOKAlignment * _Nullable);
@property (nonatomic, nonnull, readonly) LOKTextViewLayoutBuilder * _Nonnull(^flexibility)(LOKFlexibility * _Nullable);
@property (nonatomic, nonnull, readonly) LOKTextViewLayoutBuilder * _Nonnull(^viewReuseId)(NSString * _Nullable);
@property (nonatomic, nonnull, readonly) LOKTextViewLayoutBuilder * _Nonnull(^viewClass)(Class _Nullable);

@property (nonatomic, nonnull, readonly) LOKTextViewLayoutBuilder * _Nonnull(^config)( void(^ _Nullable)(UITextView *_Nonnull));
@property (nonatomic, nonnull, readonly) LOKInsetLayoutBuilder * _Nonnull(^insets)(LOKEdgeInsets);

@property (nonatomic, nonnull, readonly) LOKTextViewLayout *layout;

@end
