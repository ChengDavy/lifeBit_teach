//
//  HJClassInfo.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/13.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJClassInfo.h"

@implementation HJClassInfo

// 根据记录的已上课课程，转换成上课班级
+(HJClassInfo*)createClassInfoWithHaveClassModel:(HaveClassModel *)haveClassModel{
    HJClassInfo *classInfo = [[HJClassInfo alloc] init];
    classInfo.cClassId = haveClassModel.classId;
    classInfo.cClassName = haveClassModel.cClassname;
    classInfo.cGradeId = haveClassModel.cGradeId;
    classInfo.cGradeName = haveClassModel.cGradeName;
    classInfo.cTeacherId = haveClassModel.teacherId;
    classInfo.cClassTime = haveClassModel.classTime;
    classInfo.cLessonPlanId = haveClassModel.lessonPlanId;
    classInfo.cStatus = haveClassModel.classStatus;
    classInfo.cScheduleType = haveClassModel.scheduleType;
    classInfo.cScheduleId = haveClassModel.scheduleId;
    classInfo.cMaxRate = haveClassModel.maxRate;
    classInfo.cStartTime = haveClassModel.startDate;
    classInfo.cMinRate = haveClassModel.minRate;
    return classInfo;
}

// 根据上课班级，转换成数据库中对象
+(HaveClassModel*)conversionClassInfoWithHaveClassModel:(HJClassInfo *)classInfo{
    HaveClassModel* haveClassModel = [[LifeBitCoreDataManager shareInstance] efCraterHaveClassModel];
    haveClassModel.classId = classInfo.cClassId;
    haveClassModel.cClassname = classInfo.cClassName;
    haveClassModel.cGradeId = classInfo.cGradeId;
    haveClassModel.cGradeName = classInfo.cGradeName;
    haveClassModel.startDate = classInfo.cStartTime;
    haveClassModel.teacherId = classInfo.cTeacherId;
    haveClassModel.classTime = classInfo.cClassTime;
    haveClassModel.lessonPlanId = classInfo.cLessonPlanId;
    haveClassModel.classStatus = classInfo.cStatus;
    haveClassModel.scheduleType = classInfo.cScheduleType;
    haveClassModel.scheduleId = classInfo.cScheduleId;
    haveClassModel.maxRate = classInfo.cMaxRate;
    haveClassModel.minRate = classInfo.cMinRate;
    return haveClassModel;
}


// 根据记录的测试记录，转换成班级
+(HJClassInfo*)createClassInfoWithTestModel:(TestModel *)testModel{
    HJClassInfo *classInfo = [[HJClassInfo alloc] init];
    classInfo.cClassId = testModel.classId;
    classInfo.cClassName = testModel.classname;
    classInfo.cGradeId = testModel.greadId;
    classInfo.cGradeName = testModel.greadName;
    classInfo.cStartTime = testModel.startTime;
    classInfo.cTeacherId = testModel.teacherId;
    
    classInfo.cProjectName = testModel.projectName;
    classInfo.cProjectUnit = testModel.projectUnit;
    classInfo.cProjectId = testModel.projectId;
    classInfo.cProjectType = testModel.projectType;
    return classInfo;
}

// 课程表转换成班级
+(HJClassInfo*)createClassInfoWithScheduleModel:(ScheduleModel *)scheduleModel{
    HJClassInfo *classInfo = [[HJClassInfo alloc] init];
    classInfo.cClassId = scheduleModel.classId;
    classInfo.cClassName = scheduleModel.classname;
    classInfo.cTeacherId = scheduleModel.teacherId;
    classInfo.cClassTime = scheduleModel.classTime;
    classInfo.cWeek = scheduleModel.week;
    classInfo.cperiod = scheduleModel.period;
    classInfo.cStatus = scheduleModel.classStatus;
    classInfo.cLessonPlanId = scheduleModel.lessonPlanId;
    classInfo.cScheduleId = scheduleModel.scheduleId;
    classInfo.cGradeId = scheduleModel.gradeId;
    classInfo.cGradeName = scheduleModel.gradeName;
    classInfo.cMaxRate = scheduleModel.maxRate;
    classInfo.cMinRate = scheduleModel.minRate;
    return classInfo;
}

// 班级转换成课程表
+(ScheduleModel*)conversionScheduleModelWithClassInfo:(HJClassInfo *)classInfo{
    ScheduleModel* scheduleModel = [[LifeBitCoreDataManager shareInstance] efCraterScheduleModel];
    scheduleModel.classId = classInfo.cClassId;
    scheduleModel.classname = classInfo.cClassName;
    scheduleModel.teacherId = classInfo.cTeacherId;
    scheduleModel.classTime = classInfo.cClassTime;
    scheduleModel.week = classInfo.cWeek;
    scheduleModel.period = classInfo.cperiod;
    scheduleModel.classStatus = classInfo.cStatus;
    scheduleModel.lessonPlanId = classInfo.cLessonPlanId;
    scheduleModel.scheduleId = classInfo.cScheduleId;
    scheduleModel.gradeName = classInfo.cGradeName;
    scheduleModel.gradeId = classInfo.cGradeId;
    scheduleModel.startClassDate = classInfo.cStartTime;
    scheduleModel.maxRate = classInfo.cMaxRate;
    scheduleModel.minRate = classInfo.cMinRate;
    return scheduleModel;
}
@end
