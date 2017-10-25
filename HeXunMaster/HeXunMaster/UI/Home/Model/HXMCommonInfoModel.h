//
//  HXMCommonInfoModel.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/24.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXMCommonInfoModel : NSObject

@property (nonatomic, copy)NSString           *pTitle;
@property (nonatomic, copy)UIColor            *pStokeColor;
@property (nonatomic, assign)CGFloat           nPercent;
+ (instancetype)moneyModelWithColor:(UIColor *)color percent:(CGFloat)percent title:(NSString *)title;
@end
