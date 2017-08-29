//
//  LiteAppPool.h
//  webc
//
//  Created by Long Zhou on 2017/8/29.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LiteAppPool : NSObject

+ (instancetype)shareInstance;

- (void)setNavigation:(UINavigationController *)nav;
- (void)launchAppKeyName:(NSString *)name withBundle:(NSString *)bundle;

@end
