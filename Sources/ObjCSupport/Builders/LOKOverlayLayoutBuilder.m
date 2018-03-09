// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKOverlayLayoutBuilder.h"

@implementation LOKOverlayLayoutBuilder

+ (instancetype)withPrimaryLayout:(id<LOKLayout>)primaryLayout {
    LOKOverlayLayoutBuilder *builder = [[self alloc] init];
    builder.primary = primaryLayout;
    builder.background = @[];
    builder.overlay = @[];
    return builder;
}

- (LOKOverlayLayout *)build {
    return [[LOKOverlayLayout alloc] initWithPrimary:self.primary
                                          background:self.background
                                             overlay:self.overlay
                                           alignment:self.alignment
                                         viewReuseId:self.viewReuseId
                                           viewClass:self.viewClass
                                           configure:self.configure];
}

@end
