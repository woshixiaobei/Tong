//
//  LoadFailView.h
//  TrainingClient
//
//  Created by 李帅 on 15/12/31.
//  Copyright © 2015年 HeXun. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^BlockNoArgument)(void);


@interface LoadFailView : UIView

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UILabel                 *labelFail;
@property (nonatomic, copy  ) BlockNoArgument         reload;
@property (nonatomic, strong) UIImageView             *iFailView;

+ (instancetype)failViewWithFrame:(CGRect)frame reloadBlock:(BlockNoArgument)reloadBlock;
- (void)endLoading;
- (void)reloadData;

@end
