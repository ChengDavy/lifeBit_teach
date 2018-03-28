//
//  StudentModel+CoreDataProperties.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/2.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "StudentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StudentModel (CoreDataProperties)
// 年级ID
@property (nullable, nonatomic, retain) NSString *sGradeId;
// 年级名称
@property (nullable, nonatomic, retain) NSString *sGradeName;
// 学生的出生日期
@property (nullable, nonatomic, retain) NSString *sBirthDate;
// 学生的班级名称
@property (nullable, nonatomic, retain) NSString *sClassName;
// 学生民族
@property (nullable, nonatomic, retain) NSString *sNational;
// 性别
@property (nullable, nonatomic, retain) NSString *sSex;
// 学生id
@property (nullable, nonatomic, retain) NSString *studentId;
// 学生姓名
@property (nullable, nonatomic, retain) NSString *studentName;
// 学生学号
@property (nullable, nonatomic, retain) NSString *studentNo;

// 班级ID
@property (nullable, nonatomic, retain) NSString *sClassId;

// 是否被点名
@property (nullable, nonatomic, retain) NSNumber *sIsCallOver;


@end

NS_ASSUME_NONNULL_END
