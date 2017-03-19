//
//  ViewController.m
//  KVODemo
//
//  Created by 郭伟林 on 17/1/20.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@property (nonatomic, strong) Person *person;

@end

@implementation ViewController

- (void)dealloc {
    
    [self.person removeObserver:self forKeyPath:@"name"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    Person *person = [[Person alloc] init];
    person.name = @"gwl1";
    [person addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    person.name = @"gwl2";
    _person = person;
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    NSLog(@"%@ 对象的 %@ 属性被改变了 %@", object, keyPath, change);
}

@end
