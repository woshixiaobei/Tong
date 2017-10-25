//
//  HXMUser.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/15.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXMUser : NSObject

/** 用户id，没有登录返回空值 */
@property (nonatomic, copy) NSString *userid;

/** 用户名，没有登录返回空值 */
@property (nonatomic, copy) NSString *username;
/** 公司代码 */
@property (nonatomic, strong) NSString *company_code;
/** 用户会话cookie */
@property (nonatomic, copy) NSString *token;//token
//公司热线
@property (nonatomic, copy) NSString *hoteline;
/** 用户昵称 */
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *aliasType;//alias类型

/** 用户头像（40*40）地址，按需求可修改40为75/96/150，没有登录返回空值 */
@property (nonatomic, copy) NSString *photo;

/** 性别(0-女，1-男，2-未知，3-保密)，没有登录返回空值 */
@property (nonatomic, copy) NSString *sex;


/** 用户登录成功时返回的 snapcookie, 自动登录使用 */
@property (nonatomic, copy) NSString *snapCookie;

/** 用户登录成功时返回的 statecookie, 自动登录使用 */
@property (nonatomic, copy) NSString *loginStateCookie;

/** 是否登录成功 */
@property (nonatomic, copy) NSString *islogin;

/** 是否为华章老师*/
@property (nonatomic, assign) BOOL isHZTeacher;

/*** ******************************************************** 字段 ***/
/*** 合作者需要对老师、投顾权限做判断，因此增加 accountType           字段 ***/
/*** ******************************************************** 字段 ***/

/**
 *  返回一个不同size的头像url
 *
 *  @param width size
 *
 *  @return 头像url
 */

- (NSString *)photoPathWithSize:(NSInteger)width;
@end
