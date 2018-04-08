// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKButtonLayoutBuilder.h"

#import <LayoutKitObjC/LayoutKitObjC-Swift.h>

@implementation LOKButtonLayoutBuilder

+ (instancetype)withTitle:(NSString *)title {
    LOKButtonLayoutBuilder *builder = [[self alloc] init];
    builder.title = title;
    return builder;
}

- (LOKButtonLayout *)build {
    return [[LOKButtonLayout alloc] initWithType:self.type
                                           title:self.title
                                           image:self.image
                                       imageSize:self.imageSize
                                            font:self.font
                               contentEdgeInsets:self.contentEdgeInsets
                                       alignment:self.alignment
                                     flexibility:self.flexibility
                                     viewReuseId:self.viewReuseId
                                       viewClass:self.viewClass
                                          config:self.configure];
}

- (LOKButtonLayoutBuilder * _Nonnull (^)(LOKButtonLayoutType))withType {
    return ^LOKButtonLayoutBuilder *(LOKButtonLayoutType type){
        self.type = type;
        return self;
    };
}

- (LOKButtonLayoutBuilder * _Nonnull (^)(UIFont * _Nullable))withFont {
    return ^LOKButtonLayoutBuilder *(UIFont * font){
        self.font = font;
        return self;
    };
}

- (LOKButtonLayoutBuilder * _Nonnull (^)(UIImage * _Nullable))withImage {
    return ^LOKButtonLayoutBuilder *(UIImage * image){
        self.image = image;
        return self;
    };
}

- (LOKButtonLayoutBuilder * _Nonnull (^)(CGSize))withImageSize {
    return ^LOKButtonLayoutBuilder *(CGSize imageSize){
        self.imageSize = imageSize;
        return self;
    };
}

- (LOKButtonLayoutBuilder * _Nonnull (^)(NSValue * _Nullable))withContentEdgeInsets {
    return ^LOKButtonLayoutBuilder *(NSValue * _Nullable contentEdgeInsets){
        self.contentEdgeInsets = contentEdgeInsets;
        return self;
    };
}

- (LOKButtonLayoutBuilder *)center {
    self.alignment = LOKAlignment.center;
    return self;
}

- (LOKButtonLayoutBuilder *)fill {
    self.alignment = LOKAlignment.fill;
    return self;
}

- (LOKButtonLayoutBuilder *)topCenter {
    self.alignment = LOKAlignment.topCenter;
    return self;
}

- (LOKButtonLayoutBuilder *)topFill {
    self.alignment = LOKAlignment.topFill;
    return self;
}

- (LOKButtonLayoutBuilder *)topLeading {
    self.alignment = LOKAlignment.topLeading;
    return self;
}

- (LOKButtonLayoutBuilder *)topTrailing {
    self.alignment = LOKAlignment.topTrailing;
    return self;
}

- (LOKButtonLayoutBuilder *)bottomCenter {
    self.alignment = LOKAlignment.bottomCenter;
    return self;
}

- (LOKButtonLayoutBuilder *)bottomFill {
    self.alignment = LOKAlignment.bottomFill;
    return self;
}

- (LOKButtonLayoutBuilder *)bottomLeading {
    self.alignment = LOKAlignment.bottomLeading;
    return self;
}

- (LOKButtonLayoutBuilder *)bottomTrailing {
    self.alignment = LOKAlignment.bottomTrailing;
    return self;
}

- (LOKButtonLayoutBuilder *)centerFill {
    self.alignment = LOKAlignment.centerFill;
    return self;
}

- (LOKButtonLayoutBuilder *)centerLeading {
    self.alignment = LOKAlignment.centerLeading;
    return self;
}

- (LOKButtonLayoutBuilder *)centerTrailing {
    self.alignment = LOKAlignment.centerTrailing;
    return self;
}

- (LOKButtonLayoutBuilder *)fillLeading {
    self.alignment = LOKAlignment.fillLeading;
    return self;
}

- (LOKButtonLayoutBuilder *)fillTrailing {
    self.alignment = LOKAlignment.fillTrailing;
    return self;
}

- (LOKButtonLayoutBuilder *)fillCenter {
    self.alignment = LOKAlignment.fillCenter;
    return self;
}

- (LOKButtonLayoutBuilder * _Nonnull (^)(LOKAlignment * _Nonnull))withAlignment {
    return ^LOKButtonLayoutBuilder *(LOKAlignment * alignment){
        self.alignment = alignment;
        return self;
    };
}

- (LOKButtonLayoutBuilder * _Nonnull (^)(LOKFlexibility * _Nonnull))withFlexibility {
    return ^LOKButtonLayoutBuilder *(LOKFlexibility * flexibility){
        self.flexibility = flexibility;
        return self;
    };
}

- (LOKButtonLayoutBuilder * _Nonnull (^)(NSString * _Nonnull))withViewReuseId {
    return ^LOKButtonLayoutBuilder *(NSString * viewReuseId){
        self.viewReuseId = viewReuseId;
        return self;
    };
}

- (LOKButtonLayoutBuilder * _Nonnull (^)(Class _Nonnull))withViewClass {
    return ^LOKButtonLayoutBuilder *(Class viewClass){
        self.viewClass = viewClass;
        return self;
    };
}

- (LOKButtonLayoutBuilder * _Nonnull (^)(void(^ _Nonnull)(View *_Nonnull)))withConfig {
    return ^LOKButtonLayoutBuilder *(void(^ _Nonnull config)(View *_Nonnull)){
        self.configure = config;
        return self;
    };
}

@end
