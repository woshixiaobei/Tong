//
//  HXNavigationViewController.h
//  TrainingClient
//
//  Created by wangmingzhu on 17/3/8.
//  Copyright © 2015年 HeXun. All rights reserved.
//


#if __has_include("RTRootNavigationController.h")
#import "RTRootNavigationController.h"

@interface HXNavigationViewController : RTRootNavigationController
@end
#else
#import <UIKit/UIKit.h>

@interface HXNavigationViewController : UINavigationController
@end
#endif
