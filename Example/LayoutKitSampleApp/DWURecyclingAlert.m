// Copied from https://github.com/diwu/DWURecyclingAlert
// This adds a debug view that shows how long rendering takes as well as
// highlights views with a red boarder that are not being reused.

//DWURecyclingAlert.m
//Copyright (c) 2015 Di Wu
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

// Comment out if you want to disable this entire runtime hack
#define DWURecyclingAlertEnabled

#if defined (DEBUG) && defined (DWURecyclingAlertEnabled)

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <UIKit/UITableViewCell.h>
#import <UIKit/UIImage.h>
#import <UIKit/UITableView.h>
#import <UIKit/UILabel.h>
#import <QuartzCore/CALayer.h>
#import <UIKit/UINibLoading.h>
#import <UIKit/UICollectionViewCell.h>
#import <UIKit/UICollectionView.h>
#import <UIKit/UITableViewHeaderFooterView.h>

// ------------ UI Configuration ------------
static const CGFloat DWU_BORDER_WIDTH = 5.0;

static const CGFloat DWU_LABEL_HEIGHT = 16.0;

static const CGFloat DWU_LABEL_WIDTH_UITABLEVIEW_CELL = 240.0;

static const CGFloat DWU_LABEL_WIDTH_UICOLLECTIONVIEW_CELL = 50.0;

static const CGFloat DWU_LABEL_FONT_SIZE = 12.0;

static NSString *DWU_LABEL_FORMAT_UITABLEVIEW_CELL = @"cellForRow: %zd ms, drawRect: %zd ms";

static NSString *DWU_LABEL_FORMAT_UITABLEVIEW_HEADER = @"viewForHeader: %zd ms, drawRect: %zd ms";

static NSString *DWU_LABEL_FORMAT_UITABLEVIEW_FOOTER = @"viewForFooter: %zd ms, drawRect: %zd ms";

static NSString *DWU_LABEL_FORMAT_UICOLLECTIONVIEW_CELL = @" %zd / %zd";

#define DWU_BORDER_COLOR [[UIColor redColor] CGColor]

#define DWU_TEXT_LABEL_BACKGROUND_COLOR [UIColor blackColor]

#define DWU_TEXT_LABEL_FONT_COLOR [UIColor whiteColor]
// ------------------------------------------

static const NSInteger DWU_TIME_INTERVAL_LABEL_TAG = NSIntegerMax - 123;

static char DWU_CALAYER_ASSOCIATED_OBJECT_KEY;

static char DWU_UIVIEW_TABLEVIEW_CELL_DELEGATE_ASSOCIATED_OBJECT_KEY;

static char DWU_UIVIEW_DRAW_RECT_TIME_COUNT_NUMBER_ASSOCIATED_OBJECT_KEY;

static char DWU_UIVIEW_CELL_FOR_ROW_TIME_COUNT_NUMBER_ASSOCIATED_OBJECT_KEY;

typedef id(^CellForRowAtIndexPathBlock)(__unsafe_unretained id _self, __unsafe_unretained id arg1, __unsafe_unretained id arg2);

typedef id(^CollectionHeaderFooterBlock)(__unsafe_unretained id _self, __unsafe_unretained id arg1, __unsafe_unretained id arg2,  __unsafe_unretained id arg3);

#pragma mark - swizzling method from block

// http://www.mikeash.com/pyblog/friday-qa-2010-01-29-method-replacement-for-fun-and-profit.html
static BOOL dwu_replaceMethodWithBlock(Class c, SEL origSEL, SEL newSEL, id block) {
    if ([c instancesRespondToSelector:newSEL]) {
        return YES;
    }
    Method origMethod = class_getInstanceMethod(c, origSEL);
    IMP impl = imp_implementationWithBlock(block);
    if (!class_addMethod(c, newSEL, impl, method_getTypeEncoding(origMethod))) {
        return NO;
    }else {
        Method newMethod = class_getInstanceMethod(c, newSEL);
        if (class_addMethod(c, origSEL, method_getImplementation(newMethod), method_getTypeEncoding(origMethod))) {
            class_replaceMethod(c, newSEL, method_getImplementation(origMethod), method_getTypeEncoding(newMethod));
        }else {
            method_exchangeImplementations(origMethod, newMethod);
        }
    }
    return YES;
}

#pragma mark - time count label

@interface DWUKVOLabel : UILabel

// Known issue: *strong* will lead to retain cycle.
// (While *weak* will lead to a NSKVODeallocate exception.)
// Will adopt something like FBKVOController in the future.
@property (nonatomic, strong) UIView *observedView;

@property (nonatomic, assign) NSInteger cellForRowTimeInteger;

@property (nonatomic, assign) NSInteger drawRectTimeInteger;

@property (nonatomic, copy) NSString *format;

- (instancetype)initWithKVOTarget: (UIView *)view frame: (CGRect)frame;

@end

@implementation DWUKVOLabel

- (instancetype)initWithKVOTarget: (UIView *)view frame: (CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        _observedView = view;
        _cellForRowTimeInteger = 0;
        _drawRectTimeInteger = 0;
        [view addObserver:self forKeyPath:@"dwuCellForRowTimeCountNumber" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:nil];
        [view addObserver:self forKeyPath:@"dwuDrawRectTimeCountNumber" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    NSNumber *number = [change objectForKey:NSKeyValueChangeNewKey];
    if (!number || ![number isKindOfClass:[NSNumber class]]) {
        return;
    }

    if ([keyPath isEqualToString:@"dwuCellForRowTimeCountNumber"]) {
        self.cellForRowTimeInteger = [number integerValue];
    } else if ([keyPath isEqualToString:@"dwuDrawRectTimeCountNumber"]) {
        self.drawRectTimeInteger += [number integerValue];
    }

    [self updateText];
}

- (void)updateText {
    self.text = [NSString stringWithFormat:self.format, self.cellForRowTimeInteger, self.drawRectTimeInteger];
}

- (void)dealloc {
    [self.observedView removeObserver:self forKeyPath:@"dwuCellForRowTimeCountNumber"];
    [self.observedView removeObserver:self forKeyPath:@"dwuDrawRectTimeCountNumber"];
}

@end

#pragma mark - Category

@interface UIView (DWURecyclingAlert)

@property (nonatomic, unsafe_unretained) UIView *dwuCellDelegate;

@property (nonatomic, strong) NSNumber *dwuDrawRectTimeCountNumber;

@property (nonatomic, strong) NSNumber *dwuCellForRowTimeCountNumber;

@end

@implementation UIView (DWURecyclingAlert)

- (void)setDwuCellDelegate:(UIView *)delegate {
    objc_setAssociatedObject(self, &DWU_UIVIEW_TABLEVIEW_CELL_DELEGATE_ASSOCIATED_OBJECT_KEY, delegate, OBJC_ASSOCIATION_ASSIGN);
}

- (UIView *)dwuCellDelegate {
    UITableViewCell *delegate = objc_getAssociatedObject(self, &DWU_UIVIEW_TABLEVIEW_CELL_DELEGATE_ASSOCIATED_OBJECT_KEY);
    return delegate;
}

- (void)setDwuDrawRectTimeCountNumber: (NSNumber *)number {
    objc_setAssociatedObject(self, &DWU_UIVIEW_DRAW_RECT_TIME_COUNT_NUMBER_ASSOCIATED_OBJECT_KEY, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)dwuDrawRectTimeCountNumber {
    NSNumber *number = objc_getAssociatedObject(self, &DWU_UIVIEW_DRAW_RECT_TIME_COUNT_NUMBER_ASSOCIATED_OBJECT_KEY);
    return number;
}

- (void)setDwuCellForRowTimeCountNumber: (NSNumber *)number {
    objc_setAssociatedObject(self, &DWU_UIVIEW_CELL_FOR_ROW_TIME_COUNT_NUMBER_ASSOCIATED_OBJECT_KEY, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)dwuCellForRowTimeCountNumber {
    NSNumber *number = objc_getAssociatedObject(self, &DWU_UIVIEW_CELL_FOR_ROW_TIME_COUNT_NUMBER_ASSOCIATED_OBJECT_KEY);
    return number;
}

@end

@interface CALayer (DWURecyclingAlert)

@property (nonatomic, assign) NSInteger dwuRecyclingCount;

@end

@implementation CALayer (DWURecyclingAlert)

- (void)setDwuRecyclingCount:(NSInteger)recyclingCount {
    objc_setAssociatedObject(self, &DWU_CALAYER_ASSOCIATED_OBJECT_KEY, @(recyclingCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)dwuRecyclingCount {
    NSNumber *recyclingCountNumber = objc_getAssociatedObject(self, &DWU_CALAYER_ASSOCIATED_OBJECT_KEY);
    return [recyclingCountNumber integerValue];
}

- (void)dwu_addRedBorderEffect {
    self.borderColor = DWU_BORDER_COLOR;
    self.borderWidth = DWU_BORDER_WIDTH;
}

- (void)dwu_removeRedBorderEffect {
    self.borderColor = [[UIColor clearColor] CGColor];
    self.borderWidth = 0.0;
}

static BOOL dwu_implementsSelector(id obj, SEL sel) {
    if ([[obj class] instanceMethodForSelector:sel] != [[obj superclass] instanceMethodForSelector:sel]) {
        return YES;
    } else {
        return NO;
    }
}

static void dwu_swizzleDrawRectIfNotYet(CALayer *layer) {
    if (!layer.delegate) {
        return;
    }
    if (![layer.delegate isKindOfClass:[UIView class]]) {
        return;
    }
    UIView *containerView = (UIView *)layer.delegate;
    if (!dwu_implementsSelector(containerView, @selector(drawRect:))) {
        return;
    }
    Class c = containerView.class;
    if ([NSStringFromClass(c) hasPrefix:@"UI"]) {
        return;
    }
    static NSMutableSet *classSet;
    if (!classSet) {
        classSet = [NSMutableSet set];
    }
    if ([classSet containsObject:c]) {
        return;
    }
    [classSet addObject:c];
    SEL selector = @selector(drawRect:);
    NSString *selStr = NSStringFromSelector(selector);
    SEL newSelector = NSSelectorFromString([NSString stringWithFormat:@"dwu_%@", selStr]);
    dwu_replaceMethodWithBlock(c, selector, newSelector, ^(__unsafe_unretained UIView *containerView, CGRect rect) {
        NSDate *date = [NSDate date];
        containerView.opaque = NO;
        ((void ( *)(id, SEL, CGRect))objc_msgSend)(containerView, newSelector, rect);
        NSTimeInterval timeInterval = ceilf(-[date timeIntervalSinceNow] * 1000);
        containerView.dwuCellDelegate.dwuDrawRectTimeCountNumber = @(timeInterval);
    });
}

- (void)dwu_scanLayerHierarchyRecursively {
    dwu_swizzleDrawRectIfNotYet(self);
    static NSMapTable *cgImageRefDict;
    if (!cgImageRefDict) {
        cgImageRefDict = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn
                                               valueOptions:NSMapTableWeakMemory];
    }
    NSInteger recyclingCount = self.dwuRecyclingCount;
    SEL imageSelector = @selector(image);
    BOOL viewTargetFound = NO;
    BOOL imageTargetFound = NO;
    if ( self.delegate && [self.delegate respondsToSelector:imageSelector]) {
        UIImage *image = ((UIImage * ( *)(id, SEL))objc_msgSend)(self.delegate, imageSelector);
        if (image) {
            NSString *addressString = [NSString stringWithFormat:@"%p", image.CGImage];
            if (![cgImageRefDict objectForKey:addressString]) {
                [cgImageRefDict setObject:self.delegate forKey:addressString];
                imageTargetFound = YES;
            } else {
                UIView *someLastMarkedView = [cgImageRefDict objectForKey:addressString];
                [someLastMarkedView.layer dwu_removeRedBorderEffect];
            }
        }
    } else if (!recyclingCount && self.superlayer && self.superlayer.dwuRecyclingCount) {
        viewTargetFound = YES;
    }

    if (viewTargetFound || imageTargetFound) {
        [self dwu_addRedBorderEffect];
    } else {
        [self dwu_removeRedBorderEffect];
    }
    UIView *cellDelegate = [self dwu_findCell];
    [self dwu_injectLayer:cellDelegate.layer withCellDelegate:cellDelegate];
    for (CALayer *sublayer in self.sublayers) {
        [self dwu_injectLayer:sublayer withCellDelegate:cellDelegate];
        [sublayer dwu_scanLayerHierarchyRecursively];
    }
    self.dwuRecyclingCount++;
}

- (UIView *)dwu_findCell {
    UIView *containerView = (UIView *)self.delegate;
    if (!containerView) {
        return nil;
    }
    if (![containerView isKindOfClass:[UIView class]]) {
        return nil;
    }
    if (containerView.dwuCellDelegate) {
        return containerView.dwuCellDelegate;
    } else if ([containerView isKindOfClass:[UITableViewCell class]]) {
        return containerView;
    } else if ([containerView isKindOfClass:[UITableViewHeaderFooterView class]]) {
        return containerView;
    } else if ([containerView isKindOfClass:[UICollectionReusableView class]]) {
        return containerView;
    } else {
        return nil;
    }
}

- (void)dwu_injectLayer: (CALayer *)layer withCellDelegate:(UIView *)cellDelegate {
    if (layer.delegate && [layer.delegate isKindOfClass:[UIView class]]) {
        UIView *containerView = (UIView *)layer.delegate;
        containerView.dwuCellDelegate = cellDelegate;
    }
}

@end

#pragma mark - generate for UITableViewCell / UICollectionViewCell labels

static CellForRowAtIndexPathBlock dwu_generateTimeLabel(SEL targetSelector, CGFloat labelWidth, NSString *timeStringFormat) {
    return ^(__unsafe_unretained UITableView *_self, __unsafe_unretained id arg1, __unsafe_unretained id arg2) {
        NSDate *date = [NSDate date];
        UIView *returnView = ((UIView * ( *)(id, SEL, id, id))objc_msgSend)(_self, targetSelector, arg1, arg2);
        NSTimeInterval timeInterval = ceilf(-[date timeIntervalSinceNow] * 1000);
        [[returnView layer] dwu_scanLayerHierarchyRecursively];
        DWUKVOLabel *timeIntervalLabel = (DWUKVOLabel *)[returnView viewWithTag:DWU_TIME_INTERVAL_LABEL_TAG];
        if (!timeIntervalLabel) {
            timeIntervalLabel = [[DWUKVOLabel alloc] initWithKVOTarget:returnView frame:CGRectMake(0, 0, labelWidth, DWU_LABEL_HEIGHT)];
            timeIntervalLabel.userInteractionEnabled = NO;
            timeIntervalLabel.backgroundColor = DWU_TEXT_LABEL_BACKGROUND_COLOR;
            timeIntervalLabel.textColor = DWU_TEXT_LABEL_FONT_COLOR;
            timeIntervalLabel.font = [UIFont boldSystemFontOfSize:DWU_LABEL_FONT_SIZE];
            timeIntervalLabel.textAlignment = NSTextAlignmentCenter;
            timeIntervalLabel.adjustsFontSizeToFitWidth = YES;
            timeIntervalLabel.tag = DWU_TIME_INTERVAL_LABEL_TAG;
            timeIntervalLabel.layer.dwuRecyclingCount++;
            [returnView addSubview:timeIntervalLabel];
        }
        timeIntervalLabel.format = timeStringFormat;
        timeIntervalLabel.cellForRowTimeInteger = 0;
        timeIntervalLabel.drawRectTimeInteger = 0;
        [returnView bringSubviewToFront:timeIntervalLabel];
        returnView.dwuCellForRowTimeCountNumber = @(timeInterval);
        return returnView;
    };
}

static CollectionHeaderFooterBlock dwu_generateCollectionViewHeaderFooterTimeLabel(SEL targetSelector, CGFloat labelWidth, NSString *timeStringFormat) {
    return ^(__unsafe_unretained id _self, __unsafe_unretained id arg1, __unsafe_unretained id arg2,  __unsafe_unretained id arg3) {
        NSDate *date = [NSDate date];
        UIView *returnView = ((UIView * ( *)(id, SEL, id, id, id))objc_msgSend)(_self, targetSelector, arg1, arg2, arg3);
        NSTimeInterval timeInterval = ceilf(-[date timeIntervalSinceNow] * 1000);
        [[returnView layer] dwu_scanLayerHierarchyRecursively];
        DWUKVOLabel *timeIntervalLabel = (DWUKVOLabel *)[returnView viewWithTag:DWU_TIME_INTERVAL_LABEL_TAG];
        if (!timeIntervalLabel) {
            timeIntervalLabel = [[DWUKVOLabel alloc] initWithKVOTarget:returnView frame:CGRectMake(0, 0, labelWidth, DWU_LABEL_HEIGHT)];
            timeIntervalLabel.userInteractionEnabled = NO;
            timeIntervalLabel.backgroundColor = DWU_TEXT_LABEL_BACKGROUND_COLOR;
            timeIntervalLabel.textColor = DWU_TEXT_LABEL_FONT_COLOR;
            timeIntervalLabel.font = [UIFont boldSystemFontOfSize:DWU_LABEL_FONT_SIZE];
            timeIntervalLabel.textAlignment = NSTextAlignmentCenter;
            timeIntervalLabel.adjustsFontSizeToFitWidth = YES;
            timeIntervalLabel.tag = DWU_TIME_INTERVAL_LABEL_TAG;
            timeIntervalLabel.layer.dwuRecyclingCount++;
            [returnView addSubview:timeIntervalLabel];
        }
        timeIntervalLabel.format = timeStringFormat;
        timeIntervalLabel.cellForRowTimeInteger = 0;
        timeIntervalLabel.drawRectTimeInteger = 0;
        [returnView bringSubviewToFront:timeIntervalLabel];
        returnView.dwuCellForRowTimeCountNumber = @(timeInterval);
        return returnView;
    };
}

static void dwu_generateTimeLabelForUITableViewHeaderFooterView() {
    SEL selector = @selector(setDelegate:);
    NSString *selStr = NSStringFromSelector(selector);
    SEL newSelector = NSSelectorFromString([NSString stringWithFormat:@"dwu_uitableview_headerfooter_%@", selStr]);
    dwu_replaceMethodWithBlock(UITableView.class, selector, newSelector, ^(__unsafe_unretained UITableView *_self, __unsafe_unretained id arg) {
        SEL viewForHeaderInSectionSel = @selector(tableView:viewForHeaderInSection:);
        if ([arg respondsToSelector:viewForHeaderInSectionSel]) {
            NSString *viewForSectionSelSelStr = NSStringFromSelector(viewForHeaderInSectionSel);
            SEL newViewForSectionSel = NSSelectorFromString([NSString stringWithFormat:@"dwu_%@", viewForSectionSelSelStr]);
            dwu_replaceMethodWithBlock([arg class], viewForHeaderInSectionSel, newViewForSectionSel, dwu_generateTimeLabel(newViewForSectionSel, DWU_LABEL_WIDTH_UITABLEVIEW_CELL, DWU_LABEL_FORMAT_UITABLEVIEW_HEADER));
        }
        SEL viewForFooterInSectionSel = @selector(tableView:viewForFooterInSection:);
        if ([arg respondsToSelector:viewForFooterInSectionSel]) {
            NSString *viewForSectionSelSelStr = NSStringFromSelector(viewForFooterInSectionSel);
            SEL newViewForSectionSel = NSSelectorFromString([NSString stringWithFormat:@"dwu_%@", viewForSectionSelSelStr]);
            dwu_replaceMethodWithBlock([arg class], viewForFooterInSectionSel, newViewForSectionSel, dwu_generateTimeLabel(newViewForSectionSel, DWU_LABEL_WIDTH_UITABLEVIEW_CELL, DWU_LABEL_FORMAT_UITABLEVIEW_FOOTER));
        }
        ((void ( *)(id, SEL, id))objc_msgSend)(_self, newSelector, arg);
    });
}

static void dwu_generateTimeLabelForUITableViewCell() {
    SEL selector = @selector(setDataSource:);
    NSString *selStr = NSStringFromSelector(selector);
    SEL newSelector = NSSelectorFromString([NSString stringWithFormat:@"dwu_uitableview_%@", selStr]);
    dwu_replaceMethodWithBlock(UITableView.class, selector, newSelector, ^(__unsafe_unretained UITableView *_self, __unsafe_unretained id arg) {
        SEL cellForRowSel = @selector(tableView:cellForRowAtIndexPath:);
        NSString *cellForRowSelStr = NSStringFromSelector(cellForRowSel);
        SEL newCellForRowSel = NSSelectorFromString([NSString stringWithFormat:@"dwu_%@", cellForRowSelStr]);
        dwu_replaceMethodWithBlock([arg class], cellForRowSel, newCellForRowSel, dwu_generateTimeLabel(newCellForRowSel, DWU_LABEL_WIDTH_UITABLEVIEW_CELL, DWU_LABEL_FORMAT_UITABLEVIEW_CELL));
        ((void ( *)(id, SEL, id))objc_msgSend)(_self, newSelector, arg);
    });
}

static void dwu_generateTimeLabelForUICollectionViewCell() {
    SEL selector = @selector(setDataSource:);
    NSString *selStr = NSStringFromSelector(selector);
    SEL newSelector = NSSelectorFromString([NSString stringWithFormat:@"dwu_uicollectionview_%@", selStr]);
    dwu_replaceMethodWithBlock(UICollectionView.class, selector, newSelector, ^(__unsafe_unretained UICollectionView *_self, __unsafe_unretained id arg) {
        SEL cellForItemSel = @selector(collectionView:cellForItemAtIndexPath:);
        NSString *cellForItemSelStr = NSStringFromSelector(cellForItemSel);
        SEL newCellForItemSel = NSSelectorFromString([NSString stringWithFormat:@"dwu_%@", cellForItemSelStr]);
        dwu_replaceMethodWithBlock([arg class], cellForItemSel, newCellForItemSel, dwu_generateTimeLabel(newCellForItemSel, DWU_LABEL_WIDTH_UICOLLECTIONVIEW_CELL, DWU_LABEL_FORMAT_UICOLLECTIONVIEW_CELL));

        cellForItemSel = @selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:);
        if ([arg respondsToSelector:cellForItemSel]) {
            cellForItemSelStr = NSStringFromSelector(cellForItemSel);
            newCellForItemSel = NSSelectorFromString([NSString stringWithFormat:@"dwu_%@", cellForItemSelStr]);
            dwu_replaceMethodWithBlock([arg class], cellForItemSel, newCellForItemSel, dwu_generateCollectionViewHeaderFooterTimeLabel(newCellForItemSel, DWU_LABEL_WIDTH_UICOLLECTIONVIEW_CELL, DWU_LABEL_FORMAT_UICOLLECTIONVIEW_CELL));
        }

        ((void ( *)(id, SEL, id))objc_msgSend)(_self, newSelector, arg);
    });
}

__attribute__((constructor)) static void DWURecyclingAlert(void) {
    @autoreleasepool {
        dwu_generateTimeLabelForUITableViewCell();
        dwu_generateTimeLabelForUITableViewHeaderFooterView();
        dwu_generateTimeLabelForUICollectionViewCell();
    }
}
#endif
