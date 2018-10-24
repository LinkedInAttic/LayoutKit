#import <LayoutKitObjC/LayoutKitObjC.h>
#import "ComponentOwner.h"

NS_ASSUME_NONNULL_BEGIN

///
/// Allows UI code to use both LayoutKit and state and still support multi-threaded layout.
/// Components are nestable. @c State and @c Data must be immutable.
///
/// To build stateful LayoutKit UI, subclass this class and
/// override the @c makeLayout method to construct the UI.
/// This method will be called on a background worker thread.
///
/// The @c data and @c state properties can be read (but not modified) inside that method
/// in order to construct the layout. UI gesture handler blocks, LayoutKit config blocks,
/// UI delegates, and any other code running on the main thread is free to modify these properties.
///
/// IMPORTANT:
/// Derived classes can create additional writeable properties,
/// but those properties must be backed by @c state or @c data
/// and not regular ivars if they're to be accessed in the layout method
/// in order to get both thread safety and automatic update on change.
///
/// RECOMMENDATION:
/// It is strongly recommended that all mutable properties are backed by
/// the @c state or @c data properties in order to avoid accidental
/// unsafe access inside the @c makeLayout method.
///
/// A bit more detail regarding the thread safety of the @c data and @c state properties:
/// They are indeed safe to read within the @c makeLayout method,
/// even when it's running on a background thread.
/// They will have values that are consistent with the layout that's currently being
/// constructed on that particular background thread. These values get effectively frozen
/// on that background thread and therefore may differ from the values observable on those
/// properties on the main thread.
///
/// Both @c state and @c data properties behave in the same way but are separated for convenience.
/// Modifying either value notifies the owner of the change and triggers a re-layout.
/// The @c data property should hold the content that's provided externally, such as
/// from a network or from the user.
/// The @c state property should hold values that are managed internally by the component.
///
/// If a component doesn't need either state and/or data,
/// @c id can be used as the argument for the corresponding type parameter.
///
@interface Component<State, Data> : NSObject<ComponentOwner>

/// Derived classes should keep their mutable internal state in this property.
/// If the component has complex state comprised of more than one value,
/// it should be combined into an immutable custom object or array.
///
/// This property should only be modified on the main thread.
///
/// This property can be read from the background thread in the implementation
/// of @c makeLayout.
///
/// Setting this property triggers an asynchronous re-layout at the root component.
@property (nonatomic, nullable, strong, readwrite) State state;

@property (nonatomic, nullable, strong, readwrite) Data data;

/// References the component's owner. Used to notify the owner of state/data changes. Main thread only.
@property (nonatomic, nullable, weak, readwrite) NSObject<ComponentOwner> *owner;

/// This property can be used to access a subcomponent's current layout inside
/// the parent component's @c makeLayout method.
@property (nonatomic, nonnull, readonly) id<LOKLayout> layout;

- (nonnull instancetype)initWithState:(nullable State)state data:(nullable Data)data;

/// Components should implement this method when they derive from this class.
/// This method will be called on a background worker thread by @c ComponentHost.
- (nonnull id<LOKLayout>)makeLayout;

/// A block that produces a layout.
typedef _Nonnull id<LOKLayout>(^LayoutFunction)(void);

/// Produces a block that would construct a layout matching the component's current data and state.
/// This method will be called by @c ComponentHost. It can only be called on the main thread.
/// The resulting block should be called on a background worker thread.
- (nonnull LayoutFunction)prepareRootForWorkerThread;

@end

NS_ASSUME_NONNULL_END
