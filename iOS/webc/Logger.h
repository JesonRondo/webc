//
//  Logger.h
//  webc
//
//  Created by Long Zhou on 2017/8/21.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Logger : NSObject

+ (instancetype)shareInstance;

- (void)time;
- (void)timeEnd;
- (void)printTimestamp;
- (void)printTimestamp:(NSString *)msg;

@end
