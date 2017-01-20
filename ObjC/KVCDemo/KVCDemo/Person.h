//
//  Person.h
//  kVC
//
//  Created by apple on 14-10-8.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Dog;

@interface Person : NSObject
{
    double _weight;
    
    @protected
    double _age;
}

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray *books;

@property (nonatomic, strong) Dog *dog;

- (void)printHeight;

@end
