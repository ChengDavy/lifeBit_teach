//
//  HJTestStudentVC.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/6.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJBaseVC.h"
#import "HJClassInfo.h"
@interface HJTestStudentVC : HJBaseVC

// 项目信息
@property (nonatomic,strong)HJProjectInfo *projectInfo;

// 班级信息
@property (nonatomic,strong)HJClassInfo *classInfo;

@end
