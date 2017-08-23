//
//  ResourceManage.h
//  webc
//
//  Created by Long Zhou on 2017/8/22.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResourceManage : NSObject

+ (instancetype)shareInstance;

- (void)loadResources;
- (NSURL *)findResourceURLWithURL:(NSURL *)onlineURL;

@end
