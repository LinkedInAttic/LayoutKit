// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKBaseLayoutBuilder.h"

@class LOKLabelLayout;

@interface LOKLabelLayoutBuilder : LOKBaseLayoutBuilder

+ (nonnull instancetype)withString:(nullable NSString *)string;
+ (nonnull instancetype)withAttributedString:(nullable NSAttributedString *)attributedString;

@property (nonatomic, nullable) NSString *string;
@property (nonatomic, nullable) NSAttributedString *attributedString;
@property (nonatomic, nullable) UIFont *font;
@property (nonatomic) NSInteger numberOfLines;
@property (nonatomic) CGFloat lineHeight;

@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder * _Nonnull(^withFont)(UIFont * _Nullable);
@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder * _Nonnull(^withNumberOfLines)(NSInteger);
@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder * _Nonnull(^withLineHeight)(CGFloat);

@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder *center;
@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder *fill;
@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder *topCenter;
@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder *topFill;
@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder *topLeading;
@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder *topTrailing;
@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder *bottomCenter;
@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder *bottomFill;
@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder *bottomLeading;
@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder *bottomTrailing;
@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder *centerFill;
@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder *centerLeading;
@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder *centerTrailing;
@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder *fillLeading;
@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder *fillTrailing;
@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder *fillCenter;

@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder * _Nonnull(^withAlignment)(LOKAlignment * _Nonnull);
@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder * _Nonnull(^withFlexibility)(LOKFlexibility * _Nonnull);
@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder * _Nonnull(^withViewReuseId)(NSString * _Nonnull);
@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder * _Nonnull(^withViewClass)(Class _Nonnull);

@property (nonatomic, nonnull, readonly) LOKLabelLayoutBuilder * _Nonnull(^withConfig)( void(^ _Nonnull)(View *_Nonnull));

- (nonnull LOKLabelLayout *)build;

@end
