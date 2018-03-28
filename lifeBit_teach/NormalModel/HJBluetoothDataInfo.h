//
//  HJBluetoothDataInfo.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/12.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "BaseModel.h"
typedef  NS_ENUM(NSInteger,HJBluetoothDataType){
    HJBluetoothDataTypeHeartRate,  // 心率
    HJBluetoothDataTypeSteps, // 步数
};
@interface HJBluetoothDataInfo : BaseModel
@property (nonatomic,assign)HJBluetoothDataType dataType; // 数据类型

// 对应手表mac地址
@property (nonatomic,strong)NSString *macStr;

// 记录时间
@property (nonatomic,strong)NSDate *recordDate;

// 记录数据
@property (nonatomic,strong)NSString *recordData;

// 记录时间Data类型
@property (nonatomic,strong)NSData *recordDateData;

// 记录数据Data类型
@property (nonatomic,strong)NSData *recordDataData;


+(HJBluetoothDataInfo*)createBluetoothDataInfoWithBluetoothDataModel:(BluetoothDataModel *)bluetoothDataModel;
@end
