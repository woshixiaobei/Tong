//
//  HXMAllNewsViewController.m
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/3/21.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMAllNewsViewController.h"
#import <MJRefresh.h>
#import "UIView+PromptWords.h"
#import "HXMFocusNewsCell.h"
#import "HXMNewsModuleModel.h"
#import "HXMNewsListViewModel.h"
#import "HXMRefresh.h"
#import "HXMfooterRefresh.h"
#import "HXDefaultView.h"
#import "LoadFailView.h"
#import "HXMNewsDetailVC.h"
#import "HXNavigationViewController.h"
#import "HXMSimilarNewsController.h"
#import "HXMCompanyResearchReportViewModel.h"
#import "HXMCompanyResearchModel.h"
#import "HXMCommonModuleViewModel.h"
#import "HXMCommonModuleModel.h"
#import "HXMTotalVolumeNewsViewModel.h"

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

@interface HXMAllNewsViewController ()<UITableViewDelegate,UITableViewDataSource,pushToSimilarNewsControllerDelegate, UMSocialUIDelegate>

@property (nonatomic, strong) UITableView *tableView;//主tableView
@property (nonatomic, strong) UIView * noDataView;//没有数据视图
@property (nonatomic, strong) NSMutableArray *arr;
@property (nonatomic, strong) HXMNewsListViewModel *viewModel;//新闻列表模型
@property (nonatomic, strong) HXMCompanyResearchReportViewModel *researchReportViewModel;//公司研报视图模型
@property (nonatomic, strong) HXDefaultView *defaultView;
@property (nonatomic, strong) LoadFailView *failView;
@property (nonatomic, assign) NSInteger pageNum;//分页标识
@property (nonatomic, strong) NSArray *moduleArray;//数组id
@property (nonatomic, strong) HXMCommonModuleViewModel *commonModuleViewModel;//常用模块视图模型
@property (nonatomic, strong) HXMAnimationIndictateView *indictorView;//加载页
@property (nonatomic, strong) HXMTotalVolumeNewsViewModel *totalVolumeViewModel;//总声量视图模型
@property (nonatomic, copy) NSString *newsCount;
@property (nonatomic, copy) NSString *Count;
@property (nonatomic, copy) NSString *lastNewsId;//最新的新闻的id
@end

@implementation HXMAllNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self isInformationNewsRequest];
    [self setupMainView];
    //判断是否是情报新闻
    [self.view addSubview:self.defaultView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 获取数据
//是否是情报新闻
- (void)isInformationNewsRequest {
    
    //如果本地有保存,取本地的数据
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:kAllModuleFile]) {
 
        self.moduleArray = [NSKeyedUnarchiver unarchiveObjectWithFile:kAllModuleFile];
        NSMutableArray *arrayM = [NSMutableArray array];
        NSMutableArray * arr = [NSMutableArray array];
        NSArray *tempArray = [_moduleArray objectOrNilAtIndex:0];
        for (HXMCommonModuleModel *model in tempArray) {
            [arrayM addObject:model.module_id];
            [arr addObject:model.module_name];
        }
        if (self.module_id&&[arrayM containsObject:self.module_id]) {
            self.isInformationNews = NO;
        } else {
            self.isInformationNews = YES;
        }
    } else {
        //没有标题title时,就去请求接口
        [self updateAllModuleData];
    }
}
//初始化全部模块
- (void)updateAllModuleData {
    
    @weakify(self)
    [[self.commonModuleViewModel.requestCommonListCommand execute:nil] subscribeNext:^(id x) {
        NSLog(@"%@",x);
        @strongify(self)
        [NSKeyedArchiver archiveRootObject:x toFile:kAllModuleFile];
        self.moduleArray = x;
        
        //判断是不是情报新闻
        NSMutableArray *arrayM = [NSMutableArray array];
        NSMutableArray * arr = [NSMutableArray array];
        NSArray *tempArray = [_moduleArray objectOrNilAtIndex:0];
        for (HXMCommonModuleModel *model in tempArray) {
            [arrayM addObject:model.module_id];
            [arr addObject:model.module_name];
        }
        
        if (self.module_id&&[arrayM containsObject:self.module_id]) {
            self.isInformationNews = NO;
        } else {
            self.isInformationNews = YES;
        }
        
    } error:^(NSError *error) {
        [HXMProgressHUD showError:@"请求失败，请重新加载..." inview:self.view];
        NSLog(@"%@",error);
    } completed:^{
        NSLog(@"completed");
    }];
}

#pragma mark- 添加下拉刷新
/**添加上下拉刷新*/
-(void)setupRefresh {
    @weakify(self)
    self.tableView.mj_header = [HXMRefresh headerWithRefreshingBlock:^{
        @strongify(self)
        [self downRefresh];
    }];
    [self.tableView.mj_header beginRefreshing];
}

/**下拉刷新数据*/
- (void)downRefresh {
    _dataListArray = [NSMutableArray array];
    [_dataListArray removeAllObjects];
    switch (self.allNewsRequestType) {
        case NewsListRequestTypeNewsNormalModule://新闻模块
            
        case NewsListRequestTypeQingBaoModule://情报模块
            
            if ([self.module_id isEqual:@"11"]) {
                //公司研报接口
                [self downRefreshRequestCompanyResearchReport];
            } else {
                //普通新闻接口
                [self downRefreshRequestNormalNewsList];
            }
            break;
        case NewsListRequestTypeTotalVolumeModule://新闻总声量
            
            [self downRefreshRequestTotalVolumeNewsList];
            break;
            
        default:
            break;
    }
}
/**上拉刷新*/
- (void)getRefresh {
    
    switch (self.allNewsRequestType) {
        case NewsListRequestTypeNewsNormalModule://新闻模块
            
        case NewsListRequestTypeQingBaoModule://情报模块
            
            if ([self.module_id isEqual:@"11"]) {
                //上拉公司研报接口
                [self upRefreshRequestCompanyResearchReport];
            } else {
                //上拉新闻列表接口
                [self upRefreshRequestNormalNewsList];
            }
            break;
        case NewsListRequestTypeTotalVolumeModule://新闻总声量
            //上拉新闻总量列表接口
            [self upRefreshRequestTotalVolumeNewsList];
            break;
            
        default:
            break;
    }
}

#pragma mark - 获取公司研报数据
//上拉刷新 - 调取公司情报新闻列表
- (void)upRefreshRequestCompanyResearchReport {
    
    self.researchReportViewModel.params = [@{@"module_id": self.module_id.isNotBlank?self.module_id:@"", @"type_id": self.type_id.isNotBlank?self.type_id:@"",@"pageNum":@(self.pageNum),@"reportType":self.reportType.isNotBlank?self.reportType:@""} mutableCopy];
    @weakify(self)
    [self.researchReportViewModel.requestCompanyResearchSignal subscribeNext:^(HXMCompanyResearchModel * x) {
        
        @strongify(self)
        [self upRefreshCompanyResearchReportWithSuccessData:x];
        
    } error:^(NSError *error) {
        
        @strongify(self)
        [self refreshSubViewsWithErrorData:YES];
        
    } completed:^{
        
    }];
}

//调取下拉刷新-公司研报接口
- (void)downRefreshRequestCompanyResearchReport {
    
    self.pageNum = 1;
    self.researchReportViewModel.params = [@{@"module_id":self.module_id.isNotBlank?self.module_id:@"",@"pageNum":@(self.pageNum),@"type_id":self.type_id.isNotBlank?self.type_id:@"",@"reportType":self.reportType.isNotBlank?self.reportType:@""} mutableCopy];
    
    @weakify(self)
    [self.researchReportViewModel.requestCompanyResearchSignal subscribeNext:^(HXMCompanyResearchModel *x) {
        
        @strongify(self)
        [self downRefreshCompanyResearchReportWithSuccessData:x];
        
    } error:^(NSError *error) {
        
        @strongify(self)
        [self refreshSubViewsWithErrorData:NO];
        
    } completed:^{
        
    }];
}

#pragma mark - 获取普通新闻列表接口
//上拉刷新 - 调取普通新闻列表
- (void)upRefreshRequestNormalNewsList {
    self.viewModel.params = [@{@"module_id": self.module_id.isNotBlank?self.module_id:@"", @"type_id": self.type_id.isNotBlank?self.type_id:@"",@"id":self.next_id.isNotBlank?self.next_id:@""} mutableCopy];
    @weakify(self)
    [self.viewModel.requestNewsListSignal subscribeNext:^(HXMNewsModuleModel * x) {
        
        @strongify(self)
        [self upRefreshSubViewsWithReloadData:x];
        
    } error:^(NSError *error) {
        
        @strongify(self)
        [self refreshSubViewsWithErrorData:YES];
        
    } completed:^{
        
    }];
}

//调用下拉刷新新闻列表接口
- (void)downRefreshRequestNormalNewsList {
    self.viewModel.params = [@{@"module_id": self.module_id.isNotBlank?self.module_id:@"", @"type_id": self.type_id.isNotBlank?self.type_id:@""} mutableCopy];
    _Count = @"10";
    
    @weakify(self)
    [self.viewModel.requestNewsListSignal subscribeNext:^(HXMNewsModuleModel * x) {
        
        @strongify(self)
        [self downRefreshSubViewsWithReloadData:x];
        
    } error:^(NSError *error) {
        
        @strongify(self)
        [self refreshSubViewsWithErrorData:NO];
        
    } completed:^{
        
    }];
}
#pragma mark - 获取总声量新闻列表接口
//上拉刷新 - 调取新闻总声量列表
- (void)upRefreshRequestTotalVolumeNewsList {
    
    self.totalVolumeViewModel.params = [@{@"module_id": self.module_id.isNotBlank?self.module_id:@"", @"positive": self.type_id.isNotBlank?self.type_id:@"",@"id":self.next_id.isNotBlank?self.next_id:@""} mutableCopy];
    
    @weakify(self)
    [[self.totalVolumeViewModel.requestTotalVolumeNewsCommand execute:nil] subscribeNext:^(HXMNewsModuleModel *x) {
        
        @strongify(self)
        [self upRefreshSubViewsWithReloadData:x];
        
    } error:^(NSError *error) {
        
        @strongify(self)
        [self refreshSubViewsWithErrorData:YES];
        
    } completed:^{
        
    }];
}

//调用下拉刷新新闻列表接口
- (void)downRefreshRequestTotalVolumeNewsList {
    self.totalVolumeViewModel.params = [@{@"module_id": self.module_id.isNotBlank?self.module_id:@"", @"positive": self.type_id.isNotBlank?self.type_id:@""} mutableCopy];
    
    @weakify(self)
    [[self.totalVolumeViewModel.requestTotalVolumeNewsCommand execute:nil] subscribeNext:^(HXMNewsModuleModel *x) {
        
        @strongify(self)
        [self downRefreshSubViewsWithReloadData:x];
        
    } error:^(NSError *error) {
        
        @strongify(self)
        [self refreshSubViewsWithErrorData:NO];
        
    } completed:^{
        
    }];
}

#pragma mark - private methord
//上拉返回的成功数据
- (void)upRefreshSubViewsWithReloadData:(HXMNewsModuleModel *)x {
    
    self.next_id = x.next_id;
    if (x.news.count>0 && x.news.count >= 10) {
        [_dataListArray addObjectsFromArray:x.news];
        [self.tableView.mj_footer endRefreshing];
    }else if (x.news.count < 10) {
        [_dataListArray addObjectsFromArray:x.news];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
    
    [self.tableView reloadData];
    
}
//下拉返回的成功数据
- (void)downRefreshSubViewsWithReloadData:(HXMNewsModuleModel *)x {
    
    if (self.defaultView.defaultViewType == HXDefaultViewType_fail && self.defaultView) {
        [self.defaultView removeFromSuperview];
    }
    [self.indictorView removeFromSuperview];
    _dataListArray = [x.news mutableCopy];
    self.next_id = x.next_id;
    [self.tableView.mj_header endRefreshing];
    
    if (_dataListArray.count>0) {
        if (_dataListArray.count == 10) {
            [self.tableView.mj_header endRefreshing];
            //下拉刷新
            self.tableView.mj_footer = [HXMfooterRefresh footerWithRefreshingBlock:^{
                [self getRefresh];
            }];
            self.tableView.mj_footer.automaticallyHidden = YES;
        }
        
        _Count = [NSString stringWithFormat:@"%ld",_dataListArray.count];
        //出现弹框的个数
        for (NSInteger i = 0; i < x.news.count; i++) {
            if ([_lastNewsId isEqualToString:x.news[i].id]) {
                _Count = [NSString stringWithFormat:@"%ld",i];
            }
        }
        _lastNewsId = x.news[0].id;
        [self presentNewCount:_Count];
        
        
    } else {
        [self.defaultView defaultViewType:self.dataListArray.count != 0?HXDefaultViewType_none:HXDefaultViewType_empty];
    }
    [self.tableView reloadData];
    
}

//上拉公司研报返回数据
- (void)upRefreshCompanyResearchReportWithSuccessData:(HXMCompanyResearchModel *)x {
    
    self.pageNum ++;
    if (x.news.count>0 && x.news.count >= 10) {
        [_dataListArray addObjectsFromArray:x.news];
        [self.tableView.mj_footer endRefreshing];
    }else if (x.news.count < 10) {
        [_dataListArray addObjectsFromArray:x.news];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
    
    [self.tableView reloadData];
}
//下拉公司研报返回成功数据
- (void)downRefreshCompanyResearchReportWithSuccessData:(HXMCompanyResearchModel *)x {
    
    if (self.defaultView.defaultViewType == HXDefaultViewType_fail && self.defaultView) {
        [self.defaultView removeFromSuperview];
    }
    
    [self.indictorView removeFromSuperview];
    _dataListArray = [x.news mutableCopy];
    self.pageNum++;
    [self.tableView.mj_header endRefreshing];
    
    if (_dataListArray.count>0) {
        if (_dataListArray.count == 10) {
            [self.tableView.mj_header endRefreshing];
            //下拉刷新
            self.tableView.mj_footer = [HXMfooterRefresh footerWithRefreshingBlock:^{
                [self getRefresh];
            }];
            self.tableView.mj_footer.automaticallyHidden = YES;
        }
        _Count = [NSString stringWithFormat:@"%ld",_dataListArray.count];
        //出现弹框的个数
        for (NSInteger i = 0; i < x.news.count; i++) {
            if ([_lastNewsId isEqualToString:x.news[i].id]) {
                _Count = [NSString stringWithFormat:@"%ld",i];
            }
        }
        _lastNewsId = x.news[0].id;
        [self presentNewCount:_Count];
        
    } else {
        [self.defaultView defaultViewType:self.dataListArray.count !=0 ?HXDefaultViewType_none:HXDefaultViewType_empty];
    }
    
    [self.tableView reloadData];
}

//加载失败回调数据
- (void)refreshSubViewsWithErrorData:(BOOL)isUpRefreshError {
    [_tableView.mj_header endRefreshing];
    [self.defaultView defaultViewType:HXDefaultViewType_fail];
    if (isUpRefreshError == NO) {
        [self.indictorView removeFromSuperview];
    }
}
#pragma mark - 弹出几条新消息
- (void)presentNewCount:(NSString *)str {
    
    UIView * PresentNewCount = [[UIView alloc] init];
    PresentNewCount.backgroundColor = [UIColor colorWithHexString:@"#75a2e9"];
    [self.view addSubview:PresentNewCount];
    [PresentNewCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(32);
    }];
    
    UILabel * label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithHexString:@"#ffffff"];
    label.text = [NSString stringWithFormat:@"新增%@条新闻",str];
    [PresentNewCount addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(PresentNewCount);
    }];
    
    [UIView animateWithDuration:0.8f delay:1.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        PresentNewCount.alpha = 0;
    } completion:nil];
}

#pragma mark - pushToSimilarNewsControllerDelegate
- (void)pushToSimilarNewsCell:(HXMFocusNewsCell *)cell news_id:(NSString *)news_id {
    
    HXMSimilarNewsController *vc = [[HXMSimilarNewsController alloc]init];
    vc.module_id = self.module_id;
    vc.news_id = news_id;
    vc.type_id = self.type_id;
    [[self getviewController].navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HXMNewsDetailVC *vc = [[HXMNewsDetailVC alloc]init];
    vc.module_id = self.module_id;
    //提亮词需要传type_id
    vc.type_id = ([self.type_id isEqualToString:@"all"]||[self.type_id isEqualToString:@"hg"])?@"":self.type_id;
    vc.btnTitle = self.btnTitle;
    vc.newsDetailType = NewsDetailByNewsTypeNormal;
    vc.newsId = ((HXMDetailNewsCellModel *)[self.dataListArray objectOrNilAtIndex:indexPath.row]).id;
    [[self getviewController].navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataListArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HXMFocusNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"focusNewsCell" forIndexPath:indexPath];
    cell.btnTitle = self.btnTitle;
    cell.module_id = self.module_id;
    cell.isInformationNews = self.isInformationNews;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.model = [self.dataListArray objectOrNilAtIndex:indexPath.row];
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - 设置界面
- (void)setupMainView {
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f5f6"];
    [self.view addSubview:self.tableView];
    
    //判断是否是全部新闻的正负新闻
    if (self.isTotalVolumeNews) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    } else {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-49);
        }];
    }
    [self.view addSubview:self.indictorView];
    [self setupRefresh];
    
}
#pragma mark - 懒加载
- (UITableView *)tableView {
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#f4f5f6"];
        _tableView.estimatedRowHeight = 150.f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerNib:[UINib nibWithNibName:@"HXMFocusNewsCell" bundle:nil] forCellReuseIdentifier:@"focusNewsCell"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

//普通视图模型
- (HXMNewsListViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[HXMNewsListViewModel alloc]init];
    }
    return _viewModel;
}
//公司研报视图模型
- (HXMCompanyResearchReportViewModel *)researchReportViewModel {
    
    if (_researchReportViewModel == nil) {
        _researchReportViewModel = [[HXMCompanyResearchReportViewModel alloc]init];
    }
    return _researchReportViewModel;
}

//总声量视图模型
- (HXMTotalVolumeNewsViewModel *)totalVolumeViewModel {
    
    if (_totalVolumeViewModel == nil) {
        _totalVolumeViewModel = [[HXMTotalVolumeNewsViewModel alloc]init];
    }
    return _totalVolumeViewModel;
}
//标题模块视图模型
- (HXMCommonModuleViewModel *)commonModuleViewModel {
    
    if (_commonModuleViewModel == nil) {
        _commonModuleViewModel = [[HXMCommonModuleViewModel alloc]init];
    }
    return _commonModuleViewModel;
}

//标题数组
- (NSArray *)moduleArray {
    if (_moduleArray == nil) {
        _moduleArray = [NSArray array];
    }
    return _moduleArray;
}

- (HXMAnimationIndictateView *)indictorView {
    
    if (_indictorView == nil) {
        _indictorView = [[HXMAnimationIndictateView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49-36)];
    }
    return _indictorView;
}

- (HXDefaultView *)defaultView{
    if (!_defaultView) {
        
        @weakify(self)
        _defaultView = [[HXDefaultView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) reloadBlock:^void(HXDefaultViewType type){
            @strongify(self)
            [self setupRefresh];
        }];
        _defaultView.defaultMessageLabel.numberOfLines = 2;
        _defaultView.defaultMessageLabel.frame = CGRectMake(0, 0, 200, 50);
        if (_isInformationNews) {
            [_defaultView defaultMessage:@"未发现相关情报\n去其他新闻分类看看吧!" forDefaultViewType:HXDefaultViewType_empty];
            [_defaultView defaultImage:[UIImage imageNamed:@"HXM_emptyInformation"] forDefaultViewType:HXDefaultViewType_empty];
        } else {
            [_defaultView defaultMessage:@"未发现相关新闻\n去其他新闻分类看看吧!" forDefaultViewType:HXDefaultViewType_empty];
            [_defaultView defaultImage:[UIImage imageNamed:@"HXM_emptyNews"] forDefaultViewType:HXDefaultViewType_empty];
            
        }
    }
    return _defaultView;
}

//获取父控制器
- (UIViewController*)getviewController {
    for (UIView*next = [self.view superview];next; next = next.superview) {
        UIResponder*nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
