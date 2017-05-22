//
//  CommonWebViewController.h
//  CommonWebViewDemo
//
//  Created by 郭伟林 on 17/5/22.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonWebViewController : UIViewController

@property (nonatomic, copy) NSString *URLString;

@property (nonatomic, assign) BOOL canPullDownToRefresh;

@end
