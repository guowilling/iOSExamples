//
//  Contact.m
//  SQL练习
//
//  Created by 郭伟林 on 16/3/22.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "Contact.h"

@implementation Contact

+ (instancetype)contactWithName:(NSString *)name phone:(NSString *)phone {
    Contact *contact = [[self alloc] init];
    contact.name = name;
    contact.phone = phone;
    return contact;
}

@end
