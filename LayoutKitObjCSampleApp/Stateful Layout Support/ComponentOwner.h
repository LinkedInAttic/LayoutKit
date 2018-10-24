@class Component;

/// Used by @c Component<State,Data> base class to notify its owner of state and data changes.
@protocol ComponentOwner

/// Notifies this owner that the given component has experienced some changes and should be re-rendered.
- (void)notifyUpdateFromComponent:(nonnull Component *)component;

/// Notifies this owner that it now owns the given component.
- (void)registerComponent:(nonnull Component *)component;

/// Notifies this owner that it no longer owns the given component.
- (void)unregisterComponent:(nonnull Component *)component;

@end
