// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKTextViewLayoutBuilder.h"

#import <LayoutKitObjC/LayoutKitObjC-Swift.h>

@interface LOKTextViewLayoutBuilder ()

@property (nonatomic, nullable) LOKAlignment *privateAlignment;
@property (nonatomic, nullable) LOKFlexibility *privateFlexibility;
@property (nonatomic, nullable) NSString *privateViewReuseId;
@property (nonatomic, nullable) Class privateViewClass;

@property (nonatomic, nullable) NSString *privateString;
@property (nonatomic, nullable) NSAttributedString *privateAttributedString;
@property (nonatomic, nullable) UIFont *privateFont;
@property (nonatomic) UIEdgeInsets privateTextContainerInset;
@property (nonatomic) CGFloat privateLineFragmentPadding;
@property (nonatomic, nullable) void (^ privateConfigure)(UITextView * _Nonnull);

@end

@implementation LOKTextViewLayoutBuilder

- (instancetype)initWithString:(NSString *)string {
    self = [super init];
    _privateString = string;
    return self;
}

- (instancetype)initWithAttributedString:(NSAttributedString *)attributedString {
    self = [super init];
    _privateAttributedString = attributedString;
    return self;
}

+ (nonnull instancetype)withString:(nullable NSString *)string {
    return [[self alloc] initWithString:string];
}

+ (nonnull instancetype)withAttributedString:(nullable NSAttributedString *)attributedString {
    return [[self alloc] initWithAttributedString:attributedString];
}

- (nonnull LOKTextViewLayout *)layout {
    NSAssert(!self.privateAttributedString || !self.privateString, @"LOKTextViewLayoutBuilder should not have both a string and an attributedString.");
    if (self.privateAttributedString) {
        return [[LOKTextViewLayout alloc] initWithAttributedText:self.privateAttributedString
                                                            font:self.privateFont
                                             lineFragmentPadding:self.privateLineFragmentPadding
                                              textContainerInset:self.privateTextContainerInset
                                                 layoutAlignment:self.privateAlignment
                                                     flexibility:self.privateFlexibility
                                                     viewReuseId:self.privateViewReuseId
                                                       viewClass:self.privateViewClass
                                                       configure:self.privateConfigure];
    } else {
        return [[LOKTextViewLayout alloc] initWithText:self.privateString
                                                  font:self.privateFont
                                   lineFragmentPadding:self.privateLineFragmentPadding
                                    textContainerInset:self.privateTextContainerInset
                                       layoutAlignment:self.privateAlignment
                                           flexibility:self.privateFlexibility
                                           viewReuseId:self.privateViewReuseId
                                             viewClass:self.privateViewClass
                                             configure:self.privateConfigure];
    }
}

- (LOKTextViewLayoutBuilder * _Nonnull (^)(UIFont * _Nullable))font {
    return ^LOKTextViewLayoutBuilder *(UIFont * _Nullable font){
        self.privateFont = font;
        return self;
    };
}

- (LOKTextViewLayoutBuilder * _Nonnull (^)(UIEdgeInsets))textContainerInset {
    return ^LOKTextViewLayoutBuilder *(UIEdgeInsets textContainerInset){
        self.privateTextContainerInset = textContainerInset;
        return self;
    };
}

- (LOKTextViewLayoutBuilder * _Nonnull (^)(CGFloat))lineFragmentPadding {
    return ^LOKTextViewLayoutBuilder *(CGFloat lineFragmentPadding){
        self.privateLineFragmentPadding = lineFragmentPadding;
        return self;
    };
}

- (LOKTextViewLayoutBuilder * _Nonnull (^)(LOKAlignment * _Nonnull))alignment {
    return ^LOKTextViewLayoutBuilder *(LOKAlignment * alignment){
        self.privateAlignment = alignment;
        return self;
    };
}

- (LOKTextViewLayoutBuilder * _Nonnull (^)(LOKFlexibility * _Nonnull))flexibility {
    return ^LOKTextViewLayoutBuilder *(LOKFlexibility * flexibility){
        self.privateFlexibility = flexibility;
        return self;
    };
}

- (LOKTextViewLayoutBuilder * _Nonnull (^)(NSString * _Nonnull))viewReuseId {
    return ^LOKTextViewLayoutBuilder *(NSString * viewReuseId){
        self.privateViewReuseId = viewReuseId;
        return self;
    };
}

- (LOKTextViewLayoutBuilder * _Nonnull (^)(Class _Nonnull))viewClass {
    return ^LOKTextViewLayoutBuilder *(Class viewClass){
        self.privateViewClass = viewClass;
        return self;
    };
}

- (LOKTextViewLayoutBuilder * _Nonnull (^)(void(^ _Nullable)(UITextView *_Nonnull)))config {
    return ^LOKTextViewLayoutBuilder *(void(^ _Nullable config)(UITextView *_Nonnull)){
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
