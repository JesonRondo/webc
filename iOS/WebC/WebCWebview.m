//
//  WebCWebview.m
//  WebC
//
//  Created by Long Zhou on 2017/9/7.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import "WebCWebview.h"
#import "WebCJSBridge.h"

@interface WebCWebview()

@property(strong, nonatomic) WebCJSBridge *bridge;

@property Boolean isEnvReady;
@property(strong, nonatomic) NSMutableArray *execQueue;

@end

@implementation WebCWebview

- (id)init {
    if (self = [super init]) {
        self.isEnvReady = NO;
        self.execQueue = [[NSMutableArray alloc] init];

        self.view = [[WKWebView alloc] init];
        
        [self initViewHTML];
        [self initJSBridge];
        [self initViewJS];
    }
    return self;
}

- (void)initViewHTML {
    NSURL *viewURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"view"
                                                                            ofType:@"html"]];
    NSString *viewHTMLContent = [self contentsOfFile:@"view" ofType:@"html"];
    [self.view loadHTMLString:viewHTMLContent baseURL:viewURL];
}

- (void)initJSBridge {
    self.bridge = [[WebCJSBridge alloc] initBridgeForWKWebview:self.view];
    
    NSString *bridgeJSContent = [self contentsOfFile:@"jsbridge" ofType:@"js"];
    [self evaluateJavaScript:bridgeJSContent completionHandler:^(id result, NSError *error) {
        if (error) {
            NSLog(@"jsbridge.js eval error >>> %@", error);
        }
    }];
}

- (void)initViewJS {
    NSString *viewJSContent = [self contentsOfFile:@"view" ofType:@"js"];
    [self evaluateJavaScript:viewJSContent completionHandler:^(id result, NSError *error) {
        if (error) {
            NSLog(@"view.js eval error >>> %@", error);
        }
    }];
}

- (NSString *)contentsOfFile:(NSString *)file ofType:(NSString *)type {
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:type];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSString *content = [NSString stringWithContentsOfURL:url
                                                 encoding:NSUTF8StringEncoding
                                                    error:nil];
    return content;
}

- (void)envReady {
    self.isEnvReady = YES;
    
    // 处理队列里的未执行脚本
    for (int i = 0; i < [self.execQueue count]; i++) {
        NSDictionary *dict = [self.execQueue objectAtIndex:i];
        NSString *code = dict[@"code"];
        evalJavaScriptBlock handler = dict[@"handler"];
        
        [self evaluateJavaScript:code
               completionHandler:handler];
    }
    
    [self.execQueue removeAllObjects];
}

- (void)evaluateJavaScript:(NSString *)code completionHandler:(evalJavaScriptBlock)completionHandler {
    if (!self.isEnvReady) {
        [self.execQueue addObject:@{
                                    @"code": code,
                                    @"handler": completionHandler
                                    }];
    } else {
        [self.view evaluateJavaScript:code
                    completionHandler:^(id result, NSError * _Nullable error) {
                        if (completionHandler) {
                            completionHandler(result, error);
                        }
                    }];
    }
}

@end
