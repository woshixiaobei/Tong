//
//  HXMDetailNewsCellModel.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/23.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXMDetailNewsCellModel : NSObject
@property (nonatomic, assign) NSInteger module;
@property (nonatomic, copy) NSString *id;//新闻id
@property (nonatomic, copy) NSString *newsPositive;//正面新闻性质
@property (nonatomic, copy) NSString *newsMedia;//新闻媒体
@property (nonatomic, copy) NSString *newsResume;//新闻概述
@property (nonatomic, copy) NSString *newsTitle;//新闻标题
@property (nonatomic, assign) NSTimeInterval postTime;//发送时间
@property (nonatomic, assign) NSInteger sameNewsCount;//相似新闻个数
@property (nonatomic, copy) NSString *newsAuthor;//新闻作者
@property (nonatomic, assign) NSInteger newsType;//新闻类型
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, copy) NSString *newsUrl;//复制链接
@property (nonatomic, copy) NSString *favoriteId;//收藏id
@property (nonatomic, copy) NSString *isFavorite;//是否被收藏
@property (nonatomic, strong) NSString *moduleId;//moduleId
@property (nonatomic, assign) NSInteger isIntelligence;//是否是情报
@end
