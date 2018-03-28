//
//  SportLineChartContentView.h
//  testLineChart
//
//  Created by LongJun on 13-12-21.
//  Copyright (c) 2013年 LongJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IBLineChart : UIView

//构造函数，必须使用
- (id)initWithFrame:(CGRect)frame;


@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, assign) int horizontalScaleLineCount;

- (void)addData:(NSNumber *)dataNumber;


@end
