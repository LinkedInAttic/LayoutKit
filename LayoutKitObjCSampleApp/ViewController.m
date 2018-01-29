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

@interface MyLabelView: UILabel
@end
@implementation MyLabelView
-(instancetype)init {
    if (self = [super init]) {
        self.textColor = UIColor.redColor;
    }
    return self;
}
@end

@interface LabelBackgroundView: UIView
@end
@implementation LabelBackgroundView
-(instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = UIColor.greenColor;
    }
    return self;
}
@end

@interface ViewController ()

@property (nonatomic, strong) id<LOKLayout> primaryLayout;

@end


@implementation ViewController

- (instancetype)init {
    if (self = [super init]) {
        LOKLabelLayout* labelLayout = [[LOKLabelLayout alloc] initWithString:@"Hello world!"
                                                           font:[UIFont systemFontOfSize:UIFont.systemFontSize]
                                                  numberOfLines:0
                                                      alignment:LOKAlignment.topCenter
                                                    flexibility:LOKFlexibility.flexible
                                                    viewReuseId:nil
                                                      viewClass:MyLabelView.class
                                                      configure:^(UILabel* label) {
                                                          label.backgroundColor = UIColor.whiteColor;
                                                      }];
        LOKInsetLayout* insetLayout = [[LOKInsetLayout alloc] initWithInsets:UIEdgeInsetsMake(20, 20, 20, 20)
                                                                   alignment:LOKAlignment.topCenter
                                                                 viewReuseId:nil
                                                                   sublayout:labelLayout
                                                                   viewClass:LabelBackgroundView.class
                                                                   configure:^(UIView* view) { }];
        _primaryLayout = insetLayout;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    id<LOKLayout> safeInsetLayout = [LOKInsetLayout insetBy:self.view.safeAreaInsets sublayout:self.primaryLayout];

    LOKLayoutArrangement* arrangement = [[LOKLayoutArrangement alloc] initWithLayout:safeInsetLayout
                                                                               width:self.view.frame.size.width
                                                                              height:self.view.frame.size.height];

    [arrangement makeViewsIn:self.view];
}

@end
