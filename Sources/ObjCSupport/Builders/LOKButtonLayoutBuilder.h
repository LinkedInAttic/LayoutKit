// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKBaseLayoutBuilder.h"

@class LOKButtonLayout;

typedef NS_ENUM(NSInteger, LOKButtonLayoutType) {
    LOKButtonLayoutTypeCustom,
    LOKButtonLayoutTypeSystem,
    LOKButtonLayoutTypeDetailDisclosure,
    LOKButtonLayoutTypeInfoLight,
    LOKButtonLayoutTypeInfoDark,
    LOKButtonLayoutTypeContactAdd
};

@interface LOKButtonLayoutBuilder : LOKBaseLayoutBuilder

+ (nonnull instancetype)withTitle:(nullable NSString *)title;

@property (nonatomic) LOKButtonLayoutType type;
@property (nonatomic, nullable) NSString *title;
@property (nonatomic, nullable) UIFont *font;
@property (nonatomic, nullable) UIImage *image;
@property (nonatomic) CGSize imageSize;
@property (nonatomic, nullable) NSValue *contentEdgeInsets;

@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^withType)(LOKButtonLayoutType);
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^withFont)(UIFont * _Nullable);
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^withImage)(UIImage * _Nullable);
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^withImageSize)(CGSize);
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^withContentEdgeInsets)(NSValue * _Nullable);

@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder *center;
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder *fill;
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder *topCenter;
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder *topFill;
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder *topLeading;
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder *topTrailing;
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder *bottomCenter;
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder *bottomFill;
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder *bottomLeading;
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder *bottomTrailing;
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder *centerFill;
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder *centerLeading;
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder *centerTrailing;
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder *fillLeading;
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder *fillTrailing;
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder *fillCenter;

@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^withAlignment)(LOKAlignment * _Nonnull);
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^withFlexibility)(LOKFlexibility * _Nonnull);
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^withViewReuseId)(NSString * _Nonnull);
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^withViewClass)(Class _Nonnull);

@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^withConfig)( void(^ _Nonnull)(View *_Nonnull));

- (nonnull LOKButtonLayout *)build;

@end
