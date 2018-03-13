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

@end
