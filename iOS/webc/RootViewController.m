//
//  RootViewController.m
//  webc
//
//  Created by Long Zhou on 2017/8/17.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import "RootViewController.h"
#import "ResourceManage.h"
#import "ContainerViewController.h"
#import "Logger.h"
#import <Masonry.h>
#import <Toast/UIView+Toast.h>

typedef enum {
    FE_ONLINE, PROXY_OFFLINE, FILE_OFFLINE,
    CLEAN
} ClickType;

@interface RootViewController ()

@property(nonatomic, strong) ContainerViewController *container;

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
        case FE_ONLINE:
            [btn addTarget:self
                    action:@selector(openFEOnline)
          forControlEvents:UIControlEventTouchUpInside];
            break;
            
        case PROXY_OFFLINE:
            [btn addTarget:self
                    action:@selector(openProxyOffline)
          forControlEvents:UIControlEventTouchDown];
            
            [btn addTarget:self
                    action:@selector(openIt)
          forControlEvents:UIControlEventTouchUpInside];
            break;
            
        case FILE_OFFLINE:
            [btn addTarget:self
                    action:@selector(openFileOffline)
          forControlEvents:UIControlEventTouchUpInside];
            break;
        
        case CLEAN:
            [btn addTarget:self
                    action:@selector(cleanCache)
          forControlEvents:UIControlEventTouchUpInside];
            break;
            
        default:
            break;
    }
}

- (void)addButton {
    // 直接打开
    [self putButton:@"前端渲染" offsetTo:-100 WithType:FE_ONLINE];
    [self putButton:@"代理离线" offsetTo:-25 WithType:PROXY_OFFLINE];
    [self putButton:@"文件离线" offsetTo:50 WithType:FILE_OFFLINE];
    // 清理缓存
    [self putButton:@"清理缓存" offsetTo:150 WithType:CLEAN];
}

- (void)openUrl:(NSString *)url {
    [[Logger shareInstance] time];

    self.container = [[ContainerViewController alloc] initWithUrl:url];
    [self.navigationController pushViewController:self.container animated:YES];
}


- (void)preOpenUrl:(NSString *)url {
    self.container = [[ContainerViewController alloc] initWithUrl:url];
}

- (void)openFEOnline {
    [self openUrl:@"http://172.17.37.51:3000/fe"];
}

- (void)openProxyOffline {
    [self preOpenUrl:@"http://172.17.37.51:3000/ssr?_speed=1"];
}

- (void)openIt {
    [[Logger shareInstance] time];
    
    if (self.container) {
        [self.navigationController pushViewController:self.container animated:YES];
        self.container = nil;
    }
}

- (void)openFileOffline {
    [self openUrl:@"test"];
    
//    NSURL *fileUrl = [[ResourceManage shareInstance] findFileResourceURLWithURL:[NSURL URLWithString:@"http://172.17.37.51:3000/ssr?_speed=1"]];
    
//    [self openUrl:[fileUrl absoluteString]];
}

- (void)cleanCache {
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    [fileManager removeItemAtPath:cachePath error:nil];
    [fileManager createDirectoryAtPath:cachePath
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];

    [self.view hideToasts];
    [self.view makeToast:@"缓存清除成功！"
                duration:1.5
                position:CSToastPositionCenter];
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
