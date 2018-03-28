//
//  HaveClassModel+CoreDataProperties.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/13.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "HaveClassModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HaveClassModel (CoreDataProperties)
/*
 *班级ID
 */
@property (nullable, nonatomic, retain) NSString *classId;
/*
 *班级名称
 */
@property (nullable, nonatomic, retain) NSString *cClassname;
/*
 * 班级名称
 */
@property (nonatomic,strong)NSString *cGradeName;
// 年级ID
@property (nonatomic, retain) NSString *cGradeId;

/*
 *开始上课时间
 */
@property (nullable, nonatomic, retain) NSDate *startDate;

/*
 *老师ID
 */
@property (nullable, nonatomic, retain) NSString *teacherId;
/*
 *课程时间
 */
@property (nullable, nonatomic, retain) NSNumber *classTime;
/*
 *教案id
 */
@property (nullable, nonatomic, retain) NSString *lessonPlanId;
/*
 *上课状态(0 未定义教案   1准备上课  2上课中 3上课中  4上课完成)
 */
@property (nullable, nonatomic, retain) NSString *classStatus;
/*
 * 课程来源类型（1 课程表 ,2 自定义）
 */
@property (nullable, nonatomic, retain) NSNumber *scheduleType;
/*
 * 课程ID
 */
@property (nullable, nonatomic, retain) NSString *scheduleId;

/*
 * 最大心率值
 */
@property (nullable, nonatomic, retain) NSString *maxRate;

/*
 * 最大心率值
 */
@property (nullable, nonatomic, retain) NSString *minRate;


@end

NS_ASSUME_NONNULL_END
