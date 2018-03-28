//
//  NotStudentModel+CoreDataProperties.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/10/8.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//  未参加上课学生

#import "NotStudentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NotStudentModel (CoreDataProperties)
/*
 *学生id
 */
@property (nullable, nonatomic, retain) NSString *studentId;
/*
 *学生名称
 */
@property (nullable, nonatomic, retain) NSString *studentName;
/*
 *学生学号
 */
@property (nullable, nonatomic, retain) NSString *studentNo;
/*
 *学生性别
 */
@property (nullable, nonatomic, retain) NSString *sSex;
/*
 *开始上课时间
 */
@property (nullable, nonatomic, retain) NSDate *sStartTime;
/*
 *学生班级
 */
@property (nullable, nonatomic, retain) NSString *sClassId;
/*
 *学生班级名称
 */
@property (nullable, nonatomic, retain) NSString *sClassName;
/*
 *学生年级id
 */
@property (nullable, nonatomic, retain) NSString *sGradeId;
/*
 *学生年级名称
 */
@property (nullable, nonatomic, retain) NSString *sGradeName;
/*
 *老师id
 */
@property (nullable, nonatomic, retain) NSString *teacherId;


@end

NS_ASSUME_NONNULL_END
