//
//  HXMRemoveAliasManage.h
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/7/31.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXMRemoveAliasManage : NSObject

+ (instancetype)shareManage;
//移除alias
- (void) removeAliasUntilSuccess:(void (^)(BOOL isSuccess, NSError * error))handle;

//移除alias成功之后，并添加alias成功
- (void)removeAliasThenAddAliasIsSuccess:(void (^)(BOOL isSuccess, NSError * error))handle;
@end
