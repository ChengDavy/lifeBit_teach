//
//  LessonPlanIdUnitModel+CoreDataProperties.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/2.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LessonPlanIdUnitModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LessonPlanIdUnitModel (CoreDataProperties)
/*
 *单元适用年级
 */
@property (nullable, nonatomic, retain) NSString *grade;
/*
 *单元所属阶段
 */
@property (nullable, nonatomic, retain) NSString *lessonPlanPhase;
/*
 *单元所属项目
 */
@property (nullable, nonatomic, retain) NSString *projectType;
/*
 *单元名称
 */
@property (nullable, nonatomic, retain) NSString *unitName;
/*
 *单元内容
 */
@property (nullable, nonatomic, retain) NSString *unitContent;
/*
 *单元id
 */
@property (nullable, nonatomic, retain) NSString *unitId;
/*
 *单元所在教案阶段的序号
 */
@property (nullable, nonatomic, retain) NSNumber *unitNo;
/*
 *单元来源
 */
@property (nullable, nonatomic, retain) NSString *unitSource;
/*
 *单元时间长
 */
@property (nullable, nonatomic, retain) NSString *unitTime;
/*
 *老师id
 */
@property (nullable, nonatomic, retain) NSString *teachId;
/*
 *单元所属教案
 */
@property (nullable, nonatomic, retain) NSString *lessonPlanId;

@end

NS_ASSUME_NONNULL_END
