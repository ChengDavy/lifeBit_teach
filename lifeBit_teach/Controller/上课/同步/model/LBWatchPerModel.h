//
//  LBWatchPerModel.h
//  lifeBit_teach
//
//  Created by Aimi on 16/5/11.
//  Copyright © 2016年 joyskim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "crc16.h"

typedef NS_ENUM(NSInteger, LBWatchType) {
    LBWatchTypeUnConnected          = 0,
    LBWatchTypeConnecting           = 1,
    LBWatchTypeConnected            = 2,
    LBWatchTypeDisConnected         = 3,
    LBWatchTypeSyncHeart             = 4,
    LBWatchTypeupDataHeart           = 5,
    LBWatchTypeSyncWalk             = 6,
    LBWatchTypeupDataWalk           = 7,
    LBWatchTypeNetError             =8,
    LBWatchTypeDone                 =9,
    LBWatchTypeClean                =10,
    LBWatchTypeWait                 =11

};


typedef NS_ENUM(NSInteger, AMLBSyncType) {
    AMLBSyncTypeNotWorking         = 0, //
    AMLBSyncTypeTime               = 1, // 同步时间
    AMLBSyncTypeHeartContinue      = 2, // 同步心率
    AMLBSyncTypeWalk               = 3, // 同步步数
    AMLBSyncTypeClean              = 4, // 清除缓存
    AMLBSyncTypeWorkTime           = 5 // 处理设置工作时间
};


@interface LBWatchPerModel : NSObject <CBPeripheralDelegate>


@property(nonatomic,strong)CBPeripheral* peripheral;
@property(nonatomic,strong)CBCentralManager* manager;


@property(nonatomic)LBWatchType type;
@property(nonatomic,assign)AMLBSyncType syncType;

@property(nonatomic,strong)NSData* upDateWalkData;
@property(nonatomic,strong)NSData* upDateHeartData;
@property(nonatomic,strong)NSString* progressStr;
@property(nonatomic)BOOL isConnected;       //是否处于连接中


+(instancetype)watchPerWithPeripheral:(CBPeripheral*)peripheral;


@property(nonatomic,strong)void (^connectSuccessBlock)(CBPeripheral* peripheral);
@property(nonatomic,strong)void (^connectFailBlock)(NSString* errorStr);
@property(nonatomic,strong)void(^getDataBlock)(NSData* data);


//lifebit专用

//同步时间
-(void)syncTimeWithSuccess:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail;

//同步连续心率
-(void)syncHeartContinueWithProgress:(void (^)(NSObject* anyObj))progress Success:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail;


//同步运动步数心率数据
-(void)syncWalkWithProgress:(void (^)(NSObject* anyObj))progress Success:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail;


//清楚所有数据指令
-(void)orderCleanSuccess:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail;


//设置工作时间
-(void)orderWorkTimeSuccess:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail;

//进入休眠模式
-(void)orderSleep;


//设置5分钟工作时间
-(void)orderTestWorkTimeSuccess:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail;




@end
