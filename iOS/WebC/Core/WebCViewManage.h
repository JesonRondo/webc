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

- (WebCUIViewController *)newUIViewForKey:(NSString *)key;

@end
