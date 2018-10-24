#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Helper class for attaching a block as the tap handler.
 */
@interface BlockTapGestureRecognizer : UITapGestureRecognizer

typedef void (^ViewBlock)(UIView*);

-(instancetype)initWithBlock:(nonnull ViewBlock)block;

@end

NS_ASSUME_NONNULL_END
