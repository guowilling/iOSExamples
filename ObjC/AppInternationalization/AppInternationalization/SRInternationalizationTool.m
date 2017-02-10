//
//  SRInternationalizationTool.m
//  AppInternationalization
//
//  Created by 郭伟林 on 16/12/12.
//  Copyright © 2016年 SR. All rights reserved.
// 

#import "SRInternationalizationTool.h"

#define SRCurrentLanguage @"currentLanguage"

static SRInternationalizationTool *sharedInternationalizationTool;

@interface SRInternationalizationTool ()

@property (nonatomic, strong) NSBundle *languageBundle;

@end

@implementation SRInternationalizationTool

+ (instancetype)sharedInternationalizationTool {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @synchronized(self) {
            sharedInternationalizationTool = [[self alloc] init];
        }
    });
    return sharedInternationalizationTool;
}

- (instancetype)init {
    
    if (self = [super init]) {
        NSString *currentLanguage = self.currentLanguage;
        if (currentLanguage) {
            _languageBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:currentLanguage ofType:@"lproj"]];
        }
//        if (!currentLanguage) {
//            NSArray *languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"]; // 用户偏好设置中存储着系统当前的首选语言顺序.
//            currentLanguage = languages[0];
//            NSRange cRange = [currentLanguage rangeOfString:@"-CN"];
//            if (cRange.location != NSNotFound) {
//                currentLanguage = [currentLanguage substringToIndex:cRange.location];
//                _languageBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:currentLanguage ofType:@"lproj"]];
//            }
//        }
    }
    return self;
}

- (NSString *)currentLanguage {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:SRCurrentLanguage];
}

- (void)setCurrentLanguage:(NSString *)currentLanguage {
    
    if (currentLanguage) {
        if (![self.currentLanguage isEqualToString:currentLanguage]) {
            [[NSUserDefaults standardUserDefaults] setObject:currentLanguage forKey:SRCurrentLanguage];
            _languageBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:currentLanguage ofType:@"lproj"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"didChangesLanguageNotification" object:nil];
        }
    } else {
        if (self.currentLanguage) {
            _languageBundle = nil;
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:SRCurrentLanguage];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"didChangesLanguageNotification" object:nil];
        }
    }
}

- (NSString *)currentLanguageDescription {
    
    if ([[self currentLanguage] isEqualToString:@"zh-Hans"]) {
        return @"简体中文";
    } else if ([[self currentLanguage] isEqualToString:@"en"]) {
        return @"English";
    } else if ([[self currentLanguage] isEqualToString:@"ja"]) {
        return @"日本語";
    } else {
        return @"System";
    }
}

- (NSString *)localizedStringForKey:(NSString *)key fromTable:(NSString *)table {
    
    if (!table) {
        table = @"CustomLocalizable";
    }
    if (_languageBundle) {
        return NSLocalizedStringFromTableInBundle(key, table, _languageBundle, nil);
    }
    return NSLocalizedStringFromTable(key, table, nil);
}

@end
