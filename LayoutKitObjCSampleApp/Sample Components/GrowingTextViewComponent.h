#import "Component.h"

NS_ASSUME_NONNULL_BEGIN

@interface GrowingTextViewComponent : Component<NSString*, id><UITextViewDelegate>

@property (nonatomic, copy, nullable, readwrite) NSString *text;
@property (nonatomic, strong, nonnull, readonly) UIFont *font;
@property (nonatomic, assign, readonly) float lineLimit;
@property (nonatomic, copy, readonly) NSString *viewReuseId;
@property (nonatomic, strong, nullable, readwrite) UITextView *textView;

- (nonnull instancetype)initWithInitialText:(nonnull NSString*)placeholder
                                       font:(nullable UIFont *)font
                                  lineLimit:(float)lineLimit
                                viewReuseId:(nonnull NSString *)viewReuseId;

@end

NS_ASSUME_NONNULL_END
