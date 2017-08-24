//
//  ContainerViewController.m
//  webc
//
//  Created by Long Zhou on 2017/8/21.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import "ContainerViewController.h"
#import "WebViewJavascriptBridge.h"
#import "ProcessLineView.h"
#import "Logger.h"
#import <Masonry.h>

@interface ContainerViewController ()
{
    NSURLConnection *theConnection;
}
@property(strong, nonatomic) WebViewJavascriptBridge* bridge;
@property(strong, nonatomic) NSString *url;
@property(strong, nonatomic) UIWebView *webview;
@property(strong, nonatomic) ProcessLineView *processLine;

@end

@implementation ContainerViewController

static ContainerViewController *_backInstance = nil;

+ (void)load {
    _backInstance = [ContainerViewController getInstance];
}

+ (instancetype)getInstance {
    ContainerViewController * temp = _backInstance;
    _backInstance = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _backInstance = [[ContainerViewController alloc] init];
        _backInstance.webview = [[UIWebView alloc] init];
    });
    
    if (!temp) {
        temp = [[ContainerViewController alloc] init];
        temp.webview = [[UIWebView alloc] init];
    }
    
    return temp;
}

- (id)initWithUrl:(NSString *)url {
    [[Logger shareInstance] time];
    self = [ContainerViewController getInstance];
    
    
    if ([url isEqualToString:@"test"]) {
        url = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    }
    
    self.url = url;
    
    NSURL *originUrl = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:originUrl
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:15];
    
    [self.webview loadRequest:request];
    
    [[Logger shareInstance] timeEnd];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"...";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.webview.frame = self.view.bounds;
    self.webview.delegate = self;
    self.webview.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    [self.view addSubview:self.webview];
    
    [self registPlugins];
    
    CGRect processLineFrame = CGRectMake(
                                         0,
                                         [[UIApplication sharedApplication] statusBarFrame].size.height +
                                         self.navigationController.navigationBar.frame.size.height,
                                         self.view.frame.size.width,
                                         3);
    self.processLine = [[ProcessLineView alloc] initWithFrame:processLineFrame];
    self.processLine.lineColor = [UIColor redColor];
    [self.view addSubview:self.processLine];
    // Do any additional setup after loading the view.
}

- (void)registPlugins {
    [self.webview stringByEvaluatingJavaScriptFromString:@"function setupWebViewJavascriptBridge(callback) {\nif (window.WebViewJavascriptBridge) { return callback(WebViewJavascriptBridge); }\nif (window.WVJBCallbacks) { return window.WVJBCallbacks.push(callback); }\nwindow.WVJBCallbacks = [callback];\nvar WVJBIframe = document.createElement('iframe');\nWVJBIframe.style.display = 'none';\nWVJBIframe.src = 'https://__bridge_loaded__';\ndocument.documentElement.appendChild(WVJBIframe);\nsetTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)\n}"];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webview];
    
    [self.bridge registerHandler:@"blankOver"
                         handler:^(id data, WVJBResponseCallback responseCallback) {
                             [[Logger shareInstance] timeEnd];
                         }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showErrorMessage:(NSString *)msg {
    UILabel *label = [[UILabel alloc] init];
    [label setText:msg];
    [self.view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UIWebview delegate

//开始加载网页
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.processLine startLoadingAnimation];
}

//网页加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (![webView isLoading]) {
        [self.processLine endLoadingAnimation];
    }
    
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title = title;
}

//网页加载错误
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSString *errorMsg = (NSString *)[[error userInfo] valueForKey:@"NSLocalizedDescription"];
    [self showErrorMessage:errorMsg];
    [self.processLine endLoadingAnimation];
}

@end
