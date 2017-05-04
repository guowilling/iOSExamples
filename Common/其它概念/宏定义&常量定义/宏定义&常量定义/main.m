//
//  main.m
//  宏定义&常量定义
//
//  Created by 郭伟林 on 17/1/18.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

const int Age = 20;

#define Age 20

int main(int argc, const char * argv[]) {
    
    @autoreleasepool {
        
        // 使用一份地址
        NSLog(@"%@", MyAge);
        NSLog(@"%@", MyAge);
        NSLog(@"%@", MyAge);
        
        // 使用多份地址
        NSLog(@"%d", Age);
        NSLog(@"%d", Age);
        NSLog(@"%d", Age);
    }
    return 0;
}

void testConst()
{
    int age = 20;
    
    {
        // const 修饰 *p1.
        // *p1 是常量, p1 是变量.
        int const *p1 = &age;
        
        // 可以
        int num = 30;
        p1 = &num;
        
        // 不可以
        //*p1 = 40;
    }
    
    {
        // const 修饰 p2.
        // p2 是常量, *p2 是变量.
        int * const p2 = &age;
        
        // 可以
        *p2 = 30;
        
        // 不可以
        //int num = 30;
        //p2 = &num;
    }
}
