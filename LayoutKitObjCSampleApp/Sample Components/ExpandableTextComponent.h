#import "Component.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExpandableTextComponent : Component<NSNumber*,NSString*>

- (nonnull instancetype)initWithText:(nullable NSString *)text initiallyExpanded:(BOOL)isExpanded;
- (nonnull instancetype)initWithState:(nullable id)state data:(nullable id)data NS_UNAVAILABLE;

@property (nonatomic, readwrite, getter=isExpanded) BOOL expanded;
@property (nonatomic, nullable, readwrite) NSString *text;

@end

NS_ASSUME_NONNULL_END
