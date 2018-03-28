//
//  HJBluetoothDataInfo.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/12.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJBluetoothDataInfo.h"

@implementation HJBluetoothDataInfo
//
+(HJBluetoothDataInfo*)createBluetoothDataInfoWithBluetoothDataModel:(BluetoothDataModel *)bluetoothDataModel{
    HJBluetoothDataInfo * bluetoothDataInfo = [[HJBluetoothDataInfo alloc] init];
    bluetoothDataInfo.macStr = bluetoothDataModel.watchMac;
    bluetoothDataInfo.recordDate = bluetoothDataModel.recordDate;
    bluetoothDataInfo.recordData = bluetoothDataModel.bluetootData;
    bluetoothDataInfo.dataType = [bluetoothDataModel.dataType intValue];
    bluetoothDataInfo.recordDateData = bluetoothDataModel.recordDateData;
    bluetoothDataInfo.recordDataData = bluetoothDataModel.bluetootDataData;
    return bluetoothDataInfo;
}
@end
