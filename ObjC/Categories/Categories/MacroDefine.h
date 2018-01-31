//
//  MacroDefine.h
//  CategoriesDemo
//
//  Created by Willing Guo on 2017/6/17.
//  Copyright © 2017年 SR. All rights reserved.
//

#ifndef MacroDefine_h
#define MacroDefine_h

#define BOLDSYSTEMFONT(FONTSIZE)  [UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)      [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME, FONTSIZE)      [UIFont fontWithName:(NAME) size:(FONTSIZE)]

#define ValidString(str)       (str != nil && [str isKindOfClass:[NSString class]] && ![str isEqualToString:@""])
#define ValidDictionary(dict)  (dict != nil && [dict isKindOfClass:[NSDictionary class]])
#define ValidArray(arr)        (arr != nil && [arr isKindOfClass:[NSArray class]] && [arr count] > 0)

#endif /* MacroDefine_h */
