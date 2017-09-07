//
//  WebCJSPluginManage.m
//  WebC
//
//  Created by Long Zhou on 2017/9/7.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import "WebCJSPluginManage.h"
#import "WebCPlugin.h"

#import "WebCPluginLog.h"
#import "WebCPluginNavigation.h"

@interface WebCJSPluginManage()

@property (strong, nonatomic) WebCJSBridge *bridge;
@property (strong, nonatomic) JSContext *context;

@end

@implementation WebCJSPluginManage

- (id)initWithBridge:(WebCJSBridge *)bridge {
    if (self = [super init]) {
        self.bridge = bridge;
        self.context = [bridge context];
    }
    
    return self;
}

- (void)loadPlugins {
    WebCPluginLog *pluginLog = [[WebCPluginLog alloc] init];
    [pluginLog registPluginWith:self.bridge inContext:self.context];
    
    WebCPluginNavigation *pluginNaviagtion = [[WebCPluginNavigation alloc] init];
    [pluginNaviagtion registPluginWith:self.bridge inContext:self.context];
}

@end
