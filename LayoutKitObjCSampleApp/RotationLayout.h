// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <UIKit/UIKit.h>
#import <LayoutKitObjC/LayoutKitObjC.h>

@interface RotationLayout: NSObject <LOKLayout>

@property (nonatomic, nonnull, readonly) id<LOKLayout> sublayout;
@property (nonatomic, nonnull, readonly) LOKAlignment *alignment;
@property (nonatomic, nonnull, readonly) LOKFlexibility *flexibility;
@property (nonatomic, copy, nullable, readonly) NSString *viewReuseId;
@property (nonatomic, readonly) BOOL needsView;

- (nonnull instancetype)initWithSublayout:(nonnull id<LOKLayout>)sublayout alignment:(nullable LOKAlignment *)alignment viewReuseId:(nullable NSString *)viewReuseId;

@end

