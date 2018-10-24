// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "ViewController.h"
#import "ScreenComponent.h"
#import "ComponentHost.h"
#import "KeyboardSafeAreaListener.h"

@import Foundation;
@import UIKit;

@interface ViewController ()

@property (nonatomic, strong, nonnull) ScreenComponent *screenComponent;
@property (nonatomic, strong, nonnull) ComponentHost *host;

@end

@implementation ViewController

- (instancetype)init {
    if (self = [super init]) {
        _screenComponent = [[ScreenComponent alloc] initWithString:@"This should get replaced with new data later."];
        _host = [[ComponentHost alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;

    self.screenComponent.data = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quid sequatur, quid repugnet, vident. Quid igitur dubitamus in tota eius natura quaerere quid sit effectum? Id est enim, de quo quaerimus. Quid enim necesse est, tamquam meretricem in matronarum coetum, sic voluptatem in virtutum concilium adducere?";

    self.screenComponent.owner = self.host;
    [self.host hostInView:self.view];

    [KeyboardSafeAreaListener.shared addViewController:self];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    [self.host viewWillChangeSizeTo:size];
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    self.host.insets = self.view.safeAreaInsets;
}

@end
