//
//  HXMCollectionViewModel.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/5/2.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXMCollectionViewModel : NSObject
@property (nonatomic, strong, readonly)RACSignal *requestCollectionNewsListSignal;
@property (nonatomic, strong) NSMutableDictionary *params;
@end
