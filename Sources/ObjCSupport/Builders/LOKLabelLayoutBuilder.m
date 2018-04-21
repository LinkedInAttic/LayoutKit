// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKLabelLayoutBuilder.h"

#import <LayoutKitObjC/LayoutKitObjC-Swift.h>

@implementation LOKLabelLayoutBuilder

+ (nonnull instancetype)withString:(nullable NSString *)string {
    LOKLabelLayoutBuilder *builder = [[self alloc] init];
    builder.string = string;
    return builder;
}

+ (nonnull instancetype)withAttributedString:(nullable NSAttributedString *)attributedString {
    LOKLabelLayoutBuilder *builder = [[self alloc] init];
    builder.attributedString = attributedString;
    return builder;
}

- (nonnull LOKLabelLayout *)build {
    NSAssert(!self.attributedString || !self.string, @"LOKLabelLayoutBuilder should not have both a string and an attributedString.");
    if (self.attributedString) {
        return [[LOKLabelLayout alloc] initWithAttributedString:self.attributedString
                                                           font:self.font
                                                     lineHeight:self.lineHeight
                                                  numberOfLines:self.numberOfLines
                                                      alignment:self.alignment
                                                    flexibility:self.flexibility
                                                    viewReuseId:self.viewReuseId
                                                      viewClass:self.viewClass
                                                      configure:self.configure];
    } else {
        return [[LOKLabelLayout alloc] initWithString:self.string
                                                 font:self.font
                                           lineHeight:self.lineHeight
                                        numberOfLines:self.numberOfLines
                                            alignment:self.alignment
                                          flexibility:self.flexibility
                                          viewReuseId:self.viewReuseId
                                            viewClass:self.viewClass
                                            configure:self.configure];
    }
}

- (LOKLabelLayoutBuilder * _Nonnull (^)(UIFont * _Nullable))withFont {
    return ^LOKLabelLayoutBuilder *(UIFont * font){
        self.font = font;
        return self;
    };
}

- (LOKLabelLayoutBuilder * _Nonnull (^)(NSInteger))withNumberOfLines {
    return ^LOKLabelLayoutBuilder *(NSInteger numberOfLines){
        self.numberOfLines = numberOfLines;
        return self;
    };
}

- (LOKLabelLayoutBuilder * _Nonnull (^)(CGFloat))withLineHeight {
    return ^LOKLabelLayoutBuilder *(CGFloat lineHeight){
        self.lineHeight = lineHeight;
        return self;
    };
}

- (LOKLabelLayoutBuilder * _Nonnull (^)(LOKAlignment * _Nonnull))withAlignment {
    return ^LOKLabelLayoutBuilder *(LOKAlignment * alignment){
        self.alignment = alignment;
        return self;
    };
}

- (LOKLabelLayoutBuilder * _Nonnull (^)(LOKFlexibility * _Nonnull))withFlexibility {
    return ^LOKLabelLayoutBuilder *(LOKFlexibility * flexibility){
        self.flexibility = flexibility;
        return self;
    };
}

- (LOKLabelLayoutBuilder * _Nonnull (^)(NSString * _Nonnull))withViewReuseId {
    return ^LOKLabelLayoutBuilder *(NSString * viewReuseId){
        self.viewReuseId = viewReuseId;
        return self;
    };
}

- (LOKLabelLayoutBuilder * _Nonnull (^)(Class _Nonnull))withViewClass {
    return ^LOKLabelLayoutBuilder *(Class viewClass){
        self.viewClass = viewClass;
        return self;
    };
}

- (LOKLabelLayoutBuilder * _Nonnull (^)(void(^ _Nonnull)(View *_Nonnull)))withConfig {
    return ^LOKLabelLayoutBuilder *(void(^ _Nonnull config)(View *_Nonnull)){
        self.configure = config;
        return self;
    };
}

@end
