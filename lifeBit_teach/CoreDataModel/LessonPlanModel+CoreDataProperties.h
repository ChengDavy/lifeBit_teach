//
//  LessonPlanModel+CoreDataProperties.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/2.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LessonPlanModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LessonPlanModel (CoreDataProperties)
/*
 *教案适用年级
 */
@property (nullable, nonatomic, retain) NSString *grade;
/*
 *教案ID
 */
@property (nullable, nonatomic, retain) NSString *lessonPlanId;
/*
 *教案名称
 */
@property (nullable, nonatomic, retain) NSString *lessonPlanName;
/*
 *教案所有阶段
 */
@property (nullable, nonatomic, retain) id lessonPlanPhase;
/*
 *教案来源
 */
@property (nullable, nonatomic, retain) NSString *lessonPlanSource;
/*
 *教案时长
 */
@property (nullable, nonatomic, retain) NSString *lessonPlanTime;
/*
 *教案项目类型
 */
@property (nullable, nonatomic, retain) NSString *lessonPlanType;



/*
 *教案学习项目技巧ID
 */
@property (nullable, nonatomic, retain)NSString *sSportSkillID;
/*
 *教案学习项目技巧
 */
@property (nullable, nonatomic, retain)NSString *sSportSkill;
/*
 *教案所属老师
 */
@property (nullable, nonatomic, retain) NSString *teachId;

@end

NS_ASSUME_NONNULL_END
