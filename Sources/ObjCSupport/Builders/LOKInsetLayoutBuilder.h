// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKBaseLayoutBuilder.h"

@interface LOKInsetLayoutBuilder : LOKBaseLayoutBuilder

+ (nonnull instancetype)withInsets:(UIEdgeInsets)insets around:(nonnull id<LOKLayout>)sublayout;

@property (nonatomic) UIEdgeInsets insets;
@property (nonatomic, nonnull) id<LOKLayout> sublayout;

@property (nonatomic, nullable) LOKAlignment *alignment;
@property (nonatomic, nullable) LOKFlexibility *flexibility;
@property (nonatomic, nullable) NSString *viewReuseId;
@property (nonatomic, nullable) Class viewClass;
@property (nonatomic, nullable) void (^ configure)(UIView * _Nonnull);

- (nonnull LOKInsetLayout *)build;

@end
