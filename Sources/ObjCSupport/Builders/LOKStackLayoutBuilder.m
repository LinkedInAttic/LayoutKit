// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKStackLayoutBuilder.h"

#import <LayoutKitObjC/LayoutKitObjC-Swift.h>

@implementation LOKStackLayoutBuilder

+ (instancetype)withSublayouts:(NSArray<id<LOKLayout>> *)sublayouts {
    LOKStackLayoutBuilder *builder = [[self alloc] init];
    builder.axis = LOKAxisVertical;
    builder.sublayouts = sublayouts;
    return builder;
}

- (LOKStackLayout *)build {
    return [[LOKStackLayout alloc] initWithAxis:self.axis
                                        spacing:self.spacing
                                   distribution:self.distribution
                                      alignment:self.alignment
                                    flexibility:self.flexibility
                                      viewClass:self.viewClass
                                    viewReuseId:self.viewReuseId
                                     sublayouts:self.sublayouts
                                      configure:self.configure];
}

- (LOKStackLayoutBuilder *)horizontal {
    self.axis = LOKAxisHorizontal;
    return self;
}

- (LOKStackLayoutBuilder *)vertical {
    self.axis = LOKAxisVertical;
    return self;
}

- (LOKStackLayoutBuilder * _Nonnull (^)(CGFloat))withSpacing {
    return ^LOKStackLayoutBuilder *(CGFloat spacing){
        self.spacing = spacing;
        return self;
    };
}

- (LOKStackLayoutBuilder * _Nonnull (^)(LOKStackLayoutDistribution))withDistribution {
    return ^LOKStackLayoutBuilder *(LOKStackLayoutDistribution distribution){
        self.distribution = distribution;
        return self;
    };
}

- (LOKStackLayoutBuilder *)center {
    self.alignment = LOKAlignment.center;
    return self;
}

- (LOKStackLayoutBuilder *)fill {
    self.alignment = LOKAlignment.fill;
    return self;
}

- (LOKStackLayoutBuilder *)topCenter {
    self.alignment = LOKAlignment.topCenter;
    return self;
}

- (LOKStackLayoutBuilder *)topFill {
    self.alignment = LOKAlignment.topFill;
    return self;
}

- (LOKStackLayoutBuilder *)topLeading {
    self.alignment = LOKAlignment.topLeading;
    return self;
}

- (LOKStackLayoutBuilder *)topTrailing {
    self.alignment = LOKAlignment.topTrailing;
    return self;
}

- (LOKStackLayoutBuilder *)bottomCenter {
    self.alignment = LOKAlignment.bottomCenter;
    return self;
}

- (LOKStackLayoutBuilder *)bottomFill {
    self.alignment = LOKAlignment.bottomFill;
    return self;
}

- (LOKStackLayoutBuilder *)bottomLeading {
    self.alignment = LOKAlignment.bottomLeading;
    return self;
}

- (LOKStackLayoutBuilder *)bottomTrailing {
    self.alignment = LOKAlignment.bottomTrailing;
    return self;
}

- (LOKStackLayoutBuilder *)centerFill {
    self.alignment = LOKAlignment.centerFill;
    return self;
}

- (LOKStackLayoutBuilder *)centerLeading {
    self.alignment = LOKAlignment.centerLeading;
    return self;
}

- (LOKStackLayoutBuilder *)centerTrailing {
    self.alignment = LOKAlignment.centerTrailing;
    return self;
}

- (LOKStackLayoutBuilder *)fillLeading {
    self.alignment = LOKAlignment.fillLeading;
    return self;
}

- (LOKStackLayoutBuilder *)fillTrailing {
    self.alignment = LOKAlignment.fillTrailing;
    return self;
}

- (LOKStackLayoutBuilder *)fillCenter {
    self.alignment = LOKAlignment.fillCenter;
    return self;
}

- (LOKStackLayoutBuilder * _Nonnull (^)(LOKAlignment * _Nonnull))withAlignment {
    return ^LOKStackLayoutBuilder *(LOKAlignment * alignment){
        self.alignment = alignment;
        return self;
    };
}

- (LOKStackLayoutBuilder * _Nonnull (^)(LOKFlexibility * _Nonnull))withFlexibility {
    return ^LOKStackLayoutBuilder *(LOKFlexibility * flexibility){
        self.flexibility = flexibility;
        return self;
    };
}

- (LOKStackLayoutBuilder * _Nonnull (^)(NSString * _Nonnull))withViewReuseId {
    return ^LOKStackLayoutBuilder *(NSString * viewReuseId){
        self.viewReuseId = viewReuseId;
        return self;
    };
}

- (LOKStackLayoutBuilder * _Nonnull (^)(Class _Nonnull))withViewClass {
    return ^LOKStackLayoutBuilder *(Class viewClass){
        self.viewClass = viewClass;
        return self;
    };
}

- (LOKStackLayoutBuilder * _Nonnull (^)(void(^ _Nonnull)(View *_Nonnull)))withConfig {
    return ^LOKStackLayoutBuilder *(void(^ _Nonnull config)(View *_Nonnull)){
        self.configure = config;
        return self;
    };
}

@end
