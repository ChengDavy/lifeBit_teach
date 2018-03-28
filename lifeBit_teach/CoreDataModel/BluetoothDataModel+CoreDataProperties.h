//
//  BluetoothDataModel+CoreDataProperties.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/13.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BluetoothDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BluetoothDataModel (CoreDataProperties)

/*
 * 心率数据为1，步数数据为2
 */
@property (nullable, nonatomic, retain) NSString *dataType;
@property (nullable, nonatomic, retain) NSString *watchMac;
@property (nullable, nonatomic, retain) NSString *bluetootData;
@property (nullable, nonatomic, retain) NSData *bluetootDataData;
@property (nullable, nonatomic, retain) NSData *recordDateData;
@property (nullable, nonatomic, retain) NSDate *recordDate;


@property (nullable, nonatomic, retain) NSString *teacherId;
@end

NS_ASSUME_NONNULL_END
