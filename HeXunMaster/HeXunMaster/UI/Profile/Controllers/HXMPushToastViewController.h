//
//  HXMPushToastViewController.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/5/5.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXMBaseViewController.h"

typedef enum : NSUInteger {
    alertViewStyleTypeNeedOpenPush,
    alertViewStyleTypeCheckInformation,
} alertViewStyleType;

@interface HXMPushToastViewController : HXMBaseViewController
//展示弹框的样式
@property (nonatomic, assign) alertViewStyleType alertType;
@end
