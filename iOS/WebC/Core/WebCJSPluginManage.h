//
//  WebCJSPluginManage.h
//  WebC
//
//  Created by Long Zhou on 2017/9/7.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebCJSBridge.h"

@interface WebCJSPluginManage : NSObject

- (id)initWithBridge:(WebCJSBridge *)bridge;

// 加载所有插件
- (void)loadPlugins;

@end
