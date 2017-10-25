//
//  RRTPresentTableView.m
//  renrentong
//
//  Created by wangmingzhu on 2017/3/9.
//  Copyright © 2017年 com.lanxum. All rights reserved.
//

#import "HXMPresentTableView.h"
static NSString *presentcellId = @"presentcellId";
@interface HXMPresentTableView ()<UITableViewDelegate,UITableViewDataSource>
//跳转的tableView
@property (nonatomic, weak) UITableView *presentTableView;

@end

@implementation HXMPresentTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    
    //    self.presentTableView.frame = CGRectMake(SCREEN_WIDTH/2 - 93.5, 0, 193, self.dataArr.count * 40 < (Screen_height - 300) ? self.dataArr.count * 40:(Screen_height - 300));
    self.presentTableView.height = _dataArr.count * 40 < (Screen_height - 300) ? _dataArr.count * 40 + 10:(Screen_height - 300);
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    self.clickedImageCallback(self.dataArr[indexPath.row],self.gradeArr[indexPath.row]);
    [self removeFromSuperview];
    _presentTableView = nil;
}
#pragma mark-UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    //顶部距离
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#282828"];
    [self addSubview:lineView];
    lineView.frame = CGRectMake(SCREEN_WIDTH/2 - 70, 0, 140,5);
    return lineView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:presentcellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHexString:@"#282828"];
    cell.alpha = 0.95;
    cell.textLabel.text = self.dataArr[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#727272"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:19];
    cell.frame = CGRectMake(22, 11, 140, 40);
    if (cell.textLabel.text.length>5 ) {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    //选中的cell
    if ([self.btnTitle isEqualToString: self.dataArr[indexPath.row]]) {
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        cell.textLabel.backgroundColor = [UIColor colorWithHexString:@"#545454"];
        cell.textLabel.alpha = 0.8;
        cell.textLabel.layer.cornerRadius = 5;
        [cell.textLabel setClipsToBounds:YES];
    }

    
    NSString * module_id = self.gradeArr[indexPath.row];
//    if (self.btnTag == [module_id integerValue]) {
////        NSLog(@"一样的");
//        cell.textLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
//        cell.textLabel.backgroundColor = [UIColor colorWithHexString:@"#545454"];
//        cell.textLabel.alpha = 0.8;
//        cell.textLabel.layer.cornerRadius = 5;
//        [cell.textLabel setClipsToBounds:YES];
//    }

    dispatch_async(dispatch_get_main_queue(), ^{
        tableView.frame = CGRectMake(SCREEN_WIDTH/2 - 70, 0, 140, self.dataArr.count * 40 + 10 < (260) ? self.dataArr.count * 40 + 10:(260));
        // [self.presentTableView reloadData];
    });
    
    return cell;
}


#pragma mark - 设置界面
- (void)setupUI {
    self.backgroundColor = [UIColor blackColor];
    UITableView *tv = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tv.backgroundColor = [UIColor colorWithHexString:@"#282828"];
    tv.alpha = 0.95;
    tv.rowHeight = 40;
    tv.dataSource = self;
    tv.delegate = self;
    tv.showsVerticalScrollIndicator = NO;
    tv.showsHorizontalScrollIndicator = NO;
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tv.layer.cornerRadius = 5;
    [tv setClipsToBounds:YES];
    [tv registerClass:[UITableViewCell class] forCellReuseIdentifier:presentcellId];
    [self addSubview:tv];
    
    tv.frame = CGRectMake(SCREEN_WIDTH/2 - 70, 0, 140,260);
    _presentTableView = tv;
}

@end
