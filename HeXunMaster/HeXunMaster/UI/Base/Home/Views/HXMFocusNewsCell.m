//
//  HXMFocusNewsCell.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/15.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMFocusNewsCell.h"
#import "HXMFocusNewsDetalCell.h"

static NSString *cellId = @"cellId";

@interface HXMFocusNewsCell ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;


@end

@implementation HXMFocusNewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        
    }
    return self;
}
#pragma mark - 设置界面
- (void)setupUI {
    
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"您可能关注的公司要闻";
    label.textColor = [UIColor colorWithHexString:@"#3c5c8e"];
    label.font = [UIFont systemFontOfSize:14];
    label.frame = CGRectMake(24, 0, 200, 40);
    [header addSubview:label];
    return header;
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HXMFocusNewsDetalCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
//    cell.textLabel.text = @(indexPath.row).description;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}


#pragma mark - 懒加载
- (UITableView *)tableView {
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#f4f5f6"];
        _tableView.estimatedRowHeight = 150.f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerClass:[HXMFocusNewsDetalCell class] forCellReuseIdentifier:cellId];
        _tableView.scrollEnabled = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

@end
