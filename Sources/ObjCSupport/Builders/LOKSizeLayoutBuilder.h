// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKBaseLayoutBuilder.h"

@class LOKSizeLayout;

@interface LOKSizeLayoutBuilder : LOKBaseLayoutBuilder

+ (nonnull instancetype)withSublayout:(nullable id<LOKLayout>)sublayout;

@property (nonatomic, nullable) id<LOKLayout> sublayout;
@property (nonatomic) CGFloat minWidth;
@property (nonatomic) CGFloat maxWidth;
@property (nonatomic) CGFloat minHeight;
@property (nonatomic) CGFloat maxHeight;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic, nullable) void (^ configure)(View * _Nonnull);

@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^withWidth)(CGFloat);
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^withHeight)(CGFloat);
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^withMinWidth)(CGFloat);
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^withMinHeight)(CGFloat);
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^withMaxWidth)(CGFloat);
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^withMaxHeight)(CGFloat);

@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^withAlignment)(LOKAlignment * _Nullable);
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^withFlexibility)(LOKFlexibility * _Nullable);
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^withViewReuseId)(NSString * _Nullable);
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^withViewClass)(Class _Nullable);

@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^withConfig)( void(^ _Nonnull)(View *_Nonnull));


- (nonnull LOKSizeLayout *)build;

@end
