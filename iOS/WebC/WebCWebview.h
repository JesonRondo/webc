//
//  WebCWebview.h
//  WebC
//
//  Created by Long Zhou on 2017/9/7.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

typedef void (^evalJavaScriptBlock)(id, NSError *error);

@interface WebCWebview : NSObject

@property (strong, nonatomic) WKWebView *view;

// 设置html是否加载完毕
- (void)envReady;
// 执行脚本代码
- (void)evaluateJavaScript:(NSString *)code completionHandler:(evalJavaScriptBlock)completionHandler;

@end
