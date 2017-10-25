//
//  HXMHomeViewController.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/8.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//


#import "HXMHomeViewController.h"
#import "HXMStatisticsCountCell.h"
#import "HXMCommonModuleCell.h"
#import "HXMAllModuleViewController.h"
#import "HXMFocusNewsCell.h"
#import "HXMHomeListViewModel.h"
#import "HXMHomeListModel.h"
#import "HXMCommpanyNewsHeaderView.h"
#import "HXMDetailNewsCellModel.h"
#import "HXMCommonModuleViewModel.h"
#import "HXMNewsDetailVC.h"
#import "TableViewHeader.h"
#import "HXNavigationViewController.h"
#import "HXMNewsViewController.h"
#import "HXMSimilarNewsController.h"
#import "HXMSimilarNewsViewModel.h"
#import "HXDefaultView.h"
#import "HXMHistoryPushViewController.h"
#import "HXMOpinonAnalysisChartViewController.h"
#import "HXMTotalVolumeNewsViewController.h"
#import "HXMHistoryPushViewController.h"

@interface HXMHomeViewController ()<UITableViewDelegate,UITableViewDataSource,pushToSimilarNewsControllerDelegate>

@property (nonatomic, strong) UITableView *mainTableView;
//返回视图模型
@property (nonatomic, strong) HXMHomeListViewModel *homeListViewModel;
//获取主页数据模型
@property (nonatomic, strong) HXMHomeListModel *homeListModel;
//获取全部模块数据模型
@property (nonatomic, strong) HXMCommonModuleViewModel *commonModuleViewModel;
//获取相似新闻数据模型
@property (nonatomic, strong) HXMSimilarNewsViewModel *similarNewsViewModel;
//全部模块
@property (nonatomic, strong) NSArray *allModuleArrayM;
//头部刷新视图
@property (nonatomic,strong) TableViewHeader *tableViewHeader;
//是否需要刷新
@property (nonatomic,assign,getter = isNeedRefresh) BOOL needRefresh;
@property (nonatomic, assign) BOOL isRolling;//是否正在刷新
@property (nonatomic, assign) CGFloat tableViewOffset;//偏移量
@property (nonatomic, strong) HXDefaultView *defaultView;
@end

const CGFloat kRefreshBoundary = 100.0f;
@implementation HXMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.isNeedRefresh) {
        [self refreshBegin];
    }
    if (self.isRolling) {
        [self.tableViewHeader refreshingAnimateBegin];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.tableViewOffset = scrollView.contentOffset.y;
    NSLog(@"********%f",self.tableViewOffset);

    [self.tableViewHeader loadingViewAnimateWithScrollViewContentOffset:self.tableViewOffset];
    if (self.tableViewOffset<-100.f) {
        self.isRolling = YES;
        self.mainTableView.backgroundColor = [UIColor colorWithHexString:@"#3c5c8d"];
    
    } else {
        self.mainTableView.backgroundColor = [UIColor colorWithHexString:@"#f4f5f6"];
    }
    if (self.tableViewOffset == 0.0f) {
        self.isRolling = NO;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    if (offset <= -kRefreshBoundary) {
        [self refreshBegin];
    }
}

//下拉刷新
- (void)refreshBegin {
    
    [UIView animateWithDuration:0.2f animations:^{
        self.mainTableView.contentInset = UIEdgeInsetsMake(kRefreshBoundary, 0.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
        [self.tableViewHeader refreshingAnimateBegin];
        [self fakeDownload];
        
    }];
}
//下载数据
- (void)fakeDownload {
    
    [self initHomeListData];
    [self initAllCommonData];
}

//刷新完成
- (void)refreshComplete {
    
    [UIView animateWithDuration:0.35f animations:^{
        [self.tableViewHeader refreshingAnimateStop];
        
        self.mainTableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
        self.needRefresh = NO;
    }];
}

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - initSubView
- (void)saveAllCommonData:(NSArray *)allModuleArray {
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [path stringByAppendingPathComponent:@"allModule.plist"];
    [NSKeyedArchiver archiveRootObject:allModuleArray toFile:filePath];
}
//初始化全部模块数据
- (void)initAllCommonData {
    
    [[self.commonModuleViewModel.requestCommonListCommand execute:nil] subscribeNext:^(id x) {
        // 跳转常用模块
        self.allModuleArrayM = x;
        // 保存数据
        [self saveAllCommonData:x];
        
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    } completed:^{
        NSLog(@"completed");
    }];
}

//初始化主页数据
- (void)initHomeListData {
    
    @weakify(self)
    [[self.homeListViewModel.requestHomeListCommand execute:nil] subscribeNext:^(HXMHomeListModel * x) {
        @strongify(self)
        if (self.defaultView.defaultViewType == HXDefaultViewType_fail && self.defaultView) {
            [self.defaultView removeFromSuperview];
        }
        self.homeListModel = x;
        self.tableViewHeader.model = self.homeListModel.statData;
        [self.mainTableView reloadData];
        
    } error:^(NSError *error) {
        @strongify(self)
        [self refreshComplete];
        if (error.code == -1009) {
            [self.defaultView defaultViewType:HXDefaultViewType_fail];
        } else {
            [HXMProgressHUD showError:@"加载失败，请重试..." inview:self.view];
        }

        NSLog(@"%@",error);
    } completed:^{
        @strongify(self)
        [self refreshComplete];
        NSLog(@"completed");
    }];
}

#pragma mark - pushToSimilarNewsControllerDelegate
- (void)pushToSimilarNewsCell:(HXMFocusNewsCell *)cell news_id:(NSString *)news_id {
    
    HXMSimilarNewsController *vc = [[HXMSimilarNewsController alloc]init];
    vc.module_id = [NSString stringWithFormat:@"%ld",cell.model.module];
    vc.news_id = news_id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate,UITableViewDataSourc
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        //统计
        return 1;
    }else if (section == 1) {
        //常用模块
        return 1;
    } else if (section == 2) {
        //可能关注的公司
        return self.homeListModel.companyModuleNews.news.count;
    } else if (section == 3) {
        return self.homeListModel.sameIndustryModuleNews.news.count;
    }else if (section == 4) {
        return self.homeListModel.industryModuleNews.news.count;
    } else if (section == 5){
        return self.homeListModel.societyModuleNews.news.count;
    }else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        HXMStatisticsCountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statisticsCountCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.homeListModel.statData;
       @weakify(self)
        cell.clickSeparateView = ^(NSInteger tag) {
            @strongify(self)
            if (tag == 1000) {
                HXMTotalVolumeNewsViewController *vc = [[HXMTotalVolumeNewsViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            } else if (tag == 1001) {
                HXMHistoryPushViewController *vc = [[HXMHistoryPushViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }

        };
        return cell;
    }else if (indexPath.section == 1) {
        HXMCommonModuleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commonModuleCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.homeListModel.statData;
        return cell;
        
    }else if (indexPath.section == 2) {
        HXMFocusNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"focusNewsCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = [self.homeListModel.companyModuleNews.news objectOrNilAtIndex:indexPath.row];
        cell.model.module = self.homeListModel.companyModuleNews.module;
        //设置代理，实现相似新闻的跳转
        cell.delegate = self;
        return cell;
        
    }else if (indexPath.section == 3) {
        HXMFocusNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"focusNewsCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = [self.homeListModel.sameIndustryModuleNews.news objectOrNilAtIndex:indexPath.row];
        cell.model.module = self.homeListModel.sameIndustryModuleNews.module;
        cell.delegate = self;
        return cell;
        
    }else if (indexPath.section == 4) {
        HXMFocusNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"focusNewsCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = [self.homeListModel.industryModuleNews.news objectOrNilAtIndex:indexPath.row];
        cell.model.module = self.homeListModel.industryModuleNews.module;
        cell.delegate = self;
        return cell;
        
    }else {
        HXMFocusNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"focusNewsCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = [self.homeListModel.societyModuleNews.news objectOrNilAtIndex:indexPath.row];
        cell.model.module = self.homeListModel.societyModuleNews.module;
        cell.delegate = self;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01f;
    }else if (section == 1) {
        return 0.01f;
    } else if (section == 2) {
        if (self.homeListModel.companyModuleNews.news.count <= 0) {
            return 0.01f;
        }else {
            return 60;
        }
    }else if(section == 3){
        if (self.homeListModel.sameIndustryModuleNews.news.count <= 0) {
            return 0.01f;
        }else{
            return 60;
        }
    }else if(section == 4){
        if (self.homeListModel.industryModuleNews.news.count <= 0) {
            return 0.01f;
        }else{
            return 60;
        }
    }else if(section == 5){
        if (self.homeListModel.societyModuleNews.news.count <= 0) {
            return 0.01f;
        }else{
            return 60;
        }
    } else return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    return [self viewForHeaderInSection:section];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;

}
- (UIView *)viewForHeaderInSection:(NSInteger)section {
    
    if (section == 2) {
        if (self.homeListModel.companyModuleNews.news.count <= 0) {
            return nil;
        }else {
            HXMCommpanyNewsHeaderView *headerView = [[HXMCommpanyNewsHeaderView alloc] initWithTitle:@"公司要闻" WithTitleColor:nil withImageView:@"home_gsyw_icon"];
            return headerView;
        }
    }else if (section == 3) {
        if (self.homeListModel.sameIndustryModuleNews.news.count <= 0) {
            return nil;
        }else {
            HXMCommpanyNewsHeaderView *headerView = [[HXMCommpanyNewsHeaderView alloc] initWithTitle:@"同业要闻" WithTitleColor:nil withImageView:@"home_tyyw_icon"];
            return headerView;
        }
    }else if (section == 4) {
        if (self.homeListModel.industryModuleNews.news.count <= 0) {
            return nil;
        }else {
            HXMCommpanyNewsHeaderView *headerView = [[HXMCommpanyNewsHeaderView alloc] initWithTitle:@"行业要闻" WithTitleColor:nil withImageView:@"home_hyxw_icon"];
            return headerView;
        }
    }else if(section == 5){
        if (self.homeListModel.societyModuleNews.news.count <= 0) {
            return nil;
        }else {
            HXMCommpanyNewsHeaderView *headerView = [[HXMCommpanyNewsHeaderView alloc] initWithTitle:@"社会热点" WithTitleColor:nil withImageView:@"home_shrd_icon"];
            return headerView;
        }
    }else return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 122;
    }
    else if (indexPath.section == 1) {
        
        if(self.homeListModel.statData.common_module.count==0){
            return 0;
        } else if(self.homeListModel.statData.common_module.count<=4&&self.homeListModel.statData.common_module.count>0){
            return (134.0+10);
        } else {
            return (199.5+20);
        }
    }
    else {
        return UITableViewAutomaticDimension;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[HXMFocusNewsCell class]]) {
        HXMFocusNewsCell *newsCell = (HXMFocusNewsCell*)cell;
        HXMNewsDetailVC *vc = [[HXMNewsDetailVC alloc]init];
        vc.newsDetailType = NewsDetailByNewsTypeNormal;
        vc.module_id = [NSString stringWithFormat:@"%ld",newsCell.model.module];
        vc.newsId = [NSString stringWithFormat:@"%@",newsCell.model.id];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark -
- (void)setupUI {
    
    self.needRefresh = YES;
    self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-49);
    }];
    self.mainTableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    self.mainTableView.scrollIndicatorInsets = UIEdgeInsetsMake(-20, 0, 0, -49);
    [self.view addSubview:self.defaultView];
}
#pragma mark - getter
//全部模块的视图模型
- (HXMCommonModuleViewModel *)commonModuleViewModel {
    
    if (_commonModuleViewModel == nil) {
        _commonModuleViewModel = [[HXMCommonModuleViewModel alloc]init];
    }
    return _commonModuleViewModel;
}

//主页列表视图模型
- (HXMHomeListViewModel *)homeListViewModel {
    
    if (_homeListViewModel == nil) {
        _homeListViewModel = [[HXMHomeListViewModel alloc]init];
    }
    return _homeListViewModel;
}

- (HXMHomeListModel *)homeListModel {
    
    if (_homeListModel == nil) {
        _homeListModel = [[HXMHomeListModel alloc]init];
    }
    return _homeListModel;
}

- (TableViewHeader *)tableViewHeader {
    
    if (_tableViewHeader == nil) {
        _tableViewHeader = [[TableViewHeader alloc] initWithFrame:CGRectMake(0.0f,0.0f,SCREEN_WIDTH,148.0f)];
    }
    return _tableViewHeader;
}

- (UITableView *)mainTableView {
    
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = [UIColor colorWithHexString:@"#f4f5f6"];
        [_mainTableView registerNib:[UINib nibWithNibName:@"HXMStatisticsCountCell" bundle:nil] forCellReuseIdentifier:@"statisticsCountCell"];
        [_mainTableView registerNib:[UINib nibWithNibName:@"HXMFocusNewsCell" bundle:nil] forCellReuseIdentifier:@"focusNewsCell"];
        [_mainTableView registerClass:[HXMCommonModuleCell class] forCellReuseIdentifier:@"commonModuleCell"];
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.tableHeaderView = self.tableViewHeader;
        _mainTableView.estimatedRowHeight = 44;
    }
    return _mainTableView;
}

- (HXDefaultView *)defaultView{
    
    if (!_defaultView) {
        @weakify(self)
        _defaultView = [[HXDefaultView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49) reloadBlock:^void(HXDefaultViewType type){
            @strongify(self)
            [self refreshBegin];
        }];

        [_defaultView defaultMessage:@"新闻动态为空，敬请期待!" forDefaultViewType:HXDefaultViewType_empty];
        [_defaultView defaultImage:[UIImage imageNamed:@"HXM_emptyNews"] forDefaultViewType:HXDefaultViewType_empty];
    }
    return _defaultView;
}
@end
