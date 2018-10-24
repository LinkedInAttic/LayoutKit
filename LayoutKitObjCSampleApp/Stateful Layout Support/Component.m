#import "Component.h"

#import <objc/runtime.h>

#import "CompoundComponentState.h"

@interface Component<State, Data> ()

/// The component's state, in one (mostly) immutable object.
@property (nonatomic, nonnull, strong, readwrite) CompoundComponentState<State, Data> *compoundState;

@end

@implementation Component

@synthesize compoundState = _compoundState, owner = _owner;

#pragma mark - State Access

// State and data properties are stored in the compoundState private property,
// which handles update notification on writes and thread-specific reads.

- (nonnull instancetype)initWithState:(id)state data:(id)data {
    self = [super init];
    _compoundState = [[CompoundComponentState alloc] initWithState:state data:data subcomponents:@[]];
    return self;
}

- (void)setState:(nullable id)state {
    NSAssert(NSThread.isMainThread, @"Component state should only be updated on the main thread.");
    self.compoundState = [[CompoundComponentState alloc] initWithState:state
                                                                  data:self.compoundState.data
                                                         subcomponents:self.compoundState.subcomponents];
}

- (id)state {
    return self.compoundState.state;
}

- (void)setData:(id)data {
    NSAssert(NSThread.isMainThread, @"Component state should only be updated on the main thread.");
    self.compoundState = [[CompoundComponentState alloc] initWithState:self.compoundState.state
                                                                  data:data
                                                         subcomponents:self.compoundState.subcomponents];
}

- (id)data {
    return self.compoundState.data;
}

- (void)setCompoundState:(CompoundComponentState *)compoundState {
    NSAssert(NSThread.isMainThread, @"Component state should only be updated on the main thread.");
    if (NSThread.isMainThread) {
        _compoundState = compoundState;
        [self.owner notifyUpdateFromComponent:self];
    }
}

- (CompoundComponentState *)compoundState {
    if (NSThread.isMainThread) {
        return _compoundState;
    } else {
        // If we're on the worker thread, look up the state for this component in thread local storage.
        StateMap *stateMap = [NSThread.currentThread.threadDictionary objectForKey:key];
        NSAssert(stateMap != nil, @"Worker thread state not detected. Please use prepareRootForWorkerThread.");
        CompoundComponentState *threadLocalCompoundState = [stateMap objectForKey:self];
        NSAssert(threadLocalCompoundState != nil, @"Subcomponent not found. Probably not registered with its owner.");
        return threadLocalCompoundState;
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

- (void)notifyUpdateFromComponent:(Component *)component {
    NSAssert(NSThread.isMainThread, @"");
    NSAssert(component != nil, @"");
    NSAssert([self.compoundState.subcomponents containsObject:component], @"");
    [self.owner notifyUpdateFromComponent:self];
}

- (void)registerComponent:(nonnull Component *)component {
    NSAssert(NSThread.isMainThread, @"Component ownership should only be accessed on the main thread.");
    NSAssert(component != nil, @"Must pass a non-nill component.");
    if (component == nil) { return; }
    if ([self.compoundState.subcomponents containsObject:component]) {
        NSAssert(component.owner == self, @"Inconsistent owner property.");
        return;
    }
    component.owner = self;
    self.compoundState = [[CompoundComponentState alloc] initWithState:self.compoundState.state
                                                                  data:self.compoundState.data
                                                         subcomponents:[self.compoundState.subcomponents arrayByAddingObject:component]];
}

- (void)unregisterComponent:(nonnull Component *)component {
    NSAssert(NSThread.isMainThread, @"Component ownership should only be accessed on the main thread.");
    NSAssert(component != nil, @"Must pass a non-nill component.");
    if (component == nil) { return; }
    if (![self.compoundState.subcomponents containsObject:component]) {
        NSAssert(component.owner == self, @"Inconsistent owner property.");
        return;
    }
    component.owner = nil;
    NSMutableArray<Component *> *newSubcomponents = [self.compoundState.subcomponents mutableCopy];
    [newSubcomponents removeObject:component];
    self.compoundState = [[CompoundComponentState alloc] initWithState:self.compoundState.state
                                                                  data:self.compoundState.data
                                                         subcomponents:[newSubcomponents copy]];
}

#pragma mark - Worker Thread Support

typedef NSMapTable<Component *, CompoundComponentState *> StateMap;

NSString *key = @"layout state";

- (nonnull LayoutFunction)prepareRootForWorkerThread {
    NSAssert(NSThread.isMainThread, @"Need to be on the main thread.");
    NSAssert(![self.owner isKindOfClass:[Component class]], @"This isn't the root.");

    // Build the tree of all the components.
    [self updateListOfKnownSubcomponents];

    // Gather up the states of all the components.
    StateMap *stateMap = [[StateMap alloc] init];
    [self populateStateMap:stateMap];

    return ^id<LOKLayout>() { // Captured: stateMap and self.
        NSAssert(!NSThread.isMainThread, @"No need to call prepareRootForWorkerThread if the resulting block isn't run on a worker thread.");

        // Put the states in thread local storage so that the state property getters
        // can access a consistent set of values.
        [NSThread.currentThread.threadDictionary setObject:stateMap forKey:key];

        // Produce the layouts.
        id<LOKLayout> result = [self makeLayout];

        // Clear the components states from thread local storage.
        [NSThread.currentThread.threadDictionary removeObjectForKey:key];

        return result;
    };
}

/// Gathers the state objects from the subcomponent tree.
- (void)populateStateMap:(StateMap *)stateMap {
    NSAssert(NSThread.isMainThread, @"The state map can only be constructed on the main thread.");

    [stateMap setObject:self.compoundState forKey:self];

    for (Component* subcomponent in self.compoundState.subcomponents) {
        [subcomponent populateStateMap:stateMap];
    }
}

/// Makes sure that any components referenced by this component are tracked as subcomponents.
- (void)updateListOfKnownSubcomponents {
    NSAssert(NSThread.isMainThread, @"Component ownership should only be accessed on the main thread.");

    // Finds the ivars in this object.
    for (Class theClass = [self class]; theClass != nil && theClass != [Component class]; theClass = class_getSuperclass(theClass)) {
        unsigned int ivarCount;
        Ivar *ivars = class_copyIvarList(theClass, &ivarCount);
        for (int i = 0; i < ivarCount; i++) {
            Ivar ivar = ivars[i];

            // Checks if they hold an object.
            if (*ivar_getTypeEncoding(ivar) == '@') {
                id ivarValue = object_getIvar(self, ivar);

                // Checks if the object is another component.
                if ([ivarValue isKindOfClass:[Component class]]) {

                    // Registers it as a subcomponent.
                    [self registerComponent:(Component *)ivarValue];
                }
            }
        }
        free(ivars);
        // Could do the same with properties via class_copyPropertyList instead of or in addition to processing the ivars.
    }

    // Recurse down the subcomponent tree.
    for (Component *subcomponent in self.compoundState.subcomponents) {
        [subcomponent updateListOfKnownSubcomponents];
    }
}

#pragma mark - Layout Construction

- (nonnull id<LOKLayout>)makeLayout {
    NSAssert(NO, @"Components should derive from this class and implement this method.");
    return nil;
}

- (id<LOKLayout>)layout {
    // Just a helper property to make subcomponent layout creation more convenient.
    return [self makeLayout];
}

@end
