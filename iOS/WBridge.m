
//
//  WBridge.m
//  webc
//
//  Created by Long Zhou on 2017/8/28.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import "WBridge.h"
#import <AFNetworking.h>

@interface WBridge ()

@property(nonatomic, strong) NSMutableDictionary *viewVCs;

@end

@implementation WBridge

- (id)init {
    if (self = [super init]) {
        self.viewVCs = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)sendCmd:(NSString *)cmd data:(NSString *)data toTarget:(NSString *)target {
    ContainerViewController *vc = [self.viewVCs objectForKey:target];
    [vc evaluateJavaScript:[NSString stringWithFormat:@"viewKit.messageHandle('%@', %@)", cmd, data]
         completionHandler:^(id result, NSError *error) {
             if (error) {
                 NSLog(@"%@", error);
             }
         }];
}

- (NSString *)JSONStringifyForArray:(NSArray *)arr {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr
                                                       options:(NSJSONWritingOptions)0
                                                         error:&error];
    
    if (!jsonData) {
        return @"[]";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

- (NSString *)JSONStringifyForDict:(NSDictionary *)dict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:(NSJSONWritingOptions)0
                                                         error:&error];
    
    if (!jsonData) {
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

- (id)call {
    return ^(JSValue *cmd, JSValue *data, JSValue *callback) {
        NSString *command = [cmd toString];
        
        if ([command isEqualToString:@"navigate.push"]) {
            NSDictionary *payload = [data toDictionary];
            
            if ([self.delegate respondsToSelector:@selector(openViewWithName:)]) {
                [self.viewVCs setObject:[self.delegate openViewWithName:payload[@"path"]]
                                 forKey:payload[@"path"]];
            }

            return;
        }
        
        if ([command isEqualToString:@"nodeOpt.addStyleElement"]) {
            NSDictionary *payload = [data toDictionary];
            
            NSString *target = [payload objectForKey:@"target"];
            NSDictionary *element = [payload objectForKey:@"element"];
            NSString *elementStr = [self JSONStringifyForDict:element];

            [self sendCmd:@"addStyleElement"
                     data:[NSString stringWithFormat:@"{element:%@}", elementStr]
                 toTarget:target];
            
            return;
        }
        
        if ([command isEqualToString:@"nodeOpt.appendStyleNode"]) {
            NSDictionary *payload = [data toDictionary];
            
            NSString *target = [payload objectForKey:@"target"];
            NSDictionary *element = [payload objectForKey:@"element"];
            NSString *node = [payload objectForKey:@"node"];

            NSString *elementStr = [self JSONStringifyForDict:element];

            [self sendCmd:@"appendStyleNode"
                     data:[NSString stringWithFormat:@"{element:%@,node:'%@'}", elementStr, node]
                 toTarget:target];
            
            return;
        }
        
        if ([command isEqualToString:@"nodeOpt.patch"]) {
            NSDictionary *payload = [data toDictionary];
            
            NSString *target = [payload objectForKey:@"target"];
            NSString *html = [payload objectForKey:@"html"];
            
            [self sendCmd:@"patch"
                     data:[NSString stringWithFormat:@"{html: %@}", html]
                 toTarget:target];
            
            return;
        }
        
        if ([command isEqualToString:@"request"]) {
            NSDictionary *payload = [data toDictionary];
            NSDictionary *opts = [payload objectForKey:@"opts"];
            
            NSString *url = [opts objectForKey:@"url"];
            NSString *method = [opts objectForKey:@"method"];
//            NSString *dataType = [opts objectForKey:@"dataType"];
            
            if ([method isEqualToString:@"GET"]) {
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                    
                    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
                    [result setObject:[NSNumber numberWithInteger:response.statusCode]
                               forKey:@"statusCode"];
                    [result setObject:(NSDictionary *)responseObject
                               forKey:@"data"];
                    [result setObject:response.allHeaderFields
                               forKey:@"header"];

                    JSContext *ctx = [self.delegate coreContext];
                    
                    [callback callWithArguments:@[
                                                  [JSValue valueWithUndefinedInContext:ctx],
                                                  result
                                                  ]];
                } failure:^(NSURLSessionTask *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                }];
            }
            return;
        }
    };
}

@end
