//
//  SimpleViewModel.h
//  SimpleMVVM
//
//  Created by 郭伟林 on 16/12/5.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimpleViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *datas;

- (void)loadNewestDatasWithSuccess:(void (^)(BOOL success))success failure:(void (^)(NSError *error))failure;
- (void)loadMoreDatasWithSuccess:(void (^)(BOOL success))success   failure:(void (^)(NSError *error))failure;

@end
