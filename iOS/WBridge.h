//
//  WBridge.h
//  webc
//
//  Created by Long Zhou on 2017/8/28.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContainerViewController.h"

@protocol WBridgeDelegate <NSObject>

- (ContainerViewController *)openViewWithName:(NSString *)name;

@end

@interface WBridge : NSObject

@property (nonatomic, weak) id <WBridgeDelegate> delegate;
- (id)call;

@end
