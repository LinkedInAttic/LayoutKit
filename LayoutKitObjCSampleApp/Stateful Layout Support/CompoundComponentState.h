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
