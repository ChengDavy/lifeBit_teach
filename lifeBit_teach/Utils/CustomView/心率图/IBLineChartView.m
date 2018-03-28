//
//  TestView.m
//  Demo_LineChart
//
//  Created by 介岳西 on 16/9/6.
//  Copyright © 2016年 Caesar. All rights reserved.
//

#import "IBLineChartView.h"


@interface IBLineChartView ()

@property (nonatomic, strong) NSMutableArray * points;

@property (nonatomic, strong) ValueZigZagValue * valueZigZagValue;


@end


@implementation IBLineChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"xinlv_bg"]];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        [self addSubview:self.valueZigZagValue];
        
        
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(20 ,10, 70, 20)];
        lb.backgroundColor = [UIColor clearColor];
        lb.layer.masksToBounds = YES;
        lb.layer.cornerRadius = 10;
        lb.layer.borderColor = [UIColor whiteColor].CGColor;
        lb.layer.borderWidth = 1;
        lb.text = @"心率/次";
        lb.font = [UIFont systemFontOfSize:14];
        lb.textColor = [UIColor whiteColor];
        lb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lb];
        
        
        UILabel *lb1 = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 80 ,self.bounds.size.height - 25, 70, 20)];
        lb1.backgroundColor = [UIColor clearColor];
        lb1.layer.masksToBounds = YES;
        lb1.layer.cornerRadius = 10;
        lb1.layer.borderColor = [UIColor whiteColor].CGColor;
        lb1.layer.borderWidth = 1;
        lb1.text = @"时间/秒";
        lb1.font = [UIFont systemFontOfSize:14];
        lb1.textColor = [UIColor whiteColor];
        lb1.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lb1];
        
    }
    return self;
}


- (void)addPoint:(NSNumber *)pointValue {
    [self.valueZigZagValue addPoint:pointValue calibrationValues:_calibrationValues];
}

- (ValueZigZagValue *)valueZigZagValue {
    if (!_valueZigZagValue) {
        
        self.valueZigZagValue = [[ValueZigZagValue alloc] initWithFrame:CGRectMake(30, 0, CGRectGetWidth(self.frame) - 30, CGRectGetHeight(self.frame))];
        [_valueZigZagValue setBackgroundColor:[UIColor clearColor]];
    }
    return _valueZigZagValue;
}



- (void)drawRect:(CGRect)rect {
    
    [self setClearsContextBeforeDrawing: NO];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat backLineWidth = .2f;
    
    CGContextSetLineWidth(context, backLineWidth);//主线宽度
    
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    CGContextSetLineCap(context, kCGLineCapRound);
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    CGFloat WIDTH = CGRectGetWidth(self.frame);
    CGFloat HEIGHT = CGRectGetHeight(self.frame);
    CGFloat BOTTOM_SPACE = 50;
    CGFloat HORIZONTAL_SPACE = (HEIGHT - BOTTOM_SPACE) / (float)self.calibrationValues.count;
    

    /** 横向分隔线 */
    for (int i = 0; i < _calibrationValues.count; i++) {
        
        CGPoint bPoint = CGPointMake(30, HEIGHT - HORIZONTAL_SPACE * i - BOTTOM_SPACE);
        CGPoint ePoint = CGPointMake(WIDTH, HEIGHT - HORIZONTAL_SPACE * i - BOTTOM_SPACE);
        
        /// 横轴刻度标签
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [label setCenter:CGPointMake(bPoint.x - 15, bPoint.y)];
        [label setFont:[UIFont systemFontOfSize:10]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        [label setText:[[_calibrationValues objectAtIndex:i] stringValue]];
        [self addSubview:label];
        /// 横轴分隔线
        CGContextMoveToPoint(context, bPoint.x, bPoint.y);
        CGContextAddLineToPoint(context, ePoint.x, ePoint.y);
        
    }
    CGContextStrokePath(context);
}

@end


///////////////////////////////////////////////////////////////////////////////////////


@interface ValueZigZagValue ()

@property (nonatomic, strong) NSMutableArray * points;
@end


@implementation ValueZigZagValue

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.points = [@[] mutableCopy];
    }
    return self;
}


- (void)addPoint:(NSNumber *)pointValue calibrationValues:(NSArray *)calibrationValues {
    
    if (_points.count > 100) {
        for (int i = 0; i < _points.count - 100; i++) {
            [_points removeObjectAtIndex:i];
        }
    }    

    CGFloat BOTTOM_SPACE = 50;
    CGFloat HEIGHT = CGRectGetHeight(self.frame) ;
    
    CGFloat HORIZONTAL_SPACE = (HEIGHT -  BOTTOM_SPACE) / (float)calibrationValues.count;
    CGFloat COLUMN_SPACE = CGRectGetWidth(self.frame) / (_points.count + 1);
//    CGFloat COLUMN_SPACE = (HEIGHT - 2 * BOTTOM_SPACE) / (_points.count + 1);
    CGFloat x = 0;
    CGFloat y = (HEIGHT -  BOTTOM_SPACE) - fabs(pointValue.floatValue - [calibrationValues[0] floatValue]) * (HORIZONTAL_SPACE / 20.0);
    
    for (int i = 0; i < _points.count; i++) {
        x = i * COLUMN_SPACE;
        
        NSString * str = _points[i];
        CGPoint point = CGPointFromString(str);
        point.x = x;
        point.y = point.y;
        
        _points[i] = NSStringFromCGPoint(point);
    }
    
    [self.points addObject:NSStringFromCGPoint((CGPoint){(_points.count + 1) * COLUMN_SPACE, y})];
    
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    
    if (_points.count < 2) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    CGContextSetLineCap(context, kCGLineCapRound);
    
    CGContextSetBlendMode(context, kCGBlendModeOverlay);
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    for (int i = 0; i < _points.count - 1; i++) {
        
        CGContextSetLineWidth(context, 1.0f);//主线宽度

        
        CGPoint p1 = CGPointFromString([_points objectAtIndex:i]);
        CGPoint p2 = CGPointFromString([_points objectAtIndex:i + 1]);
        // 绘制两点间线条
        CGContextMoveToPoint(context, p1.x, p1.y);
        CGContextAddLineToPoint(context, p2.x, p2.y);
        
        
        CGContextSetLineWidth(context, .5f);//主线宽度

        // 绘制值方块
        CGRect rectangle = CGRectMake(p2.x-1,p2.y-1,2,2);
        CGContextAddRect(context, rectangle);  
        CGContextStrokePath(context); 
        

        if (_points.count < 10) {
            
            CGContextMoveToPoint(context, p2.x, 43.5);
            CGContextAddLineToPoint(context, p2.x, CGRectGetHeight(self.frame) - 50);
            
            UIFont  * font = [UIFont systemFontOfSize:12];
            CGContextSetRGBFillColor(context, 255.0, 255.0, 255.0, 1.0);
//            [[NSString stringWithFormat:@"前%ld",_points.count] drawInRect:CGRectMake(p2.x - 5, CGRectGetHeight(self.frame) - 40, 40, 20) withFont:font];
            NSDictionary *attributes = @{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor whiteColor]};
            [[NSString stringWithFormat:@"前%ld",_points.count] drawInRect:CGRectMake(p2.x - 5, CGRectGetHeight(self.frame) - 40, 40, 20) withAttributes:attributes];
        } else if (_points.count < 100) {
            
            if (i % 10 == 0) {
                CGContextMoveToPoint(context, p2.x, 43.5);
                CGContextAddLineToPoint(context, p2.x, CGRectGetHeight(self.frame) - 50);
                
                UIFont  * font = [UIFont systemFontOfSize:12];
                CGContextSetRGBFillColor(context, 255.0, 255.0, 255.0, 1.0);
//                [[NSString stringWithFormat:@"前%d", i] drawInRect:CGRectMake(p2.x - 5, CGRectGetHeight(self.frame) - 40, 40, 20) withFont:font];
                NSDictionary *attributes = @{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor whiteColor]};
                [[NSString stringWithFormat:@"前%ld",_points.count - i] drawInRect:CGRectMake(p2.x - 5, CGRectGetHeight(self.frame) - 40, 40, 20) withAttributes:attributes];
            }
        } else if (_points.count > 100) {
            if (i % 20 == 0) {
                CGContextMoveToPoint(context, p2.x, 43.5);
                CGContextAddLineToPoint(context, p2.x, CGRectGetHeight(self.frame) - 50);
                
                UIFont  * font = [UIFont systemFontOfSize:12];
                CGContextSetRGBFillColor(context, 255.0, 255.0, 255.0, 1.0);
//                [[NSString stringWithFormat:@"前%d", i] drawInRect:CGRectMake(p2.x - 5, CGRectGetHeight(self.frame) - 40, 40, 20) withFont:font];
                NSDictionary *attributes = @{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor whiteColor]};
                [[NSString stringWithFormat:@"前%lu", _points.count - i] drawInRect:CGRectMake(p2.x - 5, CGRectGetHeight(self.frame) - 40, 40, 20) withAttributes:attributes];
            }
        }
    }
    CGContextStrokePath(context);
}

@end


