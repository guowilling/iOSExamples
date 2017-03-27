//
//  ViewController.m
//  OCBlock
//
//  Created by Willing Guo on 17/1/15.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "Student.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    {
        // Block  链式编程
        Student *student = [[Student alloc] init];
        student.study(@"xx宝典").run().study(@"xx秘籍");
    }
    
//    __block int a = 0;
//    NSLog(@"block 定义前: %p", &a); // a 在栈区
//    void (^foo)(void) = ^{
//        a = 1;
//        NSLog(@"block 内部: %p", &a); // a 在堆区
//    };
//    NSLog(@"block 定义后: %p", &a); // a 在堆区
//    foo();
    
//    NSMutableString *a = [NSMutableString stringWithString:@"Tom"];
//    NSLog(@"\n block 定以前: ------------------------------------\n\
//          a 指向的堆中地址: %p; a 在栈中的指针地址: %p", a, &a); // a 在栈区
//    void (^foo)(void) = ^{
//        a.string = @"Jerry";
//        NSLog(@"\n block 内部: ------------------------------------\n\
//              a 指向的堆中地址: %p; a 在栈中的指针地址: %p", a, &a); // a 在栈区
//        a = [NSMutableString stringWithString:@"William"]; // Variable is not assignable (missing __block type specifier)
//    };
//    foo();
//    NSLog(@"\n block 定以后: ------------------------------------\n\
//          a 指向的堆中地址: %p; a 在栈中的指针地址: %p", a, &a); // a 在栈区
}


int num = 10;
void test5()
{
    void (^block)() = ^{
        // block 内部能够跟踪全局变量的改变
        NSLog(@"num = %d", num); // age = 20
    };
    num = 20;
    block();
}

void test4()
{
    static int age = 10;
    void (^block)() = ^{
        // block 内部能够跟踪 static 修饰的局部变量的改变
        NSLog(@"age = %d", age); // age = 20
    };
    age = 20;
    block();
}

void test2()
{
    __block int age = 10;
    void (^block)() = ^{
        // block 内部能够跟踪 __block 修饰的局部变量的改变
        NSLog(@"age = %d", age); // age = 20
    };
    age = 20;
    block();
}

void test1()
{
    int age = 10;
    void (^block)() = ^{
        // block 内部不能跟踪普通局部变量的改变
        NSLog(@"age = %d", age); // age = 10
    };
    age = 20;
    block();
}

@end
