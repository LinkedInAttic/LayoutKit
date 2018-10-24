#import "ExpandableTextComponent.h"
#import "BlockTapGestureRecognizer.h"

@implementation ExpandableTextComponent

- (nonnull instancetype)initWithText:(nullable NSString *)text initiallyExpanded:(BOOL)isExpanded {
    return [super initWithState:[NSNumber numberWithBool:isExpanded] data:text];
}

- (BOOL)isExpanded {
    return self.state.boolValue;
}

- (void)setExpanded:(BOOL)expanded {
    self.state = [NSNumber numberWithBool:expanded];
}

- (NSString *)text {
    return self.data;
}

- (void)setText:(NSString *)text {
    self.data = text;
}

- (id<LOKLayout>)makeLayout {

    id<LOKLayout> labelLayout = [LOKLabelLayoutBuilder withString:self.text]
    .config(^(UILabel * label) {
        __auto_type tapHandlerBlock = ^(UIView * _Nonnull __unused view) {
            // Tap handler block runs on the UI thread, so it's safe to update the state at that point.
            // The state setter will notify the component owner that the UI should be updated.
            self.expanded = !self.isExpanded;
        };
        [label addGestureRecognizer:[[BlockTapGestureRecognizer alloc] initWithBlock:tapHandlerBlock]];
        label.userInteractionEnabled = YES;
    })
    .layout;

    if (self.isExpanded) {
        return labelLayout;
    } else {
        return [LOKSizeLayoutBuilder withSublayout:labelLayout]
        .maxHeight(50)
        .layout;
    }
}

@end
