//
//  SchoolModel+CoreDataProperties.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/20.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//
// 第一次登陆时保存学校区域数据
#import "SchoolModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SchoolModel (CoreDataProperties)
/*
 * 学校ID
 */
@property (nullable, nonatomic, retain) NSString *schoolId;
/*
 * 学校名称
 */
@property (nullable, nonatomic, retain) NSString *schoolName;
/*
 * 学校区域
 */
@property (nullable, nonatomic, retain) NSString *schoolArea;
/*
 * 学校区域Id
 */
@property (nullable, nonatomic, retain) NSString *schoolAreaId;

@end

NS_ASSUME_NONNULL_END
