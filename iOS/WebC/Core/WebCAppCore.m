//
//  WebCAppCore.m
//  WebC
//
//  Created by Long Zhou on 2017/9/6.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import "WebCAppCore.h"
#import "WebCJSContext.h"
#import "WebCNetwork.h"
#import "WebCViewManage.h"

@interface WebCAppCore ()

@property(strong, nonatomic) WebCJSContext *context;
@property(strong, nonatomic) WebCViewManage *viewManage;

@end

@implementation WebCAppCore

- (id)init {
    if (self = [super init]) {
        self.context = [[WebCJSContext alloc] init];
        self.viewManage = [[WebCViewManage alloc] init];

        [self handleNotification];
    }
    return self;
}

- (void)loadBundle:(NSString *)bundle {
    WebCNetwork *request = [WebCNetwork shareInstance];
    
    __weak __typeof(self)weakSelf = self;
    [request GetScript:bundle
                handle:^(NSError *err, NSString *cnt) {
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    if (err) {
                        NSLog(@"下载脚本文件失败，错误信息: %@", err);
                    } else {
                        [strongSelf.context evaluateScript:cnt
                                             withSourceURL:[NSURL URLWithString:bundle]];
                        // 环境准备完毕
                        [strongSelf.context envReady];
                    }
                }];
}

- (void)launchApp {
    //TODO 这里加个loading界面？
    [self.context evaluateScriptAfterReady:@"webc.appStart()"];
}

- (void)handleNotification {
    // 监听push新开页面消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pushNewPageNotificationAction:) name:@"WebCPushNewPageNotification"
                                               object:nil];
}

// 打开新页面
- (void)pushNewPageNotificationAction:(NSNotification *)notification {
    NSMutableDictionary *payload = notification.object;
    NSLog(@"收到通知 %@", payload);

    NSString *pageId = (NSString *)[payload objectForKey:@"pageId"];
    
    WebCUIViewController *vc = [self.viewManage newUIViewForKey:pageId];
    [self.navigation pushViewController:vc animated:YES];
}

@end
