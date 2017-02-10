//
//  SRSettingItem.m
//  NeteaseLotteryInterface
//
//  Created by 郭伟林 on 15/9/22.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "SRSettingItem.h"

@implementation SRSettingItem

- (instancetype)initWithIcon:(NSString *)icon title:(NSString *)title {
    
    if (self = [super init]) {
        self.icon = icon;
        self.title = title;
    }
    return self;
   
    // inlineBlock
//    <#returnType#>(^<#blockName#>)(<#parameterTypes#>) = ^(<#parameters#>) {
//        <#statements#>
//    };
    
    //返回值类型 (^block名称)(参数列表)
    //void (^testBlock)() = ^{
    //    NSLog(@"xx");
    //};
    //testBlock();
    
    //void test()
    //{
    //    printf("xx");
    //}
    //void (*pointer)() = test;
    //pointer();
}

@end
