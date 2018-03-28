//
//  HJRealTimeRateVC.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/14.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJBaseVC.h"
#import "LBWatchPerModel.h"

@interface HJRealTimeRateVC : HJBaseVC

@property (nonatomic,assign)NSInteger police_Hear;

@property (nonatomic,assign)NSInteger min_Hear;
// 学生对应的周边
@property (nonatomic,strong)LBWatchPerModel *watchPerModel;

@property (nonatomic,strong)HJStudentInfo *studentInfo;

@end
