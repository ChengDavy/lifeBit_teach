//
//  ScheduleModel+CoreDataProperties.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/2.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ScheduleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScheduleModel (CoreDataProperties)
// 班级ID
@property (nullable, nonatomic, retain) NSString *classId;
// 班级名称
@property (nullable, nonatomic, retain) NSString *classname;
// 年级ID
@property (nullable, nonatomic, retain) NSString *gradeId;
// 年级名称
@property (nullable, nonatomic, retain) NSString *gradeName;
// 上课状态
@property (nullable, nonatomic, retain) NSString *classStatus;
// 教案ID
@property (nullable, nonatomic, retain) NSString *lessonPlanId;
// 第几节课
@property (nullable, nonatomic, retain) NSString *period;
// 课程名称
@property (nullable, nonatomic, retain) NSString *rowClassName;
// 星期几的课程
@property (nullable, nonatomic, retain) NSString *week;
// 课程表ID
@property (nullable, nonatomic, retain) NSString *scheduleId;
// 老师Id
@property (nullable, nonatomic, retain) NSString *teacherId;
/*
 *课程时间
 */
@property (nullable, nonatomic, retain) NSNumber *classTime;

/*
 *开始上课时间
 */
@property (nullable, nonatomic, retain) NSDate *startClassDate;

/*
 *课程最小心率
 */
@property (nullable, nonatomic, retain) NSString *minRate;
/*
 *课程最大心率
 */
@property (nullable, nonatomic, retain) NSString *maxRate;

@end

NS_ASSUME_NONNULL_END
