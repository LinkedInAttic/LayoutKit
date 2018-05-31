// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKBuilderSharedHeader.h"

@class LOKSizeLayout;

@interface LOKSizeLayoutBuilder: NSObject

+ (nonnull instancetype)withSublayout:(nullable id<LOKLayout>)sublayout;

@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^width)(CGFloat);
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^height)(CGFloat);
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^minWidth)(CGFloat);
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^minHeight)(CGFloat);
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^maxWidth)(CGFloat);
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^maxHeight)(CGFloat);

@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^alignment)(LOKAlignment * _Nullable);
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^flexibility)(LOKFlexibility * _Nullable);
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^viewReuseId)(NSString * _Nullable);
@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^viewClass)(Class _Nullable);

@property (nonatomic, nonnull, readonly) LOKSizeLayoutBuilder * _Nonnull(^config)( void(^ _Nullable)(View *_Nonnull));
@property (nonatomic, nonnull, readonly) LOKInsetLayoutBuilder * _Nonnull(^insets)(EdgeInsets);

@property (nonatomic, nonnull, readonly) LOKSizeLayout *layout;

@end
