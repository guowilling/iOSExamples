//
//  ViewController.m
//  MultiAsyncRequestsSyncDemo
//
//  Created by 郭伟林 on 2017/11/8.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self testDispatch_group_async]; // Not OK
    
//    [self testDispatch_group_enter]; // OK
    
    [self testDispatch_semaphore]; // OK
}

- (void)testDispatch_group_async {
    NSURLSession *session = [NSURLSession sharedSession];
    dispatch_queue_t dispatchQueue = dispatch_queue_create("test.dispatch_group_async", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t dispatchGroup = dispatch_group_create();
    
    dispatch_group_async(dispatchGroup, dispatchQueue, ^(){
        NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:@"https://www.baidu.com"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSLog(@"https://www.baidu.com response");
        }];
        [task resume];
    });
    
    dispatch_group_async(dispatchGroup, dispatchQueue, ^(){
        NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:@"https://www.google.com"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSLog(@"https://www.google.com response");
        }];
        [task resume];
    });
    
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
        NSLog(@"dispatch_group_notify");
    });
}

- (void)testDispatch_group_enter {
    NSURLSession *session = [NSURLSession sharedSession];
    dispatch_group_t dispatchGroup = dispatch_group_create();
    dispatch_group_enter(dispatchGroup);
    {
        NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:@"https://www.sogou.com"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSLog(@"https://www.sogou.com response");
            dispatch_group_leave(dispatchGroup);
        }];
        [task resume];
    }
    {
        dispatch_group_enter(dispatchGroup);
        NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:@"https://www.baidu.com"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSLog(@"https://www.baidu.com response");
            dispatch_group_leave(dispatchGroup);
        }];
        [task resume];
    }
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^(){
        NSLog(@"dispatch_group_notify");
    });
}

- (void)testDispatch_semaphore {
    NSURLSession *session = [NSURLSession sharedSession];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    
    dispatch_group_async(group, globalQueue, ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:@"https://www.baidu.com"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSLog(@"https://www.baidu.com response");
            dispatch_semaphore_signal(semaphore);
        }];
        [task resume];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_async(group, globalQueue, ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:@"https://www.google.com"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSLog(@"https://www.google.com response");
            dispatch_semaphore_signal(semaphore);
        }];
        [task resume];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"dispatch_group_notify");
    });
}

@end
