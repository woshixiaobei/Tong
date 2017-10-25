//
//  HXServerTime.h
//  TouGuBackStage
//
//  Created by 蔡建海 on 16/11/16.
//  Copyright © 2016年 hexun. All rights reserved.
//

//

#import <Foundation/Foundation.h>

#import "Singleton.h"

@interface HXServerTime : NSObject
singleton_h(HXServerTime);

// 秒值
@property (nonatomic, assign) double serverTime;

@end
