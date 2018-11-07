// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import "EditableTextViewLayout.h"

@implementation EditableTextViewLayout

@synthesize needsView = _needsView;

- (instancetype)initWithText:(NSString *)text
                        font:(UIFont *)font
               numberOfLines:(float)numberOfLines
                   alignment:(LOKAlignment *)alignment
                 flexibility:(LOKFlexibility *)flexibility
                 viewReuseId:(NSString *)viewReuseId
                      config:(void (^ _Nullable)(UITextView * _Nonnull))config {

    self = [super init];
    _text = [text copy];
    _font = font ?: [UIFont systemFontOfSize:UIFont.systemFontSize];
    _numberOfLines = numberOfLines;
    _alignment = alignment ?: LOKAlignment.topFill;
    _flexibility = flexibility ?: LOKFlexibility.low;
    _viewReuseId = [viewReuseId copy];
    _needsView = YES;
    _config = [config copy];
    return self;
}

- (LOKLayoutMeasurement * _Nonnull)measurementWithin:(CGSize)maxSize {

    CGFloat textContainerInsetVerticalComponent = 16; // Matches the default textView.textContainerInset.

    CGSize shrunkSize = maxSize;
    shrunkSize.height -= textContainerInsetVerticalComponent;

    CGSize size;
    if (self.text.length > 0) {
        size = [self.text boundingRectWithSize:shrunkSize
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: self.font}
                                       context:nil].size;

        size.height += textContainerInsetVerticalComponent;

        if (self.numberOfLines > 0) {
            size.height = MIN(ceil(size.height), ceil(self.font.lineHeight) * self.numberOfLines);
        } else {
            size.height = ceil(size.height);
        }

    } else {
        size.height = ceil(self.font.lineHeight);
        size.height += textContainerInsetVerticalComponent;
    }

    size.width = MIN(size.width, maxSize.width);
    size.height = MIN(size.height, maxSize.height);

    return [[LOKLayoutMeasurement alloc] initWithLayout:self size:size maxSize:maxSize sublayouts:@[]];
}

- (LOKLayoutArrangement * _Nonnull)arrangementWithin:(CGRect)rect measurement:(LOKLayoutMeasurement * _Nonnull)measurement {
    CGRect frame = [self.alignment positionWithSize:measurement.size in:rect];
    return [[LOKLayoutArrangement alloc] initWithLayout:self frame:frame sublayouts:@[]];
}

- (UIView * _Nonnull)makeView {
    return [[UITextView alloc] init];
}

- (void)configureView:(UIView * _Nonnull)view {
    UITextView *textView = (UITextView*)view;

    if (self.config != nil) {
        self.config(textView);
    }

    // TODO: Should we be setting the text here?

    // Note: For the next few property setters, it's actually important to check
    // if the value is changing. Calling some setters even without an actual change
    // causes the UITextView to behave differently and the scrolling behavior
    // becomes not as nice.
    if (textView.font != self.font) {
        textView.font = self.font;
    }
    if (textView.textContainer.lineFragmentPadding != 0) {
        textView.textContainer.lineFragmentPadding = 0;
    }
    if (textView.layoutManager.usesFontLeading) {
        textView.layoutManager.usesFontLeading = NO;
    }
    if (!textView.isEditable) {
        textView.editable = YES;
    }
    if (!textView.scrollEnabled) {
        textView.scrollEnabled = YES;
    }

    NSAssert(UIEdgeInsetsEqualToEdgeInsets(textView.textContainerInset, UIEdgeInsetsMake(8, 0, 8, 0)), @"");

    // LayoutKit has set the frame by this point, but sometimes the UITextView's internal _UITextContainerView ends up being too small.
    // Calling this method call makes it resize appropriately to match the UITextView's size.
    // The odd part is that this method sounds like it will scroll the caret (which is the selected range) into view,
    // but it's already in view. Anyway, this workaround works for now.
    // Potential problems might arise if the user intentionally scrolls the selection off-screen
    // and if a layout gets triggered at that time, this code may reset the user's scroll position.
    // Other attempted workarounds from Stack Overflow to get the internal subview to update included setNeedsLayout/layoutIfNeeded,
    // changing the frame height, resignFirstResponder/becomeFirstResponder, toggling scrollEnabled, setting heightTracksTextView to YES.
    [textView scrollRangeToVisible:textView.selectedRange];
}

@end
