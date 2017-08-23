//
//  ProcessLineView.h
//  webc
//
//  Created by Long Zhou on 2017/8/22.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProcessLineView : UIView

//进度条颜色
@property (nonatomic, strong) UIColor *lineColor;

//开始加载
- (void)startLoadingAnimation;

//结束加载
- (void)endLoadingAnimation;

@end
