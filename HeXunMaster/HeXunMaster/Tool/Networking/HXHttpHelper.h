//
//  HttpHelper.h
//  TouguClient
//
//  Created by 蔡建海 on 15/11/18.
//  Copyright © 2015年 hexun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXAPI.h"
#import "HXMHostHeader.h"

typedef  void (^ _Nullable  ResponseSuccessBlock) (id _Nullable successValue);
typedef  void (^ _Nullable  ResponseFailureBlock) (id _Nullable failureValue);




@interface HXHttpHelper : HXAPI

// 唯一标识
+ (nonnull NSString*)createUniqueIdentifier;

//
+ (NSURLSessionDataTask* _Nullable)api_requestData:(NSString* _Nullable)type
                                               url:(NSString* _Nullable)url
                                             param:(id _Nullable)params
                                    responseNoJson:(BOOL)noJson
                                           success:(void (^ _Nullable)(id _Nullable x))sucess
                                           failure:(void (^ _Nullable)(NSError* _Nullable error))failure;

//
+ (NSURLSessionDataTask* _Nullable)api_requestData:(NSString* _Nullable)type
                                               url:(NSString* _Nullable)url
                                             param:(id _Nullable)params
                                           success:(void (^ _Nullable)(id _Nullable x))sucess
                                           failure:(void (^ _Nullable)(NSError *_Nullable error))failure;


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
                                 completionHandler:(nullable void (^)(NSURLResponse *_Nullable response, NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler;

+ (nullable NSString*)parameterForGETWithDictParam:(NSDictionary * __nullable)param;

// 上传资源的方法
+ (NSURLSessionTask* _Nullable)api_upLoadWithUrl:(nonnull NSString*)url
                                           param:(id _Nullable)params
                                            data:(NSData *_Nullable)sourceData
                                        progress:(nullable void (^)(NSProgress *_Nullable))uploadProgressBlock
                                         success:(void (^ _Nullable)(id _Nullable x))sucess
                                         failure:(void (^ _Nullable)(NSError *_Nullable error))failure;

@end
