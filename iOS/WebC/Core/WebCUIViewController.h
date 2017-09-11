//
//  WebCUIViewController.h
//  WebC
//
//  Created by Long Zhou on 2017/9/7.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebCWebview.h"

@interface WebCUIViewController : UIViewController<WKNavigationDelegate>

+ (instancetype)getInstance;

- (void)sendCommand:(NSString *)cmd data:(NSMutableDictionary *)data;

@end
