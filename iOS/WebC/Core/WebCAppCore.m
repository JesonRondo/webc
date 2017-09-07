//
//  WebCAppCore.m
//  WebC
//
//  Created by Long Zhou on 2017/9/6.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import "WebCAppCore.h"
#import "WebCJSContext.h"
#import <AFNetworking.h>

@interface WebCAppCore ()

@property(strong, nonatomic) NSString *appBundleJS;
@property(strong, nonatomic) WebCJSContext *context;

@end

@implementation WebCAppCore

- (id)init {
    if (self = [super init]) {
        self.context = [[WebCJSContext alloc] init];
    }
    
    return self;
}

- (void)loadBundle:(NSString *)bundle {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    AFHTTPResponseSerializer *serializer = [[AFHTTPResponseSerializer alloc] init];
    serializer.acceptableContentTypes = [serializer.acceptableContentTypes setByAddingObject:@"text/javascript"];
    
    manager.responseSerializer = serializer;
    
    NSURL *URL = [NSURL URLWithString:bundle];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    __weak __typeof(self)weakSelf = self;
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSString *str = [[NSString alloc] initWithData:responseObject
                                                  encoding:NSUTF8StringEncoding];
            [strongSelf.context evaluateScript:str
                                 withSourceURL:[NSURL URLWithString:bundle]];
        }
    }];
    [dataTask resume];
}

- (void)launchApp {

}

@end
