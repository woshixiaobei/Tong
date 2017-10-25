//
//  HXMFeedBackView.m
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/4/28.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMFeedBackView.h"
#define MAX_LIMIT_NUMS 500

@interface HXMFeedBackView()
@property (nonatomic, weak)UIButton *commitButton;
@end

@implementation HXMFeedBackView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self initSignal];
    }
    return self;
}
- (void)buttonClick:(UIButton *)button{
    
    if (self.buttonClicked) {
        self.buttonClicked(self.contentTextView.text);
    }

}

- (void)initSignal {

    //监听UITextView输入框，提交按钮的状态
    @weakify(self);
    RAC(self.commitButton,enabled) =[ [RACObserve(self.contentTextView, text)  merge:self.contentTextView.rac_textSignal ] map:^id(NSString *value) {
        return ((value.length > 0) ? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO]);
    }];
    RAC(self.textCountlabel,text) =[ [RACObserve(self.contentTextView, text)  merge:self.contentTextView.rac_textSignal ] map:^id(NSString *value) {
        return self.textCountlabel.text = [NSString stringWithFormat:@"%lu/%d",(unsigned long)( value.length < 500?value.length:500),MAX_LIMIT_NUMS];
    }];

}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    //禁止输入表情
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        if (offsetRange.location < MAX_LIMIT_NUMS) {
            return YES;
        }
        else{
            return NO;
        }
    }
    NSString *comcatStr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger canInputLen = MAX_LIMIT_NUMS - comcatStr.length;
    if (canInputLen >= 0){
        return YES;
    }
    else{
        NSInteger len = text.length + canInputLen;
        NSRange rg = {0,MAX(len,0)};
        if (rg.length > 0){
            NSString *s = @"";
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];
            }
            else{
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          if (idx >= rg.length) {
                                              *stop = YES;
                                              return ;
                                          }
                                          trimString = [trimString stringByAppendingString:substring];
                                          idx++;
                                      }];
                s = trimString;
            }
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        
        }
        return NO;
    }
    
}

#pragma mark - 设置界面
- (void)setupUI {
    
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"您的支持是我们得动力,您的宝贵意见是我们改进的方向!";
    titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(9);
        make.left.equalTo(self).offset(24);
        make.right.equalTo(self).offset(-24);
    }];
    self.contentTextView = [[UITextView alloc] init];//]WithFrame:CGRectMake(24, 30, self.bounds.size.width-48, 200)];
    [self addSubview:self.contentTextView];
    self.contentTextView.backgroundColor = [UIColor whiteColor];
    self.contentTextView.layer.borderWidth = 0.5;
    self.contentTextView.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    self.contentTextView.font = [UIFont systemFontOfSize:15];
    self.contentTextView.textContainerInset = UIEdgeInsetsMake(9.0f, 6.0f,0.0f, 6.0f);
    self.contentTextView.contentInset = UIEdgeInsetsMake(0, 0,22.0f, 0);
    self.contentTextView.delegate = self;
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(30);
        make.left.equalTo(self).offset(24);
        make.right.equalTo(self).offset(-24);
        make.height.mas_equalTo(200);
    }];
    
    //  剩余字数
    UILabel *textCountlabel = [[UILabel alloc] init];
    textCountlabel.textColor = [UIColor lightGrayColor];
    textCountlabel.text = [NSString stringWithFormat:@"%d/%ld",0,(long)MAX_LIMIT_NUMS];
    textCountlabel.textColor = [UIColor colorWithHexString:@"#999999"];
    textCountlabel.font = [UIFont systemFontOfSize:12];
    _textCountlabel = textCountlabel;
    textCountlabel.contentMode = UIViewContentModeRight;
    [self addSubview:textCountlabel];
    [textCountlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_contentTextView).offset(-6);
        make.bottom.equalTo(_contentTextView).offset(-5);
    }];
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [commitButton setTitle:@"确认提交" forState:UIControlStateNormal];
    [commitButton setTitle:@"确认提交" forState:UIControlStateDisabled];
    [commitButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [commitButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"3c5c8e"]] forState:UIControlStateNormal];
    [commitButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"cacaca"]] forState:UIControlStateDisabled];
    commitButton.enabled = NO;
    [self addSubview:commitButton];
    commitButton.backgroundColor = [UIColor colorWithHexString:@"#3c5c8e"];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentTextView.mas_bottom).offset(8);
        make.left.right.equalTo(_contentTextView);
        make.height.mas_equalTo(44);
    }];
    self.commitButton = commitButton;
}
@end
