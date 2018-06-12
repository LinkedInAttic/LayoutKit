// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKButtonLayoutBuilder.h"

#import <LayoutKitObjC/LayoutKitObjC-Swift.h>

@interface LOKButtonLayoutBuilder ()

@property (nonatomic, nullable) LOKAlignment *privateAlignment;
@property (nonatomic, nullable) LOKFlexibility *privateFlexibility;
@property (nonatomic, nullable) NSString *privateViewReuseId;
@property (nonatomic, nullable) Class privateViewClass;

@property (nonatomic) LOKButtonLayoutType privateType;
@property (nonatomic, nullable) NSString *privateTitle;
@property (nonatomic, nullable) UIFont *privateFont;
@property (nonatomic, nullable) UIImage *privateImage;
@property (nonatomic) CGSize privateImageSize;
@property (nonatomic, nullable) NSValue *privateContentEdgeInsets;
@property (nonatomic, nullable) void (^ privateConfigure)(UIButton * _Nonnull);

@end

@implementation LOKButtonLayoutBuilder

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    _privateTitle = title;
    return self;
}

+ (instancetype)withTitle:(NSString *)title {
    return [[self alloc] initWithTitle:title];
}

- (LOKButtonLayout *)layout {
    return [[LOKButtonLayout alloc] initWithType:self.privateType
                                           title:self.privateTitle
                                           image:self.privateImage
                                       imageSize:self.privateImageSize
                                            font:self.privateFont
                               contentEdgeInsets:self.privateContentEdgeInsets
                                       alignment:self.privateAlignment
                                     flexibility:self.privateFlexibility
                                     viewReuseId:self.privateViewReuseId
                                       viewClass:self.privateViewClass
                                          config:self.privateConfigure];
}

- (LOKButtonLayoutBuilder * _Nonnull (^)(LOKButtonLayoutType))type {
    return ^LOKButtonLayoutBuilder *(LOKButtonLayoutType type){
        self.privateType = type;
        return self;
    };
}

- (LOKButtonLayoutBuilder * _Nonnull (^)(UIFont * _Nullable))font {
    return ^LOKButtonLayoutBuilder *(UIFont * font){
        self.privateFont = font;
        return self;
    };
}

- (LOKButtonLayoutBuilder * _Nonnull (^)(UIImage * _Nullable))image {
    return ^LOKButtonLayoutBuilder *(UIImage * image){
        self.privateImage = image;
        return self;
    };
}

- (LOKButtonLayoutBuilder * _Nonnull (^)(CGSize))imageSize {
    return ^LOKButtonLayoutBuilder *(CGSize imageSize){
        self.privateImageSize = imageSize;
        return self;
    };
}

- (LOKButtonLayoutBuilder * _Nonnull (^)(NSValue * _Nullable))contentEdgeInsets {
    return ^LOKButtonLayoutBuilder *(NSValue * _Nullable contentEdgeInsets){
        self.privateContentEdgeInsets = contentEdgeInsets;
        return self;
    };
}

- (LOKButtonLayoutBuilder * _Nonnull (^)(LOKAlignment * _Nonnull))alignment {
    return ^LOKButtonLayoutBuilder *(LOKAlignment * alignment){
        self.privateAlignment = alignment;
        return self;
    };
}

- (LOKButtonLayoutBuilder * _Nonnull (^)(LOKFlexibility * _Nonnull))flexibility {
    return ^LOKButtonLayoutBuilder *(LOKFlexibility * flexibility){
        self.privateFlexibility = flexibility;
        return self;
    };
}

- (LOKButtonLayoutBuilder * _Nonnull (^)(NSString * _Nonnull))viewReuseId {
    return ^LOKButtonLayoutBuilder *(NSString * viewReuseId){
        self.privateViewReuseId = viewReuseId;
        return self;
    };
}

- (LOKButtonLayoutBuilder * _Nonnull (^)(Class _Nonnull))viewClass {
    return ^LOKButtonLayoutBuilder *(Class viewClass){
        self.privateViewClass = viewClass;
        return self;
    };
}

- (LOKButtonLayoutBuilder * _Nonnull (^)(void(^ _Nullable)(UIButton *_Nonnull)))config {
    return ^LOKButtonLayoutBuilder *(void(^ _Nullable config)(UIButton *_Nonnull)){
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
