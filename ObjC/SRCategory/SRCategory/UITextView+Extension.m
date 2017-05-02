//
//  UITextView+Extension.m
//  SRCategories
//
//  Created by 郭伟林 on 16/12/5.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "UITextView+Extension.h"

@implementation UITextView (Extension)

- (void)insertAttributedText:(NSAttributedString *)text {
    
    [self insertAttributedText:text settingBlock:nil];
}

- (void)insertAttributedText:(NSAttributedString *)attributedString settingBlock:(void (^)(NSMutableAttributedString *))settingBlock {
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    [attributedText appendAttributedString:self.attributedText];
    
    //NSUInteger location = self.selectedRange.location;
    //[attributedText insertAttributedString:text atIndex:loc];
    [attributedText replaceCharactersInRange:self.selectedRange withAttributedString:attributedString];
    if (settingBlock) {
        settingBlock(attributedText);
    }
    self.attributedText = attributedText;
    
    // 如果 selectedRange.length 为 0 那么 selectedRange.location 就是 textView 的光标位置
    // 移动光标到最新插入内容的后面
    self.selectedRange = NSMakeRange(self.selectedRange.location + 1, 0);
}

@end
