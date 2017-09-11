//
//  WebCPluginNavigation.m
//  WebC
//
//  Created by Long Zhou on 2017/9/7.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import "WebCPluginNavigation.h"

@implementation WebCPluginNavigation

- (void)registPluginWith:(WebCJSBridge *)bridge {
    // navigation.push
    [bridge registerMessage:@"navigation.pushWindow" forHandler:^(id data, NSNumber *callbackId) {
        NSMutableDictionary *params = (NSMutableDictionary *)data;
        NSNumber *pageId = (NSNumber *)[params objectForKey:@"id"];
        
        NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
        [payload setObject:pageId forKey:@"pageId"];

        // 抛出事件給Core处理
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WebCPushNewPageNotification"
                                                            object:payload];
        
        // 回调給JS
        [bridge callHandlerWithData:nil error:nil handle:callbackId];
    }];
}

@end
