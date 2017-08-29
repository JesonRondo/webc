//
//  LiteAppPool.m
//  webc
//
//  Created by Long Zhou on 2017/8/29.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import "LiteAppPool.h"
#import "MainContainer.h"

@interface LiteAppPool ()

@property(nonatomic, strong) UINavigationController *nav;
@property(nonatomic, strong) NSMutableDictionary *pool;

@end

@implementation LiteAppPool

static LiteAppPool *_instance = nil;

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

- (void)setNavigation:(UINavigationController *)nav {
    self.nav = nav;
}

- (void)launchAppKeyName:(NSString *)name withBundle:(NSString *)bundle {
    MainContainer *container = [self.pool objectForKey:name];
    
    if (!container) {
        container = [[MainContainer alloc] initWithBundle:bundle andNavigation:self.nav];
        [self.pool setObject:container forKey:name];
    }

    [container loadLiteApp];
}

@end
