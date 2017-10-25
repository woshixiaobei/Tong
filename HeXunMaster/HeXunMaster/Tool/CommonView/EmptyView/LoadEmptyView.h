//
//  LoadEmptyView.h
//  TrainingClient
//
//  Created by 蔡建海 on 16/1/22.
//  Copyright © 2016年 HeXun. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MacroConst.h"
typedef void (^BlockNoArgument)(void);

@interface LoadEmptyView : UIView


// 您还没有关注老师哦 （老师空页面）


/**
 空视图页面视图
 */
@property (nonatomic, strong) UIImageView *iEmptyView;
/**
 空视图页面文案
 */
@property (nonatomic, strong) UILabel *labelDetail;

+ (instancetype)emptyViewWithFrame:(CGRect)frame reloadBlock:(BlockNoArgument)reloadBlock;

- (void)endLoading;

@end
