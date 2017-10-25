
//
//  HXMOpinionAnalysisChartView.m
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/7/18.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMOpinionAnalysisChartView.h"
#import "HXMPositiveNewsRatioPieChart.h"
#import "HXMCentralNewsRatioPieCell.h"
#import "HXMPropertyNewsCell.h"

#import "MYStockInfoMoneyModel.h"
#import "HXMSubCompanyModel.h"

@interface HXMOpinionAnalysisChartView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * amountDataArray;//总数据数组
@property (nonatomic, strong) NSArray *subCompanyArray;//子公司模型数组
@property (nonatomic, strong) NSArray *circleColorArray;//子公司占比颜色数组

@end
@implementation HXMOpinionAnalysisChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
#pragma mark - setter方法
- (void)setDataList:(NSMutableDictionary *)dataList {
    _dataList = dataList;
    self.analysisChartModel = [HXMNewsStatisticsCountModel mj_objectWithKeyValues:dataList];
    [self changeToPieChartArrayModel:dataList];
    [self.tableView reloadData];
}
#pragma mark - 转换数据
//转换模型数组
- (void) changeToPieChartArrayModel:(id)data {
    [self.amountDataArray addObjectsFromArray:self.analysisChartModel.circleArrayM];
    //添加子公司占比
    NSArray *tempSubCompanyArray = data[@"sub_company"];
    if (tempSubCompanyArray.count>0) {
        self.subCompanyArray = [HXMSubCompanyModel mj_objectArrayWithKeyValuesArray:tempSubCompanyArray];
        if (![tempSubCompanyArray isEqual:[NSNull class]]&&tempSubCompanyArray.count>0) {
            
            [self setSubCommpanyPieRate];
        }
    }
}

//设置子公司的饼状图
- (void)setSubCommpanyPieRate {
    
    NSMutableArray* pTempArray = [NSMutableArray arrayWithCapacity:6];
    CGFloat subCompanyCount = 0.0;
    
    for (NSInteger i = 0; i < self.subCompanyArray.count; i++) {
        HXMSubCompanyModel *model = self.subCompanyArray[i];
        subCompanyCount += [model.sub_news_num floatValue];
    }
    
    for (NSInteger i = 0; i < self.subCompanyArray.count; i++) {
        HXMSubCompanyModel *model = self.subCompanyArray[i];
        NSString *name = model.sub_company_name;
        NSString *countNumber = model.sub_news_num;
        CGFloat rate = [model.sub_news_num integerValue]/subCompanyCount;
        MYStockInfoMoneyModel *chartModel = [MYStockInfoMoneyModel moneyModelWithColor:self.circleColorArray[i] percent:rate title:[NSString stringWithFormat:@"%@\n%ld(%.2f%%)",name,(long)[countNumber integerValue],rate*100.f]];
        [pTempArray addObject:chartModel];
    }
    
    [self.amountDataArray addObject:pTempArray];
}
#pragma mark -UITableViewDataSource&&UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {

        HXMPropertyNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"propertyNewsCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.circleDataArray = [self.amountDataArray objectOrNilAtIndex:0];
        
        return cell;
    } else if (indexPath.row == 1) {
        HXMPositiveNewsRatioPieChart *cell = [tableView dequeueReusableCellWithIdentifier:@"positiveNewsRatioPieChart" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.amountDataArray.count == 3) {
            cell.circleDataArray = [self.amountDataArray objectOrNilAtIndex:2];
        } else {
            cell.circleDataArray = [self.amountDataArray objectOrNilAtIndex:1];
        }
        return cell;
    } else if (indexPath.row == 2) {
        HXMCentralNewsRatioPieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"centralNewsRatioPieCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.analysisChartModel;
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 330;
}

- (void)setupUI {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    [self addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f4f5f6"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 330;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.tableView registerClass:[HXMPositiveNewsRatioPieChart class] forCellReuseIdentifier:@"positiveNewsRatioPieChart"];
    [self.tableView registerClass:[HXMPropertyNewsCell class] forCellReuseIdentifier:@"propertyNewsCell"];
    [self.tableView registerClass:[HXMCentralNewsRatioPieCell class] forCellReuseIdentifier:@"centralNewsRatioPieCell"];

}

- (NSArray *)circleColorArray {
    if (_circleColorArray == nil) {
        _circleColorArray = [NSArray arrayWithObjects:[UIColor colorWithHexString:@"#688fca"],
                             [UIColor colorWithHexString:@"#f89679"],
                             [UIColor colorWithHexString:@"#adc8f2"],
                             [UIColor colorWithHexString:@"#e3cfae"],
                             [UIColor colorWithHexString:@"#e0514c"], nil];
    }
    return _circleColorArray;
}
- (NSMutableArray *)amountDataArray {
    
    if (_amountDataArray == nil) {
        _amountDataArray = [NSMutableArray array];
    }
    return _amountDataArray;
}
@end
