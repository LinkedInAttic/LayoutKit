// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKBaseLayoutBuilder.h"
#import "LOKInsetLayoutBuilder.h"

@implementation LOKBaseLayoutBuilder

- (id<LOKLayout>)build {
    NSAssert(NO, @"This method is expected to be overridden by a superclass.");
    return nil;
}

- (id<LOKLayout>)layout {
    return [self build];
}

- (LOKInsetLayoutBuilder * _Nonnull (^)(EdgeInsets))withInsets {
    return ^LOKInsetLayoutBuilder *(EdgeInsets insets){
        return [LOKInsetLayoutBuilder withInsets:insets around:[self build]];
    };
}

@end
