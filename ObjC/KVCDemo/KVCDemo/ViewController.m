//
//  ViewController.m
//  KVCDemo
//
//  Created by 郭伟林 on 17/1/20.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "Book.h"
#import "Dog.h"
#import "Bone.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)testKVC3 {
    
    Person *person = [[Person alloc] init];
    person.dog = [[Dog alloc] init];
    person.dog.bone = [[Bone alloc] init];
    NSLog(@"dog.bone: %@", [person valueForKeyPath:@"dog.bone"]);
}

- (void)testKVC2 {
    
    Person *person = [[Person alloc] init];
    person.dog = [[Dog alloc] init];
    person.dog.bone = [[Bone alloc] init];
    [person setValue:@"猪骨1" forKeyPath:@"dog.bone.type"];
    [person.dog setValue:@"猪骨2" forKeyPath:@"bone.type"];
    [person.dog.bone setValue:@"猪骨3" forKeyPath:@"type"];
    person.dog.bone.type = @"猪骨4";
    NSLog(@"person.dog.bone.type: %@", person.dog.bone.type);
    
    // forKeyPath 包含了 forKey 的功能, 一律使用 forKeyPath 就行.
    // forKeyPath 可以使用.运算符, 一层一层往下查找对象的属性.
    [person.dog setValue:@"wangcai1" forKey:@"name"];
    [person.dog setValue:@"wangcai2" forKeyPath:@"name"];
    [person setValue:@"hashiqi1" forKeyPath:@"dog.name"];
    [person setValue:@"hashiqi2" forKey:@"dog.name"]; // 错误用法
    NSLog(@"person.dog.name: %@", person.dog.name);
}

- (void)testKVC1 {
    
    Person *person = [[Person alloc] init];
    person.name = @"rose";
    [person setValue:@"jack1" forKey:@"name"];
    [person setValue:@"jack2" forKeyPath:@"_name"];
    // KVC 可以修改一个对象的属性或成员变量, 私有的也可以.
    [person setValue:@10.5 forKey:@"height"];
    [person printHeight];
}

- (void)testKVC0 {
    
    Person *person = [[Person alloc] init];
    
    Book *book1 = [[Book alloc] init];
    book1.name = @"iOS";
    book1.price = 5;
    
    Book *book2 = [[Book alloc] init];
    book2.name = @"Android";
    book2.price = 15;
    
    Book *book3 = [[Book alloc] init];
    book3.name = @"JavaScript";
    book3.price = 25;
    
    Book *book4 = [[Book alloc] init];
    book4.name = @"Python";
    book4.price = 35;
    
    person.books = @[book1, book2, book3, book4];
    
    NSMutableArray *bookNames1 = [NSMutableArray array];
    for (Book *book in person.books) {
        [bookNames1 addObject:book.name];
    }
    NSLog(@"bookNames1: %@", bookNames1);
    
    NSArray *bookNames2 = [person valueForKeyPath:@"books.name"];
    NSLog(@"bookNames2: %@", bookNames2);
}

@end
