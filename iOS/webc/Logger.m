//
//  Logger.m
//  webc
//
//  Created by Long Zhou on 2017/8/21.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import "Logger.h"

@implementation Logger

static Logger *_instance = nil;
static double cacheTimestamp = -1;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });

    return _instance;
}

- (void)time {
    cacheTimestamp = [self currentTimestamp];
}

- (void)timeEnd {
    if (cacheTimestamp > 0) {
        double nowTimestamp = [self currentTimestamp];
        NSLog(@"花费时间 %f ms", (nowTimestamp - cacheTimestamp));
        cacheTimestamp = -1;
    }
}

- (void)printTimestamp {
    NSLog(@">> current: %.0f", [self currentTimestamp]);
}

- (void)printTimestamp:(NSString *)msg {
    NSLog(@">> %@ %.0f", msg, [self currentTimestamp]);
}

- (double)currentTimestamp {
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    return [dat timeIntervalSince1970] * 1000;
}

@end
