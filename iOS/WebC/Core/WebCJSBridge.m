//
//  WebCJSBridge.m
//  WebC
//
//  Created by Long Zhou on 2017/9/7.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import "WebCJSBridge.h"

@interface WebCJSBridge()

@property (strong, nonatomic) NSMutableDictionary *pluginCallMap;

@end

@implementation WebCJSBridge

- (id)initBridgeForJSCore:(JSContext *)context {
    if (self = [super init]) {
        self.context = context;
        self.pluginCallMap = [[NSMutableDictionary alloc] init];
        [self registerHandle];
    }
    return self;
}

- (void)registerHandle {
    __weak __typeof(self)weakSelf = self;
    self.context[@"__webc_bridge_call"] = ^(NSString *cmd, id data, JSValue *callback) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        WebCJSBridgeMessage handle = [strongSelf.pluginCallMap objectForKey:cmd];
        if (handle) {
            handle(data, callback);
        }
    };
}

// 注册Native方法，等待JS调用
- (void)registerMessage:(NSString *)message forHandler:(WebCJSBridgeMessage)handle {
    [self.pluginCallMap setObject:handle forKey:message];
}

// 调用JS方法，等待回调
- (void)callHandler:(NSString *)cmd data:(id)data handle:(WebCJSBridgeCallback)callback {
    JSValue *jsMessageHandle = (JSValue *)self.context[@"__webc_bridge_handle"];
    
    NSMutableArray *args = [[NSMutableArray alloc] init];
    [args addObject:cmd];
    [args addObject:data];
    [args addObject:callback];
    
    [jsMessageHandle callWithArguments:args];
}

@end
