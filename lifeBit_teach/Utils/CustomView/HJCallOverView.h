//
//  HJCallOverView.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/8.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJStudentInfo.h"

@interface HJCallOverView : UIView

// 学生数组
@property (nonatomic,strong)NSMutableArray *studentArr;

// 点名的学生数组
@property (nonatomic,strong)NSMutableArray *callOverArr;

// 点击点名按钮回调
@property (nonatomic,strong)void (^tapCallOverStudentBlock)(NSDictionary*studentDic);
-(void)setTapCallOverStudentBlock:(void (^)(NSDictionary *studentDic))tapCallOverStudentBlock;

// 点击开始上课按钮
@property (nonatomic,strong)void (^startClassTapBlock)(void);

-(void)setStartClassTapBlock:(void (^)(void))startClassTapBlock;

-(void)showStudentView:(NSMutableArray *)studentArr withCallOverArr:(NSMutableArray*)callOverArr;
@end
