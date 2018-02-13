// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "ViewController.h"
#import "RotationLayout.h"

@import Foundation;
@import UIKit;

@interface MyLabelView: UILabel
@end
@implementation MyLabelView
- (instancetype)init {
    if (self = [super init]) {
        self.textColor = UIColor.redColor;
    }
    return self;
}
@end

@interface LabelBackgroundView: UIView
@end
@implementation LabelBackgroundView
- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = UIColor.greenColor;
    }
    return self;
}
@end

@interface ViewController ()

@property (nonatomic, strong, nonnull) id<LOKLayout> primaryLayout;
@property (nonatomic, strong, nonnull) id<LOKLayout> helloWorldLayout;
@property (nonatomic, strong, nonnull) LOKReloadableViewLayoutAdapter *adapter;

@end


@implementation ViewController

- (instancetype)init {
    if (self = [super init]) {
        _helloWorldLayout = [ViewController makeHelloLayout];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                                          collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    collectionView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:collectionView];
    self.adapter = [[LOKReloadableViewLayoutAdapter alloc] initWithCollectionView:collectionView];
    collectionView.delegate = self.adapter;
    collectionView.dataSource = self.adapter;

    LOKSizeLayout *cellLayout = [[LOKSizeLayout alloc] initWithMinWidth:self.view.bounds.size.width
                                                               maxWidth:self.view.bounds.size.width
                                                              minHeight:0
                                                              maxHeight:INFINITY
                                                              alignment:nil
                                                            flexibility:nil
                                                            viewReuseId:nil
                                                              viewClass:nil
                                                              sublayout:self.helloWorldLayout];

    NSArray *items = @[
                       cellLayout, cellLayout, cellLayout, cellLayout,
                       cellLayout, cellLayout, cellLayout, cellLayout,
                       cellLayout, cellLayout, cellLayout, cellLayout,
                       cellLayout, cellLayout, cellLayout, cellLayout,
                       cellLayout, cellLayout, cellLayout, cellLayout
                       ];
    LOKLayoutSection *section = [[LOKLayoutSection alloc] initWithHeader:nil items:items footer:nil];
    [self.adapter reloadWithSynchronous:YES
                                  width:self.view.bounds.size.width
                                 height:INFINITY
                           batchUpdates:nil
                         layoutProvider:^NSArray<LOKLayoutSection *> * _Nonnull{
                             return @[section];
                         }
                             completion:nil];

    // TODO: Unclear why this is needed.
    [collectionView reloadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    id<LOKLayout> safeInsetLayout = [LOKInsetLayout insetBy:self.view.safeAreaInsets sublayout:self.helloWorldLayout];

    LOKLayoutArrangement *arrangement = [LOKLayoutArrangement arrangeLayout:safeInsetLayout
                                                                      width:self.view.frame.size.width
                                                                     height:self.view.frame.size.height];

    [arrangement makeViewsIn:self.view];
}

+ (id<LOKLayout>)makeHelloLayout {
    LOKLabelLayout *labelLayoutA = [[LOKLabelLayout alloc] initWithString:@"Hello"
                                                                     font:[UIFont systemFontOfSize:UIFont.systemFontSize]
                                                            numberOfLines:0
                                                                alignment:LOKAlignment.fill
                                                              flexibility:LOKFlexibility.flexible
                                                              viewReuseId:nil
                                                                viewClass:MyLabelView.class
                                                                configure:^(UILabel *label) {
                                                                    label.backgroundColor = UIColor.whiteColor;
                                                                }];
    LOKLabelLayout *labelLayoutB = [[LOKLabelLayout alloc] initWithString:@"world!"
                                                                     font:[UIFont systemFontOfSize:UIFont.systemFontSize]
                                                            numberOfLines:0
                                                                alignment:LOKAlignment.fill
                                                              flexibility:LOKFlexibility.flexible
                                                              viewReuseId:nil
                                                                viewClass:MyLabelView.class
                                                                configure:^(UILabel *label) {
                                                                    label.backgroundColor = UIColor.whiteColor;
                                                                }];
    LOKStackLayout *stackLayout = [[LOKStackLayout alloc] initWithAxis:LOKAxisHorizontal
                                                               spacing:10
                                                          distribution:LOKStackLayoutDistributionDefault
                                                             alignment:nil
                                                           flexibility:nil
                                                             viewClass:nil
                                                           viewReuseId:nil
                                                            sublayouts:@[labelLayoutA, labelLayoutB]
                                                             configure:nil];
    LOKInsetLayout *insetLayout = [[LOKInsetLayout alloc] initWithInsets:UIEdgeInsetsMake(20, 20, 20, 20)
                                                               alignment:LOKAlignment.fill
                                                             viewReuseId:nil
                                                               viewClass:LabelBackgroundView.class
                                                               sublayout:stackLayout
                                                               configure:^(UIView *view) { }];
    return [[RotationLayout alloc] initWithSublayout:insetLayout
                                           alignment:LOKAlignment.center
                                         viewReuseId:nil];
}

@end
