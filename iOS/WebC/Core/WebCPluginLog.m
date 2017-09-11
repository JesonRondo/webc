//
//  WebCPluginLog.m
//  WebC
//
//  Created by Long Zhou on 2017/9/7.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import "WebCPluginLog.h"

@implementation WebCPluginLog

- (void)registPluginWith:(WebCJSBridge *)bridge {
    // log func
    [bridge registerMessage:@"log" forHandler:^(id data, NSNumber *callbackId) {
        NSString *msg = (NSString *)data;
        NSLog(@"log >>> %@", msg);

        [bridge callHandlerWithData:nil error:nil handle:callbackId];
    }];
}

@end
