// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKBaseLayoutBuilder.h"

@class LOKInsetLayout;

@interface LOKInsetLayoutBuilder : LOKBaseLayoutBuilder

+ (nonnull instancetype)withInsets:(EdgeInsets)insets around:(nonnull id<LOKLayout>)sublayout;

@property (nonatomic) EdgeInsets insets;
@property (nonatomic, nonnull) id<LOKLayout> sublayout;

@property (nonatomic, nonnull, readonly) LOKInsetLayoutBuilder * _Nonnull(^withAlignment)(LOKAlignment * _Nonnull);
@property (nonatomic, nonnull, readonly) LOKInsetLayoutBuilder * _Nonnull(^withFlexibility)(LOKFlexibility * _Nonnull);
@property (nonatomic, nonnull, readonly) LOKInsetLayoutBuilder * _Nonnull(^withViewReuseId)(NSString * _Nonnull);
@property (nonatomic, nonnull, readonly) LOKInsetLayoutBuilder * _Nonnull(^withViewClass)(Class _Nonnull);

@property (nonatomic, nonnull, readonly) LOKInsetLayoutBuilder * _Nonnull(^withConfig)( void(^ _Nonnull)(View *_Nonnull));

- (nonnull LOKInsetLayout *)build;

@end
