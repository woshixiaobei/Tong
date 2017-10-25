//
//  HXMAboutMeViewController.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/5/2.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMAboutMeViewController.h"
#import "HXMAboutMeCell.h"

@interface HXMAboutMeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation HXMAboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HXMAboutMeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aboutMeCellIndetifier" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - 设置界面
- (void)setupUI {
    
    self.view.backgroundColor  = [UIColor colorWithHexString:@"f4f5f6"];
    self.title = @"关于我们";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:19.0], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor ]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:([UIColor colorWithHexString:@"#3c5c8e"]) size:CGSizeMake(Screen_width, Screen_height)] forBarMetrics:UIBarMetricsDefault];

    [self.view addSubview:self.tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

}
#pragma mark - 懒加载
- (UITableView *)tableView {
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#f4f5f6"];
        [_tableView registerNib:[UINib nibWithNibName:@"HXMAboutMeCell" bundle:nil] forCellReuseIdentifier:@"aboutMeCellIndetifier"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 300.0f;

    }
    return _tableView;
}


@end
