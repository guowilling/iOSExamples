//
//  ViewController.m
//  FoundationToCoreFoundation
//
//  Created by Willing Guo on 17/1/15.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 桥接: Foundation(NSString) 和 Core Foundation(CFStringRef) 相互转换.
    
    // 使用C语言的函数时只要函数名称包含 creat/copy/retain 必须通过CFRelease函数释放.
    
    // MRC
    // Foundation 转 Core Foundation 直接强制类型转换.
//    NSString *ocString = [NSString stringWithFormat:@"willing"];
//    CFStringRef cString = (CFStringRef)ocString;
//    
    // Core Foundation 转 Foundation 直接强制类型转换.
//    CFStringRef cString = CFStringCreateWithCString(CFAllocatorGetDefault(), "willing", kCFStringEncodingASCII);
//    NSString *ocString = (NSString *)cString;
    
    
    // ARC
    // __bridge
    {
        // __bridge 仅仅是将 ocString 的地址给了 cString (没有增加引用数).
        // 注意: 使用 __bridge桥接, 如果 ocString 释放了, cString 就不能用了, cString 可以不用释放.
        NSString *ocString = [NSString stringWithFormat:@"willing"];
        CFStringRef cString = (__bridge CFStringRef)ocString;
    }
    
    {
        // __bridge 仅仅是将 cString 的地址给了 ocString, 不会转移对象的所有权.
        // 注意: 使用 __bridge 桥接, 如果 cString 释放了, ocString 也不能用了.
        CFStringRef cString = CFStringCreateWithCString(CFAllocatorGetDefault(), "willing", kCFStringEncodingASCII);
        NSString *ocString = (__bridge NSString *)cString;
        CFRelease(cString);
    }
    
    
    // __bridge_retained
    {
        // __bridge_retained 桥接, 增加了引用数, 即使 ocString 被释放了, cString 也可以使用.
        // 注意: 使用 __bridge_retained 桥接, cString 必须手动释放, C 语言的东西不归 ARC 管理.
        NSString *ocString = [NSString stringWithFormat:@"willing"];
        CFStringRef cString = (__bridge_retained CFStringRef)ocString;
        //CFStringRef cString = CFBridgingRetain(strOC);// 等同于上一句
        CFRelease(cString);
    }
    
    // __bridge_transfer
    {
        // __bridge_transfer 桥接, 增加了引用数, 即使 cString 被释放了, ocString 也可以使用.
        // 注意: __bridge_transfer 会自动释放 cString, 不用手动释放 cString.
        CFStringRef cString = CFStringCreateWithCString(CFAllocatorGetDefault(), "willing", kCFStringEncodingASCII);
        NSString *ocString = (__bridge_transfer NSString *)cString;
        //NSString *ocString = CFBridgingRelease(strC); // 等同于上一句
    }
}

@end
