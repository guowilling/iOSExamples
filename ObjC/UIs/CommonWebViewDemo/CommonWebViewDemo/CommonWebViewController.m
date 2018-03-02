//
//  CommonWebViewController.m
//  CommonWebViewDemo
//
//  Created by 郭伟林 on 17/5/22.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "CommonWebViewController.h"
#import <WebKit/WebKit.h>

static CGFloat const Navigation_Bar_HEIGHT = 64;

@interface CommonWebViewController () <UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) id <UIGestureRecognizerDelegate>delegate;

@property (nonatomic, strong) WKWebView *wk_webView;
@property (nonatomic, strong) UIWebView *ui_webView;

@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIBarButtonItem *closeItem;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) UIProgressView *loadingProgressView;

@end

@implementation CommonWebViewController

- (void)dealloc {
    [_wk_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_wk_webView stopLoading];
    [_ui_webView stopLoading];
}

- (WKWebView*)wk_webView {
    if (!_wk_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.preferences = [[WKPreferences alloc] init];
        config.userContentController = [[WKUserContentController alloc] init];
        _wk_webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,
                                                                  Navigation_Bar_HEIGHT,
                                                                  self.view.bounds.size.width,
                                                                  self.view.bounds.size.height - Navigation_Bar_HEIGHT)
                                         configuration:config];
        _wk_webView.navigationDelegate = self;
        _wk_webView.UIDelegate = self;
        _wk_webView.allowsBackForwardNavigationGestures = YES;
        [_wk_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
        if (_canPullDownToRefresh && [[UIDevice currentDevice] systemVersion].floatValue >= 10.0) {
            _wk_webView.scrollView.refreshControl = self.refreshControl;
        }
    }
    return _wk_webView;
}

- (UIWebView*)ui_webView {
    if (!_ui_webView) {
        _ui_webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,
                                                                  Navigation_Bar_HEIGHT,
                                                                  self.view.bounds.size.width,
                                                                  self.view.bounds.size.height - Navigation_Bar_HEIGHT)];
        _ui_webView.delegate = self;
    }
    return _ui_webView;
}

- (UIProgressView*)loadingProgressView {
    if (!_loadingProgressView) {
        _loadingProgressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0,
                                                                               Navigation_Bar_HEIGHT,
                                                                               self.view.bounds.size.width,
                                                                               2)];
        _loadingProgressView.progressTintColor = [UIColor blueColor];
    }
    return _loadingProgressView;
}

- (UIRefreshControl*)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self
                            action:@selector(reloadWebView)
                  forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

- (UIBarButtonItem*)backItem {
    if (!_backItem) {
        _backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                     style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(back:)];
    }
    return _backItem;
}

- (UIBarButtonItem*)closeItem {
    if (!_closeItem) {
        _closeItem = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                      style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:@selector(close:)];
    }
    return _closeItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 8.0) {
        [self.view addSubview:self.wk_webView];
        [self.view addSubview:self.loadingProgressView];
        [self.wk_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.URLString]]];
    } else {
        [self.view addSubview:self.ui_webView];
        [self.ui_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.URLString]]];
    }
    
    [self setupNavigationItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // after custom navigation button support slip gesture handling
    if (self.navigationController.viewControllers.count > 1) {
        self.delegate = self.navigationController.interactivePopGestureRecognizer.delegate;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self.delegate;
}

- (void)setupNavigationItem {
    if ([_ui_webView canGoBack] || [_wk_webView canGoBack]) {
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];
    } else {
        self.navigationItem.leftBarButtonItem = self.backItem;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        _loadingProgressView.progress = [change[@"new"] floatValue];
        if (_loadingProgressView.progress == 1.0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _loadingProgressView.hidden = YES;
            });
        }
    }
}

- (void)reloadWebView {
    [_ui_webView reload];
    [_wk_webView reload];
}

- (void)back:(UIBarButtonItem*)item {
    if ([_ui_webView canGoBack] || [_wk_webView canGoBack]) {
        [_ui_webView goBack];
        [_wk_webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)close:(UIBarButtonItem*)item {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.navigationController.viewControllers.count > 1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return self.navigationController.viewControllers.count > 1;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    webView.hidden = NO;
    if ([request.URL.scheme isEqual:@"about"]) {
        webView.hidden = YES;
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    [self setupNavigationItem];
    
    [_refreshControl endRefreshing];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    webView.hidden = YES;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    _loadingProgressView.hidden = NO;
    
    webView.hidden = NO;
    if ([webView.URL.scheme isEqual:@"about"]) {
        webView.hidden = YES;
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable title, NSError * _Nullable error) {
        self.navigationItem.title = title;
    }];
    
    [self setupNavigationItem];
    
    [_refreshControl endRefreshing];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    webView.hidden = YES;
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if (challenge.previousFailureCount == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

@end

