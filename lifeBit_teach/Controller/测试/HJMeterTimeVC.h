//
//  HJMeterTimeVC.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/7.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJBaseVC.h"

@interface HJMeterTimeVC : HJBaseVC

// 项目信息
@property (nonatomic,strong)HJProjectInfo *projectInfo;

// 选中学生信息
@property (nonatomic,strong)NSMutableArray *studentArr;

@end
