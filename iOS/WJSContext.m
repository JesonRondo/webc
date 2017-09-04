//
//  WJSContext.m
//  webc
//
//  Created by Long Zhou on 2017/8/28.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import "WJSContext.h"
#import "WTimer.h"
#import "WBridge.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface WJSContext ()

@property(strong, nonatomic) JSContext *context;

@end

@implementation WJSContext

- (id)init {
    self = [super init];

    self.context = [[JSContext alloc] init];

    [self initExceptionCatcher];
    [self initContext];
    [self initFramework];
    
    return self;
}

- (void)initExceptionCatcher {
    self.context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        [JSContext currentContext].exception = exception;
        NSLog(@"exception: %@", exception);
    };
}

- (void)initContext {
    _context[@"window"] = _context.globalObject;
    
    WTimer *timer= [[WTimer alloc] init];
    _context[@"setTimeout"] = [timer setTimeout];
    _context[@"clearTimeout"] = [timer clearTimeout];
    _context[@"setInterval"] = [timer setInterval];
    _context[@"clearInterval"] = [timer clearInterval];
    
    WBridge *bridge = [[WBridge alloc] init];
    bridge.delegate = self;
    self.context[@"__bridge"] = @{
                                  @"call": [bridge call]
                                  };
}

- (void)initFramework {
    NSString *frameworkPath = [[NSBundle mainBundle] pathForResource:@"framework" ofType:@"js"];
    NSString *frameworkCnt = [[NSString alloc] initWithContentsOfFile:frameworkPath
                                                             encoding:NSUTF8StringEncoding
                                                                error:nil];

    [self.context evaluateScript:frameworkCnt];
}

- (void)evaluateScript:(NSString *)content withSourceURL:(NSURL *)url {
    [self.context evaluateScript:content withSourceURL:url];
}

// delegate
- (ContainerViewController *)openViewWithName:(NSString *)name {
    if ([self.delegate respondsToSelector:@selector(openViewWithName:)]) {
        return [self.delegate openViewWithName:name];
    }
    return nil;
}

- (JSContext *)coreContext {
    return self.context;
}

@end
