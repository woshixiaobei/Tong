//
//  HXDefaultView.m
//  HXDefaultView
//
//  Created by EasonWang on 2016/12/20.
//  Copyright © 2016年 EasonWang. All rights reserved.
//

#import "HXDefaultView.h"

@implementation HXDefaultViewSetting

singleton_m(HXDefaultViewSetting)
- (UIColor *)backgroundColor
{
    if (!_backgroundColor) {
        _backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    }
    return _backgroundColor;
}

@end


CGFloat heightGap = 30.0f;
CGFloat defaultlableWidth = 200.0f;

@interface HXDefaultView ()
{
    HXDefaultViewSetting *_setting;
    BOOL _isLoading;
}

@property (nonatomic, copy) HXDefaultViewBlock reload;


/// 缺省图 imageView
@property (nonatomic, strong) UIImageView *defaultImageView;
/// 活动指示器
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
/// 缺省图片字典
@property (nonatomic, strong) NSMutableDictionary *defaultImageDict;
/// 缺省文案字典
@property (nonatomic, strong) NSMutableDictionary *defaultMessageDict;

@property (nonatomic, strong) UIView *groundView;

@end

@implementation HXDefaultView

- (instancetype)initWithFrame:(CGRect)frame reloadBlock:(HXDefaultViewBlock)reloadBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        self.reload = reloadBlock;
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}

- (void)commonInit {
    _setting = [HXDefaultViewSetting shareHXDefaultViewSetting];
    
    UIImage *emptyImage = [UIImage imageNamed:@"HXDefaultImage_empty"];
    UIImage *failImage = _setting.loadFailImage?_setting.loadFailImage:[UIImage imageNamed:@"HXDefaultImage_fail"];
    self.defaultImageDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:emptyImage,@(HXDefaultViewType_empty),failImage,@(HXDefaultViewType_fail), nil];
    
    self.defaultMessageDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@(HXDefaultViewType_empty),@"点击屏幕，重新加载",@(HXDefaultViewType_fail), nil];
    
    [self drawMainUI];
    [self gestureRecognizer];
}

- (void)gestureRecognizer
{
    self.emptyEventEnable = YES;
    self.failEventEnable = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadData)];
    [self addGestureRecognizer:tap];
    
}

- (void)drawMainUI
{
    self.backgroundColor = _setting.backgroundColor?_setting.backgroundColor:[UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1];
    
    self.groundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 0)];
    self.groundView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.groundView];
    
    UIImage *emptyImage = self.defaultImageDict[@(HXDefaultViewType_empty)];
    
    UIImageView *emptyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, emptyImage.size.width, emptyImage.size.height)];
    emptyImageView.backgroundColor = [UIColor clearColor];
    emptyImageView.image = emptyImage;
    [self.groundView addSubview:emptyImageView];
    self.defaultImageView = emptyImageView;
    
    
    [self.groundView addSubview:self.defaultMessageLabel];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0, 0, 20, 20);
    indicator.hidesWhenStopped = YES;
    indicator.backgroundColor = [UIColor clearColor];
    [self.groundView addSubview:indicator];
    self.activityIndicator = indicator;
    
    [self resetContentCenter];
    
    [self defaultViewType:HXDefaultViewType_none];
    
}
/// 调整内容中心点
- (void)resetContentCenter
{
    self.defaultImageView.center = CGPointMake(CGRectGetWidth(self.groundView.frame)/2.0, self.defaultImageView.center.y);
    
    self.defaultMessageLabel.center = CGPointMake(self.groundView.center.x, self.defaultMessageLabel.center.y);
    
    self.groundView.frame = ({
        CGRect nFrame = self.groundView.frame;
        nFrame.size.height = CGRectGetMaxY(self.defaultMessageLabel.frame);
        nFrame;
    });
    
    self.groundView.center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0-50);
    self.activityIndicator.center = CGPointMake(CGRectGetWidth(self.groundView.frame)/2.0, self.defaultMessageLabel.center.y-20);
}

/**
 停止活动指示器动画
 */
- (void)endLoading
{
    [self.activityIndicator stopAnimating];
}

- (void)defaultViewType:(HXDefaultViewType)type
{
    self.defaultViewType = type;
    [self endLoading];
}

/**
 为指定缺省类型设置缺省图
 
 
 缺省页在初始化之初已设置好默认的缺省图，如不符合需求则可通过此方法进行重新赋值。
 
 @param image 缺省图片
 @param type 缺省类型
 */
- (void)defaultImage:(UIImage*)image forDefaultViewType:(HXDefaultViewType)type
{
    // 设置空视图、错误视图
    if (type&(HXDefaultViewType_empty|HXDefaultViewType_fail)&&image) {
        [self.defaultImageDict setObject:image forKey:@(type)];
    }
}

/**
 为指定缺省类型设置缺省文字描述
 
 
 失败页已存在默认文案：“点击屏幕，重新加载”.
 
 @param message 缺省内容描述
 @param type 缺省类型
 */
- (void)defaultMessage:(NSString*)message forDefaultViewType:(HXDefaultViewType)type
{
    // 设置空视图文案、错误视图文案
    if (type&(HXDefaultViewType_empty|HXDefaultViewType_fail)&&message) {
        [self.defaultMessageDict setObject:message forKey:@(type)];
    }
}

- (void)reloadData {
    if ((self.defaultViewType&HXDefaultViewType_empty && self.emptyEventEnable) || (self.defaultViewType&HXDefaultViewType_fail && self.failEventEnable)) {
        if (self.reload && !self.activityIndicator.isAnimating) {
            self.reload(self.defaultViewType);
            [self.activityIndicator startAnimating];
        }
    }
}

#pragma mark - setter

- (void)setDefaultViewType:(HXDefaultViewType)defaultViewType
{
    _defaultViewType = defaultViewType;
    
    if (_defaultViewType == HXDefaultViewType_none) {
        self.hidden = YES;
    }else{
        self.hidden = NO;
        
        UIImage *image = self.defaultImageDict[@(_defaultViewType)];
        if (image) {
            self.defaultImageView.frame = ({
                CGRect nFrame = self.defaultImageView.frame;
                nFrame.size = image.size;
                nFrame;
            });
            self.defaultImageView.image = image;
            
            self.defaultMessageLabel.frame = ({
                CGRect nFrame = self.defaultMessageLabel.frame;
                nFrame.origin.y = CGRectGetHeight(self.defaultImageView.frame)+heightGap;
                nFrame;
            });
        }
        
        NSString *message = self.defaultMessageDict[@(_defaultViewType)];
        if (message) {
            self.defaultMessageLabel.text = message;
        }
        [self resetContentCenter];
    }
}

- (void)setDefaultViewReload:(HXDefaultViewBlock)defaultViewReload {
    _defaultViewReload = defaultViewReload;
    self.reload = _defaultViewReload;
}

#pragma mark - getter
- (UILabel *)defaultMessageLabel
{
    if (!_defaultMessageLabel) {
        _defaultMessageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.defaultImageView.frame)+heightGap, defaultlableWidth, 20)];
        _defaultMessageLabel.backgroundColor = [UIColor clearColor];
        _defaultMessageLabel.textAlignment = NSTextAlignmentCenter;
        _defaultMessageLabel.font = _setting.msgFont?_setting.msgFont:[UIFont systemFontOfSize:14.f];
        _defaultMessageLabel.textColor = _setting.msgColor?_setting.msgColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    }
    return _defaultMessageLabel;
}


@end
