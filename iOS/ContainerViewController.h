//
//  ContainerViewController.h
//  webc
//
//  Created by Long Zhou on 2017/8/21.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContainerViewController : UIViewController<UIWebViewDelegate>

- (id)initWithUrl:(NSString *)url;

@end
