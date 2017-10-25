//
//  HXMHomeViewController.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/8.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMHomeViewController.h"
#import "HXMStatisticsHeaderCell.h"
#import "HXMStatisticsCountCell.h"
#import "HXMStatisticsLevelCell.h"
#import "HXMAllModuleViewController.h"
#import "HXMFocusNewsCell.h"
#import "HXMNewsDetalController.h"

static NSString *headerCell = @"headerCell";

@interface HXMHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@end

@implementation HXMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    self.view.backgroundColor = [UIColor whiteColor];


}
- (void)viewWillAppear:(BOOL)animated {

#warning 应该这样写
 self.navigationController.navigationBar.hidden = YES;
}

- (void)setupRefresh {

   

}
#pragma mark - UITableViewDelegate,UITableViewDataSourc
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        //总量
//        self.mainTableView.rowHeight = 168;
        return 1;
    } else if (section == 1) {
        //统计
//        self.mainTableView.rowHeight = 63;
        return 1;
    } else if (section == 2) {
        //饼状图
//        self.mainTableView.rowHeight = 330;
        return 1;
    } else if (section == 3) {
        //常用模块
//        self.mainTableView.rowHeight = 160;
        return 1;
    } else if (section == 4) {
        //可能关注的公司
//        self.mainTableView.rowHeight = 170;
        return 3;
    }
    return 3;
//    else if (section == 5) {
//        //
//        self.mainTableView.rowHeight = 170;
//        return 3;
//    } else {
//        //
//        self.mainTableView.rowHeight = 170;
//        return 3;
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        self.mainTableView.rowHeight = 118;
        HXMStatisticsHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statisticsHeaderCell"forIndexPath:indexPath];
//        cell.stockModel = self.viewModel.topStockData[indexPath.row];
        return cell;
    }
    else if (indexPath.section == 1) {
        self.mainTableView.rowHeight = 108;
        HXMStatisticsCountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statisticsCountCell" forIndexPath:indexPath];
        return cell;
    } else if (indexPath.section == 3) {
        self.mainTableView.rowHeight = 199.5;
        HXMStatisticsLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statisticsLevelCell" forIndexPath:indexPath];
        return cell;
    }else if (indexPath.section == 4) {
        self.mainTableView.rowHeight = 170;
        HXMFocusNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"focusNewsCell" forIndexPath:indexPath];
        return cell;
        
    }
    else if (indexPath.section == 2){
        self.mainTableView.rowHeight = 330;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.textLabel.text = @"饼状图";
        return cell;
    
    } else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"focusNewsDetalCell" forIndexPath:indexPath];
        cell.textLabel.text = @(indexPath.row).description;
        return cell;
        
    }

//
    
    
//    NSString *reuseIdentifier=[NSString stringWithFormat:@"%ld%ldCollectionCell",(long)indexPath.section,(long)indexPath.row];
//    [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
//    HXMFocusNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    
    /*
#warning HXMStatisticsLevelCell跳转回调
    //需要自定义nav
    cell.callBackCell = ^(NSInteger indexPath) {
        HXMAllModuleViewController *vc = [[HXMAllModuleViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];

    };
    */
//    cell.textLabel.text = @(indexPath.row).description;
//    return cell;
     
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        return 0.5f;
    } else if (section == 1) {
        return 10;
    } else if (section == 2) {
        return 10;
    } else if (section == 3) {
        return 10;
    } else {
        return 0.5f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}
#pragma mark - 
- (UITableView *)mainTableView {
    
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = [UIColor colorWithHexString:@"#f4f5f6"];

        [_mainTableView registerClass:[HXMStatisticsHeaderCell class] forCellReuseIdentifier:@"statisticsHeaderCell"];
        [_mainTableView registerClass:[HXMStatisticsCountCell class] forCellReuseIdentifier:@"statisticsCountCell"];
        [_mainTableView registerClass:[HXMStatisticsLevelCell class] forCellReuseIdentifier:@"statisticsLevelCell"];
        [_mainTableView registerClass:[HXMFocusNewsCell class] forCellReuseIdentifier:@"focusNewsCell"];
        [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
    }
    return _mainTableView;
}
@end
