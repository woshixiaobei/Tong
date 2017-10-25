//
//  HXHttpHelper+HXMaster.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/15.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXHttpHelper+HXMaster.h"

@implementation HXHttpHelper (HXMaster)

//发送手机号码，获取验证码
+ (NSURLSessionTask*)api_postSendMobileCodeToGetNumber:(NSString *)phone
                                               success:(void (^)(id responseObject))success
                                               failure:(void (^)(NSError *error))failure {
    
    //http://iphone.jin.hexun.com/loginInterface!sendCode.action?username=%s
    NSString *url = [kAPIIphoneJinApiHost stringByAppendingString:@"loginInterface!sendCode.action"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] = phone.isNotBlank?phone:@"";
    return [self post:url params:params success:success failure:failure];
    
}

//点击登录按钮，获取验证码信息(0 成功  1 验证码错误   2 验证码错误 3 验证码失效)
+ (NSURLSessionTask*)api_postSendVerficationCodeToGetLogin:(NSString *)phone
                                       withVerficationCode:(NSString *)verficationCode
                                                   success:(void (^)(id responseObject))success
                                                   failure:(void (^)(NSError *error))failure {
    
    //http://iphone.jin.hexun.com/loginInterface!userLogin.action?username=%s&code=%s
    NSString *url = [kAPIIphoneJinApiHost stringByAppendingString:@"loginInterface!userLogin.action"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] = phone.isNotBlank?phone:@"";
    params[@"code"] = verficationCode;
    return [self post:url params:params success:success failure:failure];
    
}

//获取token请求(0 成功 1 token错误 2 token失效)
+ (NSURLSessionTask*)api_postSendVerficationCodeToGetTokenWithUsername:(NSString *)username
                                                       withAccessToken:(NSString *)token
                                                               success:(void (^)(id responseObject))success
                                                               failure:(void (^)(NSError *error))failure {
    
    //http://iphone.jin.hexun.com/loginInterface!tokenLogin.action?username=18501944345&token=aU3W6D3woFd42swyaY1496802485615
    NSString *url = [kAPIIphoneJinApiHost stringByAppendingString:@"loginInterface!tokenLogin.action"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] = username.isNotBlank?username:@"";
    params[@"token"] = token;
    return [self post:url params:params success:success failure:failure];
}

//获取首页的接口(username:)
+ (NSURLSessionTask *)api_getHomeRequestWithUsername:(NSString *)username
                                             success:(void (^)(id responseObject))success
                                             failure:(void (^)(NSError *error))failure {
    
    //http://iphone.jin.hexun.com/indexInterface.action?username=13681105164
    NSString *url = [kAPIIphoneJinApiHost stringByAppendingString:@"indexInterface.action"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] = username.isNotBlank?username:@"";
    return [self get:url params:params success:success failure:failure];
    
}

//获取首页中常用模块接口(username:)
+ (NSURLSessionTask *)api_getCommonModuleRequestWithUsername:(NSString *)username
                                                     success:(void (^)(id responseObject))success
                                                     failure:(void (^)(NSError *error))failure {
    
    
    //http://iphone.jin.hexun.com/moduleInterface.action?username=13800138000
    NSString *url = [kAPIIphoneJinApiHost stringByAppendingString:@"moduleInterface.action"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] = username.isNotBlank?username:@"";
    return [self get:url params:params success:success failure:failure];
}

//获取舆情图数据模块接口(company_code: module_id:)
+ (NSURLSessionTask *)api_getOpinonAnalysisChartModuleRequestWithCompanyCode:(NSString *)companyCode
                                                             module_id:(NSString *) module_id
                                                               success:(void (^)(id responseObject))success
                                                               failure:(void (^)(NSError *error))failure {
    
    
    // http://iphone.jin.hexun.com/newsInterface.action?company_code=002024&module_id=58
    NSString *url = [kAPIIphoneJinApiHost stringByAppendingString:@"newsInterface.action"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"company_code"] = companyCode.isNotBlank?companyCode:@"";
    params[@"module_id"] = module_id.isNotBlank?module_id:@"";
    return [self get:url params:params success:success failure:failure];
}

//获取正负面新闻接口(company_code: module_id: positive:)
+ (NSURLSessionTask *)api_getPositiveAndNegativeNewsModuleRequestWithCompanyCode:(NSString *)companyCode
                                                                       module_id:(NSString *) module_id
                                                                        positive:(NSString *)positive_id
                                                                         next_id:(NSString *)next_id
                                                                         success:(void (^)(id responseObject))success
                                                                         failure:(void (^)(NSError *error))failure {

    //http://iphone.jin.hexun.com/newsInterface.action?company_code=002024&module_id=7&positive=all&num=10
    NSString *url = [kAPIIphoneJinApiHost stringByAppendingString:@"newsInterface.action"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"company_code"] = companyCode.isNotBlank?companyCode:@"";
    params[@"module_id"] = module_id.isNotBlank?module_id:@"";
    params[@"positive"] = positive_id.isNotBlank?positive_id:@"";
    params[@"id"] = next_id.isNotBlank?next_id:@"";
    params[@"num"] = @(10);
    return [self get:url params:params success:success failure:failure];
}

//调取详情页接口数据(module_id: news_id:)
+ (NSURLSessionTask *)api_getDetailRequestWithUserName:(NSString *)userName
                                             module_id:(NSString *)moduleId
                                               type_id:(NSString *)typeId
                                               news_id:(NSString *)newsId
                                               success:(void (^)(id responseObject))success
                                               failure:(void (^)(NSError *error))failure {
    
    //http://iphone.jin.hexun.com/contentInterface.action?type_id=3779&module_id=7&news_id=169598407&username=13800138000 有提亮词时调用type_id
    //http://iphone.jin.hexun.com/contentInterface.action?username=13501221071&module_id=7&news_id=164409775
    NSString *url =[kAPIIphoneJinApiHost stringByAppendingString:@"contentInterface.action"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] = userName.isNotBlank?userName:@"";
    params[@"module_id"] = moduleId.isNotBlank?moduleId:@"";
    params[@"type_id"] = typeId.isNotBlank?typeId:@"";
    params[@"news_id"] = newsId.isNotBlank?newsId:@"";
    return [self get:url params:params success:success failure:failure];
}

//获取新闻列表接口（company_code: userMobile: module_id: type_id: id: num: ）
+ (NSURLSessionTask *)api_getNewsListRequestWithCompany_code:(NSString *)companyCode
                                                  userMobile:(NSString *)userMobile
                                                   module_id:(NSString *)moduleId
                                                     type_id:(NSString *)typeId
                                                      pageId:(NSString *)nextId
                                                    numCount:(NSString *)numCount
                                                     success:(void (^)(id responseObject))success
                                                     failure:(void (^)(NSError *error))failure {
    
    // http://iphone.jin.hexun.com/newsInterface.action?company_code=002024&module_id=87&num=10&type_id=all&userMobile=18501944345
    //http://iphone.jin.hexun.com/newsInterface.action?company_code=800090&id=1501119300000&module_id=7&num=10&type_id=all&userMobile=18501944345 下一页id
    NSString *url = [kAPIIphoneJinApiHost stringByAppendingString:@"newsInterface.action"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"userMobile"] = userMobile.isNotBlank?userMobile:@"";
    params[@"company_code"] = companyCode.isNotBlank?companyCode:@"";
    params[@"module_id"] = moduleId.isNotBlank?moduleId:@"";
    params[@"type_id"] = typeId.isNotBlank?typeId:@"";
    params[@"id"] = nextId.isNotBlank?nextId:@"";
    params[@"num"] = numCount;
    return [self get:url params:params success:success failure:failure];
    
}

//获取相似新闻接口
+ (NSURLSessionTask *)api_getSimilarNewsListRequestWithCompany_code:(NSString *)companyCode
                                                          module_id:(NSString *)moduleId
                                                            news_id:(NSString *)typeId
                                                             pageId:(NSString *)nextId
                                                           numCount:(NSString *)numCount
                                                            success:(void (^)(id responseObject))success
                                                            failure:(void (^)(NSError *error))failure {
    
    //http://iphone.jin.hexun.com/otherNewsInterface.action?company_code=800156&module_id=65&news_id=26253854&id=1492562484000&num=6 变更为这个
    NSString *url = [kAPIIphoneJinApiHost stringByAppendingString:@"otherNewsInterface.action"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"company_code"] = companyCode.isNotBlank?companyCode:@"";
    params[@"module_id"] = moduleId.isNotBlank?moduleId:@"";
    params[@"news_id"] = typeId.isNotBlank?typeId:@"";
    params[@"id"] = [NSString stringWithFormat:@"%@",nextId?:@""];
    params[@"num"] = numCount;
    return [self get:url params:params success:success failure:failure];
}

//获取我的收藏列表接口
+ (NSURLSessionTask *)api_getCollectionNewsListRequestWithUserMobile:(NSString *)userMobile
                                                             pageNum:(NSString *)pageNum
                                                            pageSize:(NSInteger)pageSize
                                                             success:(void (^)(id responseObject))success
                                                             failure:(void (^)(NSError *error))failure {
    
    // http://iphone.jin.hexun.com/newsFavoriteAction?userMobile=18501944345&pageNum=1&pageSize=5
    
    NSString *url = [kAPIIphoneJinApiHost stringByAppendingString:@"newsFavoriteAction"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userMobile"] = userMobile.isNotBlank?userMobile:@"";
    params[@"pageNum"] = pageNum;
    params[@"pageSize"] = @(pageSize);
    
    return [self get:url params:params success:success failure:failure];
    
}

//获取我的收藏详情接口
+ (NSURLSessionTask *)api_getDetailCollectionNewsRequestWithId:(NSString *)selectedId
                                                       success:(void (^)(id responseObject))success
                                                       failure:(void (^)(NSError *error))failure{
    
    //http://iphone.jin.hexun.com/newsFavoriteAction!getFavoriteContent.action?id=5556
    NSString *url = [kAPIIphoneJinApiHost stringByAppendingString:@"newsFavoriteAction!getFavoriteContent.action"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"id"] = selectedId.isNotBlank?selectedId:@"";
    
    return [self get:url params:params success:success failure:failure];
}

//获取我的收藏列表中-- 侧滑删除&移除多个 删除收藏列表接口（可删除多个id）
+ (NSURLSessionTask *)api_getDeleteCollectionNewsListRequestWithId:(NSString *)delegateIds
                                                           success:(void (^)(id responseObject))success
                                                           failure:(void (^)(NSError *error))failure {
    
    //http://iphone.jin.hexun.com/newsFavoriteAction!delFavoriteNews.action?ids=5445,5453
    
    NSString *url = [kAPIIphoneJinApiHost stringByAppendingString:@"newsFavoriteAction!delFavoriteNews.action"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"ids"] = delegateIds.isNotBlank?delegateIds:@"";
    
    return [self get:url params:params success:success failure:failure];
}



//删除帐号下所有收藏接口
+ (NSURLSessionTask *)api_getDeleteAllCollectionNewsListRequestWithUserMobile:(NSString *)userMobile
                                                                      success:(void (^)(id responseObject))success
                                                                      failure:(void (^)(NSError *error))failure {
    
    //http://iphone.jin.hexun.com/newsFavoriteAction!delAllFavoriteNews.action?userMobile=13899998888
    
    NSString *url = [kAPIIphoneJinApiHost stringByAppendingString:@"newsFavoriteAction!delAllFavoriteNews.action"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userMobile"] = userMobile.isNotBlank?userMobile:@"";
    
    return [self get:url params:params success:success failure:failure];
    
}

//正文详情页中-取消收藏-接口
+ (NSURLSessionTask *)api_getCancleCollectionNewsDetailRequestWithUserMobile:(NSString *)userMobile
                                                                      newsId:(NSString *)newsId
                                                                    moduleId:(NSString *)moduleId
                                                                     success:(void (^)(id responseObject))success
                                                                     failure:(void (^)(NSError *error))failure {
    
    //http://iphone.jin.hexun.com/newsFavoriteAction!delFavoriteNews.action?moduleId=87&newsId=21076293&userMobile=18501944345
    NSString *url = [kAPIIphoneJinApiHost stringByAppendingString:@"newsFavoriteAction!delFavoriteNews.action"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userMobile"] = userMobile.isNotBlank?userMobile:@"";
    params[@"newsId"] = newsId.isNotBlank?newsId:@"";
    params[@"moduleId"] = moduleId.isNotBlank?moduleId:@"";
    
    return [self get:url params:params success:success failure:failure];
}

//添加到收藏列表接口(正文详情页&新浪微博列表页添加到收藏)
+ (NSURLSessionTask *)api_getAddCollectionNewsListRequestWithUserMobile:(NSString *)userMobile
                                                                 newsId:(NSString *)newsId
                                                               moduleId:(NSString *)moduleId
                                                                success:(void (^)(id responseObject))success
                                                                failure:(void (^)(NSError *error))failure {
    
    //http://iphone.jin.hexun.com/newsFavoriteAction!addFavoriteNews?newsId=999999&moduleId=7&userMobile=13900008888
    
    NSString *url = [kAPIIphoneJinApiHost stringByAppendingString:@"newsFavoriteAction!addFavoriteNews"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userMobile"] = userMobile.isNotBlank?userMobile:@"";
    params[@"newsId"] = newsId.isNotBlank?newsId:@"";
    params[@"moduleId"] = moduleId.isNotBlank?moduleId:@"";
    
    return [self get:url params:params success:success failure:failure];
    
}

//获取推送列表数据接口
+ (NSURLSessionTask *)api_getHistroyPushNewsListRequestWithUserMobile:(NSString *)userMobile
                                                                 last:(NSString *)last
                                                              success:(void (^)(id responseObject))success
                                                              failure:(void (^)(NSError *error))failure {
    
    //http://iphone.jin.hexun.com/newsInterface!getPushNewsList.action?userMobile=18501944345&last=0
    
    NSString *url = [kAPIIphoneJinApiHost stringByAppendingString:@"newsInterface!getPushNewsList.action"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userMobile"] = userMobile.isNotBlank?userMobile:@"";
    params[@"last"] = last;
    
    return [self get:url params:params success:success failure:failure];
    
}

//推送新闻的详情页接口
+ (NSURLSessionTask *)api_getDetailPushCollectionNewsRequestWithModule_id:(NSString *)module_id
                                                                  news_id:(NSString *)news_id
                                                                  success:(void (^)(id responseObject))success
                                                                  failure:(void (^)(NSError *error))failure {
    
    //http://iphone.jin.hexun.com/contentInterface?module_id=14&news_id=61842
    
    NSString *url = [kAPIIphoneJinApiHost stringByAppendingString:@"contentInterface"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"module_id"] = module_id.isNotBlank?module_id:@"";
    params[@"news_id"] = news_id.isNotBlank?news_id:@"";
    
    return [self get:url params:params success:success failure:failure];
}

//打电话的问题反馈接口
+ (NSURLSessionTask *)api_getCallCustomerFeedbackActionRequestWithUserMobile:(NSString *)userMobile
                                                                     success:(void (^)(id responseObject))success
                                                                     failure:(void (^)(NSError *error))failure {
    
    // http://iphone.jin.hexun.com/po_iphone2.00/feedbackAction!callCustomer?userMobile=18501944345
    
    NSString *url = [kAPIIphoneJinApiHost stringByAppendingString:@"po_iphone2.00/feedbackAction!callCustomer"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userMobile"] = userMobile.isNotBlank?userMobile:@"";
    
    return [self get:url params:params success:success failure:failure];
    
}

//文字版的问题反馈接口
+ (NSURLSessionTask *)api_getTextFeedbackActionRequestWithUserMobile:(NSString *)userMobile
                                                             content:(NSString *)content
                                                             success:(void (^)(id responseObject))success
                                                             failure:(void (^)(NSError *error))failure {
    
    //http://iphone.jin.hexun.com/po_iphone2.00/feedbackAction?userMobile=18501944345&content=我是中国人
    
    NSString *url = [kAPIIphoneJinApiHost stringByAppendingString:@"po_iphone2.00/feedbackAction"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userMobile"] = userMobile.isNotBlank?userMobile:@"";
    params[@"content"] = content.isNotBlank?content:@"";
    
    return [self get:url params:params success:success failure:failure];
    
}


//公司研报
+ (NSURLSessionTask *)api_getCompanyResearchReportRequestWithWithCompany_code:(NSString *)company_code
                                                                    module_id:(NSString *)module_id
                                                                      type_id:(NSString *)type_id
                                                                   reportType:(NSString *)reportType
                                                                      pageNum:(NSString *)pageNum
                                                                     pageSize:(NSString *)pageSize
                                                                      success:(void (^)(id responseObject))success
                                                                      failure:(void (^)(NSError *error))failure {
    
    //http://iphone.jin.hexun.com/newsInterface.action?module_id=11&company_code=800156&reportType=0&type_id=all&pageNum=3&pageSize=3
    NSString *url = [kAPIIphoneJinApiHost stringByAppendingString:@"newsInterface.action"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"company_code"] = company_code.isNotBlank?company_code:@"";
    params[@"module_id"] = module_id.isNotBlank?module_id:@"";
    params[@"type_id"] = type_id.isNotBlank?type_id:@"";
    params[@"reportType"] = reportType.isNotBlank?reportType:@"";
    params[@"pageNum"] = pageNum;
    params[@"pageSize"] = pageSize;
    return [self get:url params:params success:success failure:failure];
    
}

@end
