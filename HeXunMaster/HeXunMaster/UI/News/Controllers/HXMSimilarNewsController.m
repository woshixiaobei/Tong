//
//  HXMSimilarNewsController.m
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/3/23.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMSimilarNewsController.h"
#import "HXMSimilarNewsCell.h"
#import "UIView+PromptWords.h"
#import "HXMSimilarNewsViewModel.h"
#import "HXDefaultView.h"
#import "LoadFailView.h"
#import "HXMRefresh.h"
#import "HXMfooterRefresh.h"
#import "HXMNewsDetailVC.h"
#import "HXMPushToastViewController.h"

@interface HXMSimilarNewsController ()<UITableViewDelegate,UITableViewDataSource,similarListPushToSimilarNewsControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;//主tableView
@property (nonatomic, strong) HXMSimilarNewsViewModel *similarNewsViewModel;//获取相似新闻数据模型
@property (nonatomic, strong) NSMutableArray<HXMDetailNewsCellModel *> *dataListArray;//模型数组
@property (nonatomic, copy) NSString *next_id;//下一页标识
@property (nonatomic, strong) UIView * noDataView;//没有数据视图
@property (nonatomic, strong) HXMAnimationIndictateView *indictorView;//加载页
@property (nonatomic, strong) HXDefaultView *defaultView;//默认空页面
@property (nonatomic, strong) LoadFailView *failView;//默认加载失败视图

@end

@implementation HXMSimilarNewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.title = @"相似新闻";
    [self setupUI];
    [self setupRefresh];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0f], NSForegroundColorAttributeName : [UIColor blackColor]}];
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:19.0f], NSForegroundColorAttributeName : [UIColor whiteColor]}];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
}

/**下拉刷新数据*/
- (void)downRefresh {
    
    [self.dataListArray removeAllObjects];
    self.similarNewsViewModel.params = [@{@"module_id": self.module_id, @"news_id": self.news_id,@"id":@""} mutableCopy];
    
    @weakify(self)
    [self.similarNewsViewModel.requestSimilarNewsListSignal subscribeNext:^(id x) {
        
        @strongify(self)
        if (self.defaultView.defaultViewType == HXDefaultViewType_fail && self.defaultView) {
            [self.defaultView removeFromSuperview];
        }
        [self.indictorView removeFromSuperview];
        _dataListArray = [HXMDetailNewsCellModel mj_objectArrayWithKeyValuesArray:x[@"news"]];
        self.next_id = x[@"next_id"];
        [self.tableView.mj_header endRefreshing];
        
        if (_dataListArray.count>0) {
            if (_dataListArray.count == 10) {
                [self.tableView.mj_header endRefreshing];
                //上拉刷新
                self.tableView.mj_footer = [HXMfooterRefresh footerWithRefreshingBlock:^{
                    [self getRefresh];
                }];
                self.tableView.mj_footer.automaticallyHidden = YES;
            }
        } else {
            [ self.defaultView defaultViewType:(self.dataListArray.count != 0)?HXDefaultViewType_none:HXDefaultViewType_empty];
            
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
    
    self.similarNewsViewModel.params = [@{@"module_id": self.module_id, @"news_id": self.news_id,@"id":self.next_id} mutableCopy];
    [self.similarNewsViewModel.requestSimilarNewsListSignal subscribeNext:^(id x) {
        
        self.next_id = x[@"next_id"];
        NSArray *appendArray = [HXMDetailNewsCellModel mj_objectArrayWithKeyValuesArray:x[@"news"]];
        
        if (appendArray.count>0 && appendArray.count >= 10) {
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
        [_tableView.mj_header endRefreshing];
        [self.defaultView defaultViewType:HXDefaultViewType_fail];
        
    } completed:^{
        
    }];
}

#pragma mark - UITableViewDelegate&&UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HXMSimilarNewsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"similarNewsCell" forIndexPath:indexPath];
    cell.model = [self.dataListArray objectOrNilAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HXMNewsDetailVC *detailViewController = [[HXMNewsDetailVC alloc]init];
    //    detailViewController.module_id = self.module_id;
    //    detailViewController.newsId = self.news_id;
    detailViewController.type_id = self.type_id;
    //对于敏感新闻，进入相似新闻列表，特殊处理module_id和newsId处理
    //    if ([self.module_id isEqualToString:@"14"]) {
    HXMDetailNewsCellModel *model = [self.dataListArray objectOrNilAtIndex:indexPath.row];
    detailViewController.module_id = model.moduleId;
    detailViewController.newsId = model.id;
    //        detailViewController.type_id = model.
    //    }
    detailViewController.newsDetailType = NewsDetailByNewsTypeNormal;
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}
#pragma mark - 设置界面
- (void)setupUI {
    
    self.title = @"相似新闻";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f4f5f6"];
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
        [_tableView registerClass:[HXMSimilarNewsCell class] forCellReuseIdentifier:@"similarNewsCell"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

//相似新闻的视图模型
- (HXMSimilarNewsViewModel *)similarNewsViewModel {
    
    if (_similarNewsViewModel == nil) {
        _similarNewsViewModel = [[HXMSimilarNewsViewModel alloc]init];
    }
    return _similarNewsViewModel;
}

- (NSMutableArray<HXMDetailNewsCellModel *> *)dataListArray {
    if (_dataListArray == nil) {
        _dataListArray = [NSMutableArray array];
    }
    return _dataListArray;
}

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
            [self setupRefresh];
        }];
        [_defaultView defaultMessage:@"未发现相似新闻哟!" forDefaultViewType:HXDefaultViewType_empty];
    }
    return _defaultView;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
