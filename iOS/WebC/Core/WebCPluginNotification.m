//
//  WebCPluginNotification.m
//  WebC
//
//  Created by Long Zhou on 2017/9/8.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import "WebCPluginNotification.h"

@implementation WebCPluginNotification

- (void)registPluginWith:(WebCJSBridge *)bridge {
    [bridge registerMessage:@"notification.toView" forHandler:^(id data, NSNumber *callbackId) {
        NSMutableDictionary *obj = (NSMutableDictionary *)data;
        
        NSString *cmd = [obj objectForKey:@"cmd"];
        NSNumber *targetId = [obj objectForKey:@"id"];
        NSMutableDictionary *ret = [obj objectForKey:@"data"];
        
        if (cmd == nil) {
            [bridge callHandlerWithData:nil error:@"bridge err: no send command" handle:callbackId];
            return;
        }

        if (targetId == nil) {
            [bridge callHandlerWithData:nil error:@"bridge err: no send target" handle:callbackId];
            return;
        }
        
        NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
        [payload setObject:cmd forKey:@"cmd"];
        [payload setObject:targetId forKey:@"targetId"];
        [payload setObject:ret forKey:@"data"];
        
        // 抛出事件給Core处理
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WebCSendMsgToPageNotification"
                                                            object:payload];
    }];
}

@end
