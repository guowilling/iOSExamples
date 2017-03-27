//
//  main.m
//  指针函数&函数指针
//
//  Created by 郭伟林 on 17/1/18.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

int *sum(int a, int b); // 指针函数: 函数的返回值是指针.

int *sum(int a, int b)
{
    int *p = malloc(sizeof(int));
    *p = a + b;
    return p;
}

int (*func)(int, int); // 函数指针: 指向返回值类型为 int, 需要两个 int 类型参数的函数.

int max(int a, int b)
{
    return a > b ? a : b;
}

int min(int a, int b)
{
    return a < b ? a : b;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        int *abSum = NULL;
        printf("p address is %p\n", abSum);
        abSum = sum(1, 1);
        printf("p address is %p\n", abSum);
        printf("p value is %d\n", *abSum);
        
        
        func = max; // 使函数指针 func 指向 max 函数.
        int max = func(1, 2);
        // equals: int max = (*f)(1, 2);
        printf("max: %d\n", max);
        
        func = min; // 使函数指针 func 指向 min 函数.
        int min = func(1, 2);
         //equals: int min = (*func)(1, 2);
        printf("min: %d\n", min);
    }
    return 0;
}
