// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <Foundation/Foundation.h>

@class Component;

/// Used by @c Component<State,Data> base class to notify its owner of state and data changes.
@protocol ComponentOwner

/// Notifies this owner that the given component has experienced some changes and should be re-rendered.
- (void)notifyUpdateFromComponent:(nonnull Component *)component;

/// Notifies this owner that it now owns the given component.
- (void)registerComponent:(nonnull Component *)component;

/// Notifies this owner that it now owns the given components.
- (void)registerComponents:(nonnull NSArray<Component *> *)components;

/// Notifies this owner that it no longer owns the given component.
- (void)unregisterComponent:(nonnull Component *)component;

@end
