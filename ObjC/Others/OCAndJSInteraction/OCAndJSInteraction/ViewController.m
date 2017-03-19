//
//  ViewController.m
//  OCAndJSInteraction
//
//  Created by Willing Guo on 16/12/1.
//  Copyright © 2016年 SR. All rights reserved.
//  基于<JavaScriptCore/JavaScriptCore.h> 的 ObjC 和 JS 交互.

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "JavaScriptCoreExtension.h"

@interface ViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"OCAndJSInteraction";
    
    _webView = [[UIWebView alloc] init];
    _webView.frame = self.view.bounds;
    _webView.delegate = self;
    NSString *htmlFilePath = [[NSBundle mainBundle] pathForResource:@"demoHTML" ofType:@"html"];
    NSURL *URL = [NSURL URLWithString:htmlFilePath];
    [_webView loadRequest:[NSURLRequest requestWithURL:URL]];
    [self.view addSubview:_webView];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSLog(@"webViewDidFinishLoad");
    
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    // OC 调用 JS 方式一
    //[webView stringByEvaluatingJavaScriptFromString:@"alert('这是个弹框')"];
    // OC 调用 JS 方式二
    //NSString *alertJS=@"alert('这是个弹框')";
    //[context evaluateScript:alertJS];
    
    // JS 调用 OC
    JavaScriptCoreExtension *javaScriptCoreExtension = [[JavaScriptCoreExtension alloc]init];
    context[@"STAYREAL"] = javaScriptCoreExtension;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    NSLog(@"didFailLoadWithError");
}

@end
