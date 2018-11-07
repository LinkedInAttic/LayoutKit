// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "GrowingTextViewComponent.h"
#import "EditableTextViewLayout.h"

@implementation GrowingTextViewComponent

- (nonnull instancetype)initWithInitialText:(nonnull NSString *)text
                                       font:(UIFont*)font
                                  lineLimit:(float)lineLimit
                                viewReuseId:(nonnull NSString *)viewReuseId {
    self = [super initWithState:text data:nil];
    _font = font ?: [UIFont systemFontOfSize:UIFont.systemFontSize];
    _lineLimit = lineLimit;
    _viewReuseId = viewReuseId;
    return self;
}

- (nullable NSString *)text {
    return self.state;
}

- (void)setText:(nullable NSString *)text {
    self.state = text;
}

- (id<LOKLayout>)makeLayout {
    id<LOKLayout> textViewLayout = [[EditableTextViewLayout alloc] initWithText:self.text
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
    if (self.text == nil || ![self.text isEqualToString:textView.text]) {
        self.text = textView.text;
    }
}

@end
