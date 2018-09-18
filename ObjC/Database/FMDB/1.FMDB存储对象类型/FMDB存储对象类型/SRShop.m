//
//  HMShop.m
//  FMDB存储对象类型
//
//  Created by 郭伟林 on 16/3/23.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "SRShop.h"

@implementation SRShop

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeDouble:self.price forKey:@"price"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.price = [decoder decodeDoubleForKey:@"price"];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"name: %@; price: %f", self.name, self.price];
}

@end
