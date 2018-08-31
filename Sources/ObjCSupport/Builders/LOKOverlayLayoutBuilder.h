// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <Foundation/Foundation.h>

#import "LOKLayoutBuilder.h"

@class LOKOverlayLayout;

@interface LOKOverlayLayoutBuilder: NSObject<LOKLayoutBuilder>

- (nonnull instancetype)initWithPrimaryLayouts:(nonnull NSArray< id<LOKLayout> > *)primaryLayouts;
+ (nonnull instancetype)withPrimaryLayouts:(nonnull NSArray< id<LOKLayout> > *)primaryLayouts;

@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder * _Nonnull(^overlay)(NSArray< id<LOKLayout> > * _Nullable);
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder * _Nonnull(^background)(NSArray< id<LOKLayout> > * _Nullable);

@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder * _Nonnull(^alignment)(LOKAlignment * _Nullable);
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder * _Nonnull(^flexibility)(LOKFlexibility * _Nullable);
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder * _Nonnull(^viewReuseId)(NSString * _Nullable);
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder * _Nonnull(^viewClass)(Class _Nullable);

@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder * _Nonnull(^config)( void(^ _Nullable)(LOKView *_Nonnull));
@property (nonatomic, nonnull, readonly) LOKInsetLayoutBuilder * _Nonnull(^insets)(LOKEdgeInsets);

@property (nonatomic, nonnull, readonly) LOKOverlayLayout *layout;

@end
