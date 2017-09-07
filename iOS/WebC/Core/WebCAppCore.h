//
//  WebCAppCore.h
//  WebC
//
//  Created by Long Zhou on 2017/9/6.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WebCAppCore : NSObject

// navigation bar
@property(nonatomic, strong) UINavigationController *navigation;

// 加载页面app.bundle.js
- (void)loadBundle:(NSString *)bundle;
// 启动App
- (void)launchApp;

@end
