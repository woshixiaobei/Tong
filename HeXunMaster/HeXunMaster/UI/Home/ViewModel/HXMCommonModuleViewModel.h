//
//  HXMCommonModuleViewModel.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/27.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXMCommonModuleViewModel : NSObject

@property (nonatomic, strong) RACCommand *requestCommonListCommand;
//总的数据
@property (nonatomic, strong) NSMutableArray *dataListArray;
@end
