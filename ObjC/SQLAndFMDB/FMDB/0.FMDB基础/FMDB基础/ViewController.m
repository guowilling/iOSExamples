//
//  ViewController.m
//  FMDB基础
//
//  Created by 郭伟林 on 16/3/22.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "ViewController.h"
#import "SRShop.h"
#import "SRShopTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    for (int i = 0; i < 10; i++) {
        SRShop *shop = [[SRShop alloc] init];
        shop.name = [NSString stringWithFormat:@"枕头%d", i];
        shop.price = arc4random() % 200;
        [SRShopTool addShop:shop];
    }
    
    NSArray *shops = [SRShopTool shops];
    for (SRShop *shop in shops) {
        NSLog(@"name: %@; price: %f", shop.name, shop.price);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [SRShopTool deleteShop:100];
    
    NSArray *shops = [SRShopTool shops];
    for (SRShop *shop in shops) {
        NSLog(@"name: %@; price: %f", shop.name, shop.price);
    }
}

@end
