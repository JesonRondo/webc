//
//  WebCViewManage.m
//  WebC
//
//  Created by Long Zhou on 2017/9/7.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import "WebCViewManage.h"

@interface WebCViewManage()

@property (strong, nonatomic) NSMutableDictionary *viewMap;

@end

@implementation WebCViewManage

- (id)init {
    if (self = [super init]) {
        self.viewMap = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (WebCUIViewController *)newUIViewForKey:(NSNumber *)key {
    WebCUIViewController *vc = [WebCUIViewController getInstance];
    [self.viewMap setObject:vc forKey:key];

    return vc;
}

- (void)sendUIViewMessageToTarget:(NSNumber *)key command:(NSString *)cmd data:(NSMutableDictionary *)data {
    WebCUIViewController *vc = [self.viewMap objectForKey:key];
    [vc sendCommand:cmd data:data];
}

@end
