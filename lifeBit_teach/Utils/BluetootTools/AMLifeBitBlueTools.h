//
//  AMLifeBitBlueTools.h
//  AMToolsDemo
//
//  Created by Aimi on 16/4/28.
//  Copyright © 2016年 Aimi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "crc16.h"
#import "LBWatchPerModel.h"

@interface AMLifeBitBlueTools : NSObject

@property(nonatomic,strong)CBCentralManager* manager;



@property(nonatomic, strong) void (^scanResultBlock)(CBCentralManager* central,CBPeripheral* peripheral,NSDictionary* advertisementData , NSNumber* RSSI);
@property(nonatomic, strong) void(^didUpdateStateBlock)(CBCentralManager* central);
@property(nonatomic, strong) void(^disconnectPeripheralBlock)(CBCentralManager* central,LBWatchPerModel * watch);


@property(nonatomic,strong)NSMutableArray* scanWatchArray;


//单例化创建
+(instancetype)sharedInstance;

+(instancetype)instance;

-(void)registerBlueToothManager;

//蓝牙状态更改后的回调
-(void)setDidUpdateStateBlock:(void (^)(CBCentralManager * centralManager))didUpdateStateBlock;

//蓝牙设备断开连接后回调
-(void)setDisconnectPeripheralBlock:(void (^)(CBCentralManager * central, LBWatchPerModel * watch))disconnectPeripheral;

//开始扫描
-(void)startScanWithResultBlock:(void (^)(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI))scanResultBlock;

//停止扫描
-(void)stopScan;

//连接设备
-(void)connectWatch:(LBWatchPerModel*)watch andSuccess:(void (^)(CBPeripheral* peripheral))success andFail:(void (^)(NSString *errorStr))fail;


//断开设备连接
-(void)cancelPeripheralConnection:(CBPeripheral*)CBPeripheral;

//断开所有蓝牙手表
-(void)cancelAllBluePeripheral;



//16进制转为字符串
- (NSString *)convertDataToHexStr:(NSData *)data;


//字符串转16进制
- (NSData *)convertHexStrToData:(NSString *)str;

@end
