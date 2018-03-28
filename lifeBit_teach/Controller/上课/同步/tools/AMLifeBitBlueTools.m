//
//  AMLifeBitBlueTools.m
//  AMToolsDemo
//
//  Created by Aimi on 16/4/28.
//  Copyright © 2016年 Aimi. All rights reserved.
//

#import "AMLifeBitBlueTools.h"


#define LBLog(fmt, ...) NSLog((@"LBLog: "fmt), ##__VA_ARGS__);
//#define LBLog(...);

static AMLifeBitBlueTools* _lifeBitTools;

static NSString * const kServiceUUID = @"FFE0";
static NSString * const kReadCharacteristicUUID = @"FFE1";
static NSString * const kWriteCharacteristicUUID = @"FFE2";

@interface AMLifeBitBlueTools()<CBCentralManagerDelegate,CBPeripheralDelegate>

@property(nonatomic,strong)CBUUID* serviceUUID;
@property(nonatomic,strong)CBUUID* readUUID;
@property(nonatomic,strong)CBUUID* writeUUID;


@end

@implementation AMLifeBitBlueTools


+(instancetype)sharedInstance{
    
    if (!_lifeBitTools) {
        _lifeBitTools = [[AMLifeBitBlueTools alloc]init];
        _lifeBitTools.manager = [[CBCentralManager alloc]initWithDelegate:_lifeBitTools queue:nil];
        
        _lifeBitTools.serviceUUID = [CBUUID UUIDWithString:kServiceUUID];
        _lifeBitTools.readUUID= [CBUUID UUIDWithString:kReadCharacteristicUUID];
        _lifeBitTools.writeUUID = [CBUUID UUIDWithString:kWriteCharacteristicUUID];
    }
    
    return _lifeBitTools;
}

+(instancetype)instance{
    AMLifeBitBlueTools* lifeBitBools = [[AMLifeBitBlueTools alloc]init];
    lifeBitBools.manager = [[CBCentralManager alloc]initWithDelegate:lifeBitBools queue:nil];
    
    lifeBitBools.serviceUUID = [CBUUID UUIDWithString:kServiceUUID];
    lifeBitBools.readUUID= [CBUUID UUIDWithString:kReadCharacteristicUUID];
    lifeBitBools.writeUUID = [CBUUID UUIDWithString:kWriteCharacteristicUUID];
    lifeBitBools.scanWatchArray = [NSMutableArray array];
    
    return lifeBitBools;
}


//开始扫描
-(void)startScanWithResultBlock:(void (^)(CBCentralManager *, CBPeripheral *, NSDictionary *, NSNumber *))scanResultBlock{
    [self.manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey :@NO}];
    self.scanResultBlock = scanResultBlock;
    
    LBLog(@"开始扫描");
}

//获取当前蓝牙状态
-(CBCentralManagerState)getBlueToothState{
    switch (self.manager.state) {
        case CBCentralManagerStateUnknown:
            LBLog(@"获取状态 Unknown");
            break;
            
        case CBCentralManagerStateResetting:
            LBLog(@"获取状态 Resetting");
            break;
            
        case CBCentralManagerStateUnsupported:
            LBLog(@"获取状态 Unsupported");
            break;
            
            
        case CBCentralManagerStateUnauthorized:
            LBLog(@"获取状态 Unauthorized");
            break;
            
            
        case CBCentralManagerStatePoweredOff:
            LBLog(@"获取状态 PoweredOff");
            break;
            
            
        case CBCentralManagerStatePoweredOn:{
            LBLog(@"获取状态 PoweredOn");
            break;
        }

        default:
            break;
    }
    
    return self.manager.state;
}


//停止扫描
-(void)stopScan{
    [self.manager stopScan];
}


//连接设备
-(void)connectWatch:(LBWatchPerModel*)watch andSuccess:(void (^)(CBPeripheral* peripheral))success andFail:(void (^)(NSString *errorStr))fail{
    watch.connectSuccessBlock = success;
    watch.connectFailBlock = fail;
    watch.type = LBWatchTypeConnecting;
    [self.manager connectPeripheral:watch.peripheral options:nil];
}


//断开设备连接
-(void)cancelPeripheralConnection:(CBPeripheral*)CBPeripheral{
    [self.manager cancelPeripheralConnection:CBPeripheral];
    LBLog(@"已断开连接 %@",CBPeripheral.name);
}

//断开所有设备的蓝牙连接
-(void)cancelAllBluePeripheral{
    
    NSArray* arr = [self.manager retrieveConnectedPeripheralsWithServices:@[self.serviceUUID]];
    
    if (arr && arr.count) {
        for (CBPeripheral* p in arr) {
            [self.manager cancelPeripheralConnection:p];
        }
    }
}


#pragma mark  ----CBCentralManagerDelegate----
- (void)centralManagerDidUpdateState:(CBCentralManager *)central;{
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            LBLog(@"状态改变 Unknown");
            break;
            
        case CBCentralManagerStateResetting:
            LBLog(@"状态改变 Resetting");
            break;
            
        case CBCentralManagerStateUnsupported:
            LBLog(@"状态改变Unsupported");
            break;
            
            
        case CBCentralManagerStateUnauthorized:
            LBLog(@"状态改变 Unauthorized");
            break;
            
            
        case CBCentralManagerStatePoweredOff:
            LBLog(@"状态改变 PoweredOff");
            break;
            
            
        case CBCentralManagerStatePoweredOn:{
            LBLog(@"状态改变 PoweredOn");
            break;
        }
        default:
            break;
    }
    
    if (self.didUpdateStateBlock) {
        self.didUpdateStateBlock(central);
    }

}

#pragma --mark-- 扫描到设备

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    LBLog(@"扫描到设备 %@",advertisementData);
    
    if (self.scanResultBlock) {
        self.scanResultBlock(central,peripheral,advertisementData,RSSI);
    }
}




- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    // Clears the data that we may already have
    LBLog(@"%@ 初始连接成功",peripheral.name);
    for (LBWatchPerModel* watch in self.scanWatchArray) {
        if (watch.peripheral == peripheral) {
            watch.manager = self.manager;
            [peripheral discoverServices:@[self.serviceUUID]];
            return;
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    LBLog(@"%@ 初始连接失败",peripheral.name);
    for (LBWatchPerModel* watch in self.scanWatchArray) {
        if (watch.peripheral == peripheral) {
            watch.connectFailBlock(@"初始连接失败");
            return;
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    LBLog(@"%@蓝牙设备断连了",peripheral.name);
    
    for (LBWatchPerModel* watch in self.scanWatchArray) {
        if (self.disconnectPeripheralBlock && watch.peripheral ==peripheral) {
            self.disconnectPeripheralBlock(central,watch);
            return;
        }
    }
}


#pragma mark  -----其他用到的工具----
//16进制转为字符串
- (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}



//字符串转16进制
- (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    return hexData;
}



-(void)dealloc{
    NSLog(@"AMLifeBitTools dealloc");
}

@end
