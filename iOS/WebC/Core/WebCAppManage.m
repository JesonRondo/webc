//
//  WebCAppManage.m
//  WebC
//
//  Created by Long Zhou on 2017/9/6.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import "WebCAppManage.h"
#import "WebCAppCore.h"

@interface WebCAppManage ()

@property(nonatomic, strong) NSMutableDictionary *pool;

@end

@implementation WebCAppManage

static WebCAppManage *_instance = nil;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (id)init {
    if (self = [super init]) {
        self.pool = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)launchAppKeyName:(NSString *)name withBundle:(NSString *)bundle {
    WebCAppCore *appCore = [self.pool objectForKey:name];
    
    if (!appCore) {
        appCore = [[WebCAppCore alloc] init];
        appCore.navigation = self.navigation;
        [appCore loadBundle:bundle];

        [self.pool setObject:appCore forKey:name];
    }
    
    [appCore launchApp];
}

@end
