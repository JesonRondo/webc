//
//  RootViewController.m
//  webc
//
//  Created by Long Zhou on 2017/8/17.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import "RootViewController.h"
#import "ResourceManage.h"
#import "LiteAppPool.h"
#import "Logger.h"
#import <Masonry.h>
#import <Toast/UIView+Toast.h>

typedef enum {
    OPEN_LITE_APP
} ClickType;

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"WebC";
    [self addButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)putButton:(NSString *)title offsetTo:(CGFloat)offset WithType:(ClickType)type {
    UIButton *btn = [[UIButton alloc] init];

    [btn setTitle:title forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];

    [btn setBackgroundImage:[self imageWithColor:[UIColor orangeColor]]
                   forState:UIControlStateNormal];
    [btn setBackgroundImage:[self imageWithColor:[UIColor darkGrayColor]]
                   forState:UIControlStateHighlighted];
    
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(36);
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(offset);
    }];
    
    switch (type) {
        case OPEN_LITE_APP:
            [btn addTarget:self
                    action:@selector(openLiteApp)
          forControlEvents:UIControlEventTouchUpInside];
            break;
            
        default:
            break;
    }
}

- (void)addButton {
    // 打开应用
    [self putButton:@"打开应用" offsetTo:0 WithType:OPEN_LITE_APP];
}

- (void)openLiteApp {
    [[Logger shareInstance] time];
    
    [[LiteAppPool shareInstance] setNavigation:self.navigationController];
    [[LiteAppPool shareInstance] launchAppKeyName:@"douban"
                                       withBundle:@"http://172.17.37.51:8080/app.js"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
