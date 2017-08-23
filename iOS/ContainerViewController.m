//
//  ContainerViewController.m
//  webc
//
//  Created by Long Zhou on 2017/8/21.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import "ContainerViewController.h"
#import "ResourceManage.h"
#import "ProcessLineView.h"
#import "Logger.h"
#import <Masonry.h>

@interface ContainerViewController ()
{
    NSURLConnection *theConnection;
}
@property(strong, nonatomic) NSString *url;
@property(strong, nonatomic) UIWebView *webview;
@property(strong, nonatomic) ProcessLineView *processLine;

@end

@implementation ContainerViewController

- (id)initWithUrl:(NSString *)url {
    if (self) {
        self = [super init];
        self.webview = [[UIWebView alloc] init];
    }
    
    self.url = url;

    NSURL *originUrl = [NSURL URLWithString:self.url];
    
    NSLog(@"%@", originUrl);
    NSURL *resUrl = [[ResourceManage shareInstance] findResourceURLWithURL:originUrl];
    NSLog(@"%@", resUrl);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:resUrl
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:15];
    [self.webview loadRequest:request];

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[Logger shareInstance] time];
    self.navigationItem.title = @"Webview";
    [self.view setBackgroundColor:[UIColor whiteColor]];

    self.webview.frame = self.view.bounds;
    self.webview.delegate = self;
    self.webview.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    [self.view addSubview:self.webview];
    
    CGRect processLineFrame = CGRectMake(
                                         0,
                                         [[UIApplication sharedApplication] statusBarFrame].size.height +
                                         self.navigationController.navigationBar.frame.size.height,
                                         self.view.frame.size.width,
                                         3);
    self.processLine = [[ProcessLineView alloc] initWithFrame:processLineFrame];
    self.processLine.lineColor = [UIColor redColor];
    [self.view addSubview:self.processLine];

    [[Logger shareInstance] timeEnd];
    // Do any additional setup after loading the view.
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
        [[Logger shareInstance] timeEnd];
    }
}
//网页加载错误
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSString *errorMsg = (NSString *)[[error userInfo] valueForKey:@"NSLocalizedDescription"];
    [self showErrorMessage:errorMsg];
    [self.processLine endLoadingAnimation];
}

@end
