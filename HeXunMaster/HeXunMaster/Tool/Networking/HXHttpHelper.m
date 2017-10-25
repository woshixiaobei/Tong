//
//  HttpHelper.m
//  TouguClient
//
//  Created by 蔡建海 on 15/11/18.
//  Copyright © 2015年 hexun. All rights reserved.
//

#import "HXHttpHelper.h"

#pragma mark - Host




@implementation HXHttpHelper

// 唯一标识
+ (NSString*)createUniqueIdentifier
{
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    return (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
}

//
+ (NSURLSessionDataTask*)api_requestData:(NSString*)type
                                                url:(NSString*)url
                                              param:(id)params
                                     responseNoJson:(BOOL)noJson
                                            success:(void (^)(id x))sucess
                                            failure:(void (^)(NSError* error))failure
{
    
    NSURLSessionDataTask *task = nil;
    //
    if ([type isEqualToString:@"GET"])
    {
        task = [self get:url params:params responseNoJson:noJson success:^(id x) {
            
            // 数据异常判断
//            if (x == nil || ![x isKindOfClass:NSData.class]) {
//                failure(nil);
//                return ;
//            }
            
            if (noJson == YES) {
                
                // 结果不是标准json时，转化为标准json
                NSString *str = [[NSString alloc]initWithData:x encoding:NSUTF8StringEncoding];
                if (str == nil || [str isEqualToString:@""]) {
                    failure([NSError errorWithDomain:@"数据返回错误" code:-9 userInfo:nil]);
                    return ;
                }
                if (str.length < 4) {
                    failure([NSError errorWithDomain:@"数据返回错误" code:-9 userInfo:nil]);
                    return ;
                }
                str = [str substringWithRange:NSMakeRange(1, str.length - 3)];
                NSData *strData = [str dataUsingEncoding:NSUTF8StringEncoding];
                
                NSError *error = nil;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:strData options:NSJSONReadingMutableContainers error:&error];
                if (dic == nil) {
                    failure(nil);
                    return ;
                }
                sucess(dic);
            }
            else
                sucess(x);
            
            
        } failure:failure];
    }
    else if([type isEqualToString:@"POST"])
    {
        task = [self post:url params:params responseNoJson:noJson success:^(id x) {
            
            // 数据异常判断
//            if (x == nil || ![x isKindOfClass:NSData.class]) {
//                failure(nil);
//                return ;
//            }
            if (noJson == YES) {
                
                // 结果不是标准json时，转化为标准json
                NSString *str = [[NSString alloc]initWithData:x encoding:NSUTF8StringEncoding];
                str = [str substringWithRange:NSMakeRange(1, str.length - 3)];
                NSData *strData = [str dataUsingEncoding:NSUTF8StringEncoding];
                
                NSError *error = nil;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:strData options:NSJSONReadingMutableContainers error:&error];
                sucess(dic);
            }
            else
                sucess(x);
            
        } failure:failure];
        
    }
    return task;
}

//
+ (NSURLSessionDataTask*)api_requestData:(NSString*)type
                                                url:(NSString*)url
                                              param:(id)params
                                            success:(void (^)(id x))sucess
                                            failure:(void (^)(NSError* error))failure
{
    return [self api_requestData:type url:url param:params responseNoJson:NO success:sucess failure:failure];
}

/**
 下载资源方法
 
 @param url 资源地址
 @param downloadProgressBlock 下载进度
 @param destination 需要下载到的地址
 @param completionHandler 完成处理程序
 */
+ (NSURLSessionTask* _Nullable)api_downLoadWithUrl:(nonnull NSString*)url
                                          progress:(nullable void (^)(NSProgress *_Nullable downloadProgress))downloadProgressBlock
                                       destination:(nullable NSURL *_Nullable (^)(NSURL *_Nullable targetPath, NSURLResponse *_Nullable response))destination
                                 completionHandler:(nullable void (^)(NSURLResponse *_Nullable response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler
{
    NSURLSessionConfiguration *configuration = nil;
    if (iOS8OrLater) {
        configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[self createUniqueIdentifier]];
    }else{
        configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:[self createUniqueIdentifier]];
    }
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:downloadProgressBlock destination:destination completionHandler:completionHandler];
    [downloadTask resume];
    
    return downloadTask;
}


+ (NSString*)parameterForGETWithDictParam:(NSDictionary *)param
{
    if (!param) {
        return nil;
    }
    
    NSString *str = @"?";
    NSArray *keys = [param allKeys];
    for (int i=0; i<keys.count; i++) {
        str = [str stringByAppendingFormat:@"%@=%@",keys[i],param[keys[i]]];
        if (i+1<keys.count) {
            str = [str stringByAppendingString:@"&"];
        }
    }
    return str;
}

// 上传资源的方法
+ (NSURLSessionTask* _Nullable)api_upLoadWithUrl:(nonnull NSString*)url
                                           param:(id _Nullable)params
                                            data:(NSData *_Nullable)sourceData
                                        progress:(nullable void (^)(NSProgress *_Nullable))uploadProgressBlock
                                         success:(void (^ _Nullable)(id _Nullable x))sucess
                                         failure:(void (^ _Nullable)(NSError *_Nullable error))failure
{
    return [self upload:url
                 params:params
                   data:sourceData
               progress:uploadProgressBlock
                success:sucess
                failure:failure];
}


@end


