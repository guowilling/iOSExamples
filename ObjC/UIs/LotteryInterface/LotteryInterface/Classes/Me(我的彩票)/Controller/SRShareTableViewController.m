//
//  SRShareTableViewController.m
//  LotteryInterface
//
//  Created by 郭伟林 on 15/9/22.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "SRShareTableViewController.h"
#import <MessageUI/MessageUI.h>

@interface SRShareTableViewController () <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@end

@implementation SRShareTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self addSectionItems];
}

- (void)addSectionItems {
    
    SRSettingItem *item00 = [[SRSettingArrowItem alloc] initWithIcon:@"WeiboSina" title:@"新浪微博"];
    
    SRSettingItem *item01 = [[SRSettingArrowItem alloc] initWithIcon:@"SmsShare" title:@"短信分享"];
    // __unsafe_unretained SRShareTableViewController *unsafeSelf = self;
    // __weak SRShareTableViewController *unsafeSelf = self;
    // __weak 对象释放之后会自动设置为nil __unsafe_unretained不会
    __weak typeof(self) safeSelf = self;
    item01.option = ^{ // 短信分享
        // 短信分享之后不会返回应用程序
        // NSURL *url = [NSURL URLWithString:@"sms://10010"];
        // [[UIApplication sharedApplication] openURL:url];
        
        if (![MFMessageComposeViewController canSendText]) return;
        MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc] init];
        // 默认内容
        vc.body = @"你好";
        // 接收者列表
        vc.recipients = @[@"18508235598"];
        vc.messageComposeDelegate = safeSelf;
        [safeSelf presentViewController:vc animated:YES completion:nil];
    };
    
    SRSettingItem *item02 = [[SRSettingArrowItem alloc] initWithIcon:@"MailShare" title:@"邮件分享"];
    item02.option = ^{ // 邮件分享
        // 邮件分享之后不会返回应用程序
        // NSURL *url = [NSURL URLWithString:@"mailto://10010@qq.com"];
        // [[UIApplication sharedApplication] openURL:url];
        
        if (![MFMailComposeViewController canSendMail]) return;
        MFMailComposeViewController *vc = [[MFMailComposeViewController alloc] init];
        vc.mailComposeDelegate = safeSelf;
        [vc setSubject:@"主题"]; // 邮件主题
        [vc setMessageBody:@"今天好吗" isHTML:NO]; // 邮件内容
        [vc setToRecipients:@[@"396658379@qq.com"]]; // 收件人列表
        [vc setCcRecipients:@[@"guo_weilin@foxmail.com"]]; // 抄送人列表
        [vc setBccRecipients:@[@"shuanglinyi@163.com"]]; // 密送人列表
        // 附件
        UIImage *image = [UIImage imageNamed:@"LoginScreen"];
        NSData *data = UIImageJPEGRepresentation(image, 0.5);
        [vc addAttachmentData:data mimeType:@"image/jpeg" fileName:@"xx.jpeg"];
        [safeSelf presentViewController:vc animated:YES completion:nil];
    };
    
    SRSettingGroup *group = [[SRSettingGroup alloc] init];
    group.settingItems = @[item00, item01, item02];
    [self.datas addObject:group];
}

#pragma mark - MFMessageComposeViewController

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    if (result == MessageComposeResultCancelled) {
        NSLog(@"取消发送Message");
    } else if (result == MessageComposeResultSent) {
        NSLog(@"已经发出Message");
    } else {
        NSLog(@"发送失败Message");
    }
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    if (result == MFMailComposeResultCancelled) {
        NSLog(@"取消发送Mail");
    } else if (result == MFMailComposeResultSent) {
        NSLog(@"已经发出Mail");
    } else {
        NSLog(@"发送失败Mail");
    }
}

- (void)dealloc {
    
    NSLog(@"dealloc: %@", self.class);
}

@end
