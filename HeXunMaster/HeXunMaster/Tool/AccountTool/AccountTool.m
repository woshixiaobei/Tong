//
//  AccountTool.m
//  投顾志
//
//  Created by 李帅 on 15/5/29.
//  Copyright (c) 2015年 hexun. All rights reserved.
//

#import "AccountTool.h"
//#import "User.h"
//#import "Opinion.h"

#if __has_include("User+TeacherInfo.h")
#import "User+TeacherInfo.h"
#endif

// 用户信息
#define kUserFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userInfo.plist"]

// 存储用户阅读过的观点
#define kLookedOpinionFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"lookedOpinion.data"]

#define kallModuleDataListFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"allModuleDataList.data"]
@interface AccountTool ()
{
    NSMutableArray *_lookedOpinions; /**< 存储用户阅读过的观点 */
    NSMutableArray *_allModuleDataList; /**< 存储意见关注勾选投顾 */
}

@end

@implementation AccountTool
//singleton_m(AccountTool)

- (NSMutableArray *)lookedOpinions {
    
    if (!_lookedOpinions) {
        _lookedOpinions = [NSKeyedUnarchiver unarchiveObjectWithFile:kLookedOpinionFile];
        
        if (!_lookedOpinions) {
            _lookedOpinions = [NSMutableArray array];
        }
    }
    return _lookedOpinions;
}
- (NSMutableArray *)allModuleDataList
{
    if (!_allModuleDataList) {
        _allModuleDataList = [NSKeyedUnarchiver unarchiveObjectWithFile:kallModuleDataListFile];
        
        if (!_allModuleDataList) {
            _allModuleDataList = [NSMutableArray array];//beng le
        }
    }
 
    return _allModuleDataList;
}


/**
 *  存储账户
 */
+ (void)save:(HXMUser *)userInfo {
    // 归档
    [NSKeyedArchiver archiveRootObject:userInfo toFile:kUserFile];
}

/**
 *  是否登录
 */
+ (BOOL)isLogin
{
    HXMUser *user = [self userInfo];
    return (![user.username isEqualToString:@""] && user.username != nil );
}


/**
 *  获取账户
 */
+ (HXMUser *)userInfo {
    HXMUser *userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:kUserFile];
    return userInfo;
}

// 清除沙盒文件
+ (void)deleteUserInfo {
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL isUserExist = [[NSFileManager defaultManager] fileExistsAtPath:kUserFile];
    if (!isUserExist) return;
    NSError *error = nil;
    if ([fileMgr removeItemAtPath:kUserFile error:&error]) {

    } else {

    }
}
// 清除cookie
+ (void)deleteCookies
{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in storage.cookies) {
        [storage deleteCookie:cookie];
    }
}

/**
 *  存储阅读过的观点
 *
 *  @param opinionID 阅读过的观点id
 */
- (void)saveLookedOpinion:(NSString *)opinionID {
    [self.lookedOpinions removeObject:opinionID];
    [self.lookedOpinions addObject:opinionID];
    
    // 存进沙盒
    [NSKeyedArchiver archiveRootObject:self.lookedOpinions toFile:kLookedOpinionFile];
}

- (void)saveAllModuleDataList:(NSMutableArray *)dataArray {
    [self.allModuleDataList removeObject:dataArray];
    [self.allModuleDataList addObject:dataArray];
    
    [NSKeyedArchiver archiveRootObject:self.allModuleDataList toFile:kallModuleDataListFile];
}
//- (void)saveChangedCustomes:(NSMutableArray *)customeIDArray
//{
//    [self.changedCustomes addObjectsFromArray:customeIDArray];
//
//    // 勾选投顾存进沙盒
////    [NSKeyedArchiver archiveRootObject:nil toFile:kchangedCustomesFile];
//    [self.changedCustomes writeToFile:kchangedCustomesFile atomically:YES];
//    
//}
//- (void)removeChangedCustomes:(NSMutableArray *)customeIDArray
//{
//    [self.changedCustomes removeObjectsInArray:customeIDArray];
//    // 勾选投顾存进沙盒
////    [NSKeyedArchiver archiveRootObject:self.changedCustomes toFile:kchangedCustomesFile];
//    [self.changedCustomes writeToFile:kchangedCustomesFile atomically:YES];
//}
/**
 *  阅读过的观点
 *
 *  @return 阅读过的观点
 */
- (NSArray *)filterLookedOpinions {
    return self.lookedOpinions;
}
/**
 *
 *存储勾选的投顾（一键关注登录）
 *
 */
//- (NSArray *)filterChangedCustomes
//{
//    return self.changedCustomes;
//}
@end
