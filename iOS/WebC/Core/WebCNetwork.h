//
//  WebCNetwork.h
//  WebC
//
//  Created by Long Zhou on 2017/9/7.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import "WebCPlugin.h"

@interface WebCNetwork : WebCPlugin

+ (instancetype)shareInstance;

// 发送GET请求获取脚本
- (void)GetScript:(NSString *)url handle:(void (^)(NSError *error, NSString *content))callback;

@end
