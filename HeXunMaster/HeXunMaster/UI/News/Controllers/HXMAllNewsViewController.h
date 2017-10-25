//
//  HXMAllNewsViewController.h
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/3/21.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMBaseViewController.h"
#import "HXMDetailNewsCellModel.h"
#import "HXMBaseViewController.h"

@interface HXMAllNewsViewController : HXMBaseViewController

@property (nonatomic, assign) NSInteger selecteIndex;//横着滚动选择的新闻类型
@property (nonatomic, strong) NSMutableArray <HXMDetailNewsCellModel* >*dataListArray;//数据源
@property (nonatomic, copy) NSString *type_id;
@property (nonatomic, copy) NSString *module_id;
@property (nonatomic, copy) NSString *next_id;
@property (nonatomic, copy) NSString *btnTitle;
@property (nonatomic, copy) NSString *reportType;//子标题的report类型
@property (nonatomic, assign) BOOL isInformationNews;//是情报新闻，默认是0
@property (nonatomic, assign) NewsListRequestType allNewsRequestType;//获取请求类型
@property (nonatomic, assign) BOOL isTotalVolumeNews;//是否是全部新闻

@end
