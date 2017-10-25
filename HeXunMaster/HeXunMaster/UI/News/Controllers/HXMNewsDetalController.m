//
//  HXMNewsDetalController.m
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/3/22.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMNewsDetalController.h"
#import "UIBarButtonItem+Extension.h"
#import "NSString+HXMAdd.h"
#import "ActionSheetView.h"
#import "HXMProgressHUD.h"

#define Margin 10


@interface HXMNewsDetalController ()<UIScrollViewDelegate>

@property (nonatomic, weak) UILabel *titleLabel;//标题
@property (nonatomic, weak) UILabel *timeLabel;//时间
@property (nonatomic, weak) UILabel *sourceLabel;//来源
@property (nonatomic, weak) UILabel *fromeSourceLabel;//来自哪
@property (nonatomic, weak) UILabel *detailLabel;//新闻详情
@property (nonatomic, assign) BOOL isCollection;//判断是否收藏
@property (nonatomic, assign) NSInteger amplification;//判断放大几次了
@property (nonatomic, assign) CGFloat titleFont;//标题字号
@property (nonatomic, assign) CGFloat commonFont;//其他字号
@property (nonatomic, assign) CGFloat detailFont;//内容字号
@property (nonatomic, strong) NSArray *promptArr;

@end

@implementation HXMNewsDetalController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
}



//点击底部按钮调用的方法 根据sender.tag来区别点的是哪个按钮
-(void)buttonClick:(UIButton *)sender{

    switch (sender.tag) {
        case 0:
            //收藏
            if (_isCollection == NO) {
                [sender setSelected:YES];
                 NSLog(@"收藏了");
                [HXMProgressHUD showCenterMessage:@"收藏成功"];
                _isCollection = YES;
            } else {
                [sender setSelected:NO];
                 NSLog(@"取消收藏了");
                [HXMProgressHUD showCenterMessage:@"取消收藏"];
                _isCollection = NO;
            }
            [self collectionBtnClick];
            break;
        case 1:
            //分享
            [self shareBtnClick];
            break;
        case 2:
            //缩小
            if (_amplification == 0) {
                //提示已经是最小的了
                [HXMProgressHUD showCenterMessage:@"已经最小了"];
                return;
            } else  {
            
                _amplification--;
                _titleFont -= 2;
                _commonFont -= 2;
                _detailFont -=2;
                [self ChangeTheFont];
                NSString * str  = [NSString stringWithFormat:@"%@",_promptArr[_amplification]];
                [HXMProgressHUD showCenterMessage:str];

            }
            
            break;
        case 3:
            //放大
            if (_amplification <=3) {
                 _amplification++;
                _titleFont += 2;
                _commonFont += 2;
                _detailFont +=2;
                [self ChangeTheFont];
                NSString * str  = [NSString stringWithFormat:@"%@",_promptArr[_amplification]];
                [HXMProgressHUD showCenterMessage:str];
            } else {
                [HXMProgressHUD showCenterMessage:@"已经最大了"];
                NSLog(@"已经最大了");
                //提示已经是最大了
                return;
            }

            break;
            
        default:
            break;
    }
    
}
/****收藏****/
- (void)collectionBtnClick {
    
    NSLog(@"点击收藏按钮了");
    
}
/****分享****/
- (void)shareBtnClick {
    NSArray *titlearr = @[@"新浪微博",@"微信",@"朋友圈",@"QQ",@"QQ空间",@"复制链接"];
    NSArray *imageArr = @[@"sinaweibo",@"wechat",@"wechatquan",@"tcentQQ",@"tcentkongjian",@"copyUrl"];
    
    ActionSheetView *actionsheet = [[ActionSheetView alloc] initWithShareHeadOprationWith:titlearr andImageArry:imageArr andProTitle:@"分享新闻" and:ShowTypeIsShareStyle];
    [actionsheet setBtnClick:^(NSInteger btnTag) {
        NSLog(@"\n点击第几个====%ld\n当前选中的按钮title====%@",btnTag,titlearr[btnTag]);
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:actionsheet];
    
    NSLog(@"点击分享了");
}

/****改变字体大小****/
- (void)ChangeTheFont {

    self.titleLabel.font = [UIFont systemFontOfSize:_titleFont];
    self.timeLabel.font = [UIFont systemFontOfSize:_commonFont];
    self.sourceLabel.font = [UIFont systemFontOfSize:_commonFont];
    self.fromeSourceLabel.font = [UIFont systemFontOfSize:_commonFont];
    self.detailLabel.font = [UIFont systemFontOfSize:_detailFont];
}


//pop
- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - 设置界面
- (void)setupUI {
    
    
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"back_icon" title:@"" target:self action:@selector(back)];
    self.title = @"详情";
    
    _isCollection = NO;
    _amplification = 2;
    _titleFont = 19;
    _commonFont = 12;
    _detailFont = 17;
    _promptArr = @[@"最小",@"小",@"中",@"大",@"最大"];
    UIScrollView *myScrollView = [[UIScrollView alloc] init];
    myScrollView.showsHorizontalScrollIndicator= NO;
    myScrollView.delegate = self;
    myScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    [self.view addSubview:myScrollView];
    
    UIView*parentView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1000)];
    [myScrollView addSubview:parentView];
    
    UIView*oneBgView=[[UIView alloc] init];
    oneBgView.backgroundColor=[UIColor whiteColor];
    [parentView addSubview:oneBgView];
    [oneBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(parentView);
        make.left.equalTo(parentView).offset(24.0f);
        make.right.equalTo(parentView).offset(-24.0f);
        make.height.equalTo(@1000);
    }];
    //标题
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"十二届全国人大五次会议十二届全国人大五次会议";
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    titleLabel.font = [UIFont systemFontOfSize:_titleFont];
    [oneBgView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oneBgView).offset(24);
        make.top.equalTo(oneBgView).offset(20);
        make.right.equalTo(oneBgView).offset(-24);
    }];
    _titleLabel = titleLabel;
    
    //时间
    UILabel * timeLabel = [[UILabel alloc] init];
    timeLabel.text = @"2016-12-14 02:03";
    timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    timeLabel.font = [UIFont systemFontOfSize:_commonFont];
    [oneBgView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).offset(Margin);
        make.width.mas_equalTo(115);
    }];
    _timeLabel = timeLabel;
    
    //来源
    UILabel * sourceLabel = [[UILabel alloc] init];
    sourceLabel.text = @"中国投资网";
    sourceLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    sourceLabel.font = [UIFont systemFontOfSize:_commonFont];
    [oneBgView addSubview:sourceLabel];
    [sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeLabel.mas_right).offset(2);
        make.top.equalTo(timeLabel);
    }];
    _sourceLabel = sourceLabel;
    //转自
    UILabel * fromeLabel = [[UILabel alloc] init];
    fromeLabel.text = @"转自: ";
    fromeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    fromeLabel.font = [UIFont systemFontOfSize:12];
    [oneBgView addSubview:fromeLabel];
    [fromeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sourceLabel.mas_right).offset(2);
        make.top.equalTo(timeLabel);
    }];
    UILabel * fromeSourceLabel = [[UILabel alloc] init];
    fromeSourceLabel.text = @"第一财富网";
    fromeSourceLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    fromeSourceLabel.font = [UIFont systemFontOfSize:_commonFont];
    [oneBgView addSubview:fromeSourceLabel];
    [fromeSourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fromeLabel.mas_right).offset(2);
        make.top.equalTo(timeLabel);
        make.right.equalTo(titleLabel);
    }];
    _fromeSourceLabel = fromeSourceLabel;
    //分割线
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [oneBgView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.right.equalTo(titleLabel);
        make.top.equalTo(timeLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(1);
    }];
    //详情
    UILabel * detailLabel = [[UILabel alloc] init];
    detailLabel.text = @"十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议";
    detailLabel.numberOfLines = 0;
    detailLabel.textColor = [UIColor colorWithHexString:@"#727272"];
    detailLabel.font = [UIFont systemFontOfSize:_detailFont];
    [oneBgView addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(lineView.mas_bottom).offset(Margin);
        make.right.equalTo(titleLabel);
        make.bottom.equalTo(myScrollView.mas_bottom).mas_offset(-20);
        
    }];
    _detailLabel = detailLabel;
    
    CGFloat contentHeight = [detailLabel.text textHeightWithWidth:SCREEN_WIDTH - 48 Font:[UIFont systemFontOfSize:14]];
    NSLog(@"%f",Screen_height);
    if (contentHeight + 120 >= Screen_height) {
        myScrollView.contentSize = CGSizeMake(0, contentHeight + 180);
    } else {
    myScrollView.contentSize = CGSizeMake(0, Screen_height);
    }

    
    UIView * bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor lightGrayColor];
    bottomView.alpha = 0.8;
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(60);
    }];
    NSArray * arr = @[@"tabbar_icon_home_normal",@"tabbar_icon_information_normal",@"tabbar_icon_news_normal",@"tabbar_icon_profile_normal"];
    NSArray * arr1 = @[@"tabbar_icon_home_highlight",@"tabbar_icon_information_highlight",@"tabbar_icon_news_highlight",@"tabbar_icon_profile_highlight"];
    for (NSInteger i = 0; i < 4; i++) {
        UIButton *functionBtn = [[UIButton alloc] initWithFrame:CGRectMake((Screen_width/4) *(i%4), Screen_width/4*(i/4), Screen_width/4, 60)];
        functionBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        functionBtn.clipsToBounds = YES;
   
        [functionBtn setImage:[UIImage imageNamed:arr[i]] forState:UIControlStateNormal];
        [functionBtn setImage:[UIImage imageNamed:arr1[i]] forState:UIControlStateHighlighted];
        [functionBtn setImage:[UIImage imageNamed:arr1[i]] forState:UIControlStateSelected];
        [functionBtn setTag:i];

        [functionBtn addTarget:self
                      action:@selector(buttonClick:)
            forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:functionBtn];
    }
    
 }



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
