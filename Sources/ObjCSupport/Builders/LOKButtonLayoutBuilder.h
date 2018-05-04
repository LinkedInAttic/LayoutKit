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
@property (nonatomic, nullable) void (^ configure)(UIButton * _Nonnull);

@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^withType)(LOKButtonLayoutType);
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^withFont)(UIFont * _Nullable);
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^withImage)(UIImage * _Nullable);
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^withImageSize)(CGSize);
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^withContentEdgeInsets)(NSValue * _Nullable);

@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^withAlignment)(LOKAlignment * _Nullable);
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^withFlexibility)(LOKFlexibility * _Nullable);
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^withViewReuseId)(NSString * _Nullable);
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^withViewClass)(Class _Nullable);

@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^withConfig)( void(^ _Nullable)(UIButton *_Nonnull));

- (nonnull LOKButtonLayout *)build;

@end
