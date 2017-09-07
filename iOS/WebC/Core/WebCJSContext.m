//
//  WebCJSContext.m
//  WebC
//
//  Created by Long Zhou on 2017/9/6.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import "WebCJSContext.h"
#import "WebCJSBridge.h"
#import "WebCJSPluginManage.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface WebCJSContext ()

@property(strong, nonatomic) JSContext *context;
@property(strong, nonatomic) WebCJSBridge *bridge;
@property(strong, nonatomic) NSMutableArray *execQueue;
@property Boolean isEnvReady;

@end

@implementation WebCJSContext

- (id)init {
    if (self = [super init]) {
        self.context = [[JSContext alloc] init];
        self.execQueue = [[NSMutableArray alloc] init];
        self.isEnvReady = NO;

        [self initJSBridge];
        [self initFramework];
        [self initVue];
    }
    
    return self;
}

- (void)initJSBridge {
    [self evaluateLocalScript:@"jsbridge"];
    self.bridge = [[WebCJSBridge alloc] initBridgeForJSCore:self.context];

    WebCJSPluginManage *pluginManager = [[WebCJSPluginManage alloc] initWithBridge:self.bridge];
    [pluginManager loadPlugins];
}

- (void)initFramework {
    self.context[@"window"] = self.context.globalObject;
    [self evaluateLocalScript:@"framework"];
}

- (void)initVue {
    [self evaluateLocalScript:@"vue"];
}

- (void)envReady {
    self.isEnvReady = YES;
    
    // 处理队列里的未执行脚本
    for (int i = 0; i < [self.execQueue count]; i++) {
        NSString *scriptContent = [self.execQueue objectAtIndex:i];
        [self evaluateScript:scriptContent];
    }

    [self.execQueue removeAllObjects];
}

- (void)evaluateLocalScript:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"js"];
    NSString *cnt = [[NSString alloc] initWithContentsOfFile:path
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    [self evaluateScript:cnt];
}

- (void)evaluateScript:(NSString *)content {
    [self.context evaluateScript:content];
}

- (void)evaluateScript:(NSString *)content withSourceURL:(NSURL *)url {
    [self.context evaluateScript:content withSourceURL:url];
}

- (void)evaluateScriptAfterReady:(NSString *)content {
    if (_isEnvReady) {
        [self evaluateScript:content];
    } else {
        [self.execQueue addObject:content];
    }
}

@end
