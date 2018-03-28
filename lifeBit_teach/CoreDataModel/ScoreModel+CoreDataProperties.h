//
//  ScoreModel+CoreDataProperties.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/2.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ScoreModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScoreModel (CoreDataProperties)
// 年级ID
@property (nullable, nonatomic, retain) NSString *gradeId;
// 年级名称
@property (nullable, nonatomic, retain) NSString *gradeName;
// 项目id
@property (nullable, nonatomic, retain) NSString *projectId;
// 项目名称
@property (nullable, nonatomic, retain) NSString *projectName;
// 成绩数组
@property (nullable, nonatomic, retain) id scoreArr;
// 班级id
@property (nullable, nonatomic, retain) NSString *studentClassId;
// 班级名称
@property (nullable, nonatomic, retain) NSString *studentClassName;
// 学生id
@property (nullable, nonatomic, retain) NSString *studentId;
// 学生学号
@property (nullable, nonatomic, retain) NSString *studentNo;
// 学生性别
@property (nullable, nonatomic, retain) NSString *studentSex;
// 学生性别
@property (nullable, nonatomic, retain) NSString *studentName;

// 测试老师
@property (nullable, nonatomic, retain) NSString *teachId;

// 项目成绩类型
@property (nonnull, nonatomic, retain) NSString *projectType;
// 班级id
@property (nonnull, nonatomic, retain) NSString *classId;
// 班级名称
@property (nonnull, nonatomic, retain) NSString *cClassName;

// 记录上课时间
@property (nonnull, nonatomic, retain) NSDate *startDate;

@end

NS_ASSUME_NONNULL_END
