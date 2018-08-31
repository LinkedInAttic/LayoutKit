// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <Foundation/Foundation.h>
#import <LayoutKitObjC/LayoutKitObjC.h>

#import "RotationLayout.h"

@interface RotationView: UIView
@end
@implementation RotationView
- (instancetype)init {
    if (self = [super init]) {
        self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);
    }
    return self;
}
@end

@implementation RotationLayout

- (instancetype)initWithSublayout:(id<LOKLayout>)sublayout alignment:(LOKAlignment *)alignment viewReuseId:(NSString *)viewReuseId {
    if (self = [super init]) {
        _sublayout = sublayout;
        _alignment = alignment;
        _needsView = YES;
        _flexibility = sublayout.flexibility;
        _viewReuseId = viewReuseId;
    }
    return self;
}

- (nonnull LOKLayoutArrangement *)arrangementWithin:(CGRect)rect measurement:(nonnull LOKLayoutMeasurement *)measurement {
    CGSize unrotatedSize = CGSizeMake(measurement.size.height, measurement.size.width);

    LOKLayoutArrangement *sublayoutArrangement = [self.sublayout arrangementWithin:CGRectMake(0, 0, unrotatedSize.width, unrotatedSize.height)
                                                                       measurement:measurement.sublayouts.firstObject];
    CGRect frame = [self.alignment positionWithSize:measurement.size in:rect];
    return [[LOKLayoutArrangement alloc] initWithLayout:self
                                                  frame:frame
                                             sublayouts:@[sublayoutArrangement]];
}

- (nonnull UIView *)makeView {
    return [[RotationView alloc] init];
}

- (void)configureView:(UIView *)view {
    
}

- (nonnull LOKLayoutMeasurement *)measurementWithin:(CGSize)maxSize {
    LOKLayoutMeasurement *sublayoutMeasurement = [self.sublayout measurementWithin:maxSize];
    CGSize rotatedSize = CGSizeMake(sublayoutMeasurement.size.height, sublayoutMeasurement.size.width);
    return [[LOKLayoutMeasurement alloc] initWithLayout:self
                                                   size:rotatedSize
                                                maxSize:maxSize
                                             sublayouts:@[sublayoutMeasurement]];
}

@end
