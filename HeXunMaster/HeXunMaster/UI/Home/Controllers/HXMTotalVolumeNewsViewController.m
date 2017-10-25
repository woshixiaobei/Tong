//
//  HXMTotalVolumeNewsViewController.m
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/7/18.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMTotalVolumeNewsViewController.h"
#import "HXMPresentTableView.h"
#import "ChannelScrollView.h"
#import "HXMAllNewsViewController.h"
#import "HXMNewsListViewModel.h"
#import "HXMNewsModuleModel.h"
#import "HXMTotalVolumeNewsViewModel.h"
#import "HXMTitleButton.h"

@interface HXMTotalVolumeNewsViewController ()<ChannelScrollViewDelegate>

@property (nonatomic, weak) ChannelScrollView *channelScrollView;
@property (nonatomic, weak) UIImageView *iv;//标题下拉三角
@property (nonatomic, strong) HXMTitleButton *titleButton;//标题
@property (nonatomic, copy) NSString *selectedName;//选中的名称
@property(nonatomic,strong) HXMPresentTableView *presentView;//展示视图
@property(nonatomic,strong) UIImageView *present;//展示视图的小三角
@property (nonatomic, assign) BOOL isUP;
//@property (nonatomic, strong) NSArray *channelNames;//导航数组
@property (nonatomic, strong) NSArray *titleNameArray;//标题名称数组
@property (nonatomic, strong) NSArray *titleModuleIdArray;//标题的module_id数组
@property (nonatomic, strong) HXMTotalVolumeNewsViewModel *viewModel;
@property (nonatomic, copy) NSString *next_id;
@property (nonatomic, strong) NSMutableArray *channels;//频道名称数组
@property (nonatomic, strong) NSMutableArray *typeId;//类型id数组
@property (nonatomic, assign) NewsListRequestType requestType;//正负新闻请求类型
@end

@implementation HXMTotalVolumeNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated {
//    _iv.image = [UIImage imageNamed:@"push_down_icon"];
    self.titleButton.selected = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.titleButton.selected = NO;
    if (_present != nil) {
        
        [_present removeFromSuperview];
        _present = nil;
    }
    //解决手势侧滑功能
//    if (_isUP) {
//        _iv.image = [UIImage imageNamed:@"push_down_icon"];
//        _isUP = NO;
//    } else {
//        
//        _iv.image = [UIImage imageNamed:@"pull_up_icon"];
//        _isUP =  YES;
//    }
    
    if (_presentView != nil) {
        [_presentView removeFromSuperview];
        _presentView = nil;
    }
}


//调取news新闻列表数据
- (void)updateNewsListData {
    
    _channels = [NSMutableArray array];
    _typeId = [NSMutableArray array];
    self.titleModuleIdArray = @[@"7",@"64",@"65",@"87"];
    self.titleNameArray =@[@"资讯新闻",@"社区新闻",@"微信新闻",@"微博新闻"];
    self.module_id = self.titleModuleIdArray.firstObject;
    //第一次的标题的选中状态
    if (_selectedName == nil) {
        [_titleButton setTitle:@"资讯新闻" forState:UIControlStateNormal];
        _titleButton.tag = [self.titleModuleIdArray.firstObject integerValue];
    }
    @weakify(self)
    self.viewModel.params = [@{@"module_id": self.titleModuleIdArray.firstObject, @"positive": @"all"} mutableCopy];
    
    [HXMProgressHUD showInView:self.view];
    [[self.viewModel.requestTotalVolumeNewsCommand execute:nil] subscribeNext:^(HXMNewsModuleModel *x) {
        
        @strongify(self)
        [HXMProgressHUD hide];
        [self.channels removeAllObjects];
        [self.typeId removeAllObjects];
        for (HXMnewsTypeModel *typeModel in x.news_types) {
            
            [self.channels addObject:typeModel.typeName];
            [self.typeId addObject:typeModel._id];
        }
        NSLog(@"%@",self.channels);
        [self setUpChannelView];
        _next_id = x.next_id;
        
    } error:^(NSError *error) {
        [HXMProgressHUD hide];
        [HXMProgressHUD showError:@"请求失败，请重新加载..." inview:self.view];
    } completed:^{
        
    }];
}

/** 频道设置 */
-(void)setUpChannelView{

    ChannelScrollView *channelScrollView = [ChannelScrollView GetChannelScrollViewContorllerWithChannelDatas:self.channels pageChannelCount:4];
    _channelScrollView = channelScrollView;
    channelScrollView.delegate = self;
    [self.view addSubview:channelScrollView];
    [channelScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
}

#pragma mark - ChannelScrollViewDelegate
- (UIViewController *)ChannelScrollView:(ChannelScrollView *)channelVc ViewcontrollerForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HXMAllNewsViewController *newVc = [[HXMAllNewsViewController alloc]init];
    newVc.type_id = [self.typeId objectOrNilAtIndex:indexPath.row];
    newVc.module_id = self.module_id;
    newVc.btnTitle = self.titleButton.currentTitle;
    newVc.isTotalVolumeNews = YES;
    newVc.allNewsRequestType = NewsListRequestTypeTotalVolumeModule;
    return newVc;
}

//调用普通接口
- (void)requestNormalNewsList:(NSString *)gradeIndex {
    
    _channels = [NSMutableArray array];
    _typeId = [NSMutableArray array];
    
    @weakify(self)
    [HXMProgressHUD showInView:self.view];
    self.viewModel.params = [@{@"module_id": gradeIndex,@"positive":@"all"} mutableCopy];
    [[self.viewModel.requestTotalVolumeNewsCommand execute:nil]subscribeNext:^(HXMNewsModuleModel *x) {
        @strongify(self)
        [HXMProgressHUD hide];
        //保存下一页的索引
        _next_id = x.next_id;
        [self.channels removeAllObjects];
        [self.typeId removeAllObjects];
        for (HXMnewsTypeModel *typeModel in x.news_types) {
            [self.channels addObject:typeModel.typeName];
            [self.typeId addObject:typeModel._id];
        }
        if (_channelScrollView != nil) {
            [_channelScrollView removeFromSuperview];
        }
        if (_present != nil) {
            
            [_present removeFromSuperview];
            _present = nil;
            [_presentView removeFromSuperview];
            _presentView = nil;
            _module_id = gradeIndex;
//            _iv.image = [UIImage imageNamed:@"push_down_icon"];
//            _isUP = NO;
            self.titleButton.selected = NO;
        }
        //设置导航视图
        [self setUpChannelView];
        
    } error:^(NSError *error) {
        [HXMProgressHUD hide];
        [HXMProgressHUD showError:@"请求失败，请重新加载..." inview:self.view];
    } completed:^{
        
    }];
}

//收回弹出视图
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_presentView != nil) {
        [_presentView removeFromSuperview];
        _presentView = nil;
    }
    if (_present != nil) {
        [_present removeFromSuperview];
        _present = nil;
    }
//    _iv.image = [UIImage imageNamed:@"push_down_icon"];
//    _isUP = NO;
    self.titleButton.selected = NO;
}

//点击标题的按钮
- (void)buttonClick {
    self.titleButton.selected = !self.titleButton.selected;
    if (_presentView != nil) {
        [_present removeFromSuperview];
        _present = nil;
        [_presentView removeFromSuperview];
        _presentView = nil;
        return;
    }
    //初始化标题上的下拉tableView
    [self init_presentViewSubViews];
}

//初始化标题上的下拉tableView
- (void)init_presentViewSubViews {
    
    UIImageView * iv = [[UIImageView alloc] init];
    UIImage * image = [UIImage imageNamed:@"pop_triangle_icon"];
    iv.image = image;
    [self.navigationController.view.window addSubview:iv];
    iv.frame = CGRectMake(SCREEN_WIDTH/2 - 3, 56.5, 13.5, 7.5);
    _present = iv;
    HXMPresentTableView * presentView = [[HXMPresentTableView alloc] init];
    presentView.dataArr = self.titleNameArray;
    presentView.gradeArr = self.titleModuleIdArray;
    presentView.btnTitle = _titleButton.currentTitle;
    presentView.btnTag = _titleButton.tag;
    [self.view addSubview:presentView];
    presentView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    _presentView = presentView;
    [presentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    @weakify(self)
    presentView.clickedImageCallback = ^(NSString * imageIndex, NSString *gradeIndex) {
        @strongify(self)
        [self.titleButton setTitle:imageIndex forState:UIControlStateNormal];
        self.titleButton.tag = [gradeIndex integerValue];
        
        if (_present != nil) {
            
            [_present removeFromSuperview];
            _present = nil;
            [_presentView removeFromSuperview];
            _presentView = nil;
            _module_id = gradeIndex;
            
//            _iv.image = [UIImage imageNamed:@"push_down_icon"];
//            _isUP = NO;
        self.titleButton.selected = NO;
        }

        // 调用普通接口
        [self requestNormalNewsList:gradeIndex];
    };
    
}
#pragma mark - 设置界面
- (void)setupSubViews {
    
    [self setupNavigationBar];
    [self setupNavigationTitle];
    self.requestType = NewsListRequestTypeTotalVolumeModule;
}

//设置导航栏标题
- (void)setupNavigationTitle {
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f5f6"];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
//    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
//    btn.titleLabel.font = [UIFont boldSystemFontOfSize:19];
//    [btn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
//
//    UIImageView * iv = [[UIImageView alloc] init];
//    _iv = iv;
//    UIImage * image = [UIImage imageNamed:@"push_down_icon"];
//    iv.image = image;
//    [btn addSubview:iv];
//    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(btn.titleLabel).offset(7);
//        make.left.equalTo(btn.titleLabel.mas_right).offset(7);
//        make.width.mas_equalTo(15);
//        make.height.mas_equalTo(8);
//    }];
//    [btn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
//    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [view addSubview:btn];
//    btn.frame = view.frame;
//    _titleButton = btn;
//    self.navigationItem.titleView = view;
    self.titleButton = [[HXMTitleButton alloc]init];
    self.titleButton.adjustsImageWhenHighlighted = NO;
    [self.titleButton setTitle:@"公司新闻" forState:UIControlStateNormal];
    @weakify(self)
    [self.titleButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self)
        [self buttonClick];
    }];
    self.navigationItem.titleView = self.titleButton;
    if (_selectedName == nil) {
        [_titleButton setTitle:self.titleNameArray.firstObject forState:UIControlStateNormal];
        _titleButton.tag = [self.titleModuleIdArray.firstObject integerValue];
    }
    if (_selectedName == nil) {
        [self.titleButton setTitle:@"资讯新闻" forState:UIControlStateNormal];
        //初始化数据
        [self updateNewsListData];
        
    } else {
        [self.titleButton setTitle:_selectedName forState:UIControlStateNormal];
    }
}

//设置导航条背景
- (void)setupNavigationBar {

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:19.0], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor ]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:([UIColor colorWithHexString:@"#3c5c8e"]) size:CGSizeMake(Screen_width, Screen_height)] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - 
- (HXMTotalVolumeNewsViewModel *)viewModel {

    if (_viewModel == nil) {
        _viewModel = [[HXMTotalVolumeNewsViewModel alloc]init];
    }
    return _viewModel;
}

@end
