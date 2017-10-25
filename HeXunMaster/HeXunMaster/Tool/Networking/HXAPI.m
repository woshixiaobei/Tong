//
//  API.m
//  TouGuBackStage
//
//  Created by 蔡建海 on 16/1/4.
//  Copyright © 2016年 zhaojianfei. All rights reserved.
//

#import "HXAPI.h"
#import "AccountTool.h"
//#import "ConstantHeader.h"
#import "HXServerTime.h"
#import "HXToolTime.h"
#import <AdSupport/AdSupport.h>

@implementation HXAPI

/**
 *  发送POST请求
 */
+ (NSURLSessionTask *)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    return [self post:url params:params progress:nil success:success failure:failure];
}


/**
 *  发送POST请求
 */
+ (NSURLSessionDataTask *)post:(NSString *)url params:(NSDictionary *)params progress:(void (^)(id))progress success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    return [self post:url params:params responseNoJson:NO progress:progress success:success failure:failure];
}

/**
 *  发送POST请求
 */
+ (NSURLSessionDataTask *)post:(NSString *)url params:(NSDictionary *)params responseNoJson:(BOOL)noJson progress:(void (^)(id))progress success:(void (^)(id x))success failure:(void (^)(NSError *))failure
{
    // 获得请求管理者
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    if (noJson) {
        session.requestSerializer = [AFHTTPRequestSerializer serializer];
        session.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    
    session.requestSerializer.timeoutInterval = 10.0;
    
    NSString *userToken = [AccountTool userInfo].token;
    NSString *snapCookie = [AccountTool userInfo].snapCookie;
    NSString *loginStateCookie = [AccountTool userInfo].loginStateCookie;
    if ([userToken isEqualToString:@""] || userToken == nil) {
        userToken = @"";
    }
    
    [session.requestSerializer setValue:[NSString stringWithFormat:@"userToken=%@; SnapCookie=%@; LoginStateCookie=%@", userToken, snapCookie, loginStateCookie] forHTTPHeaderField:@"Cookie"];
    
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [session.requestSerializer setValue:appVersion forHTTPHeaderField:@"AppVersion"];
    [session.requestSerializer setValue:HXAppId forHTTPHeaderField:@"appId"];
//    [session.requestSerializer setValue:RESOLUTIONAPP forHTTPHeaderField:@"resolution"];
   // NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //[session.requestSerializer setValue:idfa forHTTPHeaderField:@"deviceid"];

    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/plain", nil];
    
    NSURLSessionDataTask *task = [session POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progress) {
            progress(uploadProgress);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 设置服务器时间
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;
        NSString *strDate = [allHeaders valueForKey:@"Date"];
        if (strDate != nil && ![strDate isEqualToString:@""]) {
            double d= [HXToolTime secondsWithDateString:strDate withForm:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
            if(d>0) [[HXServerTime shareHXServerTime] setServerTime:d];
        }

        if (responseObject == nil) {
            failure(nil);
            return;
        }
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
    }];
    
    return task;
}

/**
 *  发送POST请求
 */
+ (NSURLSessionDataTask *)post:(NSString *)url params:(NSDictionary *)params responseNoJson:(BOOL)noJson success:(void (^)(id x))success failure:(void (^)(NSError *))failure
{
    return [self post:url params:params responseNoJson:noJson progress:nil success:success failure:failure];
}


/**
 *  发送 GET 请求
 */
+ (NSURLSessionDataTask *)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    return [self get:url params:params responseNoJson:NO success:success failure:failure];
}

/**
 *  发送 GET 请求
 */
+ (NSURLSessionDataTask *)get:(NSString *)url params:(NSDictionary *)params responseNoJson:(BOOL)noJson success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    // 获得请求管理者
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    if (noJson) {
        session.requestSerializer = [AFHTTPRequestSerializer serializer];
        session.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    
    // 请求超时
    session.requestSerializer.timeoutInterval = 30.0;
    
    NSString *userToken = [AccountTool userInfo].token;
    NSString *snapCookie = [AccountTool userInfo].snapCookie;
    NSString *loginStateCookie = [AccountTool userInfo].loginStateCookie;
    if ([userToken isEqualToString:@""] || userToken == nil) {
        userToken = @"";
    }
    
    [session.requestSerializer setValue:[NSString stringWithFormat:@"userToken=%@; SnapCookie=%@; LoginStateCookie=%@", userToken, snapCookie, loginStateCookie] forHTTPHeaderField:@"Cookie"];
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [session.requestSerializer setValue:appVersion forHTTPHeaderField:@"AppVersion"];
    [session.requestSerializer setValue:HXAppId forHTTPHeaderField:@"appId"];
//    [session.requestSerializer setValue:RESOLUTIONAPP forHTTPHeaderField:@"resolution"];
   // NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
   // [session.requestSerializer setValue:idfa forHTTPHeaderField:@"deviceid"];

    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/plain", nil];
    
    NSURLSessionDataTask *task = [session GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 设置服务器时间
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;
        NSString *strDate = [allHeaders valueForKey:@"Date"];
        if (strDate != nil && ![strDate isEqualToString:@""]) {
            double d= [HXToolTime secondsWithDateString:strDate withForm:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
            if(d>0) [[HXServerTime shareHXServerTime] setServerTime:d];
        }
        
        if (responseObject == nil) {
            failure(nil);
            return;
        }
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
    return task;
}

/**
 *  下载 请求
 */
+ (NSURLSessionDownloadTask *)downLoad:(NSString *)url params:(NSDictionary *)params success:(void (^)(id x))success failure:(void (^)(NSError *))failure
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
        
        
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        // 成功
        if (error == nil) {
            NSData *data = [NSData dataWithContentsOfURL:filePath];
            NSObject *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            if (success) {
                success(obj);
            }
        }
        else
        {
            if (failure) {
                failure(error);
            }
        }
    }];
    [downloadTask resume];
    
    return downloadTask;
}

+(NSURLSessionDataTask *)patch:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    // 获得请求管理者
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    // 请求超时
    session.requestSerializer.timeoutInterval = 10.0;
    
    NSString *userToken = [AccountTool userInfo].token;
    NSString *snapCookie = [AccountTool userInfo].snapCookie;
    NSString *loginStateCookie = [AccountTool userInfo].loginStateCookie;
    if ( userToken == nil || [userToken isEqualToString:@""]) {
        userToken = @"";
    }
    
    [session.requestSerializer setValue:[NSString stringWithFormat:@"userToken=%@; SnapCookie=%@; LoginStateCookie=%@", userToken, snapCookie, loginStateCookie] forHTTPHeaderField:@"Cookie"];
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [session.requestSerializer setValue:appVersion forHTTPHeaderField:@"AppVersion"];
    [session.requestSerializer setValue:HXAppId forHTTPHeaderField:@"appId"];
//    [session.requestSerializer setValue:RESOLUTIONAPP forHTTPHeaderField:@"resolution"];
    //NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
   // [session.requestSerializer setValue:idfa forHTTPHeaderField:@"deviceid"];
   
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/plain", nil];
    
    NSURLSessionDataTask *task = [session PATCH:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject == nil) {
            failure(nil);
            return;
        }
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
    
    return task;
}

/**
 *  发送upload POST请求
 */
+ (NSURLSessionDataTask *)upload:(NSString *)url
                          params:(NSDictionary *)params
                            data:(NSData *)sourceData
                        progress:(void (^)(NSProgress *))uploadProgressBlock
                         success:(void (^)(id x))success
                         failure:(void (^)(NSError *))failure;
{
    AFHTTPSessionManager *mgrRequest = [AFHTTPSessionManager manager];
    
    mgrRequest.requestSerializer = [AFHTTPRequestSerializer serializer];
    [mgrRequest.requestSerializer setValue:[NSString stringWithFormat:@"userToken=%@; SnapCookie=%@; LoginStateCookie=%@; appId=%@", [AccountTool userInfo].token, [AccountTool userInfo].snapCookie, [AccountTool userInfo].loginStateCookie, HXAppId] forHTTPHeaderField:@"Cookie"];
    
    mgrRequest.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    return [mgrRequest POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        
        if (sourceData != nil) {
            [formData appendPartWithFormData:sourceData name:@"file"];
        }
    }progress:uploadProgressBlock
            
    success:^(NSURLSessionDataTask *dataTask, id responseObject){
        
        if (success) {
            success(responseObject);
        }
    }failure:^(NSURLSessionDataTask *dataTask, NSError *error){

        if (failure) {
            failure(error);
        }
    }];
}


@end
