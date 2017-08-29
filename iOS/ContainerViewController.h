//
//  ContainerViewController.h
//  webc
//
//  Created by Long Zhou on 2017/8/21.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

typedef void (^evalJavaScriptBlock)(id, NSError *error);

@interface ContainerViewController : UIViewController<WKNavigationDelegate>

- (id)initWithName:(NSString *)name;
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(evalJavaScriptBlock)completionHandler;

@end
