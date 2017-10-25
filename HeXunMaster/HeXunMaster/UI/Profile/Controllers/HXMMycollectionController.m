//
//  HXMMycollectionController.m
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/4/21.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMMycollectionController.h"
#import "UIView+PromptWords.h"
#import "HXMCollectionViewModel.h"
#import "HXMDetailNewsCellModel.h"
#import "LoadFailView.h"
#import "HXMSimilarNewsCell.h"
#import "HXMNewsDetailVC.h"
#import "HXMDeleteAllCollectionViewModel.h"
#import "HXMDeleteMultipleCollectionViewModel.h"
#import "HXDefaultView.h"
#import "HXMSimilarNewsController.h"

@interface HXMMycollectionController ()<UITableViewDelegate,UITableViewDataSource,similarListPushToSimilarNewsControllerDelegate>

@property (nonatomic ,strong) UITableView * tableView;
@property (nonatomic, weak) UIView *funcView;//底部全选 移除 视图
@property (nonatomic, strong) UIView * noDataView;//没有数据视图
@property (nonatomic, assign) BOOL isAllSelected;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, weak) NSString *selectedString;//选中收藏的拼接字符串
@property (nonatomic, strong) HXMCollectionViewModel *collectionViewModel;
@property (nonatomic, strong) LoadFailView *failView;
@property (nonatomic, strong) NSMutableArray *dataArray;//数据源
@property(nonatomic, strong) NSMutableArray *deleteArr;//删除数据的数组
@property (nonatomic, strong) NSMutableArray *deleteIds;//删除数据的id数组
@property (nonatomic, weak) UIButton *deleteButton;//移除按钮
@property (nonatomic, weak) UIButton *allSelectedButton;//全部选中按钮
@property (nonatomic, strong) HXMDeleteMultipleCollectionViewModel *deleMutipleViewModel;//删除多个收藏的视图模型
@property (nonatomic, strong) HXMDeleteAllCollectionViewModel *deleAllViewModel;//删除全部收藏的视图模型
@property (nonatomic, strong) HXDefaultView *defaultView;//失败界面
@property (nonatomic, strong) HXMAnimationIndictateView *indictorView;//加载页
@end

@implementation HXMMycollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.deleteArr = [NSMutableArray array];
    self.page = 1;
    [self setupRefresh];
    [self setupMainView];
    [self.view addSubview:self.defaultView];
    [self init_Notification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 添加通知
- (void)init_Notification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toDownRefreshListViewController) name:@"kToRefreshMyCollectionViewControllerNotification" object:nil];
}

- (void)toDownRefreshListViewController {
    [self setupRefresh];
}

#pragma mark- 添加上下拉刷新
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
    
    self.page = 1;
    [self.dataArray removeAllObjects];
    self.collectionViewModel.params = [@{@"pageNum": @(self.page),} mutableCopy];
    
    @weakify(self)
    [self.collectionViewModel.requestCollectionNewsListSignal subscribeNext:^(id x) {
        
        @strongify(self)
        if (self.defaultView.defaultViewType == HXDefaultViewType_fail && self.defaultView) {
            [self.defaultView removeFromSuperview];
        }
       [self.indictorView removeFromSuperview];
        self.dataArray = x;
        self.page++;
        [self.tableView.mj_header endRefreshing];
        
        if (self.dataArray.count>0) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑"
                                                                                     style:UIBarButtonItemStylePlain
                                                                                    target:self
                                                                                    action:@selector(selectedBtn:)];
            if (self.dataArray.count == 10) {
                [self.tableView.mj_header endRefreshing];
                //下拉刷新
                self.tableView.mj_footer = [HXMfooterRefresh footerWithRefreshingBlock:^{
                    @strongify(self)
                    [self getRefresh];
                }];
                self.tableView.mj_footer.automaticallyHidden = YES;
            }
        } else {
            self.navigationItem.rightBarButtonItem.title = nil;
            [self.defaultView defaultViewType:self.dataArray.count != 0?HXDefaultViewType_none:HXDefaultViewType_empty];
        }
        
        //在编辑状态时，下拉刷新变换下面的全选按钮以及删除按钮
        if (self.tableView.isEditing) {
            [self.deleteArr removeAllObjects];
            [self.allSelectedButton setTitle:@"全选" forState:UIControlStateNormal];
            self.deleteButton.enabled = NO;
        }
        [self.tableView reloadData];
 
    } error:^(NSError *error) {
        [self.indictorView removeFromSuperview];
        [_tableView.mj_header endRefreshing];
        [self.defaultView defaultViewType:HXDefaultViewType_fail];
        
    } completed:^{
        
    }];
}

/**上拉刷新*/
- (void)getRefresh {

    self.collectionViewModel.params =  [@{@"pageNum": @(self.page),} mutableCopy];
    [self.collectionViewModel.requestCollectionNewsListSignal subscribeNext:^(id x) {

        self.page++;
        NSArray *appendArray = x;
        
        if (appendArray.count>0 && appendArray.count >= 10) {
            [self.dataArray addObjectsFromArray:appendArray];
            [self.tableView.mj_footer endRefreshing];
        }else if (appendArray.count < 10) {
            [self.dataArray addObjectsFromArray:appendArray];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        
        [self.tableView reloadData];
        
        for (id model in self.deleteArr) {
            NSUInteger row = [self.dataArray indexOfObject:model];
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
        
    } error:^(NSError *error) {
 
        [_tableView.mj_header endRefreshing];
        [self.defaultView defaultViewType:HXDefaultViewType_fail];
        
    } completed:^{
        
    }];
}

//请求删除全部收藏接口
- (void)requestDeleAllCollectionSignal {

    [self.deleAllViewModel.requestDeleAllSignal subscribeNext:^(id x) {
        
        [HXMProgressHUD showSuccess:@"移除成功" inview:self.view];
        [self.tableView reloadData];
    } error:^(NSError *error) {
        [HXMProgressHUD showError:@"网络出错，请重新加载..." inview:self.view];
        
    } completed:^{
        
    }];
}
//请求删除多个收藏接口
- (void)requestDeleMutipleCollectionSignal {

    [self.deleteIds removeAllObjects];
    for (HXMDetailNewsCellModel *model in self.deleteArr) {
        [self.deleteIds addObject:model.id];
    }
    //将数组拼接成字符串
    NSString *selectedIds = [self.deleteIds componentsJoinedByString:@","];
    self.deleMutipleViewModel.params = [@{@"ids":selectedIds} mutableCopy];
    [HXMProgressHUD showInView:self.view];
    [self.deleMutipleViewModel.requestDeleMutipleSignal subscribeNext:^(id x) {
        
        [HXMProgressHUD hide];
        [HXMProgressHUD showSuccess:@"移除成功" inview:self.view];
        // 2. 更新UI
        [self.dataArray removeObjectsInArray:self.deleteArr];
        [self downRefresh];
    
    } error:^(NSError *error) {
        [HXMProgressHUD hide];
        [HXMProgressHUD showError:@"网络出错，请重新加载..." inview:self.view];
        
    } completed:^{
        
    }];
}

#pragma mark -similarListPushToSimilarNewsControllerDelegate
- (void)similarListPushToSimilarNewsViewController:(HXMSimilarNewsCell *)cell news_id:(NSString *)news_id {
    HXMSimilarNewsController *vc = [[HXMSimilarNewsController alloc]init];
    vc.module_id = @(14).description;
    vc.news_id = news_id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -UITableViewDelegate&&UITableViewDataSource
//是否可以编辑  默认的时YES
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
//选中时将选中行的在self.dataArray 中的数据添加到删除数组self.deleteArr中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (!self.tableView.isEditing) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        HXMNewsDetailVC *vc = [[HXMNewsDetailVC alloc]init];
        HXMDetailNewsCellModel *selectedModel = [self.dataArray objectOrNilAtIndex:indexPath.row];
        //vc.module_id = @(14).description;
        vc.newsDetailType = NewsDetailByNewsTypeCollection;
        vc.newsId = selectedModel.id;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
    
        //选中数据
        id model = [self.dataArray objectOrNilAtIndex:indexPath.row];
        [self.deleteArr addObject:model];
        //判断是否是全选
        if (self.deleteArr.count == self.dataArray.count) {
            [self.allSelectedButton setTitle:@"取消" forState:UIControlStateNormal];
            _isAllSelected = YES;
        } else {
            [self.allSelectedButton setTitle:@"全选" forState:UIControlStateNormal];
            _isAllSelected = NO;
        }
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        if (self.deleteArr.count > 0) {
            self.deleteButton.enabled = YES;
        } else if (self.deleteArr.count == 0) {
            self.deleteButton.enabled = NO;
        }
    }
}
//取消选中时 将存放在self.deleteArr中的数据移除
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    //从选中中取消
    if (self.deleteArr.count > 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        [self.deleteArr removeObject:[self.dataArray objectAtIndex:indexPath.row]];
        //判断是否是全选
        if (self.deleteArr.count == self.dataArray.count) {
            [self.allSelectedButton setTitle:@"取消" forState:UIControlStateNormal];
            _isAllSelected = YES;
        } else {
            [self.allSelectedButton setTitle:@"全选" forState:UIControlStateNormal];
            _isAllSelected = NO;
        }
        if (self.deleteArr.count == 0) {
            self.deleteButton.enabled = NO;
        }
    }
}

#pragma mark 滑动手势删除
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"移除"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
       
        id model = [self.dataArray objectOrNilAtIndex:indexPath.row];
        [self.deleteArr addObject:model];
        // 1. 更新数据
            [self.dataArray removeObjectAtIndex:indexPath.row];
        // 2. 更新UI
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
            [self requestDeleMutipleCollectionSignal];
    }];
    deleteRowAction.backgroundColor = [UIColor colorWithHexString:@"#f85959"];
    // 将设置好的按钮放到数组中返回
    return @[deleteRowAction];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HXMFocusNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"focusNewsCell" forIndexPath:indexPath];

//    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.tintColor = [UIColor colorWithHexString:@"3c5c8e"];
    //cell.selectedBackgroundView = [[UIView alloc]init];
    id model = [self.dataArray objectOrNilAtIndex:indexPath.row];
    cell.model = model;
 
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return UITableViewAutomaticDimension;
}

//选择-右上角编辑-按钮点击响应事件
- (void)selectedBtn:(UIButton *)button {
    
    //支持同时选中多行
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.tableView.editing = !self.tableView.editing;
    if (self.tableView.editing) {
        
        /*
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
             _funcView.alpha = 1;
        } completion:^(BOOL finished) {
            _isAllSelected = NO;
         
            [self.deleteArr removeAllObjects];
            [self.allSelectedButton setTitle:@"全选" forState:UIControlStateNormal];
            self.deleteButton.enabled = NO;
        }];
      */
        self.navigationItem.rightBarButtonItem.title = @"退出";
        _funcView.hidden = NO;
        _isAllSelected = NO;
        
        [self.deleteArr removeAllObjects];
        [self.allSelectedButton setTitle:@"全选" forState:UIControlStateNormal];
        self.deleteButton.enabled = NO;
        
    }else{
        self.navigationItem.rightBarButtonItem.title = @"编辑";
        _funcView.hidden = YES;
    }
}

//全选
- (void)selectAllBtnClick:(UIButton *)sender {

    if (_isAllSelected == NO) {
        _isAllSelected = YES;
        [sender setTitle:@"取消" forState:UIControlStateNormal];
        self.deleteButton.enabled = YES;
        self.deleteArr = self.dataArray.mutableCopy;
        
        for (int i = 0; i < self.dataArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
    } else {
        _isAllSelected = NO;
        [sender setTitle:@"全选" forState:UIControlStateNormal];
        self.deleteButton.enabled = NO;
        [self.deleteArr removeAllObjects];

        for (int i = 0; i < self.dataArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}
//移除按钮点击事件
- (void)deleteClick:(UIButton *) button {
    
    if (self.tableView.editing) {
        button.enabled = NO;
        if (self.dataArray.count == 0) {
            self.navigationItem.rightBarButtonItem.title = @"编辑";
            _funcView.hidden = YES;
        }
        [self requestDeleMutipleCollectionSignal];

    }
}

#pragma mark - 设置界面
- (void)setupMainView {
    
    self.title = @"我的收藏";
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

    UIView *funcView = [[UIView alloc] init];
    funcView.hidden = YES;
    funcView.backgroundColor = [UIColor colorWithHexString:@"#f4f5f5"];
    [self.view addSubview:funcView];
    [funcView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(44.5f);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    [funcView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(funcView);
        make.height.equalTo(@0.5);
    }];
    
    UIButton * btn = [[UIButton alloc] init];
    [btn setTitle:@"全选" forState:UIControlStateNormal];
    btn.contentMode = UIViewContentModeLeft;
    [btn setTitleColor:[UIColor colorWithHexString:@"#3c5c8e"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateDisabled];
    [funcView addSubview:btn];
    [btn addTarget:self action:@selector(selectAllBtnClick:)
  forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(funcView).offset(24);
        make.bottom.equalTo(funcView);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(40);
        
    }];
    
    UIButton * deleteBntton = [[UIButton alloc] init];
    [deleteBntton setTitle:@"移除" forState:UIControlStateNormal];
    [deleteBntton setTitle:@"移除" forState:UIControlStateDisabled];
    [deleteBntton setTitleColor:[UIColor colorWithHexString:@"#3c5c8e"] forState:UIControlStateNormal];
    [deleteBntton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateDisabled];
    deleteBntton.enabled = NO;
    [funcView addSubview:deleteBntton];
    [deleteBntton addTarget:self action:@selector(deleteClick:)
     forControlEvents:UIControlEventTouchUpInside];
    [deleteBntton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(funcView).offset(-24);
        make.bottom.equalTo(funcView);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(40);
        
    }];
    self.funcView = funcView;
    self.allSelectedButton = btn;
    self.deleteButton = deleteBntton;
    
//    [self initObserveSignal];
}
- (void)initObserveSignal {

    NSMutableArray *selectedDeleArray = [NSMutableArray array];
    [self.deleteArr.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
        [selectedDeleArray addObject:x];
        
    }];
    RAC(self.allSelectedButton,currentTitle) = [selectedDeleArray.rac_sequence.signal map:^id(NSArray *value) {
        return (value.count == 10)?@"取消":@"全选";
    }];
}

#pragma mark - getter
- (UITableView *)tableView {
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#f4f5f6"];
        [_tableView registerNib:[UINib nibWithNibName:@"HXMFocusNewsCell" bundle:nil] forCellReuseIdentifier:@"focusNewsCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 100;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.editing = NO;
           }
    return _tableView;
}

- (HXDefaultView *)defaultView{
    if (!_defaultView) {
    
        @weakify(self)
        _defaultView = [[HXDefaultView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) reloadBlock:^void(HXDefaultViewType type){
            @strongify(self)
            [self setupRefresh];
        }];
    
        [_defaultView defaultMessage:@"您还没有收藏任何消息呦!" forDefaultViewType:HXDefaultViewType_empty];
        [_defaultView defaultImage:[UIImage imageNamed:@"HXM_emptyCollection"] forDefaultViewType:HXDefaultViewType_empty];

    }
    return _defaultView;
}

-(NSMutableArray *)deleteIds {
    if (_deleteIds == nil) {
        _deleteIds = [NSMutableArray array];
    }
    return _deleteIds;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (HXMCollectionViewModel *)collectionViewModel {

    if (_collectionViewModel == nil) {
        _collectionViewModel = [[HXMCollectionViewModel alloc]init];
    }
    return _collectionViewModel;
}

- (HXMDeleteAllCollectionViewModel *)deleAllViewModel {

    if (_deleAllViewModel == nil) {
        _deleAllViewModel = [[HXMDeleteAllCollectionViewModel alloc]init];
    }
    return _deleAllViewModel;
}

- (HXMDeleteMultipleCollectionViewModel *)deleMutipleViewModel {

    if (_deleMutipleViewModel == nil) {
        _deleMutipleViewModel = [[HXMDeleteMultipleCollectionViewModel alloc]init];
    }
    return _deleMutipleViewModel;
}

- (HXMAnimationIndictateView *)indictorView {
    
    if (_indictorView == nil) {
        _indictorView = [[HXMAnimationIndictateView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    }
    return _indictorView;
    
}

@end
