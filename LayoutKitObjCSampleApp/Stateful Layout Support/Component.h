// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "ComponentOwner.h"
#import "ComponentRecord.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LOKLayout;

///
/// Allows UI code to use both LayoutKit and state and support multi-threaded layout.
/// Components are nestable.
///
/// To build stateful LayoutKit UI, subclass this class and
/// override the @c makeLayoutForRecord method to construct the UI.
/// This method will be called on a background worker thread.
///
/// Subclasses of @c Component should be accompanied by corresponding
/// subclasses of @c ComponentRecord if they have any data or state.
///
/// IMPORTANT:
/// For the sake of thread-safety, all properties of this class should be readonly,
/// and all properties of the associated @c ComponentRecord class should be readonly.
/// Any changing state or data should be kept track of by the corresponding
/// @c ComponentRecord class.
///
@interface Component<Record: ComponentRecord *> : NSObject<ComponentOwner>

/// The component's state, in one immutable object.
@property (nonatomic, nonnull, strong, readonly) Record currentRecord;

/// Instantiates the component with its initial data and state.
- (nonnull instancetype)initWithRecord:(Record)record;

/// Updates the component with an updated copy of its state and/or data.
/// Notifies the component's owner that the layout should be re-generated.
/// Main thread only.
- (void)update:(Record)record;

/// References the component's owner. Used to notify the owner of state/data changes.
/// Main thread only.
@property (nonatomic, nullable, weak, readwrite) NSObject<ComponentOwner> *owner;

/// This property can be used to access a subcomponent's current layout inside
/// the parent component's @c makeLayoutForRecord method.
@property (nonatomic, nonnull, readonly) id<LOKLayout> layout;

/// Components should implement this method when they derive from this class.
/// This method will be called on a background worker thread by @c ComponentHost.
- (nonnull id<LOKLayout>)makeLayoutForRecord:(Record)record;

@end

NS_ASSUME_NONNULL_END
