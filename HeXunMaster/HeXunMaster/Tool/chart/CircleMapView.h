//
//  CircleMapView.h
//  CircleConstructionMAP
//
//  Created by wangmingzhu on 16/8/20.
//  Copyright © 2016年 wangmingzhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleMapView : UIView
@property(nonatomic , assign) CGRect fFrame;
@property(nonatomic , strong) NSMutableArray *dataArray; //数据数组
@property(nonatomic , assign) CGFloat circleRadius;//半径
@property (nonatomic, strong) NSArray *colorArr;
//初始化
-(instancetype)initWithFrame:(CGRect)frame andWithDataArray:(NSMutableArray *)dataArr andWithCircleRadius:(CGFloat)circleRadius;
@end
