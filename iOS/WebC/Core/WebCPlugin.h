//
//  WebCPlugin.h
//  WebC
//
//  Created by Long Zhou on 2017/9/7.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "WebCJSBridge.h"

@protocol WebCPluginProtocol <NSObject>

@required

- (void)registPluginWith:(WebCJSBridge *)bridge;

@end

@interface WebCPlugin : NSObject <WebCPluginProtocol>

@end
