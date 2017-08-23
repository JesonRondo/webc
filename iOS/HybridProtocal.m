//
//  HybridProtocal.m
//  webc
//
//  Created by Long Zhou on 2017/8/22.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import "HybridProtocal.h"
#import "ResourceManage.h"

static NSString *const HybridResourceProtocolHandledKey = @"HybridResourceProtocolHandledKey";

@interface HybridProtocal () 

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation HybridProtocal

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    // 只处理http和https请求
    NSString *scheme = [[request URL] scheme];
    if ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
        [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame ||
        [scheme caseInsensitiveCompare:@"file"] == NSOrderedSame) {
        // 看看是否已经处理过了，防止无限循环
        if ([NSURLProtocol propertyForKey:HybridResourceProtocolHandledKey inRequest:request]) {
            return NO;
        }
        
        // 带有_speed参数的需要代理到本地
        if ([[request.mainDocumentURL query] containsString:@"_speed"]) {
            return YES;
        }

        return NO;
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void)startLoading {
    NSURL *url = [[ResourceManage shareInstance] findResourceURLWithURL:[self.request URL]];

    NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:url];
    newRequest.allHTTPHeaderFields = self.request.allHTTPHeaderFields;

    [NSURLProtocol setProperty:@YES
                        forKey:HybridResourceProtocolHandledKey
                     inRequest:newRequest];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:config
                                                 delegate:self
                                            delegateQueue:[NSOperationQueue currentQueue]];
    [[self.session dataTaskWithRequest:newRequest] resume];

}

- (void)stopLoading {
    [self.session invalidateAndCancel];
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(nonnull NSURLResponse *)response completionHandler:(nonnull void (^)(NSURLSessionResponseDisposition))completionHandler {
    [self.client URLProtocol:self
          didReceiveResponse:response
          cacheStoragePolicy:NSURLCacheStorageAllowed];
    
    if (completionHandler) {
        completionHandler(NSURLSessionResponseAllow);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.client URLProtocol:self
                 didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        [self.client URLProtocol:self
                didFailWithError:error];
    } else {
        [self.client URLProtocolDidFinishLoading:self];
    }
}

@end
