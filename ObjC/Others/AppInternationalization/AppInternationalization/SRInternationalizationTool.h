//
//  SRInternationalizationTool.h
//  AppInternationalization
//
//  Created by 郭伟林 on 16/12/12.
//  Copyright © 2016年 SR. All rights reserved.
//

#define SRLocalizedStringForKeyFromTable(key, table) [[SRInternationalizationTool sharedInternationalizationTool] \
                                                       localizedStringForKey:key fromTable:table]

#define SRLocalizedStringForKey(key) SRLocalizedStringForKeyFromTable(key, nil)

#import <Foundation/Foundation.h>

@interface SRInternationalizationTool : NSObject

+ (instancetype)sharedInternationalizationTool;

- (void)setCurrentLanguage:(NSString *)currentLanguage;

- (NSString *)currentLanguageDescription;

- (NSString *)localizedStringForKey:(NSString *)key fromTable:(NSString *)table;

@end
