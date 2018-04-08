// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKBaseLayoutBuilder.h"

@class LOKOverlayLayout;

@interface LOKOverlayLayoutBuilder : LOKBaseLayoutBuilder

+ (nonnull instancetype)withPrimaryLayout:(nonnull id<LOKLayout>)primaryLayout;

@property (nonatomic, nonnull) id<LOKLayout> primary;
@property (nonatomic, nonnull) NSArray< id<LOKLayout> > *overlay;
@property (nonatomic, nonnull) NSArray< id<LOKLayout> > *background;

@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder * _Nonnull(^withOverlay)(NSArray< id<LOKLayout> > * _Nullable);
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder * _Nonnull(^withBackground)(NSArray< id<LOKLayout> > * _Nullable);

@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder *center;
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder *fill;
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder *topCenter;
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder *topFill;
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder *topLeading;
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder *topTrailing;
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder *bottomCenter;
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder *bottomFill;
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder *bottomLeading;
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder *bottomTrailing;
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder *centerFill;
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder *centerLeading;
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder *centerTrailing;
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder *fillLeading;
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder *fillTrailing;
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder *fillCenter;

@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder * _Nonnull(^withAlignment)(LOKAlignment * _Nonnull);
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder * _Nonnull(^withFlexibility)(LOKFlexibility * _Nonnull);
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder * _Nonnull(^withViewReuseId)(NSString * _Nonnull);
@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder * _Nonnull(^withViewClass)(Class _Nonnull);

@property (nonatomic, nonnull, readonly) LOKOverlayLayoutBuilder * _Nonnull(^withConfig)( void(^ _Nonnull)(View *_Nonnull));

- (nonnull LOKOverlayLayout *)build;

@end
