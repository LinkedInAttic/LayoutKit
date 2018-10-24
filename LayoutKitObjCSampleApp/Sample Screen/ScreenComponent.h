#import "Component.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScreenComponent : Component<id, NSString*>

- (nonnull instancetype)initWithString:(nonnull NSString*)string;

@end

NS_ASSUME_NONNULL_END
