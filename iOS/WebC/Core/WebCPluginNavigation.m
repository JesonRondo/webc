//
//  WebCPluginNavigation.m
//  WebC
//
//  Created by Long Zhou on 2017/9/7.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import "WebCPluginNavigation.h"

@implementation WebCPluginNavigation

- (void)registPluginWith:(WebCJSBridge *)bridge inContext:(JSContext *)context {
    // navigation.push
    [bridge registerMessage:@"navigation.pushWindow" forHandler:^(id data, JSValue *callback) {
        NSMutableDictionary *params = (NSMutableDictionary *)data;
        NSString *pageId = (NSString *)[params objectForKey:@"id"];
        
        NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
        [payload setObject:pageId forKey:@"pageId"];

        // 抛出事件
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WebCPushNewPageNotification"
                                                            object:payload];
    }];
}

@end
