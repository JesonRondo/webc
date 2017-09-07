//
//  WebCJSBridge.h
//  WebC
//
//  Created by Long Zhou on 2017/9/7.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

typedef void (^WebCJSBridgeMessage)(id data, JSValue *callback);
typedef void (^WebCJSBridgeCallback)(id err, id response);

@interface WebCJSBridge : NSObject

@property (strong, nonatomic) JSContext *context;

- (id)initBridgeForJSCore:(JSContext *)context;

// 注册Native方法，等待JS调用
- (void)registerMessage:(NSString *)message forHandler:(WebCJSBridgeMessage)handle;
// 调用JS方法，等待回调
- (void)callHandler:(NSString *)cmd data:(id)data handle:(WebCJSBridgeCallback)callback;

@end
