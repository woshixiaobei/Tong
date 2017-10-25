//
//  HXMStatisticsLevelCell.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/15.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMStatisticsLevelCell.h"
#import "HXMStatisticsLevelCollectionCell.h"
#import "HXMAllModuleViewController.h"
static NSString *headerId = @"headerId";

//cell行高
#define CELLHEIGHT 149

@interface HXMStatisticsLevelCell() <UICollectionViewDelegate,UICollectionViewDataSource>


@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HXMStatisticsLevelCell

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        
    }
    return self;
}
#pragma mark - UICollectionViewDelegate
//组头
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel * headerLabel = [[UILabel alloc] init];
        headerLabel.text = @"常用模块";
        headerLabel.textColor = [UIColor colorWithHexString:@"#3c5c8e"];
        headerLabel.font = [UIFont systemFontOfSize:15];
        [headerView addSubview:headerLabel];
        [headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView).offset(24);
            make.centerY.equalTo(headerView);
        }];
        
        UIView * lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
        [headerView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerLabel);
            make.right.equalTo(headerView).offset(-24);
            make.bottom.equalTo(headerView);
            make.height.mas_equalTo(1);
        }];
        
        return headerView;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 7) {
        HXMAllModuleViewController *vc = [[HXMAllModuleViewController alloc] init];
        [[self getviewController].navigationController pushViewController:vc animated:YES] ;
    }
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 8;
    
}

- (HXMStatisticsLevelCollectionCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    NSString *reuseIdentifier=[NSString stringWithFormat:@"%ld%ldCollectionCell",(long)indexPath.section,(long)indexPath.row];
    [self.collectionView registerClass:[HXMStatisticsLevelCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
    HXMStatisticsLevelCollectionCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
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


- (UICollectionView *)collectionView {

    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(Screen_width / 4, CELLHEIGHT / 2);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.headerReferenceSize = CGSizeMake(50, 50);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 199.5) collectionViewLayout:flowLayout];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
    }
    
    return _collectionView;

}

@end
