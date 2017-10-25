//
//  HXMBaseListViewController.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/16.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMBaseListViewController.h"
#import "ZLSegmentView.h"
#import "HXMNavCustomButton.h"

@interface HXMBaseListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZLSegmentView *channelView;
@property (nonatomic, strong) HXMNavCustomButton *navCustomButton;
@end

@implementation HXMBaseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupNav {

    
    self.navCustomButton.leftTitle = @"是搜狐";
    self.navigationItem.titleView = self.navCustomButton;


}
#pragma mark- 
- (void)setupUI {
    self.view.backgroundColor = [UIColor blueColor];
    self.channelView = [[ZLSegmentView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 50)];
    [self.channelView updateChannels:self.channelDataList];
    self.channelView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.channelView];
    [self.view addSubview:self.tableView];

    //布局
    [self.channelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.channelView.mas_bottom).offset(20);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.channelDataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainNewsCell" forIndexPath:indexPath];
    
    cell.textLabel.text = @(indexPath.row).description;
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

#pragma mark - 

- (UITableView *)tableView {
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor yellowColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"mainNewsCell"];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSArray *)channelDataList {

    if (_channelDataList == nil) {
        _channelDataList = @[@"zhangsna",@"lishi",@"ashfjha",@"shajfh",@"我爱生活更爱美食",@"日子有点田"];
    }
    return _channelDataList;
}

- (HXMNavCustomButton *)navCustomButton {

    if (_navCustomButton == nil) {
        _navCustomButton = [[HXMNavCustomButton alloc]init];
    }
    return _navCustomButton;

}
- (NSArray *)contentDataList {

    if (_contentDataList == nil) {
        _contentDataList = [NSMutableArray array];
    }
    return _contentDataList;
}
@end
