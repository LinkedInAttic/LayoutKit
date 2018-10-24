#import "KeyboardSafeAreaListener.h"

@interface KeyboardSafeAreaListener ()
@property (nonatomic, strong, readonly) NSHashTable<UIViewController*> *viewControllers;
@property (nonatomic, assign, readwrite, getter=isListening) BOOL listening;
@end

@implementation KeyboardSafeAreaListener

+ (id)shared {
    static KeyboardSafeAreaListener *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    _viewControllers = [NSHashTable weakObjectsHashTable];
    return self;
}

- (void)addViewController:(UIViewController *)viewController {
    [self.viewControllers addObject:viewController];
    if (!self.isListening) {
        [self startListening];
    }
}

- (void)removeViewController:(UIViewController *)viewController {
    [self.viewControllers removeObject:viewController];
    if (self.isListening && self.viewControllers.count == 0) {
        [self stopListening];
    }
}

- (void)startListening {
    self.listening = YES;

    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(keyboardDidShow:)
                                               name:UIKeyboardDidShowNotification
                                             object:nil];

    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(keyboardDidHide:)
                                               name:UIKeyboardDidHideNotification
                                             object:nil];
}

- (void)stopListening {
    self.listening = NO;
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)keyboardDidShow:(NSNotification *)notification {
    NSValue *frameEndValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    for (UIViewController *viewController in self.viewControllers) {
        UIEdgeInsets insets = viewController.additionalSafeAreaInsets;
        insets.bottom = CGRectGetMaxY(viewController.view.window.frame) - CGRectGetMinY(frameEndValue.CGRectValue) - viewController.view.window.safeAreaInsets.bottom;
        viewController.additionalSafeAreaInsets = insets;
    }
}

- (void)keyboardDidHide:(NSNotification *)notification {
    NSValue *frameEndValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    for (UIViewController *viewController in self.viewControllers) {
        UIEdgeInsets insets = viewController.additionalSafeAreaInsets;
        insets.bottom = CGRectGetMaxY(viewController.view.window.frame) - CGRectGetMinY(frameEndValue.CGRectValue) - viewController.view.window.safeAreaInsets.bottom;
        viewController.additionalSafeAreaInsets = insets;
    }
}

@end
