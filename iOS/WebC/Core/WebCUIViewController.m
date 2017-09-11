//
//  WebCUIViewController.m
//  WebC
//
//  Created by Long Zhou on 2017/9/7.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import "WebCUIViewController.h"
#import <Masonry.h>

@interface WebCUIViewController ()

@property (strong, nonatomic) WebCWebview *webview;

@end

@implementation WebCUIViewController

static WebCUIViewController *_backInstance = nil;

+ (void)load {
    _backInstance = [WebCUIViewController getInstance];
}

+ (instancetype)getInstance {
    WebCUIViewController *temp = _backInstance;
    _backInstance = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _backInstance = [[WebCUIViewController alloc] init];
    });
    
    if (!temp) {
        temp = [[WebCUIViewController alloc] init];
    }
    return temp;
}

- (id)init {
    if (self = [super init]) {
        self.webview = [[WebCWebview alloc] init];
        self.webview.view.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        self.webview.view.navigationDelegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.webview.view];
    CGRect frame = self.view.frame;
    self.webview.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
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

- (void)sendCommand:(NSString *)cmd data:(NSMutableDictionary *)data {
    NSString *strData = [self JSONStringifyForDict:data];
    
    [self.webview evaluateJavaScript:[NSString stringWithFormat:@"uiKit.handleCenter('%@', %@)", cmd, strData]
                   completionHandler:^(id result, NSError *error) {
                       if (error) {
                           NSLog(@"向view传递消息失败 >>> %@", error);
                       }
                   }];
}

- (NSString *)JSONStringifyForDict:(NSDictionary *)dict {
    if (dict == nil) {
        return @"{}";
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:(NSJSONWritingOptions)0
                                                         error:&error];
    
    if (!jsonData) {
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

#pragma mark - WKWebview delegate

// 网页加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    __weak __typeof(self)weakSelf = self;
    [self.webview evaluateJavaScript:@"document.title"
           completionHandler:^(NSString *_Nullable result, NSError * _Nullable error) {
               __strong __typeof(weakSelf)strongSelf = weakSelf;
               if (!error) {
                   strongSelf.navigationItem.title = result;
               }
           }];
    
    [self.webview envReady];
}

// 网页加载错误
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSString *errorMsg = (NSString *)[[error userInfo] valueForKey:@"NSLocalizedDescription"];
    [self showErrorMessage:errorMsg];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
