//
//  HXM_Marco.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/9.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXM_Marco.h"

NSString * HXAppId = @"";
#pragma mark - 打开系统级应用
void ApplicationOpenURL(NSURL*url)
{
    [[UIApplication sharedApplication]openURL:url];
}
// 拨打电话
void ApplicationOpenTelWithPhoneNumber(NSString*phoneNum)
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNum]];
    ApplicationOpenURL(url);
}

// 打开应用
void ApplicationOpenURLWithString(NSString*string)
{
    NSURL *url = [NSURL URLWithString:string];
    ApplicationOpenURL(url);
}
/** 根据给定字体计算单位高度 */
CGFloat UnitHeightOfFont(UIFont*font)
{
    CGSize maxSize = CGSizeMake(100, 100);
    CGSize unitSize =  CGSizeOfString(@"单位",maxSize,font);
    return unitSize.height;
}

/** 根据字符串、最大尺寸、字体计算字符串最合适尺寸 */
CGSize CGSizeOfString(NSString * text, CGSize maxSize, UIFont * font)
{
    CGSize fitSize;
    if (text.length==0 || !text) {
        fitSize = CGSizeMake(0, 0);
    }else{
        fitSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size;
    }
    return fitSize;
}

/** 设置视图大小，原点不变 */
void SetViewSize(UIView *view, CGSize size)
{
    CGRect frame = view.frame;
    frame.size = size;
    view.frame = frame;
}

/** 设置视图宽度，其他不变 */
void SetViewSizeWidth(UIView *view, CGFloat width)
{
    CGRect frame = view.frame;
    frame.size.width = width;
    view.frame = frame;
}

/** 设置视图高度，其他不变 */
void SetViewSizeHeight(UIView *view, CGFloat height)
{
    CGRect frame = view.frame;
    frame.size.height = height;
    view.frame = frame;
}

/** 设置视图原点，大小不变 */
void SetViewOrigin(UIView *view, CGPoint pt)
{
    CGRect frame = view.frame;
    frame.origin = pt;
    view.frame = frame;
}

/** 设置视图原点x坐标，大小不变 */
void SetViewOriginX(UIView *view, CGFloat x)
{
    CGRect frame = view.frame;
    frame.origin.x = x;
    view.frame = frame;
}

/** 设置视图原点y坐标，大小不变 */
void SetViewOriginY(UIView *view, CGFloat y)
{
    CGRect frame = view.frame;
    frame.origin.y = y;
    view.frame = frame;
}

void setSubviewDelaysContentTouchesNO(UIView * v)
{
    if ([v isKindOfClass:[UIScrollView class]] || [NSStringFromClass([v class]) isEqualToString:@"UITableViewCellScrollView"]) {
        if ([v respondsToSelector:@selector(setDelaysContentTouches:)]) {
            ((UIScrollView *)v).delaysContentTouches = NO;
        }
    }
    for (UIView *obj in v.subviews)
    {
        setSubviewDelaysContentTouchesNO(obj);
    }
}


/**
 *	@brief	设置 UIFont 的缩放比例
 *
 *	@param 	font 	原始 UIFont
 *	@param 	ratio 	缩放比例
 *
 *	@return	返回设置后的 UIFont
 */
UIFont * SetFontWithBaseFont(UIFont *font , float ratio)
{
    return [UIFont fontWithName:font.fontName size:font.pointSize*ratio];
}



void ApplicationIconBadgeNumber(NSInteger num)
{
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:num];
}


#pragma mark - 可变参数格式化
NSString* StringWithFormat(NSString*format,...)
{
    if (!format || format.length==0) {
        return nil;
    }
    //指向变参的指针
    va_list list;
    //使用第一个参数来初使化list指针
    va_start(list, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:list];
    //结束可变参数的获取
    va_end(list);
    return str;
}
