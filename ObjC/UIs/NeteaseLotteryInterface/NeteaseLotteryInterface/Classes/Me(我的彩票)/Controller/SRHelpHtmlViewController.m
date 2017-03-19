//
//  SRHelpHtmlViewController.m
//  NeteaseLotteryInterface
//
//  Created by 郭伟林 on 15/9/22.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import "SRHelpHtmlViewController.h"

@interface SRHelpHtmlViewController () <UIWebViewDelegate>

@property(nonatomic, weak) UIWebView *webView;

@end

@implementation SRHelpHtmlViewController

- (void)loadView {
    
    [super loadView];
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.delegate = self;
    self.view = webView;
    self.webView = webView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = self.help.title;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    //NSString *path = [[NSBundle mainBundle] pathForResource:self.help.html ofType:nil];
    //NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
    NSURL *url = [[NSBundle mainBundle] URLForResource:self.help.html withExtension:nil];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
}

- (void)back {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    // 执行javascript代码跳到对应的位置
    NSString *js = [NSString stringWithFormat:@"window.location.href = '#%@';", self.help.tag];
    [webView stringByEvaluatingJavaScriptFromString:js];
}

@end
