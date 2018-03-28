//
//  JRCheckTeatchPlanVC.h
//  lifeBit_teach
//
//  Created by joyskim-ios1 on 16/9/5.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJBaseVC.h"
#import "HJClassInfo.h"
@interface JRCheckTeatchPlanVC : HJBaseVC

@property (nonatomic, assign) JRLessonPlanShowType lessonPlanShowType; // 类型

@property (nonatomic,strong)HJLessonPlanInfo *lessonPlanInfo;

@property (nonatomic,strong)HJClassInfo *classInfo;

// 是否平台教案
@property (nonatomic,assign)BOOL isPlatform;

// 是否是课程进入预览教案
@property (nonatomic,assign)BOOL isCourse;

@end
