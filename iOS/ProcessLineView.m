//
//  ProcessLineView.m
//  webc
//
//  Created by Long Zhou on 2017/8/22.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import "ProcessLineView.h"

@interface ProcessLineView()

@property (nonatomic) CGRect originFrame;

@end


@implementation ProcessLineView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.originFrame = frame;
        self.hidden = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    self.backgroundColor = lineColor;
}

- (void)startLoadingAnimation {
    self.hidden = NO;
    self.frame = CGRectMake(
                            self.originFrame.origin.x,
                            self.originFrame.origin.y,
                            0.0,
                            self.originFrame.size.height);
    
    __weak UIView *weakSelf = self;
    [UIView animateWithDuration:0.4 animations:^{
        weakSelf.frame = CGRectMake(
                                    self.originFrame.origin.x,
                                    self.originFrame.origin.y,
                                    self.originFrame.size.width * 0.6,
                                    self.originFrame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            weakSelf.frame = CGRectMake(
                                        self.originFrame.origin.x,
                                        self.originFrame.origin.y,
                                        self.originFrame.size.width * 0.8,
                                        self.originFrame.size.height);
        }];
    }];
}

- (void)endLoadingAnimation{
    __weak UIView *weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.frame = CGRectMake(
                                    self.originFrame.origin.x,
                                    self.originFrame.origin.y,
                                    self.originFrame.size.width,
                                    self.originFrame.size.height);
    } completion:^(BOOL finished) {
        weakSelf.hidden = YES;
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
