//
//  UILabel+RichText.h
//  SRCategory
//
//  Created by 郭伟林 on 16/12/5.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (RichText)

/** Text row spacing */
@property (nonatomic, assign) CGFloat  characterLineSpace;
/** Text column spacing  */
@property (nonatomic, assign) CGFloat  characterColumnSpace;

/** Text keyword */
@property (nonatomic, copy  ) NSString *keywords;
/** Keyword font */
@property (nonatomic, strong) UIFont   *keywordsFont;
/** Keyword color */
@property (nonatomic, strong) UIColor  *keywordsColor;

/** Text underline */
@property (nonatomic, copy  ) NSString *underlineString;
/** Underline color */
@property (nonatomic, strong) UIColor  *underlineColor;

/**
 Apply rich effect.
 */
- (void)applyRichEffect;

/**
 According to the maximum width calculating the Size of the Label.
 */
- (CGSize)getRectWithMaxWidth:(CGFloat)maxWidth;

@end
