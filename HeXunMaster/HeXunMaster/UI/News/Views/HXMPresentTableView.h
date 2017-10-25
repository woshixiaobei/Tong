//
//  HXMPresentTableView.h
//  renrentong
//
//  Created by wangmingzhu on 2017/3/9.
//  Copyright © 2017年 com.lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXMPresentTableView : UIView

@property (nonatomic, copy) NSString *selectedIndex;
@property (nonatomic, copy) void(^ clickedImageCallback)(NSString * imageIndex, NSString * gradeIndex);
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSArray *gradeArr;
@property (nonatomic, copy) NSString *btnTitle;
@property (nonatomic, assign) NSInteger btnTag;
@end
