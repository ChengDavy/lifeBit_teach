//
//  TestView.h
//  Demo_LineChart
//
//  Created by 介岳西 on 16/9/6.
//  Copyright © 2016年 Caesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface IBLineChartView : UIView

@property (nonatomic, strong) NSMutableArray * calibrationValues;

- (void)addPoint:(NSNumber *)pointValue;


@end





@interface ValueZigZagValue : UIView
- (instancetype)initWithFrame:(CGRect)frame;

- (void)addPoint:(NSNumber *)pointValue calibrationValues:(NSArray *)calibrationValues;

@end
