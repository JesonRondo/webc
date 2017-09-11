//
//  WebCJSBridge.h
//  WebC
//
//  Created by Long Zhou on 2017/9/7.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>

typedef void (^WebCJSBridgeMessage)(id data, NSNumber *callbackId);

@interface WebCJSBridge : NSObject<WKScriptMessageHandler>

@property (strong, nonatomic) JSContext *context;
@property (strong, nonatomic) WKWebView *wkWebview;

- (id)initBridgeForJSCore:(JSContext *)context;
- (id)initBridgeForWKWebview:(WKWebView *)webview;

// 注册Native方法，等待JS调用
- (void)registerMessage:(NSString *)message forHandler:(WebCJSBridgeMessage)handle;
// 调用JS方法，等待回调
- (void)callHandlerWithData:(NSMutableDictionary *)data error:(NSString *)err handle:(NSNumber *)callbackId;

@end
