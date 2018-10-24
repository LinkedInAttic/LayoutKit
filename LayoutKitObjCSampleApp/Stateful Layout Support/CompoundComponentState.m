#import "CompoundComponentState.h"

@implementation CompoundComponentState

- (nonnull instancetype)initWithState:(nullable id)state
                                 data:(nullable id)data
                        subcomponents:(nonnull ComponentArray *)subcomponents {
    self = [super init];
    _state = state;
    _data = data;
    _subcomponents = subcomponents;
    return self;
}

@end
