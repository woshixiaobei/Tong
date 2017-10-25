//
//  HXMFocusNewsCell.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/15.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMFocusNewsCell.h"
#import "NSString+date.h"
#import "ActionSharedView.h"
#import "HXMSimilarNewsController.h"
#import "HXShareAPI.h"
#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"
#import "HXSharePanel.h"
#import "HXMAddCollectionViewModel.h"
#import "HXMDeleteMultipleCollectionViewModel.h"
#import "HXMProgressHUD.h"
#import "HXMCancleCollectionNewsDetailViewModel.h"
@interface HXMFocusNewsCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commonLevelLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (nonatomic, copy) NSString *favoriteId;//收藏成功之后id
@property(copy ,nonatomic) NSString *shareUrl;//分享网页
@property(copy ,nonatomic) NSString *shareTitle; // 分享标题
@property(strong ,nonatomic) UIImage *shareImage; // 分享图片
@property(copy ,nonatomic) NSString *shareSummary; // 分享摘要

@property (nonatomic, strong) HXMAddCollectionViewModel *addCollectionViewModel;//添加收藏视图模型
@property (nonatomic, strong) HXMCancleCollectionNewsDetailViewModel *cancleCollectionViewModel;//取消收藏视图模型

@end

@implementation HXMFocusNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _isCollection = NO;
    self.commonLevelLabel.textAlignment = NSTextAlignmentCenter;
    self.commonLevelLabel.layer.cornerRadius = 3;
    self.commonLevelLabel.layer.masksToBounds = YES;
    self.commonLevelLabel.layer.borderWidth = 1;
    self.commonLevelLabel.layer.borderColor =  ([UIColor colorWithHexString:@"#c7b496"]).CGColor;
    self.commonLevelLabel.textColor = [UIColor colorWithHexString:@"#c7b496"];
    self.similarNewsButton.titleLabel.text = @"0条相似新闻";
    self.backgroundColor = [UIColor whiteColor];
    [self.similarNewsButton addTarget:self action:@selector(pushToSimilarController:) forControlEvents:UIControlEventTouchUpInside];
    
    self.collectionButton.hidden = YES;
    self.shareButton.hidden = YES;
    self.similarNewsButton.hidden = YES;
}

//点击进入相似新闻列表
- (void)pushToSimilarController:(UIButton *)sender {
    if ( self.delegate && [self.delegate respondsToSelector:@selector(pushToSimilarNewsCell:news_id:)]) {
        [self.delegate pushToSimilarNewsCell:self news_id:self.model.id];
    }
}

- (UIViewController*)getviewController {
    for (UIView*next = [self superview];next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

//重写setter方法
- (void)setModel:(HXMDetailNewsCellModel *)model {
    _model = model;
    
    self.titleLabel.text = model.newsTitle;
    self.contentLabel.text = model.newsResume;
    if (model.newsMedia.length>6) {
        NSString *str = [model.newsMedia substringWithRange:NSMakeRange(0, 6)];
        NSString *newsMedia = [NSString stringWithFormat:@"%@...",str];
        self.sourceLabel.text = newsMedia;
    } else {
        
        self.sourceLabel.text = model.newsMedia;
    }
    self.commonLevelLabel.layer.borderColor = ([UIColor colorWithHexString:@"#c7b496"]).CGColor;
    
    if ([model.newsPositive isEqualToString:@"中性"]) {
        self.commonLevelLabel.text = @"中性";
        self.commonLevelLabel.layer.borderColor = ([UIColor colorWithHexString:@"#c7b496"]).CGColor;
        self.commonLevelLabel.textColor = [UIColor colorWithHexString:@"#c7b496"];
        
    }else if ([model.newsPositive isEqualToString:@"正面"]) {
        self.commonLevelLabel.text = @"正面";
        self.commonLevelLabel.layer.borderColor = ([UIColor colorWithHexString:@"#688fca"]).CGColor;
        self.commonLevelLabel.textColor = [UIColor colorWithHexString:@"#688fca"];
        
    }else if ([model.newsPositive isEqualToString:@"负面"]) {
        self.commonLevelLabel.text = @"负面";
        self.commonLevelLabel.layer.borderColor = ([UIColor colorWithHexString:@"#e0514c"]).CGColor;
        self.commonLevelLabel.textColor = [UIColor colorWithHexString:@"#e0514c"];
    }
    if (model.isIntelligence == 1) {
        self.commonLevelLabel.text = @"情报";
        self.commonLevelLabel.layer.borderColor = ([UIColor colorWithHexString:@"#c7b496"]).CGColor;
        self.commonLevelLabel.textColor = [UIColor colorWithHexString:@"#c7b496"];
    }
    
    NSString *createdTime = [self isToday:self.model.postTime/1000];
    self.sourceTimeLabel.text = createdTime;
    //判断是新闻
    if ([self.btnTitle isEqual:@"微博新闻"]) {
        self.titleLabel.text = model.newsAuthor;
        self.contentLabel.numberOfLines = 5;
        self.collectionButton.hidden = NO;
        self.shareButton.hidden = NO;
        if ([self.model.isFavorite isEqualToString:@"0"]) {
            self.collectionButton.selected = NO;
        } else {
            self.collectionButton.selected = YES;
        }
    } else {
        if (_isInformationNews) {
            //判断是情报
            self.commonLevelLabel.hidden = YES;
            [self.sourceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
                make.left.equalTo(self.contentLabel);
                make.bottom.equalTo(self.contentView).offset(-16);
            }];
        }
        self.titleLabel.text = model.newsTitle;
        self.similarNewsButton.hidden = NO;
        if (model.sameNewsCount>0&&model.sameNewsCount<999) {
            NSString *titleName = [NSString stringWithFormat:@"%ld条相似新闻",(long)model.sameNewsCount];
            [self.similarNewsButton setTitle:titleName forState:UIControlStateNormal];
            self.similarNewsButton.hidden = NO;
            
        } else if (model.sameNewsCount >999) {
            NSString *titleName = [NSString stringWithFormat:@"999+条相似新闻"];
            [self.similarNewsButton setTitle:titleName forState:UIControlStateNormal];
            self.similarNewsButton.hidden = NO;
            
        }else {
            self.similarNewsButton.hidden = YES;
        }
    }
}

//添加收藏接口
- (void)requestAddCollectionSignal {
    
    self.addCollectionViewModel.params = [@{@"newsId":self.model.id,@"moduleId":self.module_id} mutableCopy];
    [HXMProgressHUD showInView:[UIApplication sharedApplication].keyWindow];
    [self.addCollectionViewModel.requestAddSignal subscribeNext:^(id x) {
        
        [HXMProgressHUD hide];
        [HXMProgressHUD showCenterMessage:@"收藏成功"];
        self.model.isFavorite = @"1";
        
    } error:^(NSError *error) {
        [HXMProgressHUD hide];
        [HXMProgressHUD showError:@"网络出错,请重新加载..." inview:self.superview];
        
    } completed:^{
        
    }];
}
//取消收藏接口
- (void)requestDeleteCollectionSignal {
    
    self.cancleCollectionViewModel.params = [@{@"newsId":self.model.id,@"moduleId":self.module_id} mutableCopy];
    
    [HXMProgressHUD showInView:[UIApplication sharedApplication].keyWindow];
    [self.cancleCollectionViewModel.cancleCollectionNewsSignal subscribeNext:^(id x) {
        
        [HXMProgressHUD hide];
        [HXMProgressHUD showCenterMessage:@"取消收藏"];
        self.model.isFavorite = @"0";
        
    } error:^(NSError *error) {
        [HXMProgressHUD hide];
        [HXMProgressHUD showError:@"网络出错,请重新加载..." inview:self.superview];
        
    } completed:^{
        
    }];
}

- (IBAction)collectionButtonClick:(UIButton *)sender {
    
    if (![sender isKindOfClass:[UIButton class]]) {
        return;
    }
    //收藏
    if ([self.model.isFavorite isEqualToString:@"0"]) {
        //调取添加收藏接口
        [self requestAddCollectionSignal];
        [_collectionButton setSelected:YES];
    } else {
        //调取删除收藏接口
        [self requestDeleteCollectionSignal];
        [_collectionButton setSelected:NO];
    }
}
- (IBAction)shareButtonClick:(id)sender {

    ActionSharedView * shareView = [ActionSharedView new];
    HXShareAPI *api = [HXShareAPI new];
    api.preController = self.superview.viewController;
    //分享到新浪微博的时候，内容是100，logo去掉，标题加上【】,别的还30，
    shareView.shareAPI = api;
    api.shareUrl = self.model.newsUrl;
    api.shareTitle = self.model.newsAuthor;
    if ([self.btnTitle isEqualToString:@"微博新闻"]) {
        api.shareTitle = [NSString stringWithFormat:@"分享 %@ 的微博",self.model.newsAuthor];
    }
    if (api.shareType == HXSharePlatformType_Sina) {
        api.shareTitle = [NSString stringWithFormat:@"【%@】",api.shareTitle];
        
    }
    NSString *shareContent = self.model.newsResume;
    api.shareContent = shareContent.length>=30?[NSString stringWithFormat:@"%@...",[self.model.newsResume substringWithRange:NSMakeRange(0, 30)]]:shareContent;
    api.shareImage = [UIImage imageNamed:@"1024"];
    shareView.didClickPlatformButton = ^(NSInteger type) {
     
        if (type == 25) {
//             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:api.shareUrl.isNotBlank?api.shareUrl:@"http://www.hexun.com"]];
            [[UIPasteboard generalPasteboard] setString:api.shareUrl.isNotBlank?api.shareUrl:@"http://www.hexun.com"];
            [HXMProgressHUD showCenterMessage:@"复制链接成功"];
        }
    };
    [shareView show];
}

//正则去除网络标签
-(NSString *)getZZwithString:(NSString *)string{
    NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n"
                                                                                    options:0
                                                                                      error:nil];
    string=[regularExpretion stringByReplacingMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length) withTemplate:@""];
    return string;
}

- (NSString *)isToday:(NSTimeInterval )timeInterval {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *dateSMS = [dateFormatter stringFromDate:date];
    NSDate *now = [NSDate date];
    NSString *dateNow = [dateFormatter stringFromDate:now];
    if ([dateSMS isEqualToString:dateNow]) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    }
    else {
        [dateFormatter setDateFormat:@"YY-MM-dd HH:mm"];
    }
    dateSMS = [dateFormatter stringFromDate:date];
    
    return dateSMS;
}


- (HXMAddCollectionViewModel *)addCollectionViewModel {
    
    if (_addCollectionViewModel == nil) {
        _addCollectionViewModel = [[HXMAddCollectionViewModel alloc]init];
    }
    return _addCollectionViewModel;
}
- (HXMCancleCollectionNewsDetailViewModel *)cancleCollectionViewModel {
    
    if (_cancleCollectionViewModel == nil) {
        _cancleCollectionViewModel = [[HXMCancleCollectionNewsDetailViewModel alloc]init];
    }
    return _cancleCollectionViewModel;
}

@end
