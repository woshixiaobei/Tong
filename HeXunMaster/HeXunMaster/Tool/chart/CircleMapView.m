//
//  CircleMapView.m
//  CircleConstructionMAP
//
//  Created by wangmingzhu on 16/8/20.
//  Copyright © 2016年 wangmingzhu. All rights reserved.
//

#import "CircleMapView.h"

#define PI 3.14159265358979323846
//#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define degreesToRadian(x) ( 180.0 / PI * (x))

#define radiu 25.0 //中心白色圆的半径
@implementation CircleMapView{
    CGFloat f;
}
//初始化
-(instancetype)initWithFrame:(CGRect)frame andWithDataArray:(NSMutableArray *)dataArr andWithCircleRadius:(CGFloat)circleRadius{
    if (self = [super initWithFrame:frame]) {
        _dataArray = [[NSMutableArray alloc] init];
        _circleRadius = circleRadius;
    }
    return self;
}

-(CGFloat)getShareNumber:(NSMutableArray *)arr{  //比例
    
    for (int  i = 0; i < arr.count; i++) {
        f += [arr[i] floatValue];
    }
    NSLog(@"总量：%.2f  比例:%.2f",f,360.0 / f);
    
    return M_PI*2 / f;
}
-(void)drawRect:(CGRect)rect{
    CGFloat bl = [self getShareNumber:_dataArray]; //得到比例
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
       //float angle_start = radians(0.0); //开始
    CGFloat angle_start =0; //开始时的弧度  －－－－－ 旋转200度
    CGFloat ff = 0;  //记录偏转的角度 －－－－－ 旋转200度
    for (int i = 0; i < _dataArray.count; i++) {
        //float angle_end = radians([_dataArray[i] floatValue] *bl + ff);  //结束
        CGFloat angle_end =([_dataArray[i]  floatValue] *bl + ff);  //结束
        ff += [_dataArray[i] floatValue] *bl;  //开始之前的角度
        
        //drawArc(ctx, self.center, angle_start, angle_end, _colorArray[i]);
        
        // 1.上下文
        // 2.中心点
        // 3.开始
        // 4.结束
        // 5.颜色
        
        [self drawArcWithCGContextRef:ctx andWithPoint:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) andWithAngle_start:angle_start andWithAngle_end:angle_end andWithColor:self.colorArr[i] andInt:i];
        
        
        //NSLog(@"开始:%.2f  数据:%.2f  加值:%.2f  结束: %.2f   AAA:%.2f",angle_start,[_dataArray[i] floatValue],[_dataArray[i] floatValue] *bl,angle_end,[_dataArray[i] floatValue] *bl + angle_start);
        
        
        angle_start = angle_end;
    }
    
//    [self addCenterCircle];//添加中心圆
}
-(void)addCenterCircle{
    UIBezierPath *arcPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:radiu startAngle:0 endAngle:PI * 2 clockwise:YES];
    
    [[UIColor whiteColor] set];
    [arcPath fill];
    [arcPath stroke];
    
}
//static inline float radians(double degrees) {
//    return degrees * PI / 180;
//}
//static inline void drawArc(CGContextRef ctx, CGPoint point, float angle_start, float angle_end, UIColor *color) {
//    CGContextMoveToPoint(ctx, point.x, point.y);
//    CGContextSetFillColor(ctx, CGColorGetComponents( [color CGColor]));
//    CGContextAddArc(ctx, point.x, point.y, radius,  angle_start, angle_end, 0);
//    //CGContextClosePath(ctx);
//    CGContextFillPath(ctx);
//}

-(CGFloat)radians:(CGFloat)degrees {  //由角度获取弧度
    return degrees * M_PI / 180;
}
-(void)drawArcWithCGContextRef:(CGContextRef)ctx
                  andWithPoint:(CGPoint) point
            andWithAngle_start:(float)angle_start
              andWithAngle_end:(float)angle_end
                  andWithColor:(UIColor *)color
                        andInt:(int)n {
    
    CGContextMoveToPoint(ctx, point.x, point.y);
    CGContextSetFillColor(ctx, CGColorGetComponents( color.CGColor));
    CGContextAddArc(ctx, point.x, point.y, _circleRadius,  angle_start, angle_end, 0);
    CGContextFillPath(ctx);
    // 弧度的中心角度
    CGFloat h = (angle_end + angle_start) / 2.0;
    //小圆的中心点
    CGFloat xx = self.frame.size.width / 2 + (_circleRadius + 10) * cos(h);
    CGFloat yy = self.frame.size.height / 2 + (_circleRadius + 10) * sin(h);
    
    //画线
    [self addLineAndnumber:color andCGContextRef:ctx andX:xx andY:yy andInt:n angele:h];
}
/**
 * @color 颜色
 * @ctx CGContextRef
 * @x 小圆的中心点的x
 * @y 小圆的中心点的y
 * @n 表示第几个弧行
 * @angele 弧度的中心角度
 */

//画线
-(void)addLineAndnumber:(UIColor *)color
        andCGContextRef:(CGContextRef)ctx
                   andX:(CGFloat)x
                   andY:(CGFloat)y
                 andInt:(int)n
                 angele:(CGFloat)angele
{
    
    //NSLog(@"%f ----/  %f",x,y);
    
    //小圆中心点
    CGFloat smallCircleCenterPointX = x;
    CGFloat smallCircleCenterPointY = y;
    
    //NSLog(@"X:%f   Y:%f",smallCircleCenterPointX,smallCircleCenterPointY);
    //折点
    CGFloat lineLosePointX = 0.0 ; //指引线的折点
    CGFloat lineLosePointY = 0.0 ; //
    
    //指引线的终点
    CGFloat lineEndPointX ; //
    CGFloat lineEndPointY ; //
    
    //数字的起点
    CGFloat numberStartX;
    CGFloat numberStartY;
    
    //文字的起点
    CGFloat textStartX;
    CGFloat textStartY;
    
    
    // 数字的长度
    CGSize itemSizeNumber = [[NSString stringWithFormat:@"%@",_dataArray[n]] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]}];
    lineLosePointX = smallCircleCenterPointX+10.0*cos(angele);
    lineLosePointY = smallCircleCenterPointY + 10.0*sin(angele);
    
    if (smallCircleCenterPointX > self.frame.size.width / 2) {
        //指引线的终点
        lineEndPointX = lineLosePointX + 60.0; //
        lineEndPointY = lineLosePointY; //
        //数字
        numberStartX = lineEndPointX - 60.0;
        numberStartY = lineEndPointY - itemSizeNumber.height;
        //文字
        textStartX = lineEndPointX;
        textStartY = lineEndPointY;
    }else{
        //指引线的终点
        lineEndPointX = lineLosePointX - 60.0; //
        lineEndPointY = lineLosePointY; //
        
        // 数字
        numberStartX = lineEndPointX ;
        numberStartY = lineEndPointY - itemSizeNumber.height;
        
        //文字
        textStartX = lineEndPointX;
        textStartY = lineEndPointY;
    }
    
    //画边上的小圆
    UIBezierPath *arcPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(smallCircleCenterPointX, smallCircleCenterPointY) radius:1 startAngle:0 endAngle:PI * 2 clockwise:YES];
    [color set];
    [arcPath fill];
    [arcPath stroke];
    CAShapeLayer *startDotLayer = [CAShapeLayer layer];
    startDotLayer.path = arcPath.CGPath;
    //画指引线
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, smallCircleCenterPointX,smallCircleCenterPointY);
    CGContextAddLineToPoint(ctx, lineLosePointX, lineLosePointY);
    CGContextAddLineToPoint(ctx, lineEndPointX, lineEndPointY);
    CGContextSetLineWidth(ctx, 0.5);
    //画笔的颜色
    //CGContextSetRGBStrokeColor( ctx , r , g , b , 1);
    //填充颜色
    CGContextSetFillColorWithColor(ctx , color.CGColor);
    CGContextStrokePath(ctx);
    
    
    //指引线上面的数字
    NSLog(@"%f",[_dataArray[n] floatValue] / f);
    [[NSString stringWithFormat:@"%.2f%%",([_dataArray[n] floatValue] / f)*100] drawAtPoint:CGPointMake(numberStartX, numberStartY) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0],NSForegroundColorAttributeName:color}];
    //指引线下面的text
    
//    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc]init];
//     paragraph.alignment = NSTextAlignmentRight;
//    if (lineEndPointX < [UIScreen mainScreen].bounds.size.width /2.0) {
//       paragraph.alignment = NSTextAlignmentLeft;
//    }
   
//    [_dataArray[n][@"name"] drawInRect:CGRectMake(textStartX, textStartY, 60, 50) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0],NSForegroundColorAttributeName:color,NSParagraphStyleAttributeName:paragraph}];
    
}
- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    [self setNeedsDisplay];
}

- (NSArray *)colorArr {

    if (_colorArr == nil) {
        _colorArr = [NSArray array];
        _colorArr = @[[UIColor colorWithHexString:@"#688fca"],[UIColor colorWithHexString:@"#e3cfae"],[UIColor colorWithHexString:@"#f89679"]];
    }
    return _colorArr;
}

@end
