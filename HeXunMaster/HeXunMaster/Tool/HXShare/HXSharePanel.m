//
//  SharePanelView.m
//  TrainingClient
//
//  Created by 李帅 on 15/12/23.
//  Copyright © 2015年 HeXun. All rights reserved.
//

#import "HXSharePanel.h"
#import "SharePlatformButtoon.h"
#import "Masonry.h"

CGFloat HXSharePanelHeight = 261.0;

@interface HXSharePanel ()

@property (nonatomic, weak) UIView *sharePanelView;
@property (nonatomic, weak) UIButton *cancleButton;
@property (nonatomic, weak) UIView *line;
@end

@implementation HXSharePanel {
    NSArray *_sharePlatformTitleDataSource; // 分享面板平台 title 数组
    NSArray *_sharePlatformIconDataSource; // 分享面板平台 icon 数组
}

#if __has_include("UMSocialConfig.h")

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = CGRectMake(0, 0, Screen_width, Screen_height);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        
        // 创建分享平台的按钮
        [self configurationButton];
        
        @weakify(self)
        [self setDismissCompletion:^{
            
            for (int i = 0; i < self.sharePanelView.subviews.count; i++) {
                @strongify(self)
                UIButton *button = self.sharePanelView.subviews[i];
                if ([button isKindOfClass:[SharePlatformButtoon class]]) {
                    
                    [UIView animateWithDuration:kAnimationDurationTime delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        @strongify(self)
                        self.alpha = 0.0;
                        
                        button.transform = CGAffineTransformMakeTranslation(0, HXSharePanelHeight);
                        
                    } completion:^(BOOL finished) {
                        @strongify(self)
                        [self removeFromSuperview];
                    }];
                }
            }
        }];
    }
    return self;
}

- (void)configurationButton {
    
    UIView *sharePanelView = [UIView new];
    sharePanelView.backgroundColor = UIColorHex(#f5f5f5);
    [self addSubview:sharePanelView];
    self.sharePanelView = sharePanelView;
    
    @weakify(self)
    [sharePanelView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(HXSharePanelHeight);
    }];
    
    _sharePlatformTitleDataSource = @[@"微信好友", @"微信朋友圈", @"新浪微博", @"QQ"];
    _sharePlatformIconDataSource = @[[UIImage imageNamed:@"share_wechat"], [UIImage imageNamed:@"share_wechat_time_line"], [UIImage imageNamed:@"share_sina"], [UIImage imageNamed:@"share_qq"]];
    
    CGFloat cancleButtonHeight = 48.0;
    CGFloat shareButtonWidth = Screen_width / _sharePlatformTitleDataSource.count;
    
    
    for (int i = 0; i < _sharePlatformTitleDataSource.count; i++) {
        
        SharePlatformButtoon *shareButton = [[SharePlatformButtoon alloc] init];
        [shareButton setTitle:_sharePlatformTitleDataSource[i] forState:UIControlStateNormal];
        [shareButton setImage:_sharePlatformIconDataSource[i] forState:UIControlStateNormal];
        [shareButton setTitleColor:UIColorHex(#999999) forState:UIControlStateNormal];
        shareButton.titleLabel.contentMode = UIViewContentModeTop;
        shareButton.tag = i + 20;
        shareButton.transform = CGAffineTransformMakeTranslation(0, HXSharePanelHeight);
        
        [UIView animateWithDuration:kAnimationDurationTime delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            shareButton.transform = CGAffineTransformIdentity;
            
        } completion:nil];
        
        
        [sharePanelView addSubview:shareButton];
        [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.top.equalTo(sharePanelView).offset(20);
            make.width.equalTo(self).dividedBy(_sharePlatformTitleDataSource.count);
            make.left.mas_equalTo(i * shareButtonWidth);
            make.height.equalTo(sharePanelView).offset(-cancleButtonHeight);
        }];
        [[shareButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *button) {
            @strongify(self)
            if (self.dismissCompletion) {
                self.dismissCompletion();
            }
            
//            if (self.didClickPlatformButton) {
//                self.didClickPlatformButton(button.tag);
//            }
            
            if (self.shareAPI) {
                self.shareAPI.shareType = button.tag;
                [self.shareAPI shareResult:^(UMSResponseCode code){
                    
                }];
            }
            
        }];
    }
    
    
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.backgroundColor = UIColorHex(#f5f5f5);
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [cancleButton setTitleColor:UIColorHex(#444444) forState:UIControlStateNormal];
    self.cancleButton = cancleButton;
    [self addSubview:cancleButton];
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.width.equalTo(sharePanelView);
        make.height.mas_equalTo(cancleButtonHeight);
    }];
    
    [[cancleButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (self.dismissCompletion) {
            self.dismissCompletion();
        }
    }];
    
    
    UIView *lineV = [UIView new];
    lineV.backgroundColor = UIColorHex(#cccccc);
    self.line = lineV;
    [self addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(cancleButton.mas_top);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.dismissCompletion) {
        self.dismissCompletion();
    }
}

- (void)show {
    [UIView animateWithDuration:kAnimationDurationTime animations:^{
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }];
}

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}
#endif
@end
