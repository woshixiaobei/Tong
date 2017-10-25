//
//  HXMNewsViewController.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/8.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMNewsViewController.h"
#import "UIButton+ImageTitleSpacing.h"
#import "HXMPresentTableView.h"
#import "ChannelScrollView.h"
#import "HXMAllNewsViewController.h"
#import "HXMCommonModuleModel.h"
#import "HXMNewsListViewModel.h"
#import "HXMNewsModuleModel.h"
#import "HXMCommonModuleViewModel.h"
#import "HXMTitleButton.h"

@interface HXMNewsViewController ()<ChannelScrollViewDelegate>

@property (nonatomic, weak) HXMPresentTableView *presentView;
@property (nonatomic, weak) UIImageView *present;//下拉视图的小三角
@property (nonatomic, strong) HXMTitleButton *titleButton;
@property (nonatomic, strong) NSMutableArray *channels;
@property (nonatomic, strong) HXMNewsListViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray *typeId;
@property (nonatomic, copy) NSString *module_id;
@property (nonatomic, copy) NSString *next_id;
@property (nonatomic, weak) UIImageView *iv;//标题下拉三角
@property (nonatomic, assign) BOOL isUP;
@property (nonatomic, weak) ChannelScrollView *channelScrollView;
@property (nonatomic, copy) NSString *selectedName;
@property (nonatomic, strong)NSString *selectId;
@property (nonatomic, strong) NSArray *moduleArray;
@property (nonatomic, strong) HXMCommonModuleViewModel *commonModuleViewModel;
@property (nonatomic, assign) NewsListRequestType requestType;//请求类型

@end

@implementation HXMNewsViewController
- (instancetype)init {
    self = [super init];
    if (self) {
        //默认200
        _selectId = @"200";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectSecondVC:) name:@"CommonModuleToPushNewsNotification" object:nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark -接收通知跳转到相应的分类新闻并设置标题
- (void)selectSecondVC:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    _selectedName = userInfo[@"name"];
    NSString *modelId = userInfo[@"id"];
    _selectId = modelId;
    //判断是新闻列表进行跳转
    NSInteger moduleTag = [userInfo[@"moduleTag"] integerValue];
    if (moduleTag == 1) {
        //设置标题
        [_titleButton setTitle:_selectedName forState:UIControlStateNormal];
        [self initNewsListData];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.titleButton.selected = NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.titleButton.selected = NO;
    if (_present != nil) {
        [_present removeFromSuperview];
        _present = nil;
    }
    if (_presentView != nil) {
        [_presentView removeFromSuperview];
        _presentView = nil;
    }
}

#pragma mark - 初始化数据
- (void)initNewsListData {
    _channels = [NSMutableArray array];
    _typeId = [NSMutableArray array];
    
    //如果本地有保存,取本地的数据
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:kAllModuleFile]) {
        
        //公司新闻id
        self.moduleArray = [NSKeyedUnarchiver unarchiveObjectWithFile:kAllModuleFile];
        NSMutableArray *arrayM = [NSMutableArray array];
        NSMutableArray * arr = [NSMutableArray array];
        for (NSInteger i = 0; i < _moduleArray.count - 1; i++) {
            NSArray *tempArray = [_moduleArray objectOrNilAtIndex:i];
            for (HXMCommonModuleModel *model in tempArray) {
                [arrayM addObject:model.module_id];
                [arr addObject:model.module_name];
            }
        }
        
        if (_selectedName == nil) {
            [self.titleButton setTitle:arr.firstObject forState:UIControlStateNormal];
            self.titleButton.tag = [arrayM.firstObject integerValue];
        }
        if ([_selectId isEqual:@"200"]) {
            //点击tabbar进来
            self.viewModel.params = [@{@"module_id": arrayM.firstObject } mutableCopy];
            _module_id = arrayM.firstObject;
        }else{
            //点击模块进来
            self.viewModel.params = [@{@"module_id": _selectId } mutableCopy];
            _module_id = _selectId;
        }
    } else {
        //没有标题title时,就去请求接口
        [self updateAllModuleData];
    }
    //调取News列表数据
    [self updateNewsListData];
}

//初始化全部模块
- (void)updateAllModuleData {
    
    @weakify(self)
    [[self.commonModuleViewModel.requestCommonListCommand execute:nil] subscribeNext:^(id x) {
        NSLog(@"%@",x);
        @strongify(self)
        [NSKeyedArchiver archiveRootObject:x toFile:kAllModuleFile];
        self.moduleArray = x;
    } error:^(NSError *error) {
        [HXMProgressHUD showError:@"请求失败，请重新加载..." inview:self.view];
        NSLog(@"%@",error);
    } completed:^{
        NSLog(@"completed");
    }];
}

//调取news新闻列表数据
- (void)updateNewsListData {
    
    @weakify(self)
    [HXMProgressHUD showInView:self.view];
    [self.viewModel.requestNewsListSignal subscribeNext:^(HXMNewsModuleModel * x) {
        
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
    newVc.isTotalVolumeNews = NO;
    newVc.allNewsRequestType = NewsListRequestTypeNewsNormalModule;
    return newVc;
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
    NSMutableArray *array = [NSMutableArray new];
    NSMutableArray * arr = [NSMutableArray array];
    for (NSInteger i = 0; i < _moduleArray.count - 2; i++) {
        NSArray *tempArray = [_moduleArray objectOrNilAtIndex:i];
        for (HXMCommonModuleModel *model in tempArray) {
            [array addObject:model.module_name];
            [arr addObject:model.module_id];
        }
    }
    UIImageView * iv = [[UIImageView alloc] init];
    UIImage * image = [UIImage imageNamed:@"pop_triangle_icon"];
    iv.image = image;
    [self.navigationController.view.window addSubview:iv];
    iv.frame = CGRectMake(SCREEN_WIDTH/2 - 3, 56.5, 13.5, 7.5);
    _present = iv;
    HXMPresentTableView * presentView = [[HXMPresentTableView alloc] init];
    presentView.dataArr = array;
    presentView.gradeArr = arr;
    presentView.btnTitle = self.titleButton.currentTitle;
    presentView.btnTag = self.titleButton.tag;
    [self.view addSubview:presentView];
    presentView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    _presentView = presentView;
    [presentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //从首页常用模块点击进来的时候，标题的设置选中状态
    if (![_selectId isEqual:@"200"]) {
        //点击模块进来
        presentView.btnTag = [_selectId integerValue];
    }
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
            self.titleButton.selected = NO;
        }

        //点击获取网络请求
        self.viewModel.params = [@{@"module_id": gradeIndex} mutableCopy];
        [HXMProgressHUD showInView:self.view];
        [self.viewModel.requestNewsListSignal subscribeNext:^(HXMNewsModuleModel * x) {

            [self.titleButton setTitle:imageIndex forState:UIControlStateNormal];
            self.titleButton.tag = [gradeIndex integerValue];
            @strongify(self)
            [HXMProgressHUD hide];
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
                self.titleButton.selected = NO;
            }
            //设置导航视图
            [self setUpChannelView];

        } error:^(NSError *error) {
            [HXMProgressHUD hide];
            [HXMProgressHUD showError:@"请求失败，请重新加载..." inview:self.view];
        } completed:^{

        }];
    };
}
//收回弹出视图
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = touches.anyObject;
//    CGPoint point = [touch locationInView:touch.view];
//   point = [self.view convertPoint:point toView:self.view.window];
    if (_presentView != nil) {
        [_presentView removeFromSuperview];
        _presentView = nil;
    }
    if (_present != nil) {
        [_present removeFromSuperview];
        _present = nil;
    }
    self.titleButton.selected = NO;
}

#pragma mark - 设置界面
- (void)setupUI {
    self.requestType = NewsListRequestTypeQingBaoModule;
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f5f6"];
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
        [self.titleButton setTitle:@"公司新闻" forState:UIControlStateNormal];
        //初始化数据
        [self initNewsListData];
    } else {
        [self.titleButton setTitle:_selectedName forState:UIControlStateNormal];
    }
}
#pragma mark - lazyLoad

//新闻列表视图模型
- (HXMNewsListViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[HXMNewsListViewModel alloc]init];
    }
    return _viewModel;
}

//标题视图模型
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
@end
