//
//  HXMAboutMeView.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/5/2.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMAboutMeView.h"

#define UILABEL_LINE_SPACE 6

@interface HXMAboutMeView()


@end
@implementation HXMAboutMeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI {

    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    scrollView.backgroundColor = [UIColor redColor];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    scrollView.alwaysBounceHorizontal = YES;
    
    [self addSubview:scrollView];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"致尊敬的客户:";
    titleLabel.textColor = [UIColor colorWithHexString:@"#727272"];
    titleLabel.font = [UIFont systemFontOfSize:16.0f];
    
    [scrollView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).offset(29);
        make.left.equalTo(scrollView).offset(24);
        make.right.equalTo(scrollView).offset(-24);
    }];
    
    UILabel *contentLabel = [[UILabel alloc]init];
    //contentLabel.text = @"        能创造与众不同、震撼世界的总是一群能够克服惯性思维的少数派。这里聚集了过去一年，那些在世界和中国改写的商业规则，推动了社会的变革者。来听听这些最有力量的少数派的思维逻辑，认识他们，也成为他们！";
    contentLabel.textColor = [UIColor colorWithHexString:@"#727272"];
    NSString *contentString = @"      和讯通是中国第一财经门户和讯网研发的大型信息与情报整合传播平台， 由和讯网12个团队100多人于2010年设计开发完成，专注于服务金融、证券、上市公司等机构，舆情服务经验丰富！\n  和讯通平台的优势是：全面、定制、精准、直观、高效、保密，为客户提供信息监测、敏感舆情预警、专项报告、数据信息咨询等一站式服务。\n  和讯通的工作原理为“关键词智能系统抓取+人工审核”相结合的舆情监测模式。\n为和讯通提供舆情管理服务的运营团队由和讯网资深财经编辑和研究员组成，对敏感舆情判断准确；为和讯通提供技术及创新支持的团队深耕大数据领域多年，设计开发出和讯通独有智能语义分析系统，语言逻辑判断及语料研判更符合企业舆情特征。\n  和讯通致力于做更好的企业品牌工具和服务提供商，为您的企业守护基业长青。";
    [self setLabelSpace:contentLabel withValue:contentString withFont:[UIFont systemFontOfSize:16.0f]];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.numberOfLines = 0;
    
    [scrollView addSubview:contentLabel];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(8);
        make.left.right.equalTo(titleLabel);
    }];
    
    UILabel *dateLabel = [[UILabel alloc]init];
    [self setLabelSpace:dateLabel withValue:@"和讯通全体工作人员\n2017年1月1日" withFont:[UIFont systemFontOfSize:16.0f]];
    dateLabel.numberOfLines = 0;
    dateLabel.textColor = [UIColor colorWithHexString:@"#727272"];
    dateLabel.textAlignment = NSTextAlignmentRight;
    [scrollView addSubview:dateLabel];
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom).offset(30);
        make.right.equalTo(scrollView).offset(-25);
    }];


}
-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = UILABEL_LINE_SPACE; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    label.attributedText = attributeStr;
}


@end
