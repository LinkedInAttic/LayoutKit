// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "ComponentRecord.h"

@implementation ComponentRecord

- (nonnull instancetype)initWithState:(nullable id)state
                                 data:(nullable id)data
                        subcomponents:(nonnull NSArray<Component *> *)subcomponents {
    self = [super init];
    _state = state;
    _data = data;
    _subcomponents = subcomponents;
    return self;
}

- (nonnull instancetype)initWithState:(nullable id)state
                                 data:(nullable id)data {
    return [self initWithState:state data:data subcomponents:@[]];
}

- (instancetype)copyWithState:(id)state {
    return [[[self class] alloc] initWithState:state data:self.data subcomponents:self.subcomponents];
}

- (instancetype)copyWithData:(id)data {
    return [[[self class] alloc] initWithState:self.state data:data subcomponents:self.subcomponents];
}

- (instancetype)copyWithNewSubcomponent:(Component *)component {
    return [[[self class] alloc] initWithState:self.state
                                          data:self.data
                                 subcomponents:[self.subcomponents arrayByAddingObject:component]];

}

- (instancetype)copyWithNewSubcomponents:(nonnull NSArray<Component *> *)components {
    return [[[self class] alloc] initWithState:self.state
                                          data:self.data
                                 subcomponents:[self.subcomponents arrayByAddingObjectsFromArray:components]];
}

- (instancetype)copyWithoutSubcomponent:(Component *)component {
    NSMutableArray<Component *> *newSubcomponents = [self.subcomponents mutableCopy];
    [newSubcomponents removeObject:component];
    return [[ComponentRecord alloc] initWithState:self.state
                                             data:self.data
                                    subcomponents:[newSubcomponents copy]];
}

@end
