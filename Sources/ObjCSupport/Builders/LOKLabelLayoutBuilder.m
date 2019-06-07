// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKLabelLayoutBuilder.h"

#import <LayoutKitObjC/LayoutKitObjC-Swift.h>

@interface LOKLabelLayoutBuilder ()

@property (nonatomic, nullable) LOKAlignment *privateAlignment;
@property (nonatomic, nullable) LOKFlexibility *privateFlexibility;
@property (nonatomic, nullable) NSString *privateViewReuseId;
@property (nonatomic, nullable) Class privateViewClass;

@property (nonatomic, nullable) NSString *privateString;
@property (nonatomic, nullable) NSAttributedString *privateAttributedString;
@property (nonatomic, nullable) UIFont *privateFont;
@property (nonatomic) NSInteger privateNumberOfLines;
@property (nonatomic) NSLineBreakMode privateLineBreakMode;
@property (nonatomic) CGFloat privateLineHeight;
@property (nonatomic, nullable) void (^ privateConfigure)(UILabel * _Nonnull);

@end

@implementation LOKLabelLayoutBuilder

- (instancetype)initWithString:(NSString *)string {
    self = [super init];
    _privateString = string;
    _privateLineBreakMode = NSLineBreakByTruncatingTail;
    return self;
}

- (instancetype)initWithAttributedString:(NSAttributedString *)attributedString {
    self = [super init];
    _privateAttributedString = attributedString;
    _privateLineBreakMode = NSLineBreakByTruncatingTail;
    return self;
}

+ (nonnull instancetype)withString:(nullable NSString *)string {
    return [[self alloc] initWithString:string];
}

+ (nonnull instancetype)withAttributedString:(nullable NSAttributedString *)attributedString {
    return [[self alloc] initWithAttributedString:attributedString];
}

- (nonnull LOKLabelLayout *)layout {
    NSAssert(!self.privateAttributedString || !self.privateString, @"LOKLabelLayoutBuilder should not have both a string and an attributedString.");
    if (self.privateAttributedString) {
        return [[LOKLabelLayout alloc] initWithAttributedString:self.privateAttributedString
                                                           font:self.privateFont
                                                  lineBreakMode:self.privateLineBreakMode
                                                     lineHeight:self.privateLineHeight
                                                  numberOfLines:self.privateNumberOfLines
                                                      alignment:self.privateAlignment
                                                    flexibility:self.privateFlexibility
                                                    viewReuseId:self.privateViewReuseId
                                                      viewClass:self.privateViewClass
                                                      configure:self.privateConfigure];
    } else {
        return [[LOKLabelLayout alloc] initWithString:self.privateString
                                                 font:self.privateFont
                                        lineBreakMode:self.privateLineBreakMode
                                           lineHeight:self.privateLineHeight
                                        numberOfLines:self.privateNumberOfLines
                                            alignment:self.privateAlignment
                                          flexibility:self.privateFlexibility
                                          viewReuseId:self.privateViewReuseId
                                            viewClass:self.privateViewClass
                                            configure:self.privateConfigure];
    }
}

- (LOKLabelLayoutBuilder * _Nonnull (^)(UIFont * _Nullable))font {
    return ^LOKLabelLayoutBuilder *(UIFont * font){
        self.privateFont = font;
        return self;
    };
}

- (LOKLabelLayoutBuilder * _Nonnull (^)(NSInteger))numberOfLines {
    return ^LOKLabelLayoutBuilder *(NSInteger numberOfLines){
        self.privateNumberOfLines = numberOfLines;
        return self;
    };
}

- (LOKLabelLayoutBuilder * _Nonnull (^)(NSLineBreakMode))lineBreakMode {
    return ^LOKLabelLayoutBuilder *(NSLineBreakMode lineBreakMode){
        self.privateLineBreakMode = lineBreakMode;
        return self;
    };
}

- (LOKLabelLayoutBuilder * _Nonnull (^)(CGFloat))lineHeight {
    return ^LOKLabelLayoutBuilder *(CGFloat lineHeight){
        self.privateLineHeight = lineHeight;
        return self;
    };
}

- (LOKLabelLayoutBuilder * _Nonnull (^)(LOKAlignment * _Nonnull))alignment {
    return ^LOKLabelLayoutBuilder *(LOKAlignment * alignment){
        self.privateAlignment = alignment;
        return self;
    };
}

- (LOKLabelLayoutBuilder * _Nonnull (^)(LOKFlexibility * _Nonnull))flexibility {
    return ^LOKLabelLayoutBuilder *(LOKFlexibility * flexibility){
        self.privateFlexibility = flexibility;
        return self;
    };
}

- (LOKLabelLayoutBuilder * _Nonnull (^)(NSString * _Nonnull))viewReuseId {
    return ^LOKLabelLayoutBuilder *(NSString * viewReuseId){
        self.privateViewReuseId = viewReuseId;
        return self;
    };
}

- (LOKLabelLayoutBuilder * _Nonnull (^)(Class _Nonnull))viewClass {
    return ^LOKLabelLayoutBuilder *(Class viewClass){
        self.privateViewClass = viewClass;
        return self;
    };
}

- (LOKLabelLayoutBuilder * _Nonnull (^)(void(^ _Nullable)(UILabel *_Nonnull)))config {
    return ^LOKLabelLayoutBuilder *(void(^ _Nullable config)(UILabel *_Nonnull)){
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
