//
//  MYCircelChartView.h
//  HeXun-zixuan
//
//  Created by 范名扬 on 16/8/8.
//  Copyright © 2016年 com.hztc. All rights reserved.
//
//  ******************* 动画效果的环形图 *********************

#import <UIKit/UIKit.h>

@interface MYCircelChartView : UIView<CAAnimationDelegate>
@property (nonatomic, strong)NSArray                *pCircleArrayM;

/* 内环空白处半径 */
@property (nonatomic, assign)CGFloat                 nRadius;
/* 环形宽度 */
@property (nonatomic, assign)CGFloat                 nCircleWidth;
/* 内环空白处文字 */
@property (nonatomic, copy)NSString                 *pCircleText;
/* 内环空白处文字颜色 */
@property (nonatomic, strong)UIColor                *pCircleTextColor;
/* 内环空白处文字大小 */
@property (nonatomic, assign)CGFloat                 nCircleTextSize;

/* 每部分文本大小 */
@property (nonatomic, assign)CGFloat                 nStrokeTextSize;

@property (nonatomic, assign) bool isHasCircle;
@property (nonatomic, assign) BOOL isFull;
- (void)clearData;
@end
