//
//  WebCJSContext.h
//  WebC
//
//  Created by Long Zhou on 2017/9/6.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebCJSContext : NSObject

// 环境铺垫完毕（直到app.bundle执行结束时，手动调用标示一下）
- (void)envReady;

- (void)evaluateScript:(NSString *)content withSourceURL:(NSURL *)url;
- (void)evaluateScriptAfterReady:(NSString *)content;

@end
