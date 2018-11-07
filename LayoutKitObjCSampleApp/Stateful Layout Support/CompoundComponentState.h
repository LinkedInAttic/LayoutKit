// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Component;

typedef NSArray<Component *> ComponentArray;

/// Helper class that stores a component's state as a single (mostly) immutable object.
///
/// The mutable part is the subcomponents themselves and their specific
/// thread safety rules are described in the documentation of the @ Component class.
@interface CompoundComponentState<State, Data> : NSObject

@property (nonatomic, strong, nullable, readonly) State state;
@property (nonatomic, strong, nullable, readonly) Data data;
@property (nonatomic, strong, nonnull, readonly) ComponentArray *subcomponents;

- (nonnull instancetype)initWithState:(nullable State)state
                                 data:(nullable Data)data
                        subcomponents:(nonnull ComponentArray *)subcomponents;

@end


NS_ASSUME_NONNULL_END
