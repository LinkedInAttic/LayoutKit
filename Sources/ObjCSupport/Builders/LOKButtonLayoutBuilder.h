// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKLayoutBuilder.h"

@class LOKButtonLayout;

typedef NS_ENUM(NSInteger, LOKButtonLayoutType) {
    LOKButtonLayoutTypeCustom,
    LOKButtonLayoutTypeSystem,
    LOKButtonLayoutTypeDetailDisclosure,
    LOKButtonLayoutTypeInfoLight,
    LOKButtonLayoutTypeInfoDark,
    LOKButtonLayoutTypeContactAdd
};

@interface LOKButtonLayoutBuilder: NSObject<LOKLayoutBuilder>

- (nonnull instancetype)initWithTitle:(nullable NSString *)title;
+ (nonnull instancetype)withTitle:(nullable NSString *)title;

@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^type)(LOKButtonLayoutType);
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^font)(UIFont * _Nullable);
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^image)(UIImage * _Nullable);
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^imageSize)(CGSize);
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^contentEdgeInsets)(NSValue * _Nullable);

@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^alignment)(LOKAlignment * _Nullable);
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^flexibility)(LOKFlexibility * _Nullable);
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^viewReuseId)(NSString * _Nullable);
@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^viewClass)(Class _Nullable);

@property (nonatomic, nonnull, readonly) LOKButtonLayoutBuilder * _Nonnull(^config)( void(^ _Nullable)(UIButton *_Nonnull));
@property (nonatomic, nonnull, readonly) LOKInsetLayoutBuilder * _Nonnull(^insets)(LOKEdgeInsets);

@property (nonatomic, nonnull, readonly) LOKButtonLayout *layout;

@end
