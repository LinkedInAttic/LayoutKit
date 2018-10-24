#import <LayoutKitObjC/LayoutKitObjC.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * A layout that creates an editable UITextView.
 * LayoutKit provides a version of this layout that creates a non-editable UITextView.
 */
@interface EditableTextViewLayout : NSObject<LOKLayout>

@property (nonatomic, copy, nullable, readonly) NSString *text;
@property (nonatomic, strong, nonnull, readonly) UIFont *font;
@property (nonatomic, assign, readonly) float numberOfLines;
@property (nonatomic, strong, nonnull, readonly) LOKAlignment *alignment;
@property (nonatomic, strong, nonnull, readonly) LOKFlexibility *flexibility;
@property (nonatomic, copy, nullable, readonly) NSString *viewReuseId;
@property (nonatomic, copy, nullable, readonly) void (^config)(UITextView * _Nonnull);

- (nonnull instancetype)initWithText:(nullable NSString*)text
                                font:(nullable UIFont *)font
                       numberOfLines:(float)numberOfLines
                           alignment:(nullable LOKAlignment*)alignment
                         flexibility:(nullable LOKFlexibility*)flexibility
                         viewReuseId:(nullable NSString *)viewReuseId
                              config:(void (^ _Nullable)(UITextView * _Nonnull))config;

@end

NS_ASSUME_NONNULL_END
