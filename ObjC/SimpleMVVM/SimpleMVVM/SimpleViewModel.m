//
//  SimpleViewModel.m
//  SimpleMVVM
//
//  Created by 郭伟林 on 16/12/5.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "SimpleViewModel.h"
#import "SimpleModel.h"

@implementation SimpleViewModel

- (NSMutableArray *)datas {
    
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (void)loadNewestDatasWithSuccess:(void (^)(BOOL success))success failure:(void (^)(NSError *error))failure {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(2);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.datas removeAllObjects];
            for (int i = 0; i < 10; i++) {
                SimpleModel *simpleModel = [[SimpleModel alloc] init];
                simpleModel.text = @"hello, mvvm";
                [self.datas addObject:simpleModel];
            }
            if (success) {
                success(YES);
            }
        });
    });
}

- (void)loadMoreDatasWithSuccess:(void (^)(BOOL success))success   failure:(void (^)(NSError *error))failure {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(2);
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int i = 0; i < 10; i++) {
                SimpleModel *simpleModel = [[SimpleModel alloc] init];
                simpleModel.text = @"hello, mvvm";
                [self.datas addObject:simpleModel];
            }
            if (success) {
                success(YES);
            }
        });
    });
}

@end
