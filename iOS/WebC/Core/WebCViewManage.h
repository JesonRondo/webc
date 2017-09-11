//
//  WebCViewManage.h
//  WebC
//
//  Created by Long Zhou on 2017/9/7.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebCUIViewController.h"

@interface WebCViewManage : NSObject

// 新创建一个View
- (WebCUIViewController *)newUIViewForKey:(NSNumber *)key;
// 向指定View发送消息
- (void)sendUIViewMessageToTarget:(NSNumber *)key command:(NSString *)cmd data:(NSDictionary *)data;

@end
