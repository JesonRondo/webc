//
//  MainContainer.h
//  webc
//
//  Created by Long Zhou on 2017/8/28.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WJSContext.h"

@interface MainContainer : NSObject <WJSContextDelegate>

- (id)initWithBundle:(NSString *)bundle andNavigation:(UINavigationController *)nav;
- (void)loadLiteApp;

@end
