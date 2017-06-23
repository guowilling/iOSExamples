//
//  MacroDefine.h
//  CategoriesDemo
//
//  Created by Willing Guo on 2017/6/17.
//  Copyright © 2017年 SR. All rights reserved.
//

#ifndef MacroDefine_h
#define MacroDefine_h

#define kApplication         [UIApplication sharedApplication]
#define kAppWindow           [UIApplication sharedApplication].delegate.window
#define kAppDelegate         [AppDelegate shareAppDelegate]
#define kRootViewController  [UIApplication sharedApplication].delegate.window.rootViewController

#define kUserDefaults        [NSUserDefaults standardUserDefaults]
#define kNotificationCenter  [NSNotificationCenter defaultCenter]

#define kScreen_Bounds  [UIScreen mainScreen].bounds
#define KScreenWidth    [UIScreen mainScreen].bounds.size.width
#define KScreenHeight   [UIScreen mainScreen].bounds.size.height

#define kWeakSelf(type)    __weak typeof(type)weak##type = type;
#define kStrongSelf(type)  __strong typeof(type)type = weak##type;

#define KClearColor  [UIColor clearColor]
#define KWhiteColor  [UIColor whiteColor]
#define KBlackColor  [UIColor blackColor]
#define KGrayColor   [UIColor grayColor]
#define KGray2Color  [UIColor lightGrayColor]
#define KBlueColor   [UIColor blueColor]
#define KRedColor    [UIColor redColor]

#define kRandomColorKRGBColor  (arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0);

#define BOLDSYSTEMFONT(FONTSIZE)  [UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)      [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME, FONTSIZE)      [UIFont fontWithName:(NAME) size:(FONTSIZE)]

#define ValidString(str)       (str != nil && [str isKindOfClass:[NSString class]] && ![str isEqualToString:@""])
#define ValidDictionary(dict)  (dict != nil && [dict isKindOfClass:[NSDictionary class]])
#define ValidArray(arr)        (arr != nil && [arr isKindOfClass:[NSArray class]] && [arr count] > 0)

#endif /* MacroDefine_h */
