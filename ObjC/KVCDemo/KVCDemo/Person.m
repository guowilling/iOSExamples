//
//  Person.m
//  kVC
//
//  Created by apple on 14-10-8.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "Person.h"

@interface Person ()
{
    @private
    double _height;
}

@end

@implementation Person

- (void)printHeight
{
    NSLog(@"height is: %.2f", _height);
}

@end
