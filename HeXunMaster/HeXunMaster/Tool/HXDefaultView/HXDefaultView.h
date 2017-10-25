//
//  HXDefaultView.h
//  HXDefaultView
//
//  Created by EasonWang on 2016/12/20.
//  Copyright © 2016年 EasonWang. All rights reserved.
//
//  缺省页，根据 HXDefaultViewType 类型分为空页面与失败页面


#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,HXDefaultViewType) {
    HXDefaultViewType_none  = 0,
    HXDefaultViewType_empty = 1<<0,
    HXDefaultViewType_fail  = 1<<1,
};

typedef void (^HXDefaultViewBlock)(HXDefaultViewType type);

@interface HXDefaultView : UIView

/**
 缺省页文案描述，你不需要通过此属性对文案赋值，此属性可用来设置label字体、颜色等。
 */
@property (nonatomic, strong) UILabel *defaultMessageLabel;

/// 缺省页类型，默认为空页面。
@property (nonatomic, assign) HXDefaultViewType defaultViewType;
/**
 是否允许接收空页面点击事件，默认为 YES
 */
@property (nonatomic, assign) BOOL emptyEventEnable;

/**
 是否允许接收失败页面点击事件，默认为YES
 */
@property (nonatomic, assign) BOOL failEventEnable;

/**
 缺省页点击事件block
 */
@property (nonatomic, copy) HXDefaultViewBlock defaultViewReload;

/**
 初始化缺省页视图
 
 @param frame 缺省页尺寸
 @param reloadBlock 缺省页点击事件通过 block 返回。Block的返回值确定是否触发点击事件。
 @return 返回缺省页对象
 */
- (instancetype)initWithFrame:(CGRect)frame reloadBlock:(HXDefaultViewBlock)reloadBlock;

/**
 设置缺省页类型，可用于在空视图与失败视图之间切换，切换时活动指示器动画将终止
 
 @param type 缺省页类型
 */
- (void)defaultViewType:(HXDefaultViewType)type;

/**
 自定义为指定缺省类型设置缺省图
 
 
 缺省页在初始化之初已设置好默认的缺省图，如不符合需求则可通过此方法进行重新赋值。
 
 @param image 缺省图片
 @param type 缺省类型
 */
- (void)defaultImage:(UIImage*)image forDefaultViewType:(HXDefaultViewType)type;

/**
 为指定缺省类型设置缺省文字描述
 
 
 失败页已存在默认文案：“点击屏幕，重新加载”.
 
 @param message 缺省内容描述
 @param type 缺省类型
 */
- (void)defaultMessage:(NSString*)message forDefaultViewType:(HXDefaultViewType)type;

@end


@interface HXDefaultViewSetting : NSObject

singleton_h(HXDefaultViewSetting)

@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, strong) UIFont *msgFont;

@property (nonatomic, strong) UIColor *msgColor;

@property (nonatomic, strong) UIImage *loadFailImage;




@end
