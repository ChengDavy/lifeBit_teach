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
    LBWatchTypeUnConnected          = 0, // 没有连接
    LBWatchTypeConnecting           = 1, // 连接中
    LBWatchTypeConnected            = 2, // 连接
    LBWatchTypeDisConnected         = 3, // 连接失败
    LBWatchTypeSyncHeart             = 4, 
    LBWatchTypeupDataHeart           = 5,
    LBWatchTypeSyncWalk             = 6,
    LBWatchTypeupDataWalk           = 7,
    LBWatchTypeNetError             =8,
    LBWatchTypeDone                 =9,    // 同步完成
    LBWatchTypeClean                =10,   //清除数据
    LBWatchTypeWait                 =11, // 等待连接
    LBWatchTypeClearDone                 =12,    // 清除数据同步完成
};


typedef NS_ENUM(NSInteger, AMLBSyncType) {
    AMLBSyncTypeNotWorking         = 0,
    AMLBSyncTypeTime               = 1,
    AMLBSyncTypeHeartContinue      = 2,
    AMLBSyncTypeWalk               = 3,
    AMLBSyncTypeClean              = 4,
    AMLBSyncTypeWorkTime           = 5,
    
    LBWatchTypeOrderHeartContinue   =6,
    AMRealTimeSyncTypeHeart        =7,   // 实时心率
    AMCommandRealTimeSyncTypeHeart        =8,   // 用命令发送进入实时心率
    AMLBContinuingHeartContinue = 9 // 进入连续心率
};
@protocol HJDetectionPeripheralRSSI <NSObject>

-(void)didReadRSSI:(NSNumber*)RSSI withPeripher:(CBPeripheral*)peripheral;



@end



@interface LBWatchPerModel : NSObject <CBPeripheralDelegate>


@property(nonatomic,strong)CBPeripheral* peripheral;
@property(nonatomic,strong)CBCentralManager* manager;


@property(nonatomic)LBWatchType type;
@property(nonatomic,assign)AMLBSyncType syncType;

@property(nonatomic,strong)NSData* upDateWalkData;
@property(nonatomic,strong)NSData* upDateHeartData;
@property(nonatomic,strong)NSString* progressStr;
@property(nonatomic)BOOL isConnected;       //是否处于连接中

// 错误连接次数
@property (nonatomic,assign)NSInteger countConnected;

@property (nonatomic,strong)id<HJDetectionPeripheralRSSI> delegate;


@property(nonatomic,strong)NSMutableData* heartData;
@property(nonatomic,strong)NSMutableData* walkData;

@property (nonatomic,strong)NSMutableArray *syncHeartArr;
@property (nonatomic,strong)NSMutableArray *syncWalktArr;


+(instancetype)watchPerWithPeripheral:(CBPeripheral*)peripheral;


@property(nonatomic,strong)void (^connectSuccessBlock)(CBPeripheral* peripheral);
@property(nonatomic,strong)void (^connectFailBlock)(NSString* errorStr);
@property(nonatomic,strong)void(^getDataBlock)(NSData* data);

// 同步实时心率回调的Block
@property (nonatomic,strong) void (^getReadTimeSyncHeartBlock)(NSInteger heart);
-(void)setGetReadTimeSyncHeartBlock:(void (^)(NSInteger heart))getReadTimeSyncHeartBlock;
@property (nonatomic,strong) void (^readTimeSyncHeartErrorBlock)(NSString *errorStr);
-(void)setReadTimeSyncHeartErrorBlock:(void (^)(NSString *errorStr))readTimeSyncHeartErrorBlock;

@property (nonatomic, copy) void (^heartRateNotification)(NSInteger heart);
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

//设置指定工作时间
-(void)orderWorkTime:(NSString*)timerStr  Success:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail;

//设置工作时间5分钟
-(void)orderTestWorkTimeSuccess:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail;




//进入休眠模式
-(void)orderSleep;

//发送连续测心率模式
-(void)orderHeartContinue:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail;;


//查看实时心率
-(void)syncRealTimeWithSuccess:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail;



@end
