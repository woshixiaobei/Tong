//
//  API.h
//  TouGuBackStage
//
//  Created by 蔡建海 on 16/1/4.
//  Copyright © 2016年 zhaojianfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface HXAPI : NSObject

/**
 *  发送 PATCH 请求
 **/
+(NSURLSessionDataTask *)patch:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;

/**
 *  发送POST请求
 */
+ (NSURLSessionDataTask *)post:(NSString *)url params:(NSDictionary *)params progress:(void (^)(id))progress success:(void (^)(id x))success failure:(void (^)(NSError *))failure;

/**
 *  发送POST请求
 */
+ (NSURLSessionDataTask *)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id x))success failure:(void (^)(NSError *))failure;

/**
 *  发送POST请求
 */
+ (NSURLSessionDataTask *)post:(NSString *)url params:(NSDictionary *)params responseNoJson:(BOOL)noJson progress:(void (^)(id))progress success:(void (^)(id x))success failure:(void (^)(NSError *))failure;

/**
 *  发送POST请求
 */
+ (NSURLSessionDataTask *)post:(NSString *)url params:(NSDictionary *)params responseNoJson:(BOOL)noJson success:(void (^)(id x))success failure:(void (^)(NSError *))failure;

/**
 *  发送 GET 请求
 *
 *  @param url     <#url description#>
 *  @param params  <#params description#>
 *  @param noJson  返回 是否 不是标准json数据
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+ (NSURLSessionDataTask *)get:(NSString *)url params:(NSDictionary *)params responseNoJson:(BOOL)noJson success:(void (^)(id x))success failure:(void (^)(NSError *))failure;

/**
 *  发送 GET 请求
 */
+ (NSURLSessionTask *)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id x))success failure:(void (^)(NSError *))failure;

/**
 *  下载 请求
 */
+ (NSURLSessionDownloadTask *)downLoad:(NSString *)url params:(NSDictionary *)params success:(void (^)(id x))success failure:(void (^)(NSError *))failure;

/**
 *  发送upload POST请求
 */
+ (NSURLSessionDataTask *)upload:(NSString *)url
                          params:(NSDictionary *)params
                            data:(NSData *)sourceData
                        progress:(void (^)(NSProgress *))uploadProgressBlock
                         success:(void (^)(id x))success
                         failure:(void (^)(NSError *))failure;

@end
