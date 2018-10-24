// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "Component.h"

NS_ASSUME_NONNULL_BEGIN

// MARK: - GrowingTextViewComponentRecord

@interface GrowingTextViewComponentRecord : ComponentRecord<NSString*, id>

- (nonnull instancetype)initWithInitialText:(NSString *)text;

- (nonnull instancetype)copyWithText:(NSString *)text;

@property (nonatomic, copy, nullable, readonly) NSString *text;

@end

// MARK: - GrowingTextViewComponent

@interface GrowingTextViewComponent : Component<GrowingTextViewComponentRecord *><UITextViewDelegate>

@property (nonatomic, strong, nonnull, readonly) UIFont *font;
@property (nonatomic, assign, readonly) float lineLimit;
@property (nonatomic, strong, nullable, readwrite) UITextView *textView;
@property (nonatomic, strong, nonnull, readwrite) GrowingTextViewComponentRecord *currentRecord;

- (nonnull instancetype)initWithInitialText:(nonnull NSString*)placeholder
                                       font:(nullable UIFont *)font
                                  lineLimit:(float)lineLimit;

@end

NS_ASSUME_NONNULL_END
