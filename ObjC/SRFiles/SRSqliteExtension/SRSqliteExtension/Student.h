//
//  Student.h
//  SRSqliteExtension
//
//  Created by 郭伟林 on 2017/6/23.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRModelProtocol.h"

@interface Student : NSObject <SRModelProtocol> {
    
    int tmp;
}

@property (nonatomic, assign) NSInteger stuNum;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) int age;

@property (nonatomic, assign) float score;

@property (nonatomic, strong) NSArray *arr;

@property (nonatomic, strong) NSDictionary *dic;

@end
