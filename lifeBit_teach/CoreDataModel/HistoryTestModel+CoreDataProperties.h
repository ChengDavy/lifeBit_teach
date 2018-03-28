//
//  HistoryTestModel+CoreDataProperties.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/22.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "HistoryTestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HistoryTestModel (CoreDataProperties)
/*
 *班级id
 */
@property (nullable, nonatomic, retain) NSString *classId;
/*
 *班级名称
 */
@property (nullable, nonatomic, retain) NSString *classname;
/*
 *年级id
 */
@property (nullable, nonatomic, retain) NSString *greadId;
/*
 *年级名称
 */
@property (nullable, nonatomic, retain) NSString *greadName;
/*
 *项目名称
 */
@property (nullable, nonatomic, retain) NSString *projectName;
/*
 *项目ID
 */
@property (nullable, nonatomic, retain) NSString *projectId;
/*
 *项目测试单位
 */
@property (nullable, nonatomic, retain) NSString *projectUnit;
/*
 *项目测试类型
 */
@property (nullable, nonatomic, retain) NSString *data_type;
/*
 *项目描述
 */
@property (nullable, nonatomic, retain) NSString *remark;
/*
 *项目成绩（优良）
 */
@property (nullable, nonatomic, retain) NSString *good;
/*
 *项目成绩（中）
 */
@property (nullable, nonatomic, retain) NSString *pass;
/*
 *项目成绩（差）
 */
@property (nullable, nonatomic, retain) NSString *no_pass;

/*
 *开始上课时间
 */
@property (nullable, nonatomic, retain) NSDate *startDate;
/*
 *测试老师
 */
@property (nullable, nonatomic, retain) NSString *teacherId;
@end

NS_ASSUME_NONNULL_END
