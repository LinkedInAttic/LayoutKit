// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "ViewController.h"
#import "RotationLayout.h"
#import "LOKLabelLayoutBuilder.h"
#import "LOKInsetLayoutBuilder.h"
#import "LOKSizeLayoutBuilder.h"
#import "LOKStackLayoutBuilder.h"

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

    LOKSizeLayoutBuilder *cellLayoutBuilder = [LOKSizeLayoutBuilder withSublayout:self.helloWorldLayout];
    cellLayoutBuilder.width = self.view.bounds.size.width;
    LOKSizeLayout *cellLayout = [cellLayoutBuilder build];

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
    LOKLabelLayoutBuilder *labelLayoutBuilderA = [LOKLabelLayoutBuilder withString:@"Hello"];
    labelLayoutBuilderA.viewClass = MyLabelView.class;
    labelLayoutBuilderA.configure = ^(UIView * _Nonnull label) {
        label.backgroundColor = UIColor.whiteColor;
    };
    LOKLabelLayout *labelLayoutA = [labelLayoutBuilderA build];
    LOKLabelLayoutBuilder *labelLayoutBuilderB = [LOKLabelLayoutBuilder withString:@"world!"];
    labelLayoutBuilderB.viewClass = MyLabelView.class;
    labelLayoutBuilderB.configure = ^(UIView * _Nonnull label) {
        label.backgroundColor = UIColor.whiteColor;
    };
    LOKLabelLayout *labelLayoutB = [labelLayoutBuilderB build];
    LOKStackLayoutBuilder *stackLayoutBuilder = [LOKStackLayoutBuilder withSublayouts:@[labelLayoutA, labelLayoutB]];
    stackLayoutBuilder.axis = LOKAxisHorizontal;
    stackLayoutBuilder.spacing = 10;
    LOKInsetLayoutBuilder *insetLayoutBuilder = [LOKInsetLayoutBuilder withInsets:UIEdgeInsetsMake(20, 20, 20, 20) around:[stackLayoutBuilder build]];
    insetLayoutBuilder.alignment = LOKAlignment.fill;
    insetLayoutBuilder.viewClass = LabelBackgroundView.class;
    insetLayoutBuilder.configure = ^(UIView * _Nonnull view) { };
    return [[RotationLayout alloc] initWithSublayout:[insetLayoutBuilder build]
                                           alignment:LOKAlignment.center
                                         viewReuseId:nil];
}

@end
