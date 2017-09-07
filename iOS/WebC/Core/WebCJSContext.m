//
//  WebCJSContext.m
//  WebC
//
//  Created by Long Zhou on 2017/9/6.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import "WebCJSContext.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface WebCJSContext ()

@property(strong, nonatomic) JSContext *context;

@end

@implementation WebCJSContext

- (id)init {
    if (self = [super init]) {
        self.context = [[JSContext alloc] init];

        [self initJSBridge];
        [self initFramework];
        [self initVue];
    }
    
    return self;
}

- (void)initJSBridge {

}

- (void)initFramework {
    self.context[@"window"] = self.context.globalObject;
    [self evaluateLocalScript:@"framework"];
}

- (void)initVue {
    [self evaluateLocalScript:@"vue"];
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

@end
