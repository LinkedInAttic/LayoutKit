// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "ViewController.h"
@import Foundation;
@import UIKit;

@interface ViewController ()

@property (nonatomic, strong) id<LOKLayout> primaryLayout;

@end


@implementation ViewController

- (instancetype)init {
    if (self = [super init]) {
        _primaryLayout = [[LOKLabelLayout alloc] initWithAttributedText:[[NSAttributedString alloc] initWithString:@"Hello world!"]
                                                                   font:[UIFont systemFontOfSize:UIFont.systemFontSize]
                                                          numberOfLines:0
                                                              alignment:LOKAlignment.topCenter
                                                            flexibility:LOKFlexibility.flexible
                                                            viewReuseId:nil
                                                              viewClass:nil
                                                              configure:^(UILabel* label) {
                                                                  label.backgroundColor = UIColor.yellowColor;
                                                              }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    LOKInsetLayout* safeInsetLayout = [[LOKInsetLayout alloc] initWithInsets:self.view.safeAreaInsets
                                                                   alignment:LOKAlignment.fill
                                                                 viewReuseId:nil
                                                                   sublayout:self.primaryLayout
                                                                   viewClass:nil
                                                                   configure:nil];


    LOKLayoutArrangement* arrangement = [[LOKLayoutArrangement alloc] initWithLayout:safeInsetLayout
                                                                               width:self.view.frame.size.width
                                                                              height:self.view.frame.size.height];

    [arrangement makeViewsIn:self.view];
}

@end
