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

@interface RotationView: UIView
@end
@implementation RotationView
-(instancetype)init {
    if (self = [super init]) {
        self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);
    }
    return self;
}
@end

@interface RotationLayout: NSObject <LOKLayout>
-(instancetype)initWithSublayout:(id<LOKLayout>)sublayout alignment:(LOKAlignment*)alignment viewReuseId:(NSString*)viewReuseId;
@property (readonly, nonatomic, nonnull) id<LOKLayout> sublayout;
@property (readonly, nonatomic, nonnull) LOKAlignment* alignment;
@property (readonly, nonatomic) BOOL needsView;
@property (readonly, nonatomic, nonnull) LOKFlexibility* flexibility;
@property (readonly, copy, nonatomic) NSString* viewReuseId;
@end
@implementation RotationLayout

-(instancetype)initWithSublayout:(id<LOKLayout>)sublayout alignment:(LOKAlignment*)alignment viewReuseId:(NSString*)viewReuseId {
    if (self = [super init]) {
        _sublayout = sublayout;
        _alignment = alignment;
        _needsView = YES;
        _flexibility = sublayout.flexibility;
        _viewReuseId = viewReuseId;
    }
    return self;
}

- (LOKLayoutArrangement * _Nonnull)arrangementWithin:(CGRect)rect measurement:(LOKLayoutMeasurement * _Nonnull)measurement {
    CGSize unrotatedSize = CGSizeMake(measurement.size.height, measurement.size.width);

    LOKLayoutArrangement* sublayoutArrangement = [self.sublayout arrangementWithin:CGRectMake(0, 0, unrotatedSize.width, unrotatedSize.height)
                                                                       measurement:measurement.sublayouts.firstObject];
    CGRect frame = [self.alignment positionWithSize:measurement.size in:rect];
    return [[LOKLayoutArrangement alloc] initWithLayout:self
                                                  frame:frame
                                             sublayouts:@[sublayoutArrangement]];
}

- (void)configureWithBaseTypeView:(UIView * _Nonnull)baseTypeView {

}

- (UIView * _Nonnull)makeView {
    return [[RotationView alloc] init];
}

- (LOKLayoutMeasurement * _Nonnull)measurementWithin:(CGSize)maxSize {
    LOKLayoutMeasurement *sublayoutMeasurement = [self.sublayout measurementWithin:maxSize];
    CGSize rotatedSize = CGSizeMake(sublayoutMeasurement.size.height, sublayoutMeasurement.size.width);
    return [[LOKLayoutMeasurement alloc] initWithLayout:self
                                                   size:rotatedSize
                                                maxSize:maxSize
                                             sublayouts:@[sublayoutMeasurement]];
}


@end

@interface ViewController ()

@property (nonatomic, strong, nonnull) id<LOKLayout> primaryLayout;

@end


@implementation ViewController

- (instancetype)init {
    if (self = [super init]) {
        LOKLabelLayout* labelLayoutA = [[LOKLabelLayout alloc] initWithString:@"Hello"
                                                                        font:[UIFont systemFontOfSize:UIFont.systemFontSize]
                                                               numberOfLines:0
                                                                   alignment:LOKAlignment.fill
                                                                 flexibility:LOKFlexibility.flexible
                                                                 viewReuseId:nil
                                                                   viewClass:MyLabelView.class
                                                                   configure:^(UILabel* label) {
                                                                       label.backgroundColor = UIColor.whiteColor;
                                                                   }];
        LOKLabelLayout* labelLayoutB = [[LOKLabelLayout alloc] initWithString:@"world!"
                                                                        font:[UIFont systemFontOfSize:UIFont.systemFontSize]
                                                               numberOfLines:0
                                                                   alignment:LOKAlignment.fill
                                                                 flexibility:LOKFlexibility.flexible
                                                                 viewReuseId:nil
                                                                   viewClass:MyLabelView.class
                                                                   configure:^(UILabel* label) {
                                                                       label.backgroundColor = UIColor.whiteColor;
                                                                   }];
        LOKStackLayout* stackLayout = [[LOKStackLayout alloc] initWithAxis:LOKAxisHorizontal
                                                                   spacing:10
                                                              distribution:nil
                                                                 alignment:nil
                                                               flexibility:nil
                                                                 viewClass:nil
                                                               viewReuseId:nil
                                                                sublayouts:@[labelLayoutA, labelLayoutB]
                                                                 configure:nil];
        LOKInsetLayout* insetLayout = [[LOKInsetLayout alloc] initWithInsets:UIEdgeInsetsMake(20, 20, 20, 20)
                                                                   alignment:LOKAlignment.fill
                                                                 viewReuseId:nil
                                                                   viewClass:LabelBackgroundView.class
                                                                   sublayout:stackLayout
                                                                   configure:^(UIView* view) { }];

        RotationLayout* rotationLayout = [[RotationLayout alloc] initWithSublayout:insetLayout alignment:LOKAlignment.center viewReuseId:nil];

        _primaryLayout = rotationLayout;
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

    LOKLayoutArrangement* arrangement = [LOKLayoutArrangement arrangeLayout:safeInsetLayout
                                                                      width:self.view.frame.size.width
                                                                     height:self.view.frame.size.height];

    [arrangement makeViewsIn:self.view];
}

@end
