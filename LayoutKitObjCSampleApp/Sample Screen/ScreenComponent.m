// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <LayoutKitObjC/LayoutKitObjC.h>
#import "ScreenComponent.h"
#import "ExpandableTextComponent.h"
#import "GrowingTextViewComponent.h"

@interface ScreenComponent ()

@property (nonatomic, strong, nonnull, readonly) ExpandableTextComponent *labelOne;
@property (nonatomic, strong, nonnull, readonly) ExpandableTextComponent *labelTwo;
@property (nonatomic, strong, nonnull, readonly) GrowingTextViewComponent *textView;

@end

@implementation ScreenComponent

- (instancetype)initWithString:(NSString *)string {
    self = [super initWithRecord:[[ComponentRecord alloc] initWithState:nil data:string]];
    _labelOne = [[ExpandableTextComponent alloc] initWithText:string initiallyExpanded:YES];
    _labelTwo = [[ExpandableTextComponent alloc] initWithText:string initiallyExpanded:YES];
    _textView = [[GrowingTextViewComponent alloc] initWithInitialText:@""
                                                                 font:[UIFont systemFontOfSize:16]
                                                            lineLimit:2.4];
    [self registerComponents:@[_labelOne, _labelTwo, _textView]];
    return self;
}

- (id<LOKLayout>)makeLayoutForRecord:(ComponentRecord *)record {

    id<LOKLayout> topLayouts = [LOKStackLayoutBuilder withSublayouts:@[self.labelOne.layout, self.labelTwo.layout]]
    .spacing(20)
    .layout;

    id<LOKLayout> textInputWithBorderLayout = [LOKInsetLayoutBuilder withInsets:UIEdgeInsetsMake(10, 10, 10, 10) around:self.textView.layout]
    .config(^(LOKView * _Nonnull view) {
        view.layer.borderColor = UIColor.blueColor.CGColor;
        view.layer.borderWidth = 2;
        view.layer.cornerRadius = 8;
    })
    // important to mark to maintain view hierarchy undisturbed over successive layouts
    // so that user's editing session doesn't get force ended by the text view getting
    // reparented to a different superview
    .viewReuseId(@"border around UITextView")
    .insets(UIEdgeInsetsMake(10, 10, 10, 10))
    .layout;

    id<LOKLayout> buttonLayout = [LOKButtonLayoutBuilder withTitle:@"Test This"]
    .alignment(LOKAlignment.center)
    .flexibility(LOKFlexibility.inflexible)
    .viewReuseId(@"my button")
    .config(^(UIButton * _Nonnull button) {
        [button setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
    })
    .insets(UIEdgeInsetsMake(10, 0, 10, 20))
    .layout;

    id<LOKLayout> bottomStack = [LOKStackLayoutBuilder withSublayouts:@[textInputWithBorderLayout, buttonLayout]]
    .axis(LOKAxisHorizontal)
    .alignment(LOKAlignment.bottomFill)
    .layout;

    return [LOKStackLayoutBuilder withSublayouts:@[topLayouts, bottomStack]].distribution(LOKStackLayoutDistributionFillEqualSpacing).alignment(LOKAlignment.fill).layout;
}

- (void)update:(ComponentRecord *)record {
    NSString *newData = record.data;
    if (newData != self.currentRecord.data) {
        [self.labelOne update:[self.labelOne.currentRecord copyWithData:newData]];
        [self.labelTwo update:[self.labelTwo.currentRecord copyWithData:newData]];
    }
    [super update:record];
}

- (void)buttonTapped {
    __auto_type controller = [UIAlertController alertControllerWithTitle:@"Hello" message:self.textView.currentRecord.text preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"thanks" style:UIAlertActionStyleCancel handler:nil]];
    [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:controller  animated:YES completion:nil];
}

@end
