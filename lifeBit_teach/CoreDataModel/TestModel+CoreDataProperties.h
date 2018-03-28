//
//  TestModel+CoreDataProperties.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/18.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *startTime;
@property (nullable, nonatomic, retain) NSString *classId;
@property (nullable, nonatomic, retain) NSString *classname;
@property (nullable, nonatomic, retain) NSString *greadId;
@property (nullable, nonatomic, retain) NSString *greadName;
@property (nullable, nonatomic, retain) NSString *teacherId;


@property (nullable, nonatomic, retain) NSString *projectName;
@property (nullable, nonatomic, retain) NSString *projectUnit;
@property (nullable, nonatomic, retain) NSString *projectId;
@property (nullable, nonatomic, retain) NSString *projectType;


@end

NS_ASSUME_NONNULL_END
