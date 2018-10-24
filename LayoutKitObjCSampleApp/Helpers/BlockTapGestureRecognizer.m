#import "BlockTapGestureRecognizer.h"

@interface BlockTapGestureRecognizer ()

@property (nonatomic, strong, nonnull, readonly) ViewBlock block;

@end

@implementation BlockTapGestureRecognizer

- (instancetype)initWithBlock:(nonnull ViewBlock)block {
    if (self = [super initWithTarget:self action:@selector(handleFromView:)]) {
        _block = block;
    }
    return self;
}

- (void)handleFromView:(UIView*)view {
    if (_block) {
        _block(view);
    }
}

@end
