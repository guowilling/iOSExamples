//
//  StaticAnalysisViewController.m
//  MemoryProblems
//
//  Created by SR on 11/17/15.
//  Copyright (c) 2015 SR. All rights reserved.
//

#import "StaticAnalysisViewController.h"

@implementation StaticAnalysisViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self memoryLeakBug];
    
    [self resoureLeakBug];
    
    [self notCheckBlockParameterNotNull:nil];
    
    [self insertNilToArray];
    
    [self arrayWithMeetFirstNilEnd];
}

- (void)memoryLeakBug {
    
    // 通过C函数创建的对象不管什么环境都需要手动释放.
    CGPathRef shadowPath = CGPathCreateWithRect(self.inputView.bounds, NULL);
    //CGPathRelease(shadowPath);
}

- (void)resoureLeakBug {
    
    FILE *file;
    file = fopen("Info.plist", "r");
    NSLog(@"file: %@", file);
    //fclose(file);
}

- (void)notCheckBlockParameterNotNull:(void (^)())callback {
    
    // 如果 block 参数传入 nil 执行会 crash, 所以必须判断.
    if (callback) {
        callback();
    }
}

- (void)insertNilToArray {
    
    NSString *string = nil;
    // 数组中不能存储 nil 元素, 否则程序会 carsh.
    //NSArray *array = @[@"horse", string, @"dolphin"]; // -[__NSPlaceholderArray initWithObjects:count:]: attempt to insert nil object from objects[1]
}

- (void)arrayWithMeetFirstNilEnd {
    
    NSString *string = nil;
    NSArray *array = [NSArray arrayWithObjects: @"horse", string, @"dolphin", nil];
    NSLog(@"arrayWithMeetFirstNilEnd: %@", array);
}

@end
