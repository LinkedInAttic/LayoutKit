// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKStackLayoutBuilder.h"

@implementation LOKStackLayoutBuilder

+ (instancetype)withSublayouts:(NSArray<id<LOKLayout>> *)sublayouts {
    LOKStackLayoutBuilder *builder = [[self alloc] init];
    builder.axis = LOKAxisVertical;
    builder.sublayouts = sublayouts;
    return builder;
}

- (LOKStackLayout *)build {
    return [[LOKStackLayout alloc] initWithAxis:self.axis
                                        spacing:self.spacing
                                   distribution:self.distribution
                                      alignment:self.alignment
                                    flexibility:self.flexibility
                                      viewClass:self.viewClass
                                    viewReuseId:self.viewReuseId
                                     sublayouts:self.sublayouts
                                      configure:self.configure];
}

@end
