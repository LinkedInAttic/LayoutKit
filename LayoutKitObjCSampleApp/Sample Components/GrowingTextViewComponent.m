// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <LayoutKitObjC/LayoutKitObjC.h>

#import "GrowingTextViewComponent.h"
#import "EditableTextViewLayout.h"

// MARK: - GrowingTextViewComponentRecord

@implementation GrowingTextViewComponentRecord

-(instancetype)initWithInitialText:(NSString *)text {
    self = [super initWithState:text data:nil];
    return self;
}

- (instancetype)copyWithText:(NSString *)text {
    return [super copyWithState:text];
}

- (NSString *)text {
    return self.state;
}

@end

// MARK: - GrowingTextViewComponent

@interface GrowingTextViewComponent ()
@property (nonatomic, copy, readonly) NSString *viewReuseId;
@end

@implementation GrowingTextViewComponent

- (nonnull instancetype)initWithInitialText:(nonnull NSString *)text
                                       font:(nullable UIFont*)font
                                  lineLimit:(float)lineLimit {
    self = [super initWithRecord:[[GrowingTextViewComponentRecord alloc] initWithInitialText:text]];
    _font = font ?: [UIFont systemFontOfSize:UIFont.systemFontSize];
    _lineLimit = lineLimit;
    _viewReuseId = [NSString stringWithFormat:@"%p -- a GrowingTextViewComponent", self];
    return self;
}

- (id<LOKLayout>)makeLayoutForRecord:(ComponentRecord *)record {
    id<LOKLayout> textViewLayout = [[EditableTextViewLayout alloc] initWithText:record.state
                                                                           font:self.font
                                                                  numberOfLines:self.lineLimit
                                                                      alignment:nil
                                                                    flexibility:nil
                                                                    viewReuseId:self.viewReuseId
                                                                         config:^(UITextView * _Nonnull textView) {
                                                                             textView.delegate = self;
                                                                             self.textView = textView;
                                                                         }];
    return textViewLayout;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (self.currentRecord.text == nil || ![self.currentRecord.text isEqualToString:textView.text]) {
        [self update:[self.currentRecord copyWithText:textView.text]];
    }
}

@dynamic currentRecord;

@end
