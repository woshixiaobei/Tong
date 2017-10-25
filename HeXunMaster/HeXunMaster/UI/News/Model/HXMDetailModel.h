//
//  HXMDetailModel.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/31.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXMDetailModel : NSObject
//
@property (nonatomic, copy) NSString *moduleId;//模型id
@property (nonatomic, copy) NSString *id;//编号id
@property (nonatomic, copy) NSString *newsUrl;//新闻地址
@property (nonatomic, copy) NSString *newsContent;//新闻内容
@property (nonatomic, copy) NSString *newsAuthor;//新闻授权
@property (nonatomic, copy) NSString *sourceNewsMedia;//转自
@property (nonatomic, copy) NSString *newsMedia;//来源
@property (nonatomic, copy) NSString *newsTitle;//标题
@property (nonatomic, assign) BOOL isFavorite;//是否收藏,0是没有,1收藏
//@property (nonatomic,  copy) NSString* postTime;
@property (nonatomic, assign) NSTimeInterval postTime;//发布时间
@property (nonatomic, copy) NSString *favoriteId;//未收藏的id
@end
