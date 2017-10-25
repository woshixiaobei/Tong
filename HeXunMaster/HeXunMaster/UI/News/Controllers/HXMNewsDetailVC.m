//
//  HXMNewsDetailVC.m
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/4/10.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMNewsDetailVC.h"
#import "UIBarButtonItem+Extension.h"
#import "HXMDetailModel.h"
#import "NSString+date.h"
#import "ActionSheetView.h"
#import "AccountTool.h"
#import "HXMAddCollectionViewModel.h"
//#import "HXMDeleteMultipleCollectionViewModel.h"
#import "ActionSharedView.h"
#import "HXShareAPI.h"
#import "HXDefaultView.h"
#import "HXMHistoryPushViewController.h"
#import "HXMCancleCollectionNewsDetailViewModel.h"

#if __has_include("UMSocialConfig.h")

#import "UMSocialData.h"
#import "UMSocialControllerService.h"
#import "UMSocialSnsPlatformManager.h"
#if __has_include(<MobClickInOne/MobClick.h>)&&__has_include(<MobClickInOne/DplusMobClick.h>)//dplus兼容
#import <MobClickInOne/MobClick.h>
#import <MobClickInOne/DplusMobClick.h>
#elif __has_include(<UMMobClick/MobClick.h>)
#import <UMMobClick/MobClick.h>
#else
//#import "MobClick.h"
#endif

#import "UMSocialConfig.h"
#import "WeiboSDK.h"

#endif

@interface HXMNewsDetailVC ()<UIWebViewDelegate>
//  webView
@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, strong) HXMDetailModel *model;
@property (nonatomic, assign) BOOL isCollection;//判断是否收藏
@property (nonatomic, assign) NSInteger amplification;//判断放大几次了
@property (nonatomic, strong) NSArray *promptArr;
@property (nonatomic, assign) NSInteger textFont;
@property (nonatomic, copy) NSString *htmlStr;
@property (nonatomic, strong) UIView *bottomView;//底部视图
@property (nonatomic, strong) NSMutableArray <UIButton *>*bottomButtonArray;//底部视图按钮数组
@property (nonatomic, strong) HXMAddCollectionViewModel *addCollectionViewModel;
@property (nonatomic, strong) HXMCancleCollectionNewsDetailViewModel *cancleCollectionNewsViewModel;//取消收藏
@property (nonatomic, strong) HXDefaultView *defaultView;
@property (nonatomic, strong) HXMAnimationIndictateView *indictorView;//加载页
@property (nonatomic, copy) NSString *favoritId;//保存收藏成功之后的id

@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareContent;
@end

@implementation HXMNewsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestDetailWithNewsDetailType:self.newsDetailType];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0f], NSForegroundColorAttributeName : [UIColor blackColor]}];
    //    [MobClick beginLogPageView:@"详情"];
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:19.0f], NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

//- (void)viewWillDisappear:(BOOL)animated {
//
//    [super viewWillDisappear:animated];
//    [MobClick endLogPageView:@"详情"];
//}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
#pragma mark -调取接口数据
- (void)requestDetailWithNewsDetailType:(NewsDetailByNewsType)newsType {
    switch (newsType) {
        case NewsDetailByNewsTypeNormal://调取普通详情接口
            [self initRequestDataWithModuleId:self.module_id newsId:self.newsId typeId:self.type_id?:@""];
            break;
        case NewsDetailByNewsTypeCollection://调取我的收藏详情接口
            [self initRequestCollectionDetailWithNewsId:self.newsId];
            break;
            
        default:
            break;
    }
}

//请求普通列表详情接口
- (void)initRequestDataWithModuleId:(NSString *)module_id newsId:(NSString *)news_id typeId:(NSString *)type_id{
    
    NSString *username = [AccountTool userInfo].username;
    [self.view addSubview:self.indictorView];
    [HXHttpHelper api_getDetailRequestWithUserName:username module_id:module_id type_id:type_id news_id:news_id success:^(id responseObject) {
        
        [self.indictorView removeFromSuperview];
        if ([responseObject[@"state"] integerValue] == 0) {
            if (responseObject[@"data"]) {
                self.model = [HXMDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
                
                [self init_subviews];
                [self init_bottomView];
            } else {
                [self.defaultView defaultViewType:HXDefaultViewType_fail];
                [HXMProgressHUD showError:@"返回数据出错，请重新加载..." inview:self.view];
            }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.indictorView removeFromSuperview];
        [self.defaultView defaultViewType:HXDefaultViewType_fail];
        [HXMProgressHUD showError:@"加载数据失败,请重新加载..." inview:self.view];
    }];
    
}

//请求调用个人中心-我的收藏-详情接口
- (void)initRequestCollectionDetailWithNewsId:(NSString *)newsId {
    
    [self.view addSubview:self.indictorView];
    [HXHttpHelper api_getDetailCollectionNewsRequestWithId:newsId success:^(id responseObject) {
        
        [self.indictorView removeFromSuperview];
        if ([responseObject[@"state"] integerValue] == 0) {
            if (responseObject[@"data"]) {
                
                self.model = [HXMDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
                self.module_id = self.model.moduleId;
                self.newsId = self.model.id;
                
                [self init_subviews];
                [self init_bottomView];
            } else {
                [self.defaultView defaultViewType:HXDefaultViewType_fail];
                [HXMProgressHUD showError:@"返回数据出错，请重新加载..." inview:self.view];
            }
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.indictorView removeFromSuperview];
        [self.defaultView defaultViewType:HXDefaultViewType_fail];
        [HXMProgressHUD showError:@"加载数据失败,请重新加载..." inview:self.view];
    }];
    
}

#pragma mark - 收藏接口
//添加收藏接口
- (void)requestAddCollectionSignal {
    
    self.addCollectionViewModel.params = [@{@"newsId":self.newsId,@"moduleId":self.module_id} mutableCopy];
    [HXMProgressHUD showInView:self.view];
    [self.addCollectionViewModel.requestAddSignal subscribeNext:^(id x) {
        
        [HXMProgressHUD hide];
        [HXMProgressHUD showCenterMessage:@"收藏成功"];
        [self.bottomButtonArray[0] setSelected:YES];
        
    } error:^(NSError *error) {
        [HXMProgressHUD hide];
        [HXMProgressHUD showError:@"网络出错,请重新加载..." inview:self.view];
        
    } completed:^{
        
    }];
}
//取消收藏接口
- (void)requestDeleteCollectionSignal {
    
    self.cancleCollectionNewsViewModel.params = [@{@"newsId":self.newsId,@"moduleId":self.module_id} mutableCopy];
    [HXMProgressHUD showInView:self.view];
    [self.cancleCollectionNewsViewModel.cancleCollectionNewsSignal subscribeNext:^(id x) {
        
        [HXMProgressHUD hide];
        [HXMProgressHUD showCenterMessage:@"取消收藏"];
        [self.bottomButtonArray[0] setSelected:NO];
        
    } error:^(NSError *error) {
        [HXMProgressHUD hide];
        [HXMProgressHUD showError:@"网络出错,请重新加载..." inview:self.view];
        
    } completed:^{
        
    }];
    
}

#pragma mark - 初始化视图以及底部视图
- (void)init_subviews {
    
    NSString * placeholderStr = @"&nbsp;";
    NSString *createdTime = [self isToday:self.model.postTime/1000];
    NSString *placeholder = @"&nbsp;";
    
    for (NSInteger i = 0; i < 4; i++) {
        placeholder = [placeholder stringByAppendingString:placeholderStr];
    }
    
    NSString * content = [self.btnTitle  isEqual: @"微博新闻"] ? [NSString stringWithFormat:@"</br> %@",self.model.newsContent] : self.model.newsContent;
    //转自来源：
    NSString *sourceNewsString = self.model.sourceNewsMedia.length >0?[NSString stringWithFormat:@"转自:%@",self.model.sourceNewsMedia]:@"";
    
    NSString * str = [NSString stringWithFormat:@"<span style=\"font-size: %ldpx;font-weight: 900;\">%@</span></br></br><span style=\"font-size: %ldpx\">%@</span>%@<span style=\"font-size: %ldpx\">%@</span>%@<span style=\"font-size: %ldpx\">%@</span></br><span style=\"font-size: %ldpx\">%@</span><br /><br />",(long)self.textFont+12,self.model.newsTitle,self.textFont,self.model.newsMedia,placeholder,self.textFont,[NSString stringWithFormat:@"%@",createdTime],placeholder,self.textFont,sourceNewsString,self.textFont,content];
    
    [self.webView loadHTMLString:str baseURL:nil];
    
}

- (void)init_bottomView {
    
    _isCollection = self.model.isFavorite;
    self.bottomView.hidden = NO;
    if (self.model.isFavorite == 0) {
        [self.bottomButtonArray[0] setSelected:NO];
        
    } else {
        [self.bottomButtonArray[0] setSelected:YES];
    }
}

//点击底部按钮调用的方法 根据sender.tag来区别点的是哪个按钮
-(void)buttonClick:(UIButton *)sender{
    
    switch (sender.tag) {
        case 100:
            //收藏
            if (_isCollection == NO) {
                //调取添加收藏接口
                [self requestAddCollectionSignal];
                [sender setSelected:YES];
                _isCollection = YES;
                
            } else {
                //调取删除收藏接口
                [self requestDeleteCollectionSignal];
                [sender setSelected:NO];
                _isCollection = NO;
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"kToRefreshMyCollectionViewControllerNotification" object:nil];
                
            }
            
            break;
        case 101:
            //分享
            [self shareBtnClick];
            break;
        case 102:
            //放大
            if (_amplification == 2) {
                self.bottomButtonArray[2].enabled = NO;
            }
            if (_amplification <=2) {
                _amplification++;
                self.textFont += 2;
                [self init_subviews];
                [self showMsg:nil duration:1.0 imgName:@"progressHud_enlargeFont_icon"];
                self.bottomButtonArray[3].enabled = YES;
            }
            
            break;
        case 103:
            //缩小
            if (_amplification == 1) {
                self.bottomButtonArray[3].enabled = NO;
            }
            if (_amplification>0) {
                _amplification--;
                self.textFont-= 2;
                [self init_subviews];
                [self showMsg:nil duration:1.0f imgName:@"progressHud_reduceFont_icon"];
                self.bottomButtonArray[2].enabled = YES;
            }
            
            break;
            
        default:
            break;
    }
    
}

//分享
- (void)shareBtnClick {
    
    ActionSharedView * shareView = [ActionSharedView new];
    HXShareAPI *api = [HXShareAPI new];
    shareView.shareAPI = api;
    api.preController = self;
    api.shareUrl = self.model.newsUrl;
    api.shareTitle = self.model.newsTitle;
    
    if ([self getZZwithString:self.model.newsContent].length >= 30) {
        api.shareContent = [NSString stringWithFormat:@"%@...",[[self getZZwithString:self.model.newsContent] substringWithRange:NSMakeRange(0, 30)]];
    } else {
        api.shareContent = [self getZZwithString:self.model.newsContent];
    }
    if ([self.btnTitle isEqualToString:@"微博新闻"]) {
        api.shareTitle = [NSString stringWithFormat:@"分享 %@ 的微博",self.model.newsTitle];
    }
    api.shareImage = [UIImage imageNamed:@"1024"];
    
    shareView.didClickPlatformButton = ^(NSInteger type) {
        if (type == 25) {
//              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:api.shareUrl.isNotBlank?api.shareUrl:@"http://www.hexun.com"]];
            [[UIPasteboard generalPasteboard] setString:api.shareUrl.isNotBlank?api.shareUrl:@"http://www.hexun.com"];
            [HXMProgressHUD showCenterMessage:@"复制链接成功"];
        }
    };
    [shareView show];
    
}

#pragma mark - 设置界面
- (void)setupUI {
    
    self.navigationItem.title = @"详情";
    self.view.backgroundColor = [UIColor whiteColor];
    _textFont = 17;
    UIWebView *webView = [[UIWebView alloc]init];
    self.webView = webView;
    self.webView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.delegate = self;
    [self.view addSubview:_webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view);
    }];
    
    _amplification = 0;
    _promptArr = @[@"最小",@"中",@"大",@"最大"];

    [self setupBottomView];
 
    [self setNavLeftBackBtn];
}

- (void)setNavLeftBackBtn{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBackBtnClick:)];
    [self.navigationItem  setLeftBarButtonItem:item];
    
}

- (void)leftBackBtnClick:(UIButton *)btn{

    [self.navigationController popViewControllerAnimated:YES];
}

//设置底部的视图
- (void)setupBottomView {
    
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = UIColorFromRGBA(60, 92, 142, 0.95);
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    _bottomView.hidden = YES;
    NSArray * imageArrayM = @[@"detail_icon_collection_normal",@"detail_icon_share_normal",@"detail_icon_enlarge_normal",@"detail_icon_narrow_normal"];
    NSArray * selectedImageArrayM = @[@"detail_icon_collection_seleceted",@"detail_icon_share_normal",@"detail_icon_enlarge_normal",@"detail_icon_narrow_normal"];
    NSArray * disabledImageArrayM = @[@"detail_icon_collection_normal",@"detail_icon_share_normal",@"detail_icon_enlarge_disabled",@"detail_icon_narrow_disabled"];
    for (NSInteger i = 0; i < 4; i++) {
        UIButton *functionBtn = [[UIButton alloc] initWithFrame:CGRectMake((Screen_width/4) *(i%4), Screen_width/4*(i/4), Screen_width/4, 44)];
        functionBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [functionBtn setImage:[UIImage imageNamed:imageArrayM[i]] forState:UIControlStateNormal];
        [functionBtn setImage:[UIImage imageNamed:selectedImageArrayM[i]] forState:UIControlStateSelected];
        [functionBtn setImage:[UIImage imageNamed:disabledImageArrayM[i]] forState:UIControlStateDisabled];
        [functionBtn setTag:i+100];
        
        [functionBtn addTarget:self
                        action:@selector(buttonClick:)
              forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:functionBtn];
        
        [self.bottomButtonArray addObject:functionBtn];
    }
    self.bottomButtonArray[3].enabled = NO;
    
}

//正则去除网络标签
-(NSString *)getZZwithString:(NSString *)string{
    NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n"
                                                                                    options:0
                                                                                      error:nil];
    string=[regularExpretion stringByReplacingMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length) withTemplate:@""];
    return string;
}

- (void)showMsg:(NSString *)msg duration:(CGFloat)time imgName:(NSString *)imgName {
    
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.bezelView.color = [UIColor colorWithWhite:0.0 alpha:0.8];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    hud.label.text = msg;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hideAnimated:YES afterDelay:time];
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

#pragma mark - 懒加载
- (HXMAnimationIndictateView *)indictorView {
    
    if (_indictorView == nil) {
        _indictorView = [[HXMAnimationIndictateView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    }
    return _indictorView;
    
}

- (HXDefaultView *)defaultView{
    if (!_defaultView) {
        
        @weakify(self)
        _defaultView = [[HXDefaultView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) reloadBlock:^void(HXDefaultViewType type){
            @strongify(self)
            [self requestDetailWithNewsDetailType:self.newsDetailType];
        }];

        [_defaultView defaultMessage:@"新闻动态为空，敬请期待!" forDefaultViewType:HXDefaultViewType_empty];
        [_defaultView defaultImage:[UIImage imageNamed:@"HXM_emptyNews"] forDefaultViewType:HXDefaultViewType_empty];
        
    }
    return _defaultView;
}

- (HXMAddCollectionViewModel *)addCollectionViewModel {
    
    if (_addCollectionViewModel == nil) {
        _addCollectionViewModel = [[HXMAddCollectionViewModel alloc]init];
    }
    return _addCollectionViewModel;
}
-(HXMCancleCollectionNewsDetailViewModel *)cancleCollectionNewsViewModel {
    if (_cancleCollectionNewsViewModel == nil) {
        _cancleCollectionNewsViewModel = [[HXMCancleCollectionNewsDetailViewModel alloc]init];
    }
    return _cancleCollectionNewsViewModel;
}

-(NSMutableArray<UIButton *> *)bottomButtonArray {
    
    if (_bottomButtonArray == nil) {
        _bottomButtonArray = [NSMutableArray array];
    }
    return _bottomButtonArray;
}

@end
