//
//  SportLineChartContentView.m
//  testLineChart
//
//  Created by LongJun on 13-12-21.
//  Copyright (c) 2013年 LongJun. All rights reserved.
//

#import "IBLineChart.h"
#import "ARLineChartCommon.h"

#define DEFAULT_X_COUNT 100 //可见区域x轴总数

#define DEFAULT_Y_COUNT 10 //可见区域y轴竖线总数


@interface IBLineChart ()

@property (strong, nonatomic) UIFont         * textFont;
@property (strong, nonatomic) UIColor        * textColor;

@property (strong, nonatomic) NSMutableArray * horScaleValues;  /// X 轴刻度值
@property (strong, nonatomic) NSMutableArray * verScaleValues;  /// Y 轴刻度值

@property (assign, nonatomic) CGPoint          originPoint;     /// 原点
@property (assign, nonatomic) CGFloat          verSpacingValue; /// 垂直刻度线跨度值
@property (assign, nonatomic) CGFloat          horSpacingValue; /// 水平刻度线跨度值


///////////////////////////////////////////////////////////////////////////////


@property CGPoint leftTopPoint;
@property CGPoint rightBottomPoint;
@property UIColor *dataLineColor;


static bool isLineIntersectRectangle(CGFloat linePointX1,
                                     CGFloat linePointY1,
                                     CGFloat linePointX2,
                                     CGFloat linePointY2,
                                     CGFloat rectangleLeftTopX,
                                     CGFloat rectangleLeftTopY,
                                     CGFloat rectangleRightBottomX,
                                     CGFloat rectangleRightBottomY);
@end


@implementation IBLineChart


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.layer.cornerRadius = 8.0f;
        [self setClipsToBounds:YES];

        [self setBackgroundColor:[UIColor colorWithRed:33 / 255.0 green:108 / 255.0 blue:205 / 255.0 alpha:1]];
        [self setDataLineColor:[UIColor groupTableViewBackgroundColor]];
        [self setTextColor:[UIColor whiteColor]];
        [self setTextFont:[UIFont systemFontOfSize:8]];
        [self setHorizontalScaleLineCount:8];
        
        self.dataSource = [NSMutableArray array];
    }
    return self;
}


- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self setBackgroundColor:[UIColor colorWithRed:33 / 255.0 green:108 / 255.0 blue:205 / 255.0 alpha:1]];
    [self setDataLineColor:[UIColor groupTableViewBackgroundColor]];
    [self setTextColor:[UIColor whiteColor]];
    [self setTextFont:[UIFont systemFontOfSize:8]];
    [self setHorizontalScaleLineCount:8];
    
    self.dataSource = [NSMutableArray array];
}




- (void)addData:(NSNumber *)dataNumber {
    
    if (self.dataSource.count >= 101) {
        [self.dataSource removeObjectAtIndex:0];
//        NSLog(@"----------- %ld", self.dataSource.count);
    }
    
    [self.dataSource addObject:dataNumber];
    
    if (_dataSource.count) {
        [self processingRawData];
    }
}


- (void)setDataSource:(NSMutableArray *)dataSource {
    
    _dataSource = dataSource;
    
    if (_dataSource.count) {
        [self processingRawData];
    } 
}



- (void)processingRawData {
    
    //生成x轴、左y轴、右y轴刻度值
    [self buildXYSetpArray:DEFAULT_X_COUNT yStepCount:self.horizontalScaleLineCount];
    
    /// 找到最大的数，转换成字符串，得到其高度/宽度；画x轴y轴要留出这些刻度字符串的高度/宽度 ///////
    double xMax =  [[self.horScaleValues firstObject] integerValue];
    for (NSNumber *num in self.horScaleValues) {
        if ([num doubleValue] > xMax) {
            xMax = [num doubleValue];
        }
    }
    
    NSString *xMaxStr = [NSString stringWithFormat:@"%.2lf", xMax];
    CGSize size1 = [xMaxStr sizeWithFont:self.textFont];
    //

    // 原点
    self.originPoint = CGPointMake(30, self.frame.size.height - size1.width - 5);
    
    self.leftTopPoint = CGPointMake(self.originPoint.x, 0 + 20);
    
    self.rightBottomPoint = CGPointMake(self.frame.size.width, self.originPoint.y);
    
    //x轴上每一个Step的距离
    self.horSpacingValue = (self.rightBottomPoint.x - self.originPoint.x) / ([self.horScaleValues count] - 1); //- 0.1;
    
    //y轴上每一个Step的距离
    self.verSpacingValue = (self.originPoint.y - self.leftTopPoint.y) / self.horizontalScaleLineCount - 0.1;
    
    [self setNeedsDisplay];
}





//////////////////// 生成x轴、左y轴、右y轴刻度值数组 ///////////////////////
- (void)buildXYSetpArray:(NSInteger)xStepCount yStepCount:(NSInteger)yStepCount {
    
    @autoreleasepool {
        if ([self.dataSource count] >= 2) {
            
            float verMinValue, verMaxValue;
            
            float value = [[self.dataSource firstObject] floatValue];
            
            verMinValue = value; 
            verMaxValue = value;
            
            for (NSInteger i = 1; i < self.dataSource.count; i++) {
                
                float tempValue = [[self.dataSource objectAtIndex:i] floatValue];
                tempValue < verMinValue ? (verMinValue = tempValue) : verMinValue;
                tempValue > verMaxValue ? (verMaxValue = tempValue) : verMaxValue;
            }
            verMaxValue += 10; 
            
            self.verScaleValues ? [self.verScaleValues removeAllObjects] : [self setVerScaleValues:[@[] mutableCopy]];
            self.horScaleValues ? [self.horScaleValues removeAllObjects] : [self setHorScaleValues:[@[] mutableCopy]];
            /// Y 轴
            float YStepDistance = verMaxValue / yStepCount ;
            
            for (int i = 0; i < yStepCount; i++) {
                [self.verScaleValues addObject:[NSNumber numberWithFloat: (YStepDistance + i * YStepDistance)]];
            }
            
            for (int i = 0; i < 100; i++) {
                
                [self.horScaleValues addObject:@""];
            }
            
        } else if (self.dataSource.count == 1) {
            
            float value = [[self.dataSource firstObject] floatValue];
            
            self.horScaleValues = [NSMutableArray arrayWithObject:@""];
            
            self.verScaleValues = [NSMutableArray arrayWithObject:@(value)];
        }
    }
}




- (void)drawRect:(CGRect)rect {
    
    @autoreleasepool {
        
        [self setClearsContextBeforeDrawing:YES];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        ////////////////////// 水平方向 //////////////////////////
        for (NSInteger index = 0; index < [self.horScaleValues count]; index++) {
            
            NSString * str = [self.horScaleValues objectAtIndex:index];
            NSString * valueStr = [NSString stringWithFormat:@"%@", str]; 
            
            float xPosition = self.originPoint.x + (index + 1) * self.horSpacingValue;
            
            if (xPosition > self.originPoint.x && xPosition < self.rightBottomPoint.x) {
                
                //画x轴文字
                [self.textColor set];
                CGSize title1Size = [valueStr sizeWithFont:self.textFont];
                CGRect titleRect1 = CGRectMake(xPosition - (title1Size.width) / 2,
                                               self.originPoint.y + 2,
                                               title1Size.width,
                                               title1Size.height);
                
                [valueStr drawInRect:titleRect1 
                            withFont:self.textFont 
                       lineBreakMode:NSLineBreakByClipping 
                           alignment:NSTextAlignmentCenter];
                
                
                //画竖线（不包含原点位置的竖线）
                CGFloat dashPattern[]= {1.0, 1};
                CGContextSetLineDash(context, 0.0, dashPattern, 1); //虚线效果
                //            [ARLineChartCommon drawLine:context
                //                             startPoint:CGPointMake(xPosition, self.originPoint.y)
                //                               endPoint:CGPointMake(xPosition, self.leftTopPoint.y)
                //                              lineColor:self.dataLineColor 
                //                                 isNode:NO];
            }
        }
        
        
        /////////////////////// 左边垂直方向 /////////////////////////
        for (NSInteger i = 0; i < [self.verScaleValues count]; i++) {
            
            NSNumber * num = [self.verScaleValues objectAtIndex:i];
            NSString * valueStr = [NSString stringWithFormat:@"%.0lf", [num doubleValue]];
            
            CGFloat y1Position = self.originPoint.y - (i + 1) * self.verSpacingValue; 
            
            if (y1Position < self.originPoint.y && y1Position > self.leftTopPoint.y) {
                //画左y轴文字
                [line1Color set];
                CGSize title1Size = [valueStr sizeWithFont:self.textFont];
                CGRect titleRect1 = CGRectMake(7,
                                               y1Position - (title1Size.height)/2,
                                               title1Size.width,
                                               title1Size.height);
                
                [valueStr drawInRect:titleRect1 
                            withFont:self.textFont 
                       lineBreakMode:NSLineBreakByClipping 
                           alignment:NSTextAlignmentRight];
                
                //画横线（不包含原点位置的横线）
                CGFloat dashPattern[]= {1.0, 1};
                CGContextSetLineDash(context, 0.0, dashPattern, 1); //虚线效果
                [ARLineChartCommon drawLine:context
                                 startPoint:CGPointMake(self.originPoint.x, y1Position)
                                   endPoint:CGPointMake(self.rightBottomPoint.x, y1Position)
                                  lineColor:[UIColor groupTableViewBackgroundColor] 
                                     isNode:NO];
            }
        }
        
        
        /////////////////////// 根据数据源画折线 /////////////////////////
        if (self.dataSource && self.dataSource.count > 0) {
            
            for (NSInteger i = 0; i < self.dataSource.count - 1; i++) {
                
                float value1 = [[self.dataSource objectAtIndex:i] floatValue];
                float value2 = [[self.dataSource objectAtIndex:i + 1] floatValue];
                
                /// 取出 Y 轴刻度值
                float scaleValue = [(NSNumber*)[self.verScaleValues firstObject] floatValue];
                
                float y1Position = self.originPoint.y - fabs(((self.verSpacingValue * value1) / scaleValue ));
                
                float y1Position2 = self.originPoint.y - fabs(((self.verSpacingValue * value2) / scaleValue ));
                
                
                float xPosition = self.originPoint.x + i * self.horSpacingValue;
                float xPosition2 = self.originPoint.x + (i + 1) * self.horSpacingValue;
                
                
                
                
                
                CGPoint startPoint = CGPointMake(xPosition, y1Position);
                CGPoint endPoint = CGPointMake(xPosition2, y1Position2);
                
                CGFloat normal[1]={1};
                CGContextSetLineDash(context,0,normal,0); //画实线
                
                //画折线
                if ( isLineIntersectRectangle(xPosition, y1Position, xPosition2, y1Position2, 
                                              _leftTopPoint.x, 
                                              _leftTopPoint.y, 
                                              _rightBottomPoint.x, 
                                              _rightBottomPoint.y) ) {
                    
                    [ARLineChartCommon drawLine:context 
                                     startPoint:startPoint 
                                       endPoint:endPoint 
                                      lineColor:self.dataLineColor 
                                         isNode:YES];
                }
            }
        }
        //////////////// 画原点上的 x 轴 //////////////////////
        [ARLineChartCommon drawLine:context
                         startPoint:CGPointMake(self.originPoint.x, self.originPoint.y)
                           endPoint:CGPointMake(self.rightBottomPoint.x, self.rightBottomPoint.y)
                          lineColor:self.textColor 
                             isNode:NO];
        
        //////////////// 画原点上的 y 轴 /////////////////////
        CGFloat normal[1]={1};
        CGContextSetLineDash(context,0,normal,0); //画实线
        [ARLineChartCommon drawLine:context
                         startPoint:self.originPoint
                           endPoint:self.leftTopPoint
                          lineColor:self.textColor 
                             isNode:NO];
    }
}



/** <p>判断线段是否在矩形内 </p>
 * 先看线段所在直线是否与矩形相交，
 * 如果不相交则返回false，
 * 如果相交，
 * 则看线段的两个点是否在矩形的同一边（即两点的x(y)坐标都比矩形的小x(y)坐标小，或者大）,
 * 若在同一边则返回false，
 * 否则就是相交的情况。
 * @param linePointX1 线段起始点x坐标
 * @param linePointY1 线段起始点y坐标
 * @param linePointX2 线段结束点x坐标
 * @param linePointY2 线段结束点y坐标
 * @param rectangleLeftTopX 矩形左上点x坐标
 * @param rectangleLeftTopY 矩形左上点y坐标
 * @param rectangleRightBottomX 矩形右下点x坐标
 * @param rectangleRightBottomY 矩形右下点y坐标
 * @return 是否相交
 */
static bool isLineIntersectRectangle(CGFloat linePointX1,
                                     CGFloat linePointY1,
                                     CGFloat linePointX2,
                                     CGFloat linePointY2,
                                     CGFloat rectangleLeftTopX,
                                     CGFloat rectangleLeftTopY,
                                     CGFloat rectangleRightBottomX,
                                     CGFloat rectangleRightBottomY)
{
    CGFloat  lineHeight = linePointY1 - linePointY2;
    CGFloat lineWidth = linePointX2 - linePointX1;  // 计算叉乘
    CGFloat c = linePointX1 * linePointY2 - linePointX2 * linePointY1;
    if ((lineHeight * rectangleLeftTopX + lineWidth * rectangleLeftTopY + c >= 0 && lineHeight * rectangleRightBottomX + lineWidth * rectangleRightBottomY + c <= 0)
        || (lineHeight * rectangleLeftTopX + lineWidth * rectangleLeftTopY + c <= 0 && lineHeight * rectangleRightBottomX + lineWidth * rectangleRightBottomY + c >= 0)
        || (lineHeight * rectangleLeftTopX + lineWidth * rectangleRightBottomY + c >= 0 && lineHeight * rectangleRightBottomX + lineWidth * rectangleLeftTopY + c <= 0)
        || (lineHeight * rectangleLeftTopX + lineWidth * rectangleRightBottomY + c <= 0 && lineHeight * rectangleRightBottomX + lineWidth * rectangleLeftTopY + c >= 0))
    {
        
        if (rectangleLeftTopX > rectangleRightBottomX) {
            CGFloat temp = rectangleLeftTopX;
            rectangleLeftTopX = rectangleRightBottomX;
            rectangleRightBottomX = temp;
        }
        if (rectangleLeftTopY < rectangleRightBottomY) {
            CGFloat temp1 = rectangleLeftTopY;
            rectangleLeftTopY = rectangleRightBottomY;
            rectangleRightBottomY = temp1;   }
        if ((linePointX1 < rectangleLeftTopX && linePointX2 < rectangleLeftTopX)
            || (linePointX1 > rectangleRightBottomX && linePointX2 > rectangleRightBottomX)
            || (linePointY1 > rectangleLeftTopY && linePointY2 > rectangleLeftTopY)
            || (linePointY1 < rectangleRightBottomY && linePointY2 < rectangleRightBottomY)) {
            return false;
        } else {
            return true;
        }
    } else {
        return false;
    }
}



@end
