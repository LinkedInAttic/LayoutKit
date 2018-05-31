// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <Foundation/Foundation.h>

#import "LOKBuilderSharedHeader.h"

@class LOKOverlayLayout;

@interface LOKOverlayLayoutBuilder: NSObject

+ (nonnull instancetype)withPrimaryLayout:(nonnull id<LOKLayout>)primaryLayout;

@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder * _Nonnull(^overlay)(NSArray< id<LOKLayout> > * _Nullable);
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder * _Nonnull(^background)(NSArray< id<LOKLayout> > * _Nullable);

@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder * _Nonnull(^alignment)(LOKAlignment * _Nullable);
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder * _Nonnull(^flexibility)(LOKFlexibility * _Nullable);
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder * _Nonnull(^viewReuseId)(NSString * _Nullable);
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder * _Nonnull(^viewClass)(Class _Nullable);

@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder * _Nonnull(^config)( void(^ _Nullable)(View *_Nonnull));
@property (nonatomic, nonnull, readonly) LOKInsetLayoutBuilder * _Nonnull(^insets)(EdgeInsets);

@property (nonatomic, nonnull, readonly) LOKOverlayLayout *layout;

@end
