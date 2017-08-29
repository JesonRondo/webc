//
//  ContainerViewController.m
//  webc
//
//  Created by Long Zhou on 2017/8/21.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import "ContainerViewController.h"
//#import "WebViewJavascriptBridge.h"
#import "ProcessLineView.h"
#import "Logger.h"
#import "WJSContext.h"
#import <Masonry.h>

@interface ContainerViewController ()
//@property(strong, nonatomic) WebViewJavascriptBridge* bridge;
//@property(strong, nonatomic) NSString *url;
@property(nonatomic) Boolean loaded;
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) WKWebView *webview;
@property(strong, nonatomic) ProcessLineView *processLine;
@property(strong, nonatomic) NSMutableArray *execQueue;

@end

@implementation ContainerViewController

static ContainerViewController *_backInstance = nil;

+ (void)load {
    _backInstance = [ContainerViewController getInstance];
}

+ (instancetype)getInstance {
    ContainerViewController *temp = _backInstance;
    _backInstance = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _backInstance = [[ContainerViewController alloc] init];
    });
    
    if (!temp) {
        temp = [[ContainerViewController alloc] init];
    }
    return temp;
}

- (id)init {
    if (self = [super init]) {
        self.loaded = NO;
        self.execQueue = [[NSMutableArray alloc] init];
        
        self.webview = [[WKWebView alloc] init];
        self.webview.navigationDelegate = self;
        
        NSString *viewPath = [[NSBundle mainBundle] pathForResource:@"view" ofType:@"html"];
        NSURL *viewURL = [NSURL fileURLWithPath:viewPath];
        NSString *viewHTMLContent = [NSString stringWithContentsOfURL:viewURL
                                                             encoding:NSUTF8StringEncoding
                                                                error:nil];
        
        [self.webview loadHTMLString:viewHTMLContent baseURL:viewURL];
//        [self.webview loadFileURL:viewURL allowingReadAccessToURL:viewURL];
    }
    return self;
}

- (id)initWithName:(NSString *)name {
    self = [ContainerViewController getInstance];
    self.name = name;

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webview];
    CGRect frame = self.view.frame;
    self.webview.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
//    self.navigationItem.title = @"...";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
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
//    [self.webview stringByEvaluatingJavaScriptFromString:@"function setupWebViewJavascriptBridge(callback) {\nif (window.WebViewJavascriptBridge) { return callback(WebViewJavascriptBridge); }\nif (window.WVJBCallbacks) { return window.WVJBCallbacks.push(callback); }\nwindow.WVJBCallbacks = [callback];\nvar WVJBIframe = document.createElement('iframe');\nWVJBIframe.style.display = 'none';\nWVJBIframe.src = 'https://__bridge_loaded__';\ndocument.documentElement.appendChild(WVJBIframe);\nsetTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)\n}"];
//    
//    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webview];
//    
//    [self.bridge registerHandler:@"blankOver"
//                         handler:^(id data, WVJBResponseCallback responseCallback) {
//                             [[Logger shareInstance] timeEnd];
//                         }];
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

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(evalJavaScriptBlock)completionHandler {
    if (!self.loaded) {
        [self.execQueue addObject:@{
                                    @"code": javaScriptString,
                                    @"handler": completionHandler
                                }];
    } else {
        [self.webview evaluateJavaScript:javaScriptString
                       completionHandler:^(id result, NSError * _Nullable error) {
                           if (completionHandler) {
                               completionHandler(result, error);
                           }
                       }];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - WKWebview delegate

//开始加载网页
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self.processLine startLoadingAnimation];
}

//网页加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (![webView isLoading]) {
        [self.processLine endLoadingAnimation];
    }
    
    __weak __typeof(self)weakSelf = self;
    [self evaluateJavaScript:@"document.title"
           completionHandler:^(NSString *_Nullable result, NSError * _Nullable error) {
               __strong __typeof(weakSelf)strongSelf = weakSelf;
               if (!error) {
                   strongSelf.navigationItem.title = result;
               }
           }];
    
    self.loaded = YES;
    
    for (int i = 0; i < [self.execQueue count]; i++) {
        NSDictionary *dict = [self.execQueue objectAtIndex:i];
        NSString *code = dict[@"code"];
        evalJavaScriptBlock handler = dict[@"handler"];

        [self evaluateJavaScript:code
               completionHandler:handler];
    }
    [self.execQueue removeAllObjects];
}

//网页加载错误
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSString *errorMsg = (NSString *)[[error userInfo] valueForKey:@"NSLocalizedDescription"];
    [self showErrorMessage:errorMsg];
    [self.processLine endLoadingAnimation];
}

@end
