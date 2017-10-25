//
//  HXMNewsStatisticsCountModel.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/23.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMNewsStatisticsCountModel.h"
#import "MYStockInfoMoneyModel.h"
@implementation HXMNewsStatisticsCountModel


- (void)mj_keyValuesDidFinishConvertingToObject
{
    //返回数据集合
    NSMutableArray *arr = [NSMutableArray array];
    
    //第一个正面新闻占比饼状图
    NSMutableArray *arr0 = [NSMutableArray array];
    self.sumPositive = self.today_positive_num + self.today_neutral_num + self.today_negative_num;
    
    if (self.today_positive_num) {
        MYStockInfoMoneyModel *model = [MYStockInfoMoneyModel moneyModelWithColor:[UIColor colorWithHexString:@"#688fca"] percent:self.today_positive_num / self.sumPositive title:[NSString stringWithFormat:@"%@\n%ld(%.2f%%)",@"正面新闻",(long)self.today_positive_num,(self.today_positive_num / self.sumPositive*100.f)]];
        [arr0 appendObject:model];
    }
    if (self.today_negative_num) {
        MYStockInfoMoneyModel *model = [MYStockInfoMoneyModel moneyModelWithColor:[UIColor colorWithHexString:@"#f89679"] percent:self.today_negative_num / self.sumPositive title:[NSString stringWithFormat:@"%@\n%ld(%.2f%%)",@"负面新闻",(long)self.today_negative_num,(self.today_negative_num / self.sumPositive*100.f)]];
        [arr0 appendObject:model];
    }
    if (self.today_neutral_num) {
        MYStockInfoMoneyModel *model = [MYStockInfoMoneyModel moneyModelWithColor:[UIColor colorWithHexString:@"#e3cfae"] percent:self.today_neutral_num / self.sumPositive title:[NSString stringWithFormat:@"%@\n%ld(%.2f%%)",@"中性新闻",(long)self.today_neutral_num,(self.today_neutral_num / self.sumPositive*100.f)]];
        [arr0 appendObject:model];
    }
         [arr appendObject:arr0];
    
    //第二个渠道饼状图（如果有子公司，显示子公司的饼状图）
    NSMutableArray *arr1 = [NSMutableArray array];
    self.sumChannel = self.weibo_num + self.weixin_num + self.media_num + self.club_num ;
    if (self.weibo_num) {
        MYStockInfoMoneyModel *model = [MYStockInfoMoneyModel moneyModelWithColor:[UIColor colorWithHexString:@"#688fca"] percent:self.weibo_num / self.sumChannel title:[NSString stringWithFormat:@"%@\n%ld(%.2f%%)",@"微博新闻",(long)self.weibo_num,(self.weibo_num / self.sumChannel*100.f)]];
        [arr1 appendObject:model];
    }
    if (self.weixin_num) {
        MYStockInfoMoneyModel *model = [MYStockInfoMoneyModel moneyModelWithColor:[UIColor colorWithHexString:@"#f89679"] percent:self.weixin_num / self.sumChannel title:[NSString stringWithFormat:@"%@\n%ld(%.2f%%)",@"微信新闻",(long)self.weixin_num,(self.weixin_num / self.sumChannel*100.f)]];
        [arr1 appendObject:model];
    }
    if (self.media_num) {
        MYStockInfoMoneyModel *model = [MYStockInfoMoneyModel moneyModelWithColor:[UIColor colorWithHexString:@"#e3cfae"] percent:self.media_num / self.sumChannel title:[NSString stringWithFormat:@"%@\n%ld(%.2f%%)",@"公司新闻",(long)self.media_num,(self.media_num / self.sumChannel*100.f)]];
        [arr1 appendObject:model];
    }
    if (self.club_num) {
        MYStockInfoMoneyModel *model = [MYStockInfoMoneyModel moneyModelWithColor:[UIColor colorWithHexString:@"#adc8f2"] percent:self.club_num / self.sumChannel title:[NSString stringWithFormat:@"%@\n%ld(%.2f%%)",@"社区新闻",(long)self.club_num,(self.club_num / self.sumChannel*100.f)]];
        [arr1 appendObject:model];
    }
        [arr appendObject:arr1];

    self.sumProvinceNum = self.province_num + self.centre_num + self.other_num;
    //第三个子公司下个级别的占比
//    NSMutableArray *arr2 = [NSMutableArray array];
//    CGFloat sumTotal = self.province_num + self.centre_num + self.other_num ;
//    if (self.province_num) {
//        MYStockInfoMoneyModel *model = [MYStockInfoMoneyModel moneyModelWithColor:[UIColor colorWithHexString:@"#f89679"] percent:self.province_num / sumTotal title:[NSString stringWithFormat:@"%@\n%ld(%.2f%%)",@"省级",self.province_num,(self.province_num / sumTotal*100.f)]];
//        [arr2 appendObject:model];
//    }
//    if (self.centre_num) {
//        MYStockInfoMoneyModel *model = [MYStockInfoMoneyModel moneyModelWithColor:[UIColor colorWithHexString:@"#e0514c"] percent:self.centre_num / sumTotal title:[NSString stringWithFormat:@"%@\n%ld(%.2f%%)",@"中央级",self.centre_num,(self.centre_num / sumTotal*100.f)]];
//        [arr2 appendObject:model];
//    }
//    if (self.other_num) {
//        MYStockInfoMoneyModel *model = [MYStockInfoMoneyModel moneyModelWithColor:[UIColor colorWithHexString:@"#e3cfae"] percent:self.other_num / sumTotal title:[NSString stringWithFormat:@"%@\n%ld(%.2f%%)",@"其他",self.other_num,(self.other_num / sumTotal*100.f)]];
//        [arr2 appendObject:model];
//    }
//    
//    [arr appendObject:arr2];
//    
    _circleArrayM = [NSArray arrayWithArray:arr];
    
}

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"common_module":@"HXMCommonModuleModel",
             @"sub_company":@"HXMSubCompanyModel"
             };
}

@end
