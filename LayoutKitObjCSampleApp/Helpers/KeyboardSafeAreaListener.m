// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

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
