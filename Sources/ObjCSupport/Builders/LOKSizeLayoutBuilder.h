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

@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^withWidth)(CGFloat);
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^withHeight)(CGFloat);
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^withMinWidth)(CGFloat);
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^withMinHeight)(CGFloat);
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^withMaxWidth)(CGFloat);
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^withMaxHeight)(CGFloat);

@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder *center;
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder *fill;
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder *topCenter;
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder *topFill;
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder *topLeading;
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder *topTrailing;
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder *bottomCenter;
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder *bottomFill;
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder *bottomLeading;
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder *bottomTrailing;
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder *centerFill;
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder *centerLeading;
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder *centerTrailing;
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder *fillLeading;
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder *fillTrailing;
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder *fillCenter;

@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^withAlignment)(LOKAlignment * _Nonnull);
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^withFlexibility)(LOKFlexibility * _Nonnull);
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^withViewReuseId)(NSString * _Nonnull);
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^withViewClass)(Class _Nonnull);

@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^withConfig)( void(^ _Nonnull)(View *_Nonnull));


- (nonnull LOKSizeLayout *)build;

@end
