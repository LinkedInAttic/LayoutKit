// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKSizeLayoutBuilder.h"

#import <LayoutKitObjC/LayoutKitObjC-Swift.h>

@interface LOKSizeLayoutBuilder ()

@property (nonatomic, nullable) LOKAlignment *privateAlignment;
@property (nonatomic, nullable) LOKFlexibility *privateFlexibility;
@property (nonatomic, nullable) NSString *privateViewReuseId;
@property (nonatomic, nullable) Class privateViewClass;

@property (nonatomic, nullable) id<LOKLayout> privateSublayout;
@property (nonatomic) CGFloat privateMinWidth;
@property (nonatomic) CGFloat privateMaxWidth;
@property (nonatomic) CGFloat privateMinHeight;
@property (nonatomic) CGFloat privateMaxHeight;
@property (nonatomic) CGFloat privateWidth;
@property (nonatomic) CGFloat privateHeight;
@property (nonatomic, nullable) void (^ privateConfigure)(LOKView * private_Nonnull);

@end

@implementation LOKSizeLayoutBuilder

- (instancetype)initWithSublayout:(id<LOKLayout>)sublayout {
    self = [super init];
    _privateSublayout = sublayout;
    _privateMinWidth = 0;
    _privateMinHeight = 0;
    _privateMaxWidth = INFINITY;
    _privateMaxHeight = INFINITY;
    return self;
}

+ (instancetype)withSublayout:(id<LOKLayout>)sublayout {
    return [[self alloc] initWithSublayout:sublayout];
}

- (CGFloat)privateWidth {
    NSAssert(self.privateMaxWidth == self.privateMinWidth, @"Can't retrieve a single width property when there's a range set.");
    return self.privateMaxWidth;
}

- (void)setPrivateWidth:(CGFloat)width {
    self.privateMinWidth = width;
    self.privateMaxWidth = width;
}

- (CGFloat)privateHeight {
    NSAssert(self.privateMaxHeight == self.privateMinHeight, @"Can't retrieve a singular height property when there's a range set.");
    return self.privateMaxHeight;
}

- (void)setPrivateHeight:(CGFloat)height {
    self.privateMinHeight = height;
    self.privateMaxHeight = height;
}

- (LOKSizeLayout *)layout {
    return [[LOKSizeLayout alloc] initWithMinWidth:self.privateMinWidth
                                          maxWidth:self.privateMaxWidth
                                         minHeight:self.privateMinHeight
                                         maxHeight:self.privateMaxHeight
                                         alignment:self.privateAlignment
                                       flexibility:self.privateFlexibility
                                       viewReuseId:self.privateViewReuseId
                                         viewClass:self.privateViewClass
                                         sublayout:self.privateSublayout
                                         configure:self.privateConfigure];
}

- (LOKSizeLayoutBuilder * _Nonnull (^)(CGFloat))width {
    return ^LOKSizeLayoutBuilder *(CGFloat width){
        self.privateWidth = width;
        return self;
    };
}

- (LOKSizeLayoutBuilder * _Nonnull (^)(CGFloat))height {
    return ^LOKSizeLayoutBuilder *(CGFloat height){
        self.privateHeight = height;
        return self;
    };
}

- (LOKSizeLayoutBuilder * _Nonnull (^)(CGFloat))minWidth {
    return ^LOKSizeLayoutBuilder *(CGFloat minWidth){
        self.privateMinWidth = minWidth;
        return self;
    };
}

- (LOKSizeLayoutBuilder * _Nonnull (^)(CGFloat))minHeight {
    return ^LOKSizeLayoutBuilder *(CGFloat minHeight){
        self.privateMinHeight = minHeight;
        return self;
    };
}

- (LOKSizeLayoutBuilder * _Nonnull (^)(CGFloat))maxWidth {
    return ^LOKSizeLayoutBuilder *(CGFloat maxWidth){
        self.privateMaxWidth = maxWidth;
        return self;
    };
}

- (LOKSizeLayoutBuilder * _Nonnull (^)(CGFloat))maxHeight {
    return ^LOKSizeLayoutBuilder *(CGFloat maxHeight){
        self.privateMaxHeight = maxHeight;
        return self;
    };
}

- (LOKSizeLayoutBuilder * _Nonnull (^)(LOKAlignment * _Nonnull))alignment {
    return ^LOKSizeLayoutBuilder *(LOKAlignment * alignment){
        self.privateAlignment = alignment;
        return self;
    };
}

- (LOKSizeLayoutBuilder * _Nonnull (^)(LOKFlexibility * _Nonnull))flexibility {
    return ^LOKSizeLayoutBuilder *(LOKFlexibility * flexibility){
        self.privateFlexibility = flexibility;
        return self;
    };
}

- (LOKSizeLayoutBuilder * _Nonnull (^)(NSString * _Nonnull))viewReuseId {
    return ^LOKSizeLayoutBuilder *(NSString * viewReuseId){
        self.privateViewReuseId = viewReuseId;
        return self;
    };
}

- (LOKSizeLayoutBuilder * _Nonnull (^)(Class _Nonnull))viewClass {
    return ^LOKSizeLayoutBuilder *(Class viewClass){
        self.privateViewClass = viewClass;
        return self;
    };
}

- (LOKSizeLayoutBuilder * _Nonnull (^)(void(^ _Nullable)(LOKView *_Nonnull)))config {
    return ^LOKSizeLayoutBuilder *(void(^ _Nullable config)(LOKView *_Nonnull)){
        self.privateConfigure = config;
        return self;
    };
}

- (LOKInsetLayoutBuilder * _Nonnull (^)(LOKEdgeInsets))insets {
    return ^LOKInsetLayoutBuilder *(LOKEdgeInsets insets){
        return [LOKInsetLayoutBuilder withInsets:insets around:self.layout];
    };
}

@end
