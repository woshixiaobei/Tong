//
//  AccountTool.h
//  投顾志
//
//  Created by 李帅 on 15/5/29.
//  Copyright (c) 2015年 hexun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXMUser.h"
//#import "Singleton.h"

//@class User;

@interface AccountTool : NSObject
//singleton_h(AccountTool)

@property (nonatomic, strong, readonly) NSMutableArray *lookedOpinions; /**< 存储用户阅读过的观点 */
@property (nonatomic, strong, readonly) NSMutableArray *allModuleDataList; /**存储全部模块的数组模型 */
/**
 *  存储用户信息
 */
+ (void)save:(HXMUser *)account;

/**
 *  是否登录
 */
+ (BOOL)isLogin;

/**
 *  获取用户信息
 */
+ (HXMUser *)userInfo;

/**
 *  清除沙盒文件
 */
+ (void)deleteUserInfo;

/**
 *  请粗cookies
 */
+ (void)deleteCookies;

/**
 *  存储阅读过的观点
 *
 *  @param opinionID 阅读过的观点id
 */
- (void)saveLookedOpinion:(NSString *)opinionID;
/**
 *
 *存储勾选的投顾（一键关注登录）
 *
 */
- (void)saveChangedCustomes:(NSMutableArray *)customeIDArray;
- (void)removeChangedCustomes:(NSMutableArray *)customeIDArray;

/**
 *  阅读过的观点
 *
 *  @return 阅读过的观点
 */
- (NSArray *)filterLookedOpinions;
/**
 *
 *存储勾选的投顾（一键关注登录）
 *
 */
- (NSArray *)filterChangedCustomes;

/**
 保存全部模块的数组模型

 @param dataArray 数组模型
 */
- (void)saveAllModuleDataList:(NSMutableArray *)dataArray;
@end
