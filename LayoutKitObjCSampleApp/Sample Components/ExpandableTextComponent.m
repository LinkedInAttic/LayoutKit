// Copyright 2018 LinkedIn Corp.
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

#import <LayoutKitObjC/LayoutKitObjC.h>
#import "ExpandableTextComponent.h"
#import "BlockTapGestureRecognizer.h"

// MARK: - ExpandableTextComponentRecord

@implementation ExpandableTextComponentRecord

- (instancetype)initWithText:(NSString *)text initiallyExpanded:(BOOL)isExpanded {
    self = [super initWithState:[NSNumber numberWithBool:isExpanded] data:text];
    return self;
}

- (instancetype)copyWithText:(NSString *)text {
    return [super copyWithData:text];
}

- (instancetype)copyWithExpandedState:(BOOL)expanded {
    return [super copyWithState:[NSNumber numberWithBool:expanded]];
}

- (NSString *)text {
    return self.data;
}

- (BOOL)isExpanded {
    return self.state.boolValue;
}

@end

// MARK: - ExpandableTextComponent

@implementation ExpandableTextComponent

@dynamic currentRecord;

- (nonnull instancetype)initWithText:(nullable NSString *)text initiallyExpanded:(BOOL)isExpanded {
    self = [super initWithRecord:[[ExpandableTextComponentRecord alloc] initWithText:text initiallyExpanded:isExpanded]];
    return self;
}

- (id<LOKLayout>)makeLayoutForRecord:(ExpandableTextComponentRecord *)record {

    id<LOKLayout> labelLayout = [LOKLabelLayoutBuilder withString:record.text]
    .config(^(UILabel * label) {
        __auto_type tapHandlerBlock = ^(UIView * _Nonnull __unused view) {
            // Tap handler block runs on the UI thread, so it's safe to update the state at that point.
            // The state setter will notify the component owner that the UI should be updated.
            ExpandableTextComponentRecord *updatedRecord = [self.currentRecord copyWithExpandedState:!self.currentRecord.isExpanded];
            [self update:updatedRecord];
        };
        [label addGestureRecognizer:[[BlockTapGestureRecognizer alloc] initWithBlock:tapHandlerBlock]];
        label.userInteractionEnabled = YES;
    })
    .layout;

    if (record.isExpanded) {
        return labelLayout;
    } else {
        return [LOKSizeLayoutBuilder withSublayout:labelLayout]
        .maxHeight(50)
        .layout;
    }
}

@end
