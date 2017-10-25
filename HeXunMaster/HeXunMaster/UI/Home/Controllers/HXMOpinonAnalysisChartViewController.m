//
//  HXMOpinonAnalysisChartViewController.m
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/7/18.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMOpinonAnalysisChartViewController.h"
#import "HXMOpinionAnalysisChartView.h"
#import "HXDefaultView.h"
#import "HXMAnalysisChartViewModel.h"
#import "HXMAnimationIndictateView.h"

@interface HXMOpinonAnalysisChartViewController ()
@property (nonatomic, strong) HXMOpinionAnalysisChartView *mainChartView;
@property (nonatomic, strong) HXMAnalysisChartViewModel *analysisChartViewModel;//视图模型
@property (nonatomic, strong) HXMAnimationIndictateView *indictorView;//加载页
@property (nonatomic, strong) HXDefaultView *defaultView;
@property (nonatomic, assign) CGFloat totalNewsNumber;//新闻总数
@end
@implementation HXMOpinonAnalysisChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupSubViews];
    [self requestChartData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)requestChartData {
    
    
    @weakify(self)
    [[self.analysisChartViewModel.requestAnalysisChartNewsCommand execute:nil] subscribeNext:^(NSMutableDictionary *x) {
       @strongify(self)
        NSLog(@"%@",x);
        if (self.defaultView.defaultViewType == HXDefaultViewType_fail && self.defaultView) {
            [self.defaultView removeFromSuperview];
        }
        [self.indictorView removeFromSuperview];
        self.mainChartView.dataList = x;
        
        //计算新闻总数
        self.totalNewsNumber = [self caculatationTotalNewsNum:x];
        [self.defaultView defaultViewType:((self.totalNewsNumber == 0))?HXDefaultViewType_empty:HXDefaultViewType_none];


    } error:^(NSError *error) {
        @strongify(self)
        [self.indictorView removeFromSuperview];
        [self.defaultView defaultViewType:HXDefaultViewType_fail];
        [HXMProgressHUD showError:@"加载数据失败,请重新加载..." inview:self.view];
        
    } completed:^{
        
    }];
}

- (CGFloat)caculatationTotalNewsNum:(NSMutableDictionary *)x {

    //判断是否为空
    CGFloat totalNum = self.mainChartView.analysisChartModel.sumChannel+self.mainChartView.analysisChartModel.sumPositive;
    totalNum = totalNum + [x[@"province_num"] floatValue]+[x[@"other_num"] floatValue]+[x[@"centre_num"] floatValue];
    if (self.mainChartView.analysisChartModel.sub_company.count>0) {
        for (HXMSubCompanyModel *subCompanyModel in self.mainChartView.analysisChartModel.sub_company ) {
            totalNum = totalNum + [subCompanyModel.sub_news_num floatValue];
        }
    }
    return totalNum;
}
#pragma mark - setupUI
- (void)setupSubViews {
    
    [self setupNavigationBar];
    [self initSubviews];
}
- (void)initSubviews {
    
    self.mainChartView = [[HXMOpinionAnalysisChartView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainChartView];
    [self.view addSubview:self.defaultView];
    
    [self.mainChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.view addSubview:self.indictorView];
}
- (void)setupNavigationBar {
    
    self.navigationItem.title = @"舆情分析";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:19.0], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor ]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:([UIColor colorWithHexString:@"#3c5c8e"]) size:CGSizeMake(Screen_width, Screen_height)] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - 懒加载
- (HXMAnimationIndictateView *)indictorView {
    
    if (_indictorView == nil) {
        _indictorView = [[HXMAnimationIndictateView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    }
    return _indictorView;
    
}
- (HXMAnalysisChartViewModel *)analysisChartViewModel {

    if (_analysisChartViewModel == nil) {
        _analysisChartViewModel = [[HXMAnalysisChartViewModel alloc]init];
    }
    return _analysisChartViewModel;
}

- (HXDefaultView *)defaultView{
    if (!_defaultView) {
        @weakify(self)
        _defaultView = [[HXDefaultView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) reloadBlock:^void(HXDefaultViewType type){
            @strongify(self)
            [self requestChartData];
        }];
        [_defaultView defaultMessage:@"舆情图迷路了，请稍后再来..." forDefaultViewType:HXDefaultViewType_empty];
        [_defaultView defaultImage:[UIImage imageNamed:@"HXM_analysisChart"] forDefaultViewType:HXDefaultViewType_empty];
    }
    return _defaultView;
}

@end
