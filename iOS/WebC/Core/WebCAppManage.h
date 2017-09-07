//
//  WebCAppManage.h
//  WebC
//
//  Created by Long Zhou on 2017/9/6.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WebCAppManage : NSObject

+ (instancetype)shareInstance;

// navigation bar
@property(nonatomic, strong) UINavigationController *navigation;
// 加载一个App
- (void)launchAppKeyName:(NSString *)name withBundle:(NSString *)bundle;

@end
