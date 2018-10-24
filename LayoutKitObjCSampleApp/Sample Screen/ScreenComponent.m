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
    self = [super initWithState:nil data:string];
    _labelOne = [[ExpandableTextComponent alloc] initWithText:string initiallyExpanded:YES];
    _labelTwo = [[ExpandableTextComponent alloc] initWithText:string initiallyExpanded:YES];
    _textView = [[GrowingTextViewComponent alloc] initWithInitialText:@""
                                                                 font:[UIFont systemFontOfSize:16]
                                                            lineLimit:2.4
                                                          viewReuseId:@"this is my text view"];
    return self;
}

- (id<LOKLayout>)makeLayout {

    id<LOKLayout> topLayouts = [LOKStackLayoutBuilder withSublayouts:@[self.labelOne.layout, self.labelTwo.layout]]
    .spacing(20)
    .layout;

    id<LOKLayout> textInputWithBorderLayout = [LOKInsetLayoutBuilder withInsets:UIEdgeInsetsMake(10, 10, 10, 10) around:self.textView.layout]
    .config(^(LOKView * _Nonnull view) {
        view.layer.borderColor = UIColor.blueColor.CGColor;
        view.layer.borderWidth = 2;
        view.layer.cornerRadius = 8;
    })
    .viewReuseId(@"important to mark to maintain view hierarchy undisturbed over multiple layouts so that user's editing session doesn't get force ended by the text view getting reparented to a different superview")
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

- (void)setData:(id)data {
    [super setData:data];
    self.labelOne.data = data;
    self.labelTwo.data = data;
    // If we were pre-populating the text input with some text, we'd do that here.
}

- (void)buttonTapped {
    __auto_type controller = [UIAlertController alertControllerWithTitle:@"Hello" message:self.textView.text preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"thanks" style:UIAlertActionStyleCancel handler:nil]];
    [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:controller animated:YES completion:nil];
}

@end
