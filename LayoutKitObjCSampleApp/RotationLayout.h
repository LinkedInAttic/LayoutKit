// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <UIKit/UIKit.h>
#import <LayoutKit/LayoutKit-Swift.h>

@interface RotationLayout: NSObject <LOKLayout>
-(nonnull instancetype)initWithSublayout:(nonnull id<LOKLayout>)sublayout alignment:(nullable LOKAlignment *)alignment viewReuseId:(nullable NSString *)viewReuseId;
@property (readonly, nonatomic, nonnull) id<LOKLayout> sublayout;
@property (readonly, nonatomic, nonnull) LOKAlignment *alignment;
@property (readonly, nonatomic) BOOL needsView;
@property (readonly, nonatomic, nonnull) LOKFlexibility *flexibility;
@property (readonly, copy, nonatomic, nullable) NSString *viewReuseId;
@end

