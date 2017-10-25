//
//  HXMSimilarNewsViewModel.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/4/24.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXMSimilarNewsViewModel : NSObject

@property (nonatomic, strong, readonly)RACSignal *requestSimilarNewsListSignal;
@property (nonatomic, strong) NSDictionary *params;
//新闻列表数组
@property (nonatomic, strong) NSArray *newsListArray;
@end
