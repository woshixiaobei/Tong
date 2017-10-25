//
//  HXMInformationViewController.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/8.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMInformationViewController.h"
#import "UIView+PromptWords.h"
#import "UIButton+ImageTitleSpacing.h"
#import "HXMPresentTableView.h"
#import "ChannelScrollView.h"
#import "HXMAllNewsViewController.h"
#import "HXMCommonModuleModel.h"
#import "HXMNewsListViewModel.h"
#import "HXMNewsModuleModel.h"
#import "HXMCommonModuleViewModel.h"
#import "HXMCompanyResearchReportViewModel.h"
#import "HXMCompanyResearchModel.h"
#import "HXMCompanyChannelModel.h"
#import "HXMTitleButton.h"

@interface HXMInformationViewController ()<ChannelScrollViewDelegate>

@property(nonatomic, strong) HXMPresentTableView *presentView;
@property(nonatomic, weak) UIImageView *present;
@property (nonatomic, strong) HXMTitleButton *titleButton;
@property (nonatomic, strong) HXMNewsListViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray *channels;//频道名称数组
@property (nonatomic, strong) NSMutableArray *typeId;//类型id数组
@property (nonatomic, strong) NSMutableArray *reportType;//公司情报数组
@property (nonatomic, copy) NSString *next_id;
@property (nonatomic, weak) UIImageView *iv;//标题的下拉三角
@property (nonatomic, assign) BOOL isUP;
@property (nonatomic, weak) ChannelScrollView *channelScrollView;
@property (nonatomic, copy) NSString *selectedName;
@property (nonatomic, strong)NSString *selectId;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) NSArray *moduleArray;
@property (nonatomic, strong) HXMCommonModuleViewModel *commonModuleViewModel;
@property (nonatomic, strong) HXMCompanyResearchReportViewModel *researchReportViewModel;//
@property (nonatomic, assign) NewsListRequestType requestType;//请求类型
@end

@implementation HXMInformationViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        //默认200
        _selectId = @"200";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectSecondVC:) name:@"CommonModuleToPushInformationNotification" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

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
     NSInteger moduleTag = [userInfo[@"moduleTag"] integerValue];
    if (moduleTag == 2) {
        //设置标题
        [_titleButton setTitle:_selectedName forState:UIControlStateNormal];
        //设置下拉视图选中tag
//        _presentView.btnTag = [modelId integerValue];
        //请求接口
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

            NSArray *tempArray = [_moduleArray objectOrNilAtIndex:1];
            for (HXMCommonModuleModel *model in tempArray) {
                [arrayM addObject:model.module_id];
                [arr addObject:model.module_name];
        }
        
        if (_selectedName == nil) {
            [self.titleButton setTitle:arr.firstObject forState:UIControlStateNormal];
            self.titleButton.tag = [arrayM.firstObject integerValue];
        }
        if ([_selectId isEqual:@"200"]) {
            //点击tabbar进来
            self.viewModel.params = [@{@"module_id": arrayM.firstObject} mutableCopy];
            _module_id = arrayM.firstObject;
        }else{
            //点击模块进来
            self.viewModel.params = [@{@"module_id": _selectId} mutableCopy];
            _module_id = _selectId;
        }
    } else {
        //没有标题title时,就去请求接口
        [self updateAllModuleData];
    }
    
    //调取News列表数据
    if ([self.module_id isEqual:@"11"]) {
        //如果是公司研报，调取公司研报接口
        [self requetCompanyResearchReport:self.module_id];
    } else {
        //调用普通接口
        [self requestNormalNewsList:self.module_id];
    }
}

//初始化全部模块
- (void)updateAllModuleData {
    @weakify(self)
    [[self.commonModuleViewModel.requestCommonListCommand execute:nil] subscribeNext:^(id x) {
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
//- (void)updateNewsListData {
//    
//    @weakify(self)
//    [self.viewModel.requestNewsListSignal subscribeNext:^(HXMNewsModuleModel * x) {
//        
//        @strongify(self)
//        [self.channels removeAllObjects];
//        [self.typeId removeAllObjects];
//        for (HXMnewsTypeModel *typeModel in x.news_types) {
//            
//            [self.channels addObject:typeModel.typeName];
//            [self.typeId addObject:typeModel._id];
//        }
//        NSLog(@"%@",self.channels);
//        
//        [self setUpChannelView];
//        _next_id = x.next_id;
//        
//    } error:^(NSError *error) {
//        [HXMProgressHUD showError:@"请求失败，请重新加载..." inview:self.view];
//    } completed:^{
//        
//    }];
//}
#pragma mark - 设置界面
- (void)setupUI {
    
    self.requestType = NewsListRequestTypeQingBaoModule;
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f5f6"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.titleButton = [[HXMTitleButton alloc]init];
    self.titleButton.adjustsImageWhenHighlighted = NO;
    [self.titleButton setTitle:@"公司新闻" forState:UIControlStateNormal];
    self.titleButton.frame = CGRectMake(0, 0, 200, 20);
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
   
    self.pageNum = 1;
    NSMutableArray *array = [NSMutableArray new];
    NSMutableArray * arr = [NSMutableArray array];
    NSArray *tempArray = [_moduleArray objectOrNilAtIndex:1];
    for (HXMCommonModuleModel *model in tempArray) {
        [array addObject:model.module_name];
        [arr addObject:model.module_id];

    }
    UIImageView * iv = [[UIImageView alloc] init];
    UIImage * image = [UIImage imageNamed:@"pop_triangle_icon"];
    iv.image = image;
    [self.navigationController.view.window addSubview:iv];
    iv.frame = CGRectMake(SCREEN_WIDTH/2 - 3, 56.5, 13.5, 7.5);
    _present = iv;
    self.presentView = [[HXMPresentTableView alloc] init];
    self.presentView.dataArr = array;
    self.presentView.gradeArr = arr;
    self.presentView.btnTitle = self.titleButton.currentTitle;
    self.presentView.btnTag = self.titleButton.tag;
    [self.view addSubview:self.presentView];
    self.presentView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];

    [self.presentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //从首页常用模块点击进来的时候，标题的设置选中状态
    if (![_selectId isEqual:@"200"]) {
        //点击模块进来
        self.presentView.btnTag = [_selectId integerValue];
    }
    @weakify(self)
    self.presentView.clickedImageCallback = ^(NSString * imageIndex, NSString *gradeIndex) {
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
        
        //点击获取情报列表数据
        if ([self.module_id isEqual:@"11"]) {
            //如果是公司研报，调取公司研报接口
            [self requetCompanyResearchReport:gradeIndex];
        } else {
            //调用普通接口
            [self requestNormalNewsList:gradeIndex ];
        }
    };
}

#pragma mark - 调取导航栏接口
//调用公司研报接口
- (void)requetCompanyResearchReport:(NSString *)gradeIndex {

    _reportType = [NSMutableArray array];
    @weakify(self)
    [HXMProgressHUD showInView:self.view];
    self.researchReportViewModel.params = [@{@"module_id":gradeIndex,@"pageNum":@(self.pageNum)} mutableCopy];

    [self.researchReportViewModel.requestCompanyResearchSignal subscribeNext:^(HXMCompanyResearchModel *x) {
        @strongify(self)
        [HXMProgressHUD hide];
        self.pageNum++;
        [self.channels removeAllObjects];
        [self.typeId removeAllObjects];
        [self.reportType removeAllObjects];
        
        for (HXMCompanyChannelModel *typeModel in x.report_news_types) {
            [self.channels addObject:typeModel.reportName];
            [self.typeId addObject:typeModel.type];
            [self.reportType addObject:typeModel.reportType];
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
}

//调用普通接口
- (void)requestNormalNewsList:(NSString *)gradeIndex {

    @weakify(self)
    [HXMProgressHUD showInView:self.view];
    self.viewModel.params = [@{@"module_id": gradeIndex} mutableCopy];
    [self.viewModel.requestNewsListSignal subscribeNext:^(HXMNewsModuleModel * x) {
        
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
    self.titleButton.selected = NO;
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
    if ([self.module_id isEqual:@"11"]) {
        newVc.reportType = [self.reportType objectOrNilAtIndex:indexPath.row];
    }
    newVc.module_id = self.module_id;
    newVc.btnTitle = self.titleButton.currentTitle;
    newVc.allNewsRequestType = NewsListRequestTypeQingBaoModule;
    return newVc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 懒加载

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

//公司研报
- (HXMCompanyResearchReportViewModel *)researchReportViewModel {

    if (_researchReportViewModel == nil) {
        _researchReportViewModel = [[HXMCompanyResearchReportViewModel alloc]init];
    }
    return _researchReportViewModel;
}

//标题数组
- (NSArray *)moduleArray {
    if (_moduleArray == nil) {
        _moduleArray = [NSArray array];
    }
    return _moduleArray;
}
@end
