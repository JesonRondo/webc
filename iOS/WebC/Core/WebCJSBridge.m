//
//  WebCJSBridge.m
//  WebC
//
//  Created by Long Zhou on 2017/9/7.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import "WebCJSBridge.h"

typedef enum {
    JSCoreContext,
    WKWebViewContext
} ContextType;

@interface WebCJSBridge()

@property ContextType contextType;
@property(strong, nonatomic) NSMutableDictionary *pluginCallMap;

@end

@implementation WebCJSBridge

- (id)initBridgeForJSCore:(JSContext *)context {
    if (self = [super init]) {
        self.contextType = JSCoreContext;
        self.context = context;
        self.pluginCallMap = [[NSMutableDictionary alloc] init];
        [self registerHandle];
    }
    return self;
}

- (id)initBridgeForWKWebview:(WKWebView *)webview {
    if (self = [super init]) {
        self.contextType = WKWebViewContext;
        self.wkWebview = webview;
        self.pluginCallMap = [[NSMutableDictionary alloc] init];
        [self registerHandle];
    }
    return self;
}

- (void)registerHandle {
    if (self.contextType == JSCoreContext) {
        __weak __typeof(self)weakSelf = self;
        self.context[@"__webc_bridge_call"] = ^(NSString *cmd, id data, NSNumber *callbackId) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            [strongSelf callPlugin:cmd
                              data:data
                          callback:callbackId];
        };
    } else if (self.contextType == WKWebViewContext) {
        WKUserContentController *controller = self.wkWebview.configuration.userContentController;
        [controller addScriptMessageHandler:self name:@"__webc_bridge_call"];
    }
}

// 在WK中JS调用方法处理
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"__webc_bridge_call"]) {
        NSMutableDictionary *body = (NSMutableDictionary *)message.body;
        NSString *cmd = [body objectForKey:@"cmd"];
        id data = [body objectForKey:@"data"];
        NSNumber *callbackId = [body objectForKey:@"callback"];

        [self callPlugin:cmd
                    data:data
                callback:callbackId];
    }
}

- (void)callPlugin:(NSString *)cmd data:(id)data callback:(NSNumber *)callbackId {
    WebCJSBridgeMessage handle = [self.pluginCallMap objectForKey:cmd];
    if (handle) {
        handle(data, callbackId);
    }
}

// 注册Native方法，等待JS调用
- (void)registerMessage:(NSString *)message forHandler:(WebCJSBridgeMessage)handle {
    [self.pluginCallMap setObject:handle forKey:message];
}

// 回调JS方法（data为nil或NSMutableDictionary, error为nil或NSString）
- (void)callHandlerWithData:(NSMutableDictionary *)data error:(NSString *)err handle:(NSNumber *)callbackId {
    if (data == nil) {
        data = [[NSMutableDictionary alloc] init];
    }
    
    if (self.contextType == JSCoreContext) {
        JSValue *jsMessageHandle = (JSValue *)self.context[@"__webc_bridge_handle"];
        NSMutableArray *args = [[NSMutableArray alloc] init];

        [args addObject:data];

        if (err) {
            [args addObject:err];
        } else {
            [args addObject:[JSValue valueWithUndefinedInContext:self.context]];
        }
        
        [args addObject:callbackId];
        
        [jsMessageHandle callWithArguments:args];
    } else if (self.contextType == WKWebViewContext) {
        NSString *retData = [self JSONStringifyForDict:data];
        
        NSString *retError;
        if (err) {
            retError = [NSString stringWithFormat:@"'%@'", (NSString *)err];
        } else {
            retError = @"undefined";
        }
        
        NSString *retCallbackId = [callbackId stringValue];
        
        [self.wkWebview evaluateJavaScript:[NSString stringWithFormat:@"__webc_bridge_handle(%@,%@,%@)", retData, retError, retCallbackId]
                         completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                             if (error) {
                                 NSLog(@"bridge callback error %@", error);
                             }
                         }];
    }
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

@end
