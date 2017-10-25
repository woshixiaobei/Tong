//
//  HXHttpHelper+HXMaster.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/15.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXHttpHelper.h"

@interface HXHttpHelper (HXMaster)

//发送手机号码，获取验证码（发送验证码 0 成功 1 手机号为空 2 手机号格式错误 3 手机号没有登录权限）
+ (NSURLSessionTask*)api_postSendMobileCodeToGetNumber:(NSString *)phone
                                               success:(void (^)(id responseObject))success
                                               failure:(void (^)(NSError *error))failure;

//点击登录按钮，获取验证码信息(0 成功  1 验证码错误   2 验证码错误 3 验证码失效)
+ (NSURLSessionTask*)api_postSendVerficationCodeToGetLogin:(NSString *)phone
                                       withVerficationCode:(NSString *)verficationCode
                                                   success:(void (^)(id responseObject))success
                                                   failure:(void (^)(NSError *error))failure;


//获取token请求(0 成功 1 token错误 2 token失效)
+ (NSURLSessionTask*)api_postSendVerficationCodeToGetTokenWithUsername:(NSString *)username
                                                       withAccessToken:(NSString *)token
                                                               success:(void (^)(id responseObject))success
                                                               failure:(void (^)(NSError *error))failure;


//获取首页的接口(username:)
+ (NSURLSessionTask *)api_getHomeRequestWithUsername:(NSString *)username
                                             success:(void (^)(id responseObject))success
                                             failure:(void (^)(NSError *error))failure;

//获取首页中常用模块接口(username:)
+ (NSURLSessionTask *)api_getCommonModuleRequestWithUsername:(NSString *)username
                                                     success:(void (^)(id responseObject))success
                                                     failure:(void (^)(NSError *error))failure;


//获取舆情图数据模块接口(company_code: module_id:)
+ (NSURLSessionTask *)api_getOpinonAnalysisChartModuleRequestWithCompanyCode:(NSString *)companyCode
                                                                   module_id:(NSString *) module_id
                                                                     success:(void (^)(id responseObject))success
                                                                     failure:(void (^)(NSError *error))failure;

//获取正负面新闻接口(company_code: module_id: positive: id:(下一页标识))
+ (NSURLSessionTask *)api_getPositiveAndNegativeNewsModuleRequestWithCompanyCode:(NSString *)companyCode
                                                                       module_id:(NSString *) module_id
                                                                        positive:(NSString *)positive_id
                                                                         next_id:(NSString *)next_id
                                                                         success:(void (^)(id responseObject))success
                                                                         failure:(void (^)(NSError *error))failure;

//调取详情页接口数据(userName: module_id: news_id: type_id:)(有提亮词时，需要传type_id,没有提亮词的时候，可以为空或者不传)
+ (NSURLSessionTask *)api_getDetailRequestWithUserName:(NSString *)userName
                                             module_id:(NSString *)moduleId
                                               type_id:(NSString *)typeId
                                               news_id:(NSString *)newsId
                                               success:(void (^)(id responseObject))success
                                               failure:(void (^)(NSError *error))failure;


//获取新闻列表接口（company_code: userMobile: module_id: type_id: pageId: id: num: ）
+ (NSURLSessionTask *)api_getNewsListRequestWithCompany_code:(NSString *)companyCode
                                                  userMobile:(NSString *)userMobile
                                                   module_id:(NSString *)moduleId
                                                     type_id:(NSString *)typeId
                                                      pageId:(NSString *)nextId
                                                    numCount:(NSString *)numCount
                                                     success:(void (^)(id responseObject))success
                                                     failure:(void (^)(NSError *error))failure;

//获取相似新闻列表接口（company_code:  module_id: type_id: pageId: id: num: ）
+ (NSURLSessionTask *)api_getSimilarNewsListRequestWithCompany_code:(NSString *)companyCode
                                                          module_id:(NSString *)moduleId
                                                            news_id:(NSString *)typeId
                                                             pageId:(NSString *)nextId
                                                           numCount:(NSString *)numCount
                                                            success:(void (^)(id responseObject))success
                                                            failure:(void (^)(NSError *error))failure;

//获取我的收藏列表接口
+ (NSURLSessionTask *)api_getCollectionNewsListRequestWithUserMobile:(NSString *)userMobile
                                                             pageNum:(NSString *)pageNum
                                                            pageSize:(NSInteger)pageSize
                                                             success:(void (^)(id responseObject))success
                                                             failure:(void (^)(NSError *error))failure;

//获取我的收藏详情接口
+ (NSURLSessionTask *)api_getDetailCollectionNewsRequestWithId:(NSString *)selectedId
                                                       success:(void (^)(id responseObject))success
                                                       failure:(void (^)(NSError *error))failure;

//获取删除收藏列表接口
+ (NSURLSessionTask *)api_getDeleteCollectionNewsListRequestWithId:(NSString *)delegateIds
                                                           success:(void (^)(id responseObject))success
                                                           failure:(void (^)(NSError *error))failure;

//删除帐号下所有收藏接口
+ (NSURLSessionTask *)api_getDeleteAllCollectionNewsListRequestWithUserMobile:(NSString *)userMobile
                                                                      success:(void (^)(id responseObject))success
                                                                      failure:(void (^)(NSError *error))failure;

//正文详情页中-取消收藏-接口
+ (NSURLSessionTask *)api_getCancleCollectionNewsDetailRequestWithUserMobile:(NSString *)userMobile
                                                                      newsId:(NSString *)newsId
                                                                    moduleId:(NSString *)moduleId
                                                                     success:(void (^)(id responseObject))success
                                                                     failure:(void (^)(NSError *error))failure;
//添加到收藏列表接口
+ (NSURLSessionTask *)api_getAddCollectionNewsListRequestWithUserMobile:(NSString *)userMobile
                                                                 newsId:(NSString *)newsId
                                                               moduleId:(NSString *)moduleId
                                                                success:(void (^)(id responseObject))success
                                                                failure:(void (^)(NSError *error))failure;

//获取推送列表数据接口
+ (NSURLSessionTask *)api_getHistroyPushNewsListRequestWithUserMobile:(NSString *)userMobile
                                                                 last:(NSString *)last
                                                              success:(void (^)(id responseObject))success
                                                              failure:(void (^)(NSError *error))failure;

//推送新闻的详情页接口
+ (NSURLSessionTask *)api_getDetailPushCollectionNewsRequestWithModule_id:(NSString *)module_id
                                                                  news_id:(NSString *)news_id
                                                                  success:(void (^)(id responseObject))success
                                                                  failure:(void (^)(NSError *error))failure;

//打电话的问题反馈接口
+ (NSURLSessionTask *)api_getCallCustomerFeedbackActionRequestWithUserMobile:(NSString *)userMobile
                                                                     success:(void (^)(id responseObject))success
                                                                     failure:(void (^)(NSError *error))failure;

//文字版的问题反馈接口
+ (NSURLSessionTask *)api_getTextFeedbackActionRequestWithUserMobile:(NSString *)userMobile
                                                             content:(NSString *)content
                                                             success:(void (^)(id responseObject))success
                                                             failure:(void (^)(NSError *error))failure;

//公司研报
+ (NSURLSessionTask *)api_getCompanyResearchReportRequestWithWithCompany_code:(NSString *)company_code
                                                                    module_id:(NSString *)module_id
                                                                      type_id:(NSString *)type_id
                                                                   reportType:(NSString *)reportType
                                                                      pageNum:(NSString *)pageNum
                                                                     pageSize:(NSString *)pageSize
                                                                      success:(void (^)(id responseObject))success
                                                                      failure:(void (^)(NSError *error))failure;
@end
