//
//  HXMCommonModuleCell.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/23.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMCommonModuleCell.h"
#import "HXNavigationViewController.h"
#import "HXMStatisticsLevelCollectionCell.h"
#import "HXMAllModuleViewController.h"
#import "AccountTool.h"
#import "HXMUser.h"
#import "HXMCommonModuleViewModel.h"
#import "HXMOpinonAnalysisChartViewController.h"

static NSString *headerId = @"headerId";

//cell行高
#define CELLHEIGHT 149

@interface HXMCommonModuleCell() <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) HXMCommonModuleViewModel *commonModuleViewModel;

@end

@implementation HXMCommonModuleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        
    }
    return self;
}



- (void)setModel:(HXMNewsStatisticsCountModel *)model {
    
    _model = model;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
//组头
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
        
        for (UIView * view in headerView.subviews) {
            [view removeFromSuperview];
        }
        UILabel *grayLabel = [[UILabel alloc]init];
        grayLabel.backgroundColor = [UIColor colorWithHexString:@"#f4f5f6"];
        [headerView addSubview:grayLabel];
        [grayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(headerView);
            make.height.equalTo(@10);
        }];
        
        headerView.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
        imageView.image = [UIImage imageNamed:@"home_cymk_icon"];
        [headerView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView).offset(24);
            make.centerY.equalTo(headerView).offset(5);
            make.width.height.equalTo(@15);
        }];
        
        UILabel * headerLabel = [[UILabel alloc] init];
        headerLabel.text = @"常用模块";
        headerLabel.textColor = [UIColor colorWithHexString:@"#3c5c8e"];
        headerLabel.font = [UIFont boldSystemFontOfSize:17];
        [headerView addSubview:headerLabel];
        [headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(6);
            make.centerY.equalTo(imageView);
        }];
        
        UIView * lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
        [headerView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView);
            make.right.equalTo(headerView).offset(-24);
            make.bottom.equalTo(headerView);
            make.height.mas_equalTo(0.5);
        }];
        
        return headerView;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //点击进全部
    if (indexPath.row == self.model.common_module.count - 1) {
//        [self initCommonModule];
        
        HXMAllModuleViewController *vc = [[HXMAllModuleViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    } else {
        self.selectedModel = self.model.common_module[indexPath.item];
        NSString * name = self.selectedModel.module_name;
        NSString * model_id = self.selectedModel.module_id;
        NSInteger moduleTag = self.selectedModel.module_tag;
        if (moduleTag == 1) {
            //进入新闻
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CommonModuleToPushNewsNotification" object:nil userInfo:@{@"name":name,@"id":model_id,@"moduleTag":@(moduleTag)}];
        } else if(moduleTag == 2) {
            //进入情报
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CommonModuleToPushInformationNotification" object:nil userInfo:@{@"name":name,@"id":model_id,@"moduleTag":@(moduleTag)}];
        }
        if ([model_id isEqualToString:@"58"]) {
            //进入舆情分析图
            HXMOpinonAnalysisChartViewController *vc = [[HXMOpinonAnalysisChartViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.viewController.navigationController pushViewController:vc animated:YES];
            
        }

    }
    
}

- (void)initCommonModule {
    
    //    [[self.commonModuleViewModel.requestCommonListCommand execute:nil] subscribeNext:^(id x) {
    //        NSLog(@"%@",x);
    //        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    //        NSString *filePath = [path stringByAppendingPathComponent:@"allModule.plist"];
    //        [NSKeyedArchiver archiveRootObject:x toFile:filePath];
    // 跳转常用模块
    HXMAllModuleViewController *vc = [[HXMAllModuleViewController alloc] init];
    //        vc.allModuleListArrayM = x;
    vc.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
    //
    //    } error:^(NSError *error) {
    //        NSLog(@"%@",error);
    //    } completed:^{
    //        NSLog(@"completed");
    //    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.model.common_module.count;
}

- (HXMStatisticsLevelCollectionCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseIdentifier=[NSString stringWithFormat:@"%ld%ldCollectionCell",(long)indexPath.section,(long)indexPath.row];
    [self.collectionView registerClass:[HXMStatisticsLevelCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
    HXMStatisticsLevelCollectionCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.model = self.model.common_module[indexPath.item];
    
    return cell;
    
}

#pragma mark - 设置界面
- (void)setupUI {
    [self.contentView addSubview:self.collectionView];
}
/** 获取父控制器 */
- (UIViewController*)getviewController {
    for (UIView*next = [self superview];next; next = next.superview) {
        UIResponder*nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (HXMCommonModuleViewModel *)commonModuleViewModel {
    
    if (_commonModuleViewModel == nil) {
        _commonModuleViewModel = [[HXMCommonModuleViewModel alloc]init];
    }
    return _commonModuleViewModel;
}

- (UICollectionView *)collectionView {
    
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(Screen_width / 4, CELLHEIGHT / 2);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.headerReferenceSize = CGSizeMake(Screen_width, 60);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 199.5+10) collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
    }
    
    return _collectionView;
}


@end
