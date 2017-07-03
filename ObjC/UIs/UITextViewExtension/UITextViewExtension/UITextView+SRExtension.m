//
//  UITextView+SRExtension.m
//  UITextViewExtension
//
//  Created by 郭伟林 on 2017/6/27.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "UITextView+SRExtension.h"
#import <objc/runtime.h>

static const void * SRPlaceholderViewKey    = &SRPlaceholderViewKey;
static const void * SRPlaceholderColorKey   = &SRPlaceholderColorKey;
static const void * SRTextViewMaxHeightKey  = &SRTextViewMaxHeightKey;
static const void * SRTextViewMinHeightKey  = &SRTextViewMinHeightKey;
static const void * SRTextViewLastHeightKey = &SRTextViewLastHeightKey;

@interface UITextView ()

@property (nonatomic, assign) CGFloat lastHeight;

@end

@implementation UITextView (SRExtension)

+ (void)load {
    
    Method dealoc = class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc"));
    Method myDealoc = class_getInstanceMethod(self.class, @selector(myDealoc));
    method_exchangeImplementations(dealoc, myDealoc);
}

- (void)myDealoc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    UITextView *placeholderView = objc_getAssociatedObject(self, SRPlaceholderViewKey);
    if (placeholderView) {
        NSArray *propertys = @[@"frame", @"bounds", @"font", @"text", @"textAlignment", @"textContainerInset"];
        for (NSString *property in propertys) {
            [self removeObserver:self forKeyPath:property];
        }
    }
    
    [self myDealoc];
}

- (UITextView *)placeholderView {
    
    UITextView *placeholderView = objc_getAssociatedObject(self, SRPlaceholderViewKey);
    if (!placeholderView) {
        placeholderView = [[UITextView alloc] init];
        objc_setAssociatedObject(self, SRPlaceholderViewKey, placeholderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        placeholderView.textColor = [UIColor lightGrayColor];
        placeholderView.backgroundColor = [UIColor clearColor];
        placeholderView.userInteractionEnabled = NO;
        placeholderView.showsHorizontalScrollIndicator = NO;
        placeholderView.showsVerticalScrollIndicator = NO;
        placeholderView.scrollEnabled = NO;
        self.scrollEnabled = NO;
        [self refreshPlaceholderView];
        [self addSubview:placeholderView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textViewTextDidChange)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];
        
        NSArray *propertys = @[@"frame", @"bounds", @"font", @"text", @"textAlignment", @"textContainerInset"]; // also need 'text'
        for (NSString *property in propertys) {
            [self addObserver:self forKeyPath:property options:NSKeyValueObservingOptionNew context:nil];
        }
    }
    return placeholderView;
}

- (void)setPlaceholder:(NSString *)placeholder {
    
    [self placeholderView].text = placeholder;
}

- (NSString *)placeholder {
    
    if (self.isPlaceholderExist) {
        return [self placeholderView].text;
    }
    return nil;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    
    if (self.isPlaceholderExist) {
        self.placeholderView.textColor = placeholderColor;
        objc_setAssociatedObject(self, SRPlaceholderColorKey, placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (UIColor *)placeholderColor {
    
    return objc_getAssociatedObject(self, SRPlaceholderColorKey);
}

- (void)setMaxHeight:(CGFloat)maxHeight {
    
    objc_setAssociatedObject(self, SRTextViewMaxHeightKey, [NSString stringWithFormat:@"%lf", maxHeight], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)maxHeight {
    
    return [objc_getAssociatedObject(self, SRTextViewMaxHeightKey) doubleValue];
}

- (void)setMinHeight:(CGFloat)minHeight {
    
    CGRect frame = self.frame;
    frame.size.height = minHeight;
    self.frame = frame;
    objc_setAssociatedObject(self, SRTextViewMinHeightKey, [NSString stringWithFormat:@"%lf", minHeight], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)minHeight {
    
    return [objc_getAssociatedObject(self, SRTextViewMinHeightKey) doubleValue];
}

- (void)setLastHeight:(CGFloat)lastHeight {
    
    objc_setAssociatedObject(self, SRTextViewLastHeightKey, [NSString stringWithFormat:@"%lf", lastHeight], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)lastHeight {
    
    return [objc_getAssociatedObject(self, SRTextViewLastHeightKey) doubleValue];
}

- (BOOL)isPlaceholderExist {
    
    UITextView *placeholderView = objc_getAssociatedObject(self, SRPlaceholderViewKey);
    return placeholderView != nil;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    [self refreshPlaceholderView];
    
    if ([keyPath isEqualToString:@"text"]) {
        [self textViewTextDidChange];
    }
}

- (void)refreshPlaceholderView {
    
    UITextView *placeholderView = objc_getAssociatedObject(self, SRPlaceholderViewKey);
    if (placeholderView) {
        self.placeholderView.frame = self.bounds;
        self.placeholderView.font = self.font;
        self.placeholderView.textAlignment = self.textAlignment;
        self.placeholderView.textContainerInset = self.textContainerInset;
    }
}

- (void)textViewTextDidChange {
    
    UITextView *placeholderView = objc_getAssociatedObject(self, SRPlaceholderViewKey);
    if (placeholderView) {
        self.placeholderView.hidden = (self.text.length > 0 && self.text);
    }
    
    NSInteger currentHeight = ceil([self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height);
    if (currentHeight == self.lastHeight) {
        return;
    }
    CGRect frame = self.frame;
    if (currentHeight > self.maxHeight) {
        self.scrollEnabled = YES;
        frame.size.height = self.maxHeight;
        self.frame = frame;
        self.lastHeight = self.maxHeight;
    } else if (currentHeight < self.minHeight) {
        frame.size.height = self.minHeight;
        self.frame = frame;
        self.lastHeight = self.minHeight;
    } else {
        frame.size.height = currentHeight;
        self.frame = frame;
        self.lastHeight = currentHeight;
    }
}

@end
