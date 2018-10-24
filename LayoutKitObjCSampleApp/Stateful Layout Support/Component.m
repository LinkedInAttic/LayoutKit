// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "Component.h"
#import "Component+Internal.h"
#import "ComponentRecord.h"

@implementation Component

@synthesize currentRecord = _currentRecord, owner = _owner;

#pragma mark - State Access

- (instancetype)initWithRecord:(ComponentRecord *)record {
    self = [super init];
    _currentRecord = record;
    for (Component *subcomponent in record.subcomponents) {
        NSAssert(subcomponent.owner == nil, @"Given subcomponent shouldn't be already owned by any other component.");
        subcomponent.owner = self;
    }
    return self;
}

- (ComponentRecord *)currentRecord {
    NSAssert(NSThread.isMainThread, @"Current component state should only be accessed on the main thread.");
    return _currentRecord;
}

- (void)update:(ComponentRecord *)record {
    NSAssert(NSThread.isMainThread, @"Component state should only be updated on the main thread.");
    if (NSThread.isMainThread && _currentRecord != record) {
        _currentRecord = record;
        [self.owner notifyUpdateFromComponent:self];
    }
}

// internal accessor to the thread-specific copy of this component's data/state record
- (ComponentRecord *)threadSafeRecord {
    if (NSThread.isMainThread) {
        return _currentRecord;
    } else {
        // If we're on the worker thread, look up the state for this component in thread-local storage.
        StateMap *stateMap = [NSThread.currentThread.threadDictionary objectForKey:stateMapKey];
        NSAssert(stateMap != nil, @"Worker thread state not detected. Please use prepareRootForWorkerThread.");
        ComponentRecord *threadLocalRecord = [stateMap objectForKey:self];
        NSAssert(threadLocalRecord != nil, @"Subcomponent not found. Probably not registered with its owner.");
        return threadLocalRecord;
    }
}

#pragma mark - Owner Tracking

- (void)setOwner:(nullable NSObject<ComponentOwner> *)owner {
    NSAssert(NSThread.isMainThread, @"Component ownership should only be accessed on the main thread.");
    if (owner == _owner) { return; }
    __auto_type oldOwner = self.owner;
    _owner = owner;
    [oldOwner unregisterComponent:self];
    [self.owner registerComponent:self];
}

- (nullable NSObject<ComponentOwner> *)owner {
    NSAssert(NSThread.isMainThread, @"Component ownership should only be accessed on the main thread.");
    return _owner;
}

- (void)notifyUpdateFromComponent:(nonnull Component *)component {
    NSAssert(NSThread.isMainThread, @"Updates should only be happening on the main thread.");
    NSAssert(component != nil, @"Received update from a nil component.");
    NSAssert(component.owner == self, @"Received update from a component");
    NSAssert([self.currentRecord.subcomponents containsObject:component], @"Received update notification");
    [self.owner notifyUpdateFromComponent:self];
}

- (void)registerComponent:(nonnull Component *)component {
    NSAssert(NSThread.isMainThread, @"Component ownership should only be accessed on the main thread.");
    NSAssert(component != nil, @"Must pass a non-nill component.");
    if (component == nil) { return; }
    if ([self.currentRecord.subcomponents containsObject:component]) {
        NSAssert(component.owner == self, @"Inconsistent owner property.");
        return;
    }
    component.owner = self;
    [self update:[self.currentRecord copyWithNewSubcomponent:component]];
}

- (void)registerComponents:(nonnull NSArray<Component *> *)components {
    NSAssert(NSThread.isMainThread, @"Component ownership should only be accessed on the main thread.");
    NSAssert(components != nil, @"Must pass a non-nill components array.");
    if (components == nil) { return; }
    for (Component *component in components) {
        if ([self.currentRecord.subcomponents containsObject:component]) {
            NSAssert(component.owner == self, @"Inconsistent owner property.");
            return;
        }
        component.owner = self;
    }
    [self update:[self.currentRecord copyWithNewSubcomponents:components]];
}

- (void)unregisterComponent:(nonnull Component *)component {
    NSAssert(NSThread.isMainThread, @"Component ownership should only be accessed on the main thread.");
    NSAssert(component != nil, @"Must pass a non-nill component.");
    if (component == nil) { return; }
    if (![self.currentRecord.subcomponents containsObject:component]) {
        NSAssert(component.owner == self, @"Inconsistent owner property.");
        return;
    }
    component.owner = nil;
    [self update:[self.currentRecord copyWithoutSubcomponent:component]];
}

#pragma mark - Worker Thread Support

typedef NSMapTable<Component *, ComponentRecord *> StateMap;

NSString *stateMapKey = @"layout state";

- (nonnull LayoutFunction)prepareRootForWorkerThread {
    NSAssert(NSThread.isMainThread, @"Need to be on the main thread.");
    NSAssert(![self.owner isKindOfClass:[Component class]], @"This isn't the root.");

    // While still on the main thread,
    // Gather up the states of all the components,
    // And capture them in a local variable.
    StateMap *stateMap = [[StateMap alloc] init];
    [self populateStateMap:stateMap];

    return ^id<LOKLayout>() { // Captured: stateMap and self.
        NSAssert(!NSThread.isMainThread, @"No need to call prepareRootForWorkerThread if the resulting block isn't run on a worker thread.");

        // Put the states in thread local storage so that the state property getters
        // can access a consistent set of values.
        [NSThread.currentThread.threadDictionary setObject:stateMap forKey:stateMapKey];

        // Produce the layouts.
        id<LOKLayout> result = [self layout];

        // Clear the components states from thread local storage.
        [NSThread.currentThread.threadDictionary removeObjectForKey:stateMapKey];

        return result;
    };
}

/// Gathers the state objects from the subcomponent tree.
- (void)populateStateMap:(StateMap *)stateMap {
    NSAssert(NSThread.isMainThread, @"The state map can only be constructed on the main thread.");

    [stateMap setObject:self.currentRecord forKey:self];

    for (Component* subcomponent in self.currentRecord.subcomponents) {
        [subcomponent populateStateMap:stateMap];
    }
}

#pragma mark - Layout Construction

- (nonnull id<LOKLayout>)makeLayoutForRecord:(ComponentRecord *)record {
    NSAssert(NO, @"Components should derive from this class and implement this method.");
    return nil;
}

- (id<LOKLayout>)layout {
    return [self makeLayoutForRecord:[self threadSafeRecord]];
}

@end
