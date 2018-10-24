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

///
/// A component's state as a single immutable object.
/// @c State and @c Data generic type parameters should be immutable objects,
/// for example: @c NSString, @c NSNumber, @c NSArray, or custom immutable classes.
/// @c id can be used for the type parameter if a component doesn't use state or data.
///
/// The distinction between state and data is that state is primarily managed
/// (and mutated, via the copy methods) by the component while data is provided externally.
/// Sometimes it may be necessary for the component's owner to provide a starting
/// state or even to mutate it to synchronize it to another componet's state,
/// so it's not a hard rule that only the component itself should be setting its state.
///
/// If a component doesn't need either state and/or data,
/// @c id can be used as the argument for the corresponding type parameter.
///
@interface ComponentRecord<State, Data> : NSObject

/// The component's state that's managed by this component.
@property (nonatomic, strong, nullable, readonly) State state;

/// The data that's provided to this component.
@property (nonatomic, strong, nullable, readonly) Data data;

@property (nonatomic, strong, nonnull, readonly) NSArray<Component *> *subcomponents;

- (nonnull instancetype)initWithState:(nullable State)state
                                 data:(nullable Data)data
                        subcomponents:(nonnull NSArray<Component *> *)subcomponents;

- (nonnull instancetype)initWithState:(nullable State)state
                                 data:(nullable Data)data;

- (nonnull instancetype)copyWithState:(nullable State)state;
- (nonnull instancetype)copyWithData:(nullable Data)data;
- (nonnull instancetype)copyWithNewSubcomponent:(nonnull Component *)component;
- (nonnull instancetype)copyWithNewSubcomponents:(nonnull NSArray<Component *> *)components;
- (nonnull instancetype)copyWithoutSubcomponent:(nonnull Component *)component;

@end

NS_ASSUME_NONNULL_END
