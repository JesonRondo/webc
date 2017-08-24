//
//  ResourceManage.m
//  webc
//
//  Created by Long Zhou on 2017/8/22.
//  Copyright © 2017年 Long Zhou. All rights reserved.
//

#import "ResourceManage.h"
#import "SSZipArchive.h"

@implementation ResourceManage

static ResourceManage *_instance = nil;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (void)loadResources {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"http://172.17.37.51:3000/data/pkg.amr"];
    NSURLSessionDownloadTask *downloadTask =
        [session downloadTaskWithURL:url
                   completionHandler:^(NSURL * __nullable location,
                                       NSURLResponse * __nullable response,
                                       NSError * __nullable error) {
                       
                       NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
                       NSDictionary *allHeaders = res.allHeaderFields;
                       
                       NSString *contentLength = (NSString *)[allHeaders objectForKey:@"Content-Length"];
                       
                       if (!error && [contentLength intValue] > 0) {
                           NSLog(@"> 离线资源下载完毕");
                           
                           NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                           
                           if ([paths count] > 0) {
                               // 解压
                               NSString *documentpath = [paths objectAtIndex:0];
                               
                               NSString *zipLocation = [location path];
                               NSString *unZipLocation = [documentpath stringByAppendingString:@"/hybrid_res"];
                               
                               [SSZipArchive unzipFileAtPath:zipLocation
                                               toDestination:unZipLocation
                                             progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) { }
                                           completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nonnull error) {
                                               if (!error) {
                                                   NSLog(@"> 离线资源解压完毕");
                                               }
                                           }];
                           }
                       } else {
                           NSLog(@"> 离线资源下载失败");
                       }
                   }];
    [downloadTask resume];
}

- (NSURL *)findResourceURLWithURL:(NSURL *)onlineURL {
    NSString *localPath;
    NSString *localFile;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *docUrl = [[manager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSString *docPath = [docUrl path];
    NSString *docFile = [docUrl absoluteString];
    
    // 获取本地文件
    
    // html
    if (![[onlineURL path] containsString:@"."]) {
        NSString *distFile = [NSString stringWithFormat:@"%@%@%@", @"hybrid_res/dist", [onlineURL path], @"/index.html"];
        
        localPath = [NSString stringWithFormat:@"%@/%@", docPath, distFile];
        localFile = [NSString stringWithFormat:@"%@%@", docFile, distFile];
    } else { // 资源文件
        NSString *distFile = [NSString stringWithFormat:@"%@%@", @"hybrid_res/dist", [onlineURL path]];
        localPath = [NSString stringWithFormat:@"%@/%@", docPath, distFile];
        localFile = [NSString stringWithFormat:@"%@%@", docFile, distFile];
    }
    
    if ([manager fileExistsAtPath:localPath]) { // 存在文件
        if ([onlineURL query]) {
            localFile = [localFile stringByAppendingString:[NSString stringWithFormat:@"?%@", [onlineURL query]]];
        }
        return [NSURL URLWithString:localFile];
    } else { // 不存在文件
        return onlineURL;
    }
}

- (NSURL *)findFileResourceURLWithURL:(NSURL *)onlineURL {
    NSString *localPath;
    NSString *localFile;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *docUrl = [[manager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSString *docPath = [docUrl path];
    NSString *docFile = [docUrl absoluteString];
    
    // 获取本地文件
    
    // html
    NSString *distFile = [NSString stringWithFormat:@"%@%@%@", @"hybrid_res/dist", [onlineURL path], @"/index_file.html"];
        
    localPath = [NSString stringWithFormat:@"%@/%@", docPath, distFile];
    localFile = [NSString stringWithFormat:@"%@%@", docFile, distFile];

    if ([manager fileExistsAtPath:localPath]) { // 存在文件
        if ([onlineURL query]) {
            localFile = [localFile stringByAppendingString:[NSString stringWithFormat:@"?%@", [onlineURL query]]];
        }
        return [NSURL URLWithString:localFile];
    } else { // 不存在文件
        return onlineURL;
    }
}

@end
