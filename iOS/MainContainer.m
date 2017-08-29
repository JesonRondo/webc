//
//  MainContainer.m
//  webc
//
//  Created by Long Zhou on 2017/8/28.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import "MainContainer.h"
#import "ContainerViewController.h"
#import "WJSContext.h"
#import <AFNetworking.h>

@interface MainContainer ()

@property(strong, nonatomic) NSString *appBundleJS;
@property(strong, nonatomic) WJSContext *context;
@property(strong, nonatomic) UINavigationController *nav;

@end

@implementation MainContainer

- (id)initWithBundle:(NSString *)bundle andNavigation:(UINavigationController *)nav {
    if (self = [super init]) {
        self.appBundleJS = bundle;
        self.nav = nav;
        self.context = [[WJSContext alloc] init];
        self.context.delegate = self;
    }
    return self;
}

//TODO vue 和 new vue拆开
- (void)loadLiteApp {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    AFHTTPResponseSerializer *serializer = [[AFHTTPResponseSerializer alloc] init];
    serializer.acceptableContentTypes = [serializer.acceptableContentTypes setByAddingObject:@"text/javascript"];
    
    manager.responseSerializer = serializer;
    
    NSURL *URL = [NSURL URLWithString:self.appBundleJS];
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
                                 withSourceURL:[NSURL URLWithString:strongSelf.appBundleJS]];
        }
    }];
    [dataTask resume];
}

// delegate
- (ContainerViewController *)openViewWithName:(NSString *)name {
    ContainerViewController *viewVC = [[ContainerViewController alloc] initWithName:name];
    [_nav pushViewController:viewVC animated:YES];
    
    return viewVC;
}

@end
