//
//  HJStartClassVC.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/9.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJBaseVC.h"

@interface HJStartClassVC : HJBaseVC

@property (nonatomic,strong)HJClassInfo *inClassInfo;
//班级所有学生
@property (nonatomic,strong)NSMutableArray *studentArr;


// 签到学生
@property (nonatomic,strong)NSMutableArray *signInStudentArr;

@end
