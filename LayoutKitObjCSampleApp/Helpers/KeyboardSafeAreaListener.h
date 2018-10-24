#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyboardSafeAreaListener : NSObject

@property (nonatomic, class, readonly) KeyboardSafeAreaListener *shared;

- (void)addViewController:(UIViewController*)viewController;
- (void)removeViewController:(UIViewController*)viewController;

@end

NS_ASSUME_NONNULL_END
