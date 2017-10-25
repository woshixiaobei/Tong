//
//  HXMChannelsView.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/8.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMChannelsView.h"
#import "HXMChannelLable.h"
#import "UIView+Extension.h"
#import "NSString+HXMAdd.h"

#define Margin 20

@interface HXMChannelsView ()

@property (nonatomic, strong)  NSArray *channels;
@property (nonatomic, strong)  NSMutableArray *channelLables;
@property (nonatomic, weak)   HXMChannelLable *clicklable;
@property (nonatomic, weak)   UILabel *lineLable;
@property (nonatomic, assign) NSInteger pageClCount;
@property (nonatomic, strong) NSMutableArray *lineWidthArr;


@end

static NSString *ReuseIdentifier = @"HXMChannelsView_ReuseIdentifier";

@implementation HXMChannelsView

-(instancetype)initWithChannels:(NSArray *) channels pageCount:(NSInteger) pageCount{
    if (self = [super init]) {
        self.channels = channels;
        self.pageClCount = pageCount;
        [self setUpChannelScrollView];
    }
    return self;
}


-(void)setUpChannelScrollView{

    self.showsHorizontalScrollIndicator = NO;
    self.bounces = NO;
    self.backgroundColor = [UIColor colorWithHexString:@"#f6f5f4"];
    CGFloat scrollWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat scrollHeight = 36;
    __block CGFloat channllableWidth = 24;
    self.frame = CGRectMake(0, 0, scrollWidth, scrollHeight);

//        UILabel *lineLable = [[UILabel alloc]init];
//        lineLable.height = 2;
//        lineLable.y = 34;
//    lineLable.backgroundColor = [UIColor redColor];
//    //[UIColor colorWithHexString:@"0099ff"];
//        self.lineLable = lineLable;
//        [self addSubview:lineLable];

    
        [self.channels enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        
        HXMChannelLable *lable = [[HXMChannelLable alloc]init];
        lable.height = self.height;
        CGSize size = [obj sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17.f],NSFontAttributeName, nil]];
        lable.width = size.width;
        
        NSString *title = self.channels[idx];
        CGFloat lineWidth =  [title sizeWithFont:[UIFont systemFontOfSize:17.f] maxSize:CGSizeMake(lable.width, 36)].width + 5;
        [self.lineWidthArr addObject:@(lineWidth)];
        
        lable.y = 0;
        lable.x = channllableWidth;
        channllableWidth += (lable.width + 16);
        lable.tag = idx;
        
        if (lable.tag==0) {
            lable.isSelect = YES;
            self.lineLable.width = [self.lineWidthArr[0] floatValue];
            self.lineLable.x = self.clicklable.x + (lable.width - self.lineLable.width)/2;
        }
        lable.text = obj;
        UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickChannel:)];
        [lable addGestureRecognizer:tapges];
        [self.channelLables addObject:lable];
        [self addSubview:lable];
        lable.userInteractionEnabled = YES;
    }];
    
    if (channllableWidth > scrollWidth) {
        
        self.contentSize = CGSizeMake(channllableWidth, 0);
    } else {
        
        self.contentSize = CGSizeMake(scrollWidth, 0);
        
    }
}

-(void)clickChannel:(UITapGestureRecognizer*) tapges{
    HXMChannelLable *lable = (HXMChannelLable*)tapges.view;
    self.clicklable = lable;
    lable.isSelect = NO;
    NSInteger index = lable.tag;
    self.lineLable.width = [self.lineWidthArr[index] floatValue];
    self.lineLable.x = self.clicklable.x + (lable.width - self.lineLable.width)/2;
    [self lastScrollCenterMethod];
    if (self.clickChannel) {
        self.clickChannel(index);
    }
}


- (void)lastScrollCenterMethod{
    CGFloat  offsetX = self.clicklable.center.x - self.frame.size.width*0.5;
    if (offsetX < 0 ) {
        offsetX = 0 ;
    }else if(offsetX >self.contentSize.width - self.frame.size.width){
        offsetX = self.contentSize.width - self.frame.size.width;
    }
    [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
    
    for (HXMChannelLable *lable in self.channelLables) {
        if (self.clicklable.tag == lable.tag) {
            lable.isSelect = YES;
        }else{
            lable.isSelect = NO;
        }
    }
}


-(void)setIndex:(NSInteger)Index{
    _index = Index;
    self.clicklable = self.channelLables[_index];
    self.lineLable.width = [self.lineWidthArr[Index] floatValue];
    self.lineLable.centerX = self.clicklable.centerX;
}


-(NSArray *)channelLables{
    if (_channelLables==nil) {
        _channelLables = [NSMutableArray array];
    }
    return _channelLables;
}

-(NSMutableArray *)lineWidthArr{
    if (_lineWidthArr == nil) {
        _lineWidthArr = [NSMutableArray array];
    }
    return _lineWidthArr;
}

@end
