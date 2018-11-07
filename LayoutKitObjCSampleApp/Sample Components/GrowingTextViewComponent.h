// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "Component.h"

NS_ASSUME_NONNULL_BEGIN

@interface GrowingTextViewComponent : Component<NSString*, id><UITextViewDelegate>

@property (nonatomic, copy, nullable, readwrite) NSString *text;
@property (nonatomic, strong, nonnull, readonly) UIFont *font;
@property (nonatomic, assign, readonly) float lineLimit;
@property (nonatomic, copy, readonly) NSString *viewReuseId;
@property (nonatomic, strong, nullable, readwrite) UITextView *textView;

- (nonnull instancetype)initWithInitialText:(nonnull NSString*)placeholder
                                       font:(nullable UIFont *)font
                                  lineLimit:(float)lineLimit
                                viewReuseId:(nonnull NSString *)viewReuseId;

@end

NS_ASSUME_NONNULL_END
