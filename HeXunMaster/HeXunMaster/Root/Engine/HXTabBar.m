//
//  FSTabBar.m
//  CustomApp
//
//  Created by cjh on 13-6-27.
//  Copyright (c) 2016年 cjh. All rights reserved.
//

#import "HXTabBar.h"

@interface HXTabBar ()
{
    NSArray *_imageNormal;
    NSArray *_imageSelect;
    NSArray *_tabTitle;
    NSMutableArray *_marrayButton;
    UIImageView *_tabbarTopLine;
    UIImageView *_newMessDot;
}

@property (nonatomic, strong) UIImageView *redIcon;
@property (nonatomic, strong) UILabel *labelCount;
/** 我的红点(不同于财圈的红点) */
@property (nonatomic, weak) UIImageView *meRedDot;

@end

@implementation HXTabBar
@synthesize selectIndex = _selectIndex;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    
    _imageNormal = @[@"tabbar_icon_home_normal",@"tabbar_icon_news_normal",@"tabbar_icon_information_normal",@"tabbar_icon_profile_normal"];
    _imageSelect = @[@"tabbar_icon_home_highlight",@"tabbar_icon_news_highlight",@"tabbar_icon_information_highlight",@"tabbar_icon_profile_highlight"];
    _tabTitle = @[@"首页", @"新闻", @"情报",@"个人中心"];
    _marrayButton = [[NSMutableArray alloc] initWithCapacity:4];
    
//    self.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    [self drawMainUI];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateItemModel) name:NOTIFICATIONMESSAGERECEIVED object:nil];
    
    return self;
}

//
- (void)drawMainUI
{
    NSInteger count = _imageNormal.count;
    
    UIImage *image = [UIImage imageNamed:[_imageNormal objectOrNilAtIndex:0]];
    
    CGFloat widthButton = self.width/4;
    CGSize sizeIcon = image.size;
    
    UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    viewBG.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self addSubview:viewBG];
    
    for(NSInteger i = 0; i<count; ++i) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(0, 0, widthButton, self.height);
        [button setImage:[UIImage imageNamed:[_imageNormal objectOrNilAtIndex:i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[_imageSelect objectOrNilAtIndex:i]] forState:UIControlStateSelected];
        [button setTitle:[_tabTitle objectOrNilAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#505050"] forState:UIControlStateNormal];
        [button setTitleColor: [UIColor colorWithHexString:@"#3c5c8e"]forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:10.0f];
        
        // 先全部移到最左端，
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        CGSize sizeTitle = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}];
        
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, widthButton/2 - sizeIcon.width/2, 12, 0)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(28, widthButton/2 - sizeIcon.width - sizeTitle.width/2 + 0.5, 0, 0)];
        
        [self addSubview:button];
        button.center = CGPointMake(widthButton/2 + widthButton*i, button.centerY);
        [_marrayButton addObject:button];
        if (i == 2) {
            [self showNew];
//            CGFloat width = button.currentImage.size.width;
//            CGFloat height = self.height + button.currentImage.size.height - sizeIcon.height;
//            button.bottom = self.bottom;
//            button.centerX = self.centerX;
//            [button setImageEdgeInsets:UIEdgeInsetsMake(self.height - height - 15,widthButton/2 - width/2,0,0)];
//            [button setTitleEdgeInsets:UIEdgeInsetsMake(28, widthButton/2 - width - sizeTitle.width/2 + 0.5, 0, 0)];
        }
    }
    
    //    sel_count_bk
    UIImage *imageRed = [UIImage imageNamed:@"sel_count_bk"];
    UIImage *imageRedStre = [imageRed stretchableImageWithLeftCapWidth:imageRed.size.width/2 topCapHeight:imageRed.size.height/2];
    
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageRed.size.width, imageRed.size.height)];
    icon.image = imageRedStre;
    icon.layer.cornerRadius = icon.size.width/2;
    icon.clipsToBounds = YES;
    icon.backgroundColor = [UIColor clearColor];
    
    // 财圈按钮
    UIButton *button = [_marrayButton firstObject];
    [button addSubview:icon];
    
    icon.hidden = YES;
    
    self.redIcon = icon;
    
    UILabel *label = [[UILabel alloc]initWithFrame:self.redIcon.bounds];
    label.font = [UIFont systemFontOfSize:12.0];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.redIcon addSubview:label];
    self.labelCount = label;
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#aaaaaa"];
    [self addSubview:line];
    
    // 给我的按钮添加红点
    [self setupMeButtonRedDot];
    
//    [self updateItemModel];
}

- (void)showNew
{
    
    UIButton *button = _marrayButton[2];
    UIImageView *new = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabbar_live_icon_new"]];
    [button addSubview:new];
    [new mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(button.imageView.mas_top).offset(15);
        make.left.equalTo(button.imageView.mas_left).offset(button.currentImage.size.width/2 + 9);
    }];
}

// 给我的按钮添加红点
- (void)setupMeButtonRedDot {
    UIImage *redDotImage = [[UIImage imageNamed:@"sel_count_bk"] imageByResizeToSize:CGSizeMake(10, 10)];
    UIImageView *meRedDot = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, redDotImage.size.width, redDotImage.size.height)];
    meRedDot.hidden = YES;
    meRedDot.image = redDotImage;
    self.meRedDot = meRedDot;
    // 我的按钮
    UIButton *meButton = [_marrayButton lastObject];
    [meButton addSubview:meRedDot];
    meRedDot.center = CGPointMake(meButton.size.width - 30, meRedDot.height / 2 + 4);
    meRedDot.left = meButton.width / 2 + 2 ;
    
}

//- (void)updateItemModel {
//    MessageCountModel *countModel = [[[GlobalData shareGlobalData] countMessage] getMessageCount];
//    [self setredIconOffset:countModel];
//}

//
//- (void)setredIconOffset:(MessageCountModel *)model {

//    // 我的按钮的红点判断
//    if (model.articleCommentCount > 0 || model.systemCount > 0 || model.chatCommentCount > 0 || model.qaUnReadCount > 0 || model.myPrivateOpinionUnReadCount > 0) {
//        self.meRedDot.hidden = NO;
//    } else {
//        self.meRedDot.hidden = YES;
//    }
//    
//    // 财圈按钮的红点判断
//    if (model.articleCount == 0) {
//        self.redIcon.hidden = YES;
//        return;
//    }
//    
//    self.redIcon.hidden = NO;
//    
//    NSString *text = @"";
//    if (model.articleCount > 99) {
//        text = @"99+";
//    }
//    else
//        text = [NSString stringWithFormat:@"%li", model.articleCount];
    
//    self.labelCount.text = text;
//    
//    CGFloat minWidth =  [UIImage imageNamed:@"sel_count_bk"].size.width;
//    
//    CGSize sizeText = [text sizeForFont:self.labelCount.font size:CGSizeMake(Screen_width, minWidth) mode:NSLineBreakByCharWrapping];
//    
//    CGFloat realWidth = MAX(sizeText.width + 5, minWidth);
//    
//    self.redIcon.width = realWidth;
//    self.labelCount.width = realWidth;
//    
//    UIButton *button = [_marrayButton firstObject];
//    
//    self.redIcon.center = CGPointMake(button.size.width - 30, self.redIcon.height/2 + 4);
//    self.redIcon.left = button.width/2 + 2 ;
//    self.labelCount.center = CGPointMake(self.redIcon.width/2, self.redIcon.height/2);
//    
//}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    
    NSInteger tabItemCount = _imageNormal.count;
    
    for (int i =0; i < tabItemCount; i++) {
        
        UIButton *button = (UIButton *)[_marrayButton objectOrNilAtIndex:i];
        button.selected = (self.selectIndex == i);
    }
}

- (void)drawRect:(CGRect)rect
{
    NSInteger tabItemCount = _imageNormal.count;
    
    for (int i =0; i < tabItemCount; i++) {
        
        UIButton *button = (UIButton *)[_marrayButton objectOrNilAtIndex:i];
        button.selected = (self.selectIndex == i);
    }
}

@end
