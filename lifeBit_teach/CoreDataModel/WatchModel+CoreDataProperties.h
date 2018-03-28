//
//  WatchModel+CoreDataProperties.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/2.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "WatchModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WatchModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *ipadIdentifying;
@property (nullable, nonatomic, retain) NSString *teachBoxId;
@property (nullable, nonatomic, strong) NSString *teachBoxName;
@property (nullable, nonatomic, strong) NSString *teachBoxNo;
@property (nullable, nonatomic, strong) NSString *watchId;
@property (nullable, nonatomic, strong) NSString *watchMAC;
@property (nullable, nonatomic, strong) NSString *watchNo;

// 老师id
@property (nullable, nonatomic, strong) NSString *teacherId;
@end

NS_ASSUME_NONNULL_END
