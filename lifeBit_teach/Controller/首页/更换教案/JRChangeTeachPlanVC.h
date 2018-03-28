//
//  JRChangeTeachPlanVC.h
//  lifeBit_teach
//
//  Created by joyskim-ios1 on 16/9/5.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJBaseVC.h"
#import "HJLessonPlanInfo.h"
#import "HJClassInfo.h"

@interface JRChangeTeachPlanVC : HJBaseVC

@property (nonatomic,assign)JRLessonPlanShowType lessonPlanType;

// 班级信息
@property (nonatomic,strong)HJClassInfo *classInfo;
// 教案
@property (nonatomic,strong)HJLessonPlanInfo *lessonPlanInfo;

@end
