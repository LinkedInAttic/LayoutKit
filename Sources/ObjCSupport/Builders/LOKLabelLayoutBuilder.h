// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKBaseLayoutBuilder.h"

@interface LOKLabelLayoutBuilder : LOKBaseLayoutBuilder

+ (nonnull instancetype)withString:(nullable NSString *)string;
+ (nonnull instancetype)withAttributedString:(nullable NSAttributedString *)attributedString;

@property (nonatomic, nullable) NSString *string;
@property (nonatomic, nullable) NSAttributedString *attributedString;
@property (nonatomic, nullable) UIFont *font;
@property (nonatomic) NSInteger numberOfLines;
@property (nonatomic) CGFloat lineHeight;

- (nonnull LOKLabelLayout *)build;

@end
