//
//  VersionModel+CoreDataProperties.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/10/13.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "VersionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VersionModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *uTeacherId;
@property (nullable, nonatomic, retain) NSString *books_v;
@property (nullable, nonatomic, retain) NSString *grade_v;
@property (nullable, nonatomic, retain) NSString *mac_v;
@property (nullable, nonatomic, retain) NSString *project_v;
@property (nullable, nonatomic, retain) NSString *books_Classify_v;
@property (nullable, nonatomic, retain) NSString *student_v;
@property (nullable, nonatomic, retain) NSString *courses_v;

@end

NS_ASSUME_NONNULL_END
