//
//  HXMHistoryPushViewController.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/5/2.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMHistoryPushViewController.h"
#import "HXDefaultView.h"
#import "LoadFailView.h"
#import "HXMHistoryPushViewModel.h"
#import "HXMDetailNewsCellModel.h"
#import "HXMSimilarNewsCell.h"
#import "HXMNewsDetailVC.h"
#import "UIView+PromptWords.h"
#import "HXMSimilarNewsController.h"
#import "HXDefaultView.h"

@interface HXMHistoryPushViewController ()<UITableViewDelegate,UITableViewDataSource,pushToSimilarNewsControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <HXMDetailNewsCellModel *>*dataListArray;//模型数组
@property (nonatomic, copy) NSString *last_id;//下一页标识
@property (nonatomic, strong) HXDefaultView *defaultView;
@property (nonatomic, strong) LoadFailView *failView;
@property (nonatomic, strong) UIView * noDataView;//没有数据视图
@property (nonatomic, strong) HXMHistoryPushViewModel *historyPushViewModel;//获取推送新闻数据模型
@property (nonatomic, strong) HXMAnimationIndictateView *indictorView;//加载页

@end

@implementation HXMHistoryPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self setupRefresh];
    [self.view addSubview:self.defaultView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark- 添加上下拉刷新
/**添加上下拉刷新*/
-(void)setupRefresh
{
    @weakify(self)
    self.tableView.mj_header = [HXMRefresh headerWithRefreshingBlock:^{
        @strongify(self)
        [self downRefresh];
    }];
    [self.tableView.mj_header beginRefreshing];
   
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        @strongify(self)
//        [self getRefresh];
//    }];
//    self.tableView.mj_footer.automaticallyHidden = YES;
    
}

/**下拉刷新数据*/
- (void)downRefresh {
    
    [self.dataListArray removeAllObjects];
    self.historyPushViewModel.params = [@{@"last": @0} mutableCopy];
    @weakify(self)
    [self.historyPushViewModel.requestHistoryPushSignal subscribeNext:^(id x) {
        @strongify(self)
        if (self.defaultView.defaultViewType == HXDefaultViewType_fail && self.defaultView) {
            [self.defaultView removeFromSuperview];
        }
        [self.indictorView removeFromSuperview];
        self.dataListArray = [HXMDetailNewsCellModel mj_objectArrayWithKeyValuesArray:x[@"data"]];
        self.last_id = x[@"last"];
        [self.tableView.mj_header endRefreshing];
        
        if (_dataListArray.count>0) {
            if (_dataListArray.count == 10) {
                [self.tableView.mj_header endRefreshing];
                //下拉刷新
                self.tableView.mj_footer = [HXMfooterRefresh footerWithRefreshingBlock:^{
                    @strongify(self)
                    [self getRefresh];
                }];
                self.tableView.mj_footer.automaticallyHidden = YES;
            }
  
        } else {
            [self.defaultView defaultViewType:((self.dataListArray.count !=0)|| [x[@"data"] isEqual:nil]||[x[@"data"] isEqual:@""])?HXDefaultViewType_none:HXDefaultViewType_empty];
        }
        [self.tableView reloadData];
        
    } error:^(NSError *error) {
        @strongify(self)
        [self.indictorView removeFromSuperview];
        [_tableView.mj_header endRefreshing];
        [self.defaultView defaultViewType:HXDefaultViewType_fail];
        
    } completed:^{
        
    }];
}

/**上拉刷新*/
- (void)getRefresh {
    
    self.historyPushViewModel.params = [@{@"last":self.last_id} mutableCopy];
    @weakify(self)
    [self.historyPushViewModel.requestHistoryPushSignal subscribeNext:^(id x) {
        
        @strongify(self)
        self.last_id = x[@"last"];
        NSArray *appendArray = [HXMDetailNewsCellModel mj_objectArrayWithKeyValuesArray:x[@"data"]];
        
        if (appendArray.count>0 && (appendArray.count == 10)) {
            [_dataListArray addObjectsFromArray:appendArray];
            [self.tableView.mj_footer endRefreshing];
        }else if (appendArray.count < 10) {
            [_dataListArray addObjectsFromArray:appendArray];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        
        [self.tableView reloadData];
        
    } error:^(NSError *error) {
        @strongify(self)
        [_tableView.mj_header endRefreshing];
        [self.defaultView defaultViewType:HXDefaultViewType_fail];
        
    } completed:^{
        
    }];
    
}
#pragma mark -similarListPushToSimilarNewsControllerDelegate
- (void)pushToSimilarNewsCell:(HXMFocusNewsCell *)cell news_id:(NSString *)news_id {
//- (void)similarListPushToSimilarNewsViewController:(HXMSimilarNewsCell *)cell news_id:(NSString *)news_id {
    HXMSimilarNewsController *vc = [[HXMSimilarNewsController alloc]init];
    vc.module_id = @(14).description;
    vc.news_id = news_id;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UITableViewDelegate&&UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HXMFocusNewsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"focusNewsCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = [self.dataListArray objectOrNilAtIndex:indexPath.row];
    cell.delegate = self;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HXMNewsDetailVC *vc = [[HXMNewsDetailVC alloc]init];
    HXMDetailNewsCellModel *selectedModel = [self.dataListArray objectOrNilAtIndex:indexPath.row];
    vc.module_id = @(14).description;
    vc.newsId = selectedModel.id;
    vc.newsDetailType = NewsDetailByNewsTypeNormal;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 设置界面

- (void)setupUI {
    self.title = @"历史推送";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f5f6"];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:19.0], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor ]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:([UIColor colorWithHexString:@"#3c5c8e"]) size:CGSizeMake(Screen_width, Screen_height)] forBarMetrics:UIBarMetricsDefault];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view addSubview:self.indictorView];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#f4f5f6"];
        _tableView.estimatedRowHeight = 150.f;
        [_tableView registerNib:[UINib nibWithNibName:@"HXMFocusNewsCell" bundle:nil] forCellReuseIdentifier:@"focusNewsCell"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

//相似新闻的视图模型
- (HXMHistoryPushViewModel *)historyPushViewModel {
    
    if (_historyPushViewModel == nil) {
        _historyPushViewModel = [[HXMHistoryPushViewModel alloc]init];
    }
    return _historyPushViewModel;
}

- (NSMutableArray<HXMDetailNewsCellModel *> *)dataListArray {
    if (_dataListArray == nil) {
        _dataListArray = [NSMutableArray array];
    }
    return _dataListArray;
}
///**没有数据调用这个方法*/
//- (void)noDataReturn {
//    self.noDataView = [[UIView alloc] init];
//    self.noDataView.frame = self.view.frame;
//    [self.view addSubview:self.noDataView];
//    UIView *promptWordsView = [UIView getPromptWordsWithTitle:@"您还没有收藏任何消息呦!" Font:15.f TextColor:[UIColor colorWithHexString:@"#dddcdd"] Frame:CGRectMake(0, 0, Screen_width,Screen_height/2 + 420)];
//    [self.noDataView addSubview:promptWordsView];
//    UIImageView * iv = [[UIImageView alloc] init];
//    iv.frame = CGRectMake(Screen_width /2 - 100, Screen_height / 2 - 200, 200, 200);
//    UIImage * image = [UIImage imageNamed:@"HXM_emptyPush"];
//    iv.contentMode = UIViewContentModeScaleAspectFit;
//    iv.image = image;
//    [self.noDataView addSubview:iv];
//}

- (HXMAnimationIndictateView *)indictorView {
    
    if (_indictorView == nil) {
        _indictorView = [[HXMAnimationIndictateView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-36)];
    }
    return _indictorView;
}

- (LoadFailView *)failView {
    
    if (!_failView) {
        @weakify(self)
        _failView = [LoadFailView failViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) reloadBlock:^{
            @strongify(self)
            [self setupRefresh];
        }];
    }
    return _failView;
}

- (HXDefaultView *)defaultView {
    
    if (!_defaultView) {
        @weakify(self)
        _defaultView = [[HXDefaultView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) reloadBlock:^void(HXDefaultViewType type){
            @strongify(self)
            [self setupRefresh];
        }];
        [_defaultView defaultMessage:@"您暂未收到任何消息" forDefaultViewType:HXDefaultViewType_empty];
        [_defaultView defaultImage:[UIImage imageNamed:@"HXM_emptyPush"] forDefaultViewType:HXDefaultViewType_empty];
    }
    return _defaultView;
}

@end
