//
//  HXMHomeListViewModel.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/23.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXMHomeListViewModel.h"

@interface HXMHomeListViewModel : NSObject

@property (nonatomic, copy) NSString *username;
//@property (nonatomic, strong) HXMHomeListViewModel *model;
/**
 请求首页命令
 */
@property (nonatomic, strong) RACCommand *requestHomeListCommand;
@end
