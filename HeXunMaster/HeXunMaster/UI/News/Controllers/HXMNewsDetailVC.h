//
//  HXMNewsDetailVC.h
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/4/10.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXMBaseViewController.h"

@interface HXMNewsDetailVC : HXMBaseViewController
@property (nonatomic, copy) NSString *module_id;
@property (nonatomic, copy) NSString *type_id;
@property (nonatomic, copy) NSString *newsId;
@property (nonatomic, copy) NSString *btnTitle;
@property (nonatomic, assign) BOOL newsIsPush;//是否是推送过来的
@property (nonatomic, assign) NewsDetailByNewsType newsDetailType;
@end
