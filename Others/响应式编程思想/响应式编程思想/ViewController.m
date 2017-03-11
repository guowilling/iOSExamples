//
//  ViewController.m
//  响应式编程思想
//
//  Created by 郭伟林 on 17/2/10.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@property (nonatomic, strong) Person *person;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    Person *p = [[Person alloc] init];
    [p addObserver:self forKeyPath:@"number" options:NSKeyValueObservingOptionNew context:nil];
    _person = p;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    NSLog(@"%@", _person.number);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    static int i = 0;
    i++;
    _person.number = [NSString stringWithFormat:@"number: %d", i]; // Must setter.
    //_person -> _number = [NSString stringWithFormat:@"%d",i]; // No KVO effcts.
}

@end
