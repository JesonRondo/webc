//
//  WebCNetwork.m
//  WebC
//
//  Created by Long Zhou on 2017/9/7.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import "WebCNetwork.h"
#import <AFNetworking.h>

@implementation WebCNetwork

static WebCNetwork *_instance = nil;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (void)GetScript:(NSString *)url handle:(void (^)(NSError *error, NSString *content))callback {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    AFHTTPResponseSerializer *serializer = [[AFHTTPResponseSerializer alloc] init];
    serializer.acceptableContentTypes = [serializer.acceptableContentTypes setByAddingObject:@"text/javascript"];
    
    manager.responseSerializer = serializer;

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];

    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            if (callback) {
                callback(error, nil);
            }
        } else {
            if (callback) {
                NSString *cnt = [[NSString alloc] initWithData:responseObject
                                                      encoding:NSUTF8StringEncoding];
                callback(nil, cnt);
            }
        }
    }];
    [dataTask resume];
}

@end
