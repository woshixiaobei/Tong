//
//  HXMNewsDetailViewController.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/22.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMNewsDetailViewController.h"
#import "UIBarButtonItem+Extension.h"
//#import "DTCoreText.h"
#import "HXMDetailModel.h"
#import "NSString+HXMAdd.h"
#import "HXMNewsDetalCell.h"
#define Margin 10

@interface HXMNewsDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic, assign) NSInteger module_id;
@property (nonatomic, assign) NSInteger news_id;
@property (nonatomic, strong) HXMDetailModel *model;
@property(nonatomic, weak) UILabel *titleLabel;//标题
@property (nonatomic, weak) UILabel *detalLabel;//详情
@property (nonatomic, weak) UILabel *sourceLabel;//来源
@property (nonatomic, weak) UILabel *timeLabel;//时间
@property (nonatomic, weak) UILabel *levelLabel;//等级
@property (nonatomic, weak) UITableView *mainTableView;
@end

@implementation HXMNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self initRequestDataWithModuleId:self.module_id newsId:self.newsId];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
- (void)initRequestDataWithModuleId:(NSString *)module_id newsId:(NSString *)news_id {
    
    [HXMProgressHUD showInView:self.view];
    [HXHttpHelper api_getDetailRequestWithModule_id:module_id news_id:news_id success:^(id responseObject) {
        //NSLog(@"%@",responseObject);
        [HXMProgressHUD hide];
        if ([responseObject[@"state"] integerValue] == 0) {
            if (responseObject[@"data"]) {
                self.model = [HXMDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
                [self.mainTableView reloadData];
            } else {
                [HXMProgressHUD showError:@"返回数据为空" inview:self.view];
            }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [HXMProgressHUD hide];
        [HXMProgressHUD showError:@"加载数据失败..." inview:self.view];
    }];
    
    
}
- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

//#pragma mark - DTAttributedTextContentViewDelegate
//- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame{
//    
//    if([attachment isKindOfClassNSTextAttachmentnt class]]){
//        CGFloat aspectRatio = frame.size.height / frame.size.width;
//        CGFloat width = SCREEN_WIDTH - 16*2;
//        CGFloat height = width * aspectRatio;
//        UIView *View = [[UIView alloc] initWithFrame:frame];
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,width,height)];
//        imageView.backgroundColor = [UIColor grayColor];
//        [imageView sd_setImageWithURL:attachment.contentURL placeholderImage:[UIImage imageNamed:@"tabar_icon_home_highlight"] options:SDWebImageProgressiveDownload];
//        imageView.userInteractionEnabled = YES;
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [View addSubview:imageView];
//        
//        return View;
//    }
//    return nil;
//}

#pragma mark - UITableViewDelegate,UITableViewDataSourc

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HXMNewsDetalCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    cell.btnTitle = self.btnTitle;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"------1111----%@",self.model.newsContent);
    
    HXMDetailModel *model = self.model;
    NSLog(@"%f",[self.model.newsContent textHeightWithWidth:SCREEN_WIDTH - 20 Font:[UIFont systemFontOfSize:15]] + 100);
    CGFloat x = [self.model.newsTitle textHeightWithWidth:SCREEN_WIDTH - 20 Font:[UIFont systemFontOfSize:24]];
    return [self.model.newsContent textHeightWithWidth:SCREEN_WIDTH - 20 Font:[UIFont systemFontOfSize:15]] + 20 + x + 65;
}
#pragma mark - 设置界面
- (void)setupUI {
    
    
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"详情";
    
    UITableView *mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    [mainTableView registerClass:[HXMNewsDetalCell class] forCellReuseIdentifier:@"cellId"];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.showsVerticalScrollIndicator = NO;
    mainTableView.showsHorizontalScrollIndicator = NO;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
    _mainTableView = mainTableView;
    
    
    //    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    //    headerView.backgroundColor = [UIColor whiteColor];
    //
    //    mainTableView.tableHeaderView = headerView;
    //    //标题
    //    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    //    titleLabel.text = @"十二届全国人大五次会议十二届全国人大五次会议届全国人大五次会议十二届全国人大五次会议";
    //    titleLabel.numberOfLines = 2;
    //    titleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    //    titleLabel.font = [UIFont boldSystemFontOfSize:24];
    //    [titleLabel sizeToFit];
    //    _titleLabel = titleLabel;
    //    CGSize size = [titleLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT)
    //                                                options:NSStringDrawingUsesLineFragmentOrigin
    //                                             attributes:@{NSFontAttributeName:titleLabel.font}
    //                                                context:nil].size;
    //
    //    [headerView addSubview:titleLabel];
    //    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(headerView).offset(14);
    //        make.left.equalTo(headerView).offset(24);
    //        make.right.equalTo(headerView).offset(-24);
    //        make.height.mas_equalTo(size.height);
    //    }];
    
    //    //来源
    //    UILabel * sourceLabel = [[UILabel alloc] init];
    //    sourceLabel.text = @"中国投资网";
    //    sourceLabel.textColor = [UIColor colorWithHexString:@"#505050"];
    //    sourceLabel.font = [UIFont systemFontOfSize:12];
    //    [headerView addSubview:sourceLabel];
    //    [sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(titleLabel.mas_bottom).offset(20);
    //        make.left.equalTo(titleLabel);
    //        make.bottom.equalTo(headerView.mas_bottom).offset(-30);
    //    }];
    //    _sourceLabel = sourceLabel;
    //    //时间
    //    UILabel * timeLabel = [[UILabel alloc] init];
    //    timeLabel.text = @"2017-03-01 02:03";
    //    timeLabel.textColor = [UIColor colorWithHexString:@"#505050"];
    //    timeLabel.font = [UIFont systemFontOfSize:12];
    //    [headerView addSubview:timeLabel];
    //    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(sourceLabel);
    //        make.left.equalTo(sourceLabel.mas_right).offset(13);
    //    }];
    //    _timeLabel = timeLabel;
    //
    //    UILabel * reprintSourceLabel = [[UILabel alloc] init];
    //    reprintSourceLabel.text = @"第一财富网";
    //    reprintSourceLabel.textColor = [UIColor colorWithHexString:@"#505050"];
    //    reprintSourceLabel.font = [UIFont systemFontOfSize:12];
    //    [headerView addSubview:reprintSourceLabel];
    //    [reprintSourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(timeLabel.mas_right).offset(13);
    //        make.top.equalTo(timeLabel);
    //    }];
    //
    //    headerView.height = 14+size.height+20+12+30;
    //    UILabel *contentLabel = [[UILabel alloc]init];
    //    contentLabel.text = @"生活";
    //    contentLabel.textColor = [UIColor colorWithHexString:@"#505050"];
    //    contentLabel.font = [UIFont systemFontOfSize:18];
    //    [headerView addSubview:contentLabel];
    //    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(reprintSourceLabel.mas_bottom).offset(30);
    //        make.left.equalTo(headerView).offset(24);
    //        make.right.equalTo(headerView).offset(-24);
    //    }];
    //    NSMutableAttributedString * attrString =[[NSMutableAttributedString alloc] initWithData:[resultModel.tips dataUsingEncoding:NSUnicodeStringEncoding]options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}documentAttributes:nil error:nil];
    
    //    [attrString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(0, attrString.length)];
    //
    //    contentLabel.attributedText = attrString;
    //    NSMutableAttributedString *htmlString =[[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]}documentAttributes:NULL error:nil];
    
    //    [htmlString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(0, htmlString.length)];
    
    //    CGSize textSize = [htmlString boundingRectWithSize:(CGSize){ScreenWidth - 20, CGFLOAT_MAX}options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    //    return textSize.height ;
}

- (void)loadRequest {
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://158d07545b.imwork.net:15565/po_iphone2.00/contentInterface.action?module_id=7&news_id=157454427"]];
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //    [self.view addSubview:self.webView];
    //    self.webView.scalesPageToFit = YES;
    //    [self.webView loadHTMLString:str baseURL:nil];;
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    NSLog(@"webViewDidStartLoad");
    
}

- (void)webViewDidFinishLoad:(UIWebView *)web{
    
    NSLog(@"webViewDidFinishLoad");
    
}

-(void)webView:(UIWebView*)webView  DidFailLoadWithError:(NSError*)error{
    
    NSLog(@"DidFailLoadWithError");
    
}
@end
