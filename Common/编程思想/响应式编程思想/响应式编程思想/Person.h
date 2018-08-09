//
//  Person.h
//  响应式编程思想
//
//  Created by 郭伟林 on 17/2/10.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject {
    @public
    NSString *_number;
}

@property (nonatomic, copy) NSString *number;

@end
