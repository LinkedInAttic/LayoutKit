// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "LOKTextViewLayoutBuilder.h"

#import <LayoutKitObjC/LayoutKitObjC-Swift.h>

@implementation LOKTextViewLayoutBuilder

+ (nonnull instancetype)withString:(nullable NSString *)string {
    LOKTextViewLayoutBuilder *builder = [[self alloc] init];
    builder.string = string;
    return builder;
}

+ (nonnull instancetype)withAttributedString:(nullable NSAttributedString *)attributedString {
    LOKTextViewLayoutBuilder *builder = [[self alloc] init];
    builder.attributedString = attributedString;
    return builder;
}

- (nonnull LOKTextViewLayout *)build {
    NSAssert(!self.attributedString || !self.string, @"LOKTextViewLayoutBuilder should not have both a string and an attributedString.");
    if (self.attributedString) {
        return [[LOKTextViewLayout alloc] initWithAttributedText:self.attributedString
                                                            font:self.font
                                             lineFragmentPadding:self.lineFragmentPadding
                                              textContainerInset:self.textContainerInset
                                                 layoutAlignment:self.alignment
                                                     flexibility:self.flexibility
                                                     viewReuseId:self.viewReuseId
                                                       viewClass:self.viewClass
                                                       configure:self.configure];
    } else {
        return [[LOKTextViewLayout alloc] initWithText:self.string
                                                  font:self.font
                                   lineFragmentPadding:self.lineFragmentPadding
                                    textContainerInset:self.textContainerInset
                                       layoutAlignment:self.alignment
                                           flexibility:self.flexibility
                                           viewReuseId:self.viewReuseId
                                             viewClass:self.viewClass
                                             configure:self.configure];
    }
}

- (LOKTextViewLayoutBuilder * _Nonnull (^)(UIFont * _Nullable))withFont {
    return ^LOKTextViewLayoutBuilder *(UIFont * _Nullable font){
        self.font = font;
        return self;
    };
}

- (LOKTextViewLayoutBuilder * _Nonnull (^)(UIEdgeInsets))withTextContainerInset {
    return ^LOKTextViewLayoutBuilder *(UIEdgeInsets textContainerInset){
        self.textContainerInset = textContainerInset;
        return self;
    };
}

- (LOKTextViewLayoutBuilder * _Nonnull (^)(CGFloat))withLineFragmentPadding {
    return ^LOKTextViewLayoutBuilder *(CGFloat lineFragmentPadding){
        self.lineFragmentPadding = lineFragmentPadding;
        return self;
    };
}

- (LOKTextViewLayoutBuilder * _Nonnull (^)(LOKAlignment * _Nonnull))withAlignment {
    return ^LOKTextViewLayoutBuilder *(LOKAlignment * alignment){
        self.alignment = alignment;
        return self;
    };
}

- (LOKTextViewLayoutBuilder * _Nonnull (^)(LOKFlexibility * _Nonnull))withFlexibility {
    return ^LOKTextViewLayoutBuilder *(LOKFlexibility * flexibility){
        self.flexibility = flexibility;
        return self;
    };
}

- (LOKTextViewLayoutBuilder * _Nonnull (^)(NSString * _Nonnull))withViewReuseId {
    return ^LOKTextViewLayoutBuilder *(NSString * viewReuseId){
        self.viewReuseId = viewReuseId;
        return self;
    };
}

- (LOKTextViewLayoutBuilder * _Nonnull (^)(Class _Nonnull))withViewClass {
    return ^LOKTextViewLayoutBuilder *(Class viewClass){
        self.viewClass = viewClass;
        return self;
    };
}

- (LOKTextViewLayoutBuilder * _Nonnull (^)(void(^ _Nullable)(UITextView *_Nonnull)))withConfig {
    return ^LOKTextViewLayoutBuilder *(void(^ _Nullable config)(UITextView *_Nonnull)){
        self.configure = config;
        return self;
    };
}

@end
