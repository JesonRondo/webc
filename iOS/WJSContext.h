//
//  WJSContext.h
//  webc
//
//  Created by Long Zhou on 2017/8/28.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import "WBridge.h"
#import <Foundation/Foundation.h>
#import "ContainerViewController.h"

@protocol WJSContextDelegate <NSObject>

- (ContainerViewController *)openViewWithName:(NSString *)name;

@end

@interface WJSContext : NSObject <WBridgeDelegate>

@property (nonatomic, weak) id <WJSContextDelegate> delegate;
- (void)evaluateScript:(NSString *)content withSourceURL:(NSURL *)url;

@end
