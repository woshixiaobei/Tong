//
//  HXMDeleteAllCollectionViewModel.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/5/10.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXMDeleteAllCollectionViewModel : NSObject
@property (nonatomic, strong, readonly)RACSignal *requestDeleAllSignal;
@end
