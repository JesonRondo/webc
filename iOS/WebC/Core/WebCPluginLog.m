//
//  WebCPluginLog.m
//  WebC
//
//  Created by Long Zhou on 2017/9/7.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import "WebCPluginLog.h"

@interface WebCPlugin()

@end

@implementation WebCPluginLog

- (void)registPluginWith:(WebCJSBridge *)bridge withContext:(JSContext *)context {
    // log func
    [bridge registerMessage:@"log" forHandler:^(id data, JSValue *callback) {
        NSString *msg = (NSString *)data;
        NSLog(@"log >>> %@", msg);
        
        NSMutableArray *args = [[NSMutableArray alloc] init];
        [args addObject:[JSValue valueWithUndefinedInContext:context]];
        [callback callWithArguments:args];
    }];
}

@end
