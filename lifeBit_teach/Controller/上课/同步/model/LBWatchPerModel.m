//
//  LBWatchPerModel.m
//  lifeBit_teach
//
//  Created by Aimi on 16/5/11.
//  Copyright © 2016年 joyskim. All rights reserved.
//

#import "LBWatchPerModel.h"

#define LBLog(fmt, ...) NSLog((@"LBLog %@: "fmt),self.peripheral.name,##__VA_ARGS__);
//#define LBLog(...);

static NSString * const kServiceUUID = @"FFE0";
static NSString * const kReadCharacteristicUUID = @"FFE1";
static NSString * const kWriteCharacteristicUUID = @"FFE2";

@interface LBWatchPerModel()

@property(nonatomic,strong)CBUUID* serviceUUID;
// 周边设备服务读的特征
@property(nonatomic,strong)CBUUID* readUUID;
// 周边设备服务写的特征
@property(nonatomic,strong)CBUUID* writeUUID;


@property(nonatomic,strong)CBCharacteristic* readCharacteristic;
@property(nonatomic,strong)CBCharacteristic* writeCharacteristic;

@property(nonatomic,strong)NSTimer* timer; //十秒超时计时器
@property(nonatomic,assign)NSInteger time;

//lifeBit专用回调
@property(nonatomic,strong)void (^syncSuccessBlock)(NSObject* anyObj);
@property(nonatomic,strong)void (^syncFailBlock)(NSString* errorStr);
@property(nonatomic,strong)void (^syncProgressBlock)(NSObject* anyObj);


@property(nonatomic,strong)NSMutableString* responseStr;

@property(nonatomic,strong)NSMutableData* heartData;
@property(nonatomic,strong)NSMutableData* walkData;

@property(nonatomic,strong)NSData* sendData;


@end


@implementation LBWatchPerModel

+(instancetype)watchPerWithPeripheral:(CBPeripheral*)peripheral{
    LBWatchPerModel* m =  [[LBWatchPerModel alloc]init];
    m.peripheral = peripheral;
    m.peripheral.delegate = m;
    m.type = LBWatchTypeUnConnected;
    m.serviceUUID = [CBUUID UUIDWithString:kServiceUUID];
    m.readUUID= [CBUUID UUIDWithString:kReadCharacteristicUUID];
    m.writeUUID = [CBUUID UUIDWithString:kWriteCharacteristicUUID];
    
    m.syncType = AMLBSyncTypeNotWorking;
    m.progressStr = @"";
    
    return  m;
}


-(void)setType:(LBWatchType)type{
    if (_type == LBWatchTypeDone) {
        return;
    }
    
    if (type == LBWatchTypeConnected) {
        self.isConnected = YES;
    }
    
    if (type == LBWatchTypeDone || type ==LBWatchTypeDisConnected || type == LBWatchTypeNetError) {
        self.isConnected = NO;
    }
    
    _type =type;
}


//发送数据
-(void)sendData:(NSData*)data{
//     判断周边手表是否与中央连接
    if (self.peripheral.state == CBPeripheralStateConnected) {
        LBLog(@"发送数据:%@",data);
        [self.peripheral writeValue:data forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}

#pragma mark  ----CBPeripheralDelegate----
//发现服务
- (void)peripheral:(CBPeripheral *)aPeripheral didDiscoverServices:(NSError *)error {
//
    if (error) {
        LBLog(@"didDiscoverServices error");
        if (self.connectFailBlock) {
            self.connectFailBlock(@"查找服务出错");
            LBLog(@"查找服务出错");
            [self.manager cancelPeripheralConnection:aPeripheral];
        }
        return;
    }
    
    for (CBService *service in aPeripheral.services) {
        // 查找特征
        if ([service.UUID isEqual:self.serviceUUID]) {
            LBLog(@"已到服务 %@ 并开始查找特征",service.UUID);
            [aPeripheral discoverCharacteristics:nil forService:service];
            return;
        }
    }
    
    if (self.connectFailBlock) {
        self.connectFailBlock(@"没有发现相关服务");
        LBLog(@"没有发现相关服务");
        [self.manager cancelPeripheralConnection:aPeripheral];
    }
}

//发现特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:
(CBService *)service error:(NSError *)error {
    if (error) {
        LBLog(@"didDiscoverCharacteristicsForService error");
        if (self.connectFailBlock) {
            self.connectFailBlock(@"查找特征出现错误");
            LBLog(@"查找特征出现错误");
            [self.manager cancelPeripheralConnection:peripheral];
        }
        return;
    }
    
    BOOL hasRead = NO;
    BOOL hasWrite = NO;
    
    if ([service.UUID isEqual:self.serviceUUID]) {
        
        for (CBCharacteristic *characteristic in service.characteristics) {
            
            if ([characteristic.UUID isEqual:self.readUUID]) {
                //监听某个特征
                self.readCharacteristic = characteristic;
                
                //订阅某一个特征,用于检测
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                LBLog(@"已订阅读取特征 %@",characteristic.UUID);
                hasRead = YES;
            }
            
            if ([characteristic.UUID isEqual:self.writeUUID]) {
                //监听某个特征
                self.writeCharacteristic = characteristic;
                LBLog(@"已存入写入特征:%@",characteristic.UUID);
                hasWrite = YES;
                
            }
        }
    }
    
    if (hasRead && hasWrite) {
        LBLog(@"已连接");
        if (self.connectSuccessBlock) {
            self.connectSuccessBlock(peripheral);
        }
        
    }else{
        if (self.connectFailBlock) {
            self.connectFailBlock(@"没有找到read或者write特征");
            LBLog(@"没有找到read或者write特征");
            [self.manager cancelPeripheralConnection:peripheral];
        }
    }
    
}


//监听的特征值发生了变化
- (void)peripheral:(CBPeripheral *)peripheral
didUpdateNotificationStateForCharacteristic:
(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        LBLog(@"didUpdateNotificationStateForCharacteristic error");
        return;
    }
    // Exits if it's not the transfer characteristic
    if (![characteristic.UUID isEqual:self.readUUID]) {
        return;
    }
    // Notification has started
    if (characteristic.isNotifying) {
        //        LBLog(@"%@", characteristic.value);
        [peripheral readValueForCharacteristic:characteristic];
        
    } else {
        // Notification has stopped
        LBLog(@"didUpdateNotificationStateForCharacteristic stopped");
    }
}


#pragma --mark-- 写入成功时调用

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {
        LBLog(@"error:    %@",error);
        LBLog(@"发送失败");
    }else{
        LBLog(@"发送成功");
    }
}
#pragma --mark-- 监听读，read改变时调用

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    NSData* data = characteristic.value;
//    LBLog(@" 收到数据 %@ :%@",characteristic.UUID,data);
    if (self.getDataBlock) {
        self.getDataBlock(characteristic.value);
    }
    
    [self handleData:data andErrorStr:nil];
}

#pragma mark  ----lifeBit 专用方法------
//同步时间
-(void)syncTimeWithSuccess:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail{
    
    self.syncType = AMLBSyncTypeTime;
    
    self.syncSuccessBlock = success;
    self.syncFailBlock = fail;
    
    //拼接时间命令字符串
    NSString* yearStr = [[self getDataWithFormat:@"YYYY"] mutableCopy];
    NSMutableString* dataStr = [@"C00A" mutableCopy];
    
    [dataStr appendString:[yearStr substringWithRange:NSMakeRange(2, 2)]];
    [dataStr appendString:[yearStr substringWithRange:NSMakeRange(0, 2)]];
    
    [dataStr appendString:[self getDataWithFormat:@"MMdd"]];
    [dataStr appendString:[self weekdayStringFromDate:[NSDate date]]];
    [dataStr appendString:[self getDataWithFormat:@"HHmmss"]];
    
    LBLog(@"dateStr = %@",dataStr);
    
    //命令数据转data并crc16加密
    NSMutableData* data = [[self convertHexStrToData:dataStr] mutableCopy];
    UInt16 crc = crc_ccitt((unsigned char*)data.bytes, 10);
    LBLog(@"crc :%x",crc);
    [data appendBytes:&crc length:2];
    LBLog(@"同步时间指令为:%@",data);
    [self sendData:data];
}


//同步连续心率数据
-(void)syncHeartContinueWithProgress:(void (^)(NSObject* anyObj))progress Success:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail{
    self.syncType = AMLBSyncTypeHeartContinue;
    self.syncSuccessBlock = success;
    self.syncFailBlock = fail;
    self.syncProgressBlock = progress;
    
    self.responseStr = [@"" mutableCopy];
    self.heartData  = [NSMutableData data];
    
    Byte bytes[] = {0xC7,0x02};
    NSMutableData* data = [NSMutableData dataWithBytes:bytes length:2];
    UInt16 crc = crc_ccitt((unsigned char*)data.bytes, 2);
    LBLog(@"crc :%x",crc);
    [data appendBytes:&crc length:2];
    LBLog(@"同步心率指令为:%@",data);
    [self sendData:data];
}

//同步运动步数数据
-(void)syncWalkWithProgress:(void (^)(NSObject* anyObj))progress Success:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail{
    self.syncType = AMLBSyncTypeWalk;
    self.syncSuccessBlock = success;
    self.syncFailBlock = fail;
    self.syncProgressBlock = progress;
    
    self.responseStr = [@"" mutableCopy];
    self.walkData = [NSMutableData data];
    
    Byte bytes[] = {0xDA,0x02};
    NSMutableData* data = [NSMutableData dataWithBytes:bytes length:2];
    UInt16 crc = crc_ccitt((unsigned char*)data.bytes, 2);
    LBLog(@"crc :%x",crc);
    [data appendBytes:&crc length:2];
    LBLog(@"同步运动步数指令为:%@",data);
    [self sendData:data];
}


-(void)setSyncType:(AMLBSyncType)syncType{
    _syncType = syncType;
    //当数据不再传输中时,停止超时检测
    if (syncType == AMLBSyncTypeNotWorking) {
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
    }else{
        self.time = 10;
        if (self.timer) {
            [self.timer invalidate];
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runTime) userInfo:nil repeats:YES];
    }
}


//清楚所有数据指令
-(void)orderCleanSuccess:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail{
    self.syncType = AMLBSyncTypeClean;
    self.syncSuccessBlock = success;
    self.syncFailBlock = fail;
    
    self.responseStr = [@"" mutableCopy];
    
    Byte bytes[] = {0xDB,0x03,0x00};
    NSMutableData* data = [NSMutableData dataWithBytes:bytes length:3];
    UInt16 crc = crc_ccitt((unsigned char*)data.bytes, 3);
    LBLog(@"crc :%x",crc);
    [data appendBytes:&crc length:2];
    LBLog(@"清楚数据数指令为:%@",data);
    [self sendData:data];
}

//设置工作时间
-(void)orderWorkTimeSuccess:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail{
    self.syncType = AMLBSyncTypeWorkTime;
    self.syncSuccessBlock = success;
    self.syncFailBlock = fail;
    
    self.responseStr = [@"" mutableCopy];
    
    Byte bytes[] = {0xDB,0x04,0x03,0x30};
    NSMutableData* data = [NSMutableData dataWithBytes:bytes length:4];
    UInt16 crc = crc_ccitt((unsigned char*)data.bytes, 4);
    LBLog(@"crc :%x",crc);
    [data appendBytes:&crc length:2];
    LBLog(@"设置工作时间指令为:%@",data);
    [self sendData:data];
}

//设置工作时间5分钟
-(void)orderTestWorkTimeSuccess:(void (^)(NSObject* anyObj))success fail:(void(^)(NSString* errorStr))fail{
    self.syncType = AMLBSyncTypeWorkTime;
    self.syncSuccessBlock = success;
    self.syncFailBlock = fail;
    
    self.responseStr = [@"" mutableCopy];
    
    Byte bytes[] = {0xDB,0x04,0x03,0x05};
    NSMutableData* data = [NSMutableData dataWithBytes:bytes length:4];
    UInt16 crc = crc_ccitt((unsigned char*)data.bytes, 4);
    LBLog(@"crc :%x",crc);
    [data appendBytes:&crc length:2];
    LBLog(@"设置工作时间指令为:%@",data);
    [self sendData:data];
}

//进入休眠模式
-(void)orderSleep{
    self.syncType = AMLBSyncTypeNotWorking;
    self.responseStr = [@"" mutableCopy];
    
    Byte bytes[] = {0xD9,0x02};
    NSMutableData* data = [NSMutableData dataWithBytes:bytes length:2];
    UInt16 crc = crc_ccitt((unsigned char*)data.bytes, 2);
    LBLog(@"crc :%x",crc);
    [data appendBytes:&crc length:2];
    LBLog(@"设置休眠:%@",data);
    [self sendData:data];
}


-(void)runTime{
    self.time --;
    LBLog(@"超时剩余:%d",(int)self.time);
    if (self.time <=0) {
        //超时了
        [self handleData:nil andErrorStr:@"手表超时或app没有响应蓝牙手表的数据"];
    }
}


#pragma mark  ----收到数据后的处理-------
-(void)handleData:(NSData*)data andErrorStr:(NSString*)errorStr{
    LBLog(@"syncData:%@ error:%@",data,errorStr);
    
    //超时没有收到回包
    if (errorStr) {
        self.syncType = AMLBSyncTypeNotWorking;
        NSLog(@"超时了");
        self.syncFailBlock(errorStr);
        return;
    }
    
    self.time = 10;
    
    if (!data) {
        return;
    }
    
    Byte* bytes = (Byte*)data.bytes;
    
    //指令出现错误
    if (bytes[0] ==0xFE) {
        self.syncType = AMLBSyncTypeNotWorking;
        if (bytes[1] == 0x01) {
            self.syncFailBlock(@"指令不存在");
            NSLog(@"sync 不存在");
            
        }else if (bytes[1] == 0x02){
            self.syncFailBlock(@"crc16错误");
            NSLog(@"sync crc16错误");
            
        }else if (bytes[1] == 0x03){
            self.syncFailBlock(@"data错误");
            NSLog(@"sync data错误 %@",self.peripheral.name);
            
        }else if (bytes[1] == 0x04){
            self.syncFailBlock(@"length错误");
            NSLog(@"sync length错误");
            
        }
        
        return;
    }
    
    switch (self.syncType) {
        case AMLBSyncTypeTime:
            [self handleSyncTimeData:data andErrorStr:errorStr];
            break;
            
        case AMLBSyncTypeHeartContinue:
            [self handleHeartContinueData:data andErrorStr:errorStr];
            break;
            
        case AMLBSyncTypeWalk:
            [self handleWalkData:data andErrorStr:errorStr];
            break;
            
        case AMLBSyncTypeClean:
            [self handleOrderCleanData:data andErrorStr:errorStr];
            break;
            
        case AMLBSyncTypeWorkTime:
            [self handleOrderWorkTimeData:data andErrorStr:errorStr];
            break;
            
            
        default:
            break;
    }
}


//处理时间同步的数据
-(void)handleSyncTimeData:(NSData*)data andErrorStr:(NSString*)errorStr{
    Byte* bytes = (Byte*)data.bytes;
    //收到成功回包
    if (bytes[0] == 0xFF && bytes[1] == 0x02) {
        self.syncType = AMLBSyncTypeNotWorking;
        LBLog(@"同步时间成功");
        self.syncSuccessBlock(nil);
        
    }else{
        //        self.syncType = AMLBSyncTypeNotWorking;
        //        LBLog(@"硬件返回格式出错");
        //        self.syncFailBlock(@"硬件返回格式出错");
        
    }
}


//处理连续心率数据
-(void)handleHeartContinueData:(NSData*)data andErrorStr:(NSString*)errorStr{
    Byte* bytes = (Byte*)data.bytes;
    
    if (bytes[0] == 0xE4 && (bytes[1] ==0x12 || bytes[1] == 0x0A)) {
        //保存读取到的心率数据
        [self saveHeartBytes:bytes andData:data];
        
        //请求剩余的心率数据
        Byte sendbytes[] = {0xFF,0x02};
        
        NSMutableData* sendData = [NSMutableData dataWithBytes:sendbytes length:2];
        UInt16 crc = crc_ccitt((unsigned char*)sendData.bytes, 2);
        [sendData appendBytes:&crc length:2];
        LBLog(@"继续同步心率指令为:%@",sendData);
        [self sendData:sendData];
        
    }else if (bytes[0] == 0xE4 && bytes[1] == 0x02){
#warning aimi
        //收到心率数据结束标示
        Byte sendbytes[] = {0xFF,0x02};
        
        NSMutableData* sendData = [NSMutableData dataWithBytes:sendbytes length:2];
        UInt16 crc = crc_ccitt((unsigned char*)sendData.bytes, 2);
        [sendData appendBytes:&crc length:2];
        LBLog(@"继续同步心率指令为:%@",sendData);
        [self sendData:sendData];
        
        self.syncType = AMLBSyncTypeNotWorking;
        
        LBLog(@"心率数据信息:%@",self.responseStr);
        if (self.heartData.length >1) {
            [self.heartData replaceBytesInRange:NSMakeRange([self.heartData length]-1, 1) withBytes:NULL length:0];
        }
        
        self.syncSuccessBlock(self.heartData);
        
        
    }else{
        //        self.syncType = AMLBSyncTypeNotWorking;
        //        LBLog(@"硬件返回格式出错");
        //        self.syncFailBlock(@"硬件返回格式出错");
    }
}




//处理运动步数数据
-(void)handleWalkData:(NSData*)data andErrorStr:(NSString*)errorStr{
    Byte* bytes = (Byte*)data.bytes;
    if (bytes[0] == 0xEF && (bytes[1] ==0x0C)) {
        //保存读取到的计步数据
        [self saveWalkBytes:bytes andData:data];
        
        //请求剩余的计步数据
        Byte sendbytes[] = {0xFF,0x02};
        
        NSMutableData* sendData = [NSMutableData dataWithBytes:sendbytes length:2];
        UInt16 crc = crc_ccitt((unsigned char*)sendData.bytes, 2);
        [sendData appendBytes:&crc length:2];
        LBLog(@"继续同步步数指令为:%@",sendData);
        [self sendData:sendData];
        
    }else if (bytes[0] == 0xEF && bytes[1] == 0x02){
#warning aimi
        //收到计步数据结束标示
        Byte sendbytes[] = {0xFF,0x02};
        
        NSMutableData* sendData = [NSMutableData dataWithBytes:sendbytes length:2];
        UInt16 crc = crc_ccitt((unsigned char*)sendData.bytes, 2);
        [sendData appendBytes:&crc length:2];
        LBLog(@"继续同步步数指令为:%@",sendData);
        [self sendData:sendData];
        
        self.syncType = AMLBSyncTypeNotWorking;
        LBLog(@"计步数据信息:%@",self.responseStr);
        if (self.walkData.length>1) {
            
            [self.walkData replaceBytesInRange:NSMakeRange([self.walkData length]-1, 1) withBytes:NULL length:0];
        }
        self.syncSuccessBlock(self.walkData);
        
    }else{
        //        self.syncType = AMLBSyncTypeNotWorking;
        //        LBLog(@"硬件返回格式出错");
        //        self.syncFailBlock(@"硬件返回格式出错");
    }
}



//处理清楚数据的回复
-(void)handleOrderCleanData:(NSData*)data andErrorStr:(NSString*)errorStr{
    Byte* bytes = (Byte*)data.bytes;
    //收到成功回包
    if (bytes[0] == 0xFF && bytes[1] == 0x02) {
        self.syncType = AMLBSyncTypeNotWorking;
        LBLog(@"清除数据成功");
        self.syncSuccessBlock(nil);
        
    }else{
        //        self.syncType = AMLBSyncTypeNotWorking;
        //        LBLog(@"硬件返回格式出错");
        //        self.syncFailBlock(@"硬件返回格式出错");
        
    }
}

//处理设置工作时间
-(void)handleOrderWorkTimeData:(NSData*)data andErrorStr:(NSString*)errorStr{
    Byte* bytes = (Byte*)data.bytes;
    //收到成功回包
    if (bytes[0] == 0xFF && bytes[1] == 0x02) {
        self.syncType = AMLBSyncTypeNotWorking;
        LBLog(@"设置工作时间成功");
        self.syncSuccessBlock(nil);
        
    }else{
        //        self.syncType = AMLBSyncTypeNotWorking;
        //        LBLog(@"硬件返回格式出错");
        //        self.syncFailBlock(@"硬件返回格式出错");
        
    }
}


//解析心率的bytes
-(void)saveHeartBytes:(Byte*)bytes andData:(NSData*)data{
    
    if (data.length >= 14) {
        //2条心率数据
        
        
        Byte timeBty[] = {bytes[3],bytes[4],bytes[5],bytes[6]};
        Byte heartBty[] = {bytes[7]};
        
        
        
        NSData* timedata = [NSData dataWithBytes:timeBty length:4];
        NSData* heartData = [NSData dataWithBytes:heartBty length:1];
        
        
        
        int i ;
        [timedata getBytes:&i length:4];
        
        int j;
        [heartData getBytes:&j length:1];
        
        NSDate* date2000 = [self transStringToDate:@"2000-01-01 00:00:00" withformotStr:@"yyyy-MM-dd HH:mm:ss"];
        NSDate* date = [NSDate dateWithTimeInterval:i sinceDate:date2000];
        NSString* timeStr = [self transDateToString:date withformotStr:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString* heartStr = [NSString stringWithFormat:@"%d",heartBty[0]];
        
        
        [self.responseStr appendString:timeStr];
        [self.responseStr appendString:@"="];
        [self.responseStr appendString:heartStr];
        [self.responseStr appendString:@"\n"];
        
        
        NSMutableString* progressStr = [NSMutableString string];
        [progressStr appendString:timeStr];
        [progressStr appendString:@"="];
        [progressStr appendString:heartStr];
        
        self.syncProgressBlock(progressStr);
        
        [self.heartData appendData:timedata];
        [self.heartData appendData:heartData];
        Byte f4[] = {0xF4};
        [self.heartData appendBytes:f4 length:1];
        
        
        Byte timeBty2[] = {bytes[11],bytes[12],bytes[13],bytes[14]};
        Byte heartBty2[] = {bytes[15]};
        
        NSData* timedata2 = [NSData dataWithBytes:timeBty2 length:4];
        NSData* heartData2 = [NSData dataWithBytes:heartBty2 length:1];
        
        int a ;
        [timedata2 getBytes:&a length:4];
        
        int b;
        [heartData2 getBytes:&b length:1];
        
        NSDate* date2 = [NSDate dateWithTimeInterval:a sinceDate:date2000];
        NSString* timeStr2 = [self transDateToString:date2 withformotStr:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString* heartStr2 = [NSString stringWithFormat:@"%d",heartBty2[0]];
        
        
        [self.responseStr appendString:timeStr2];
        [self.responseStr appendString:@"="];
        [self.responseStr appendString:heartStr2];
        [self.responseStr appendString:@"\n"];
        
        
        NSMutableString* progressStr2 = [NSMutableString string];
        [progressStr2 appendString:timeStr2];
        [progressStr2 appendString:@"="];
        [progressStr2 appendString:heartStr2];
        self.syncProgressBlock(progressStr2);
        
        [self.heartData appendData:timedata2];
        [self.heartData appendData:heartData2];
        [self.heartData appendBytes:f4 length:1];
        
        //        NSLog(@"%@",self.responseStr);
    }else{
        //1条心率数据
        NSMutableString* progressStr = [NSMutableString string];
        
        Byte timeBty[] = {bytes[3],bytes[4],bytes[5],bytes[6]};
        Byte heartBty[] = {bytes[7]};
        
        NSData* timedata = [NSData dataWithBytes:timeBty length:4];
        NSData* heartData = [NSData dataWithBytes:heartBty length:1];
        
        int i ;
        [timedata getBytes:&i length:4];
        
        int j;
        [heartData getBytes:&j length:1];
        
        NSDate* date2000 = [self transStringToDate:@"2000-01-01 00:00:00" withformotStr:@"yyyy-MM-dd HH:mm:ss"];
        NSDate* date = [NSDate dateWithTimeInterval:i sinceDate:date2000];
        NSString* timeStr = [self transDateToString:date withformotStr:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString* heartStr = [NSString stringWithFormat:@"%d",heartBty[0]];
        
        
        [self.responseStr appendString:timeStr];
        [self.responseStr appendString:@"="];
        [self.responseStr appendString:heartStr];
        [self.responseStr appendString:@"\n"];
        
        [progressStr appendString:timeStr];
        [progressStr appendString:@"="];
        [progressStr appendString:heartStr];
        self.syncProgressBlock(progressStr);
        
        [self.heartData appendData:timedata];
        [self.heartData appendData:heartData];
        Byte f4[] = {0xF4};
        [self.heartData appendBytes:f4 length:1];
        
        //        NSLog(@"%@",self.responseStr);
    }
}



//解析步数
-(void)saveWalkBytes:(Byte*)bytes andData:(NSData*)data{
    NSMutableString* progressStr = [NSMutableString string];
    
    
    Byte timeBty[] = {bytes[3],bytes[4],bytes[5],bytes[6]};
    Byte walkBty[] = {bytes[7],bytes[8],bytes[9],0x00};
    
    
    NSData* timedata = [NSData dataWithBytes:timeBty length:4];
    NSData* walkData = [NSData dataWithBytes:walkBty length:4];
    
    
    int i ;
    [timedata getBytes:&i length:4];
    
    int j;
    [walkData getBytes:&j length:4];
    
//    LBLog(@"walkData:%@   j:%d",walkData,j);
    
    NSDate* date2000 = [self transStringToDate:@"2000-01-01 00:00:00" withformotStr:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date = [NSDate dateWithTimeInterval:i sinceDate:date2000];
    NSString* timeStr = [self transDateToString:date withformotStr:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString* walkStr = [NSString stringWithFormat:@"%d",j];
    
    [self.responseStr appendString:timeStr];
    [self.responseStr appendString:@"="];
    [self.responseStr appendString:walkStr];
    [self.responseStr appendString:@"\n"];
    
    [progressStr appendString:timeStr];
    [progressStr appendString:@"="];
    [progressStr appendString:walkStr];
    
    LBLog(@"收到的步数解析为:%@", progressStr);
    self.syncProgressBlock(progressStr);
    
    
    
    [self.walkData appendData:timedata];
    [self.walkData appendData:walkData];
    Byte f4[] = {0xF4};
    [self.walkData appendBytes:f4 length:1];
    
    
    //        NSLog(@"%@",self.responseStr);
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


//获取日期是周几
-(NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"06", @"00", @"01", @"02", @"03", @"04", @"05", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}


//日期转化
-(NSString *)getDataWithFormat:(NSString *)formotStr{
    //@"EEE MMM dd HH:mm:ss ZZZ yyyy"
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formotStr];
    NSString * dateString = [format stringFromDate:[NSDate date]];
    return dateString;
}


-(NSString *)transDateToString:(NSDate *)date withformotStr:(NSString *)formotStr{
    //@"EEE MMM dd HH:mm:ss ZZZ yyyy"
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formotStr];
    NSString * dateString = [format stringFromDate:date];
    return dateString;
}

-(NSDate*)transStringToDate:(NSString *)str withformotStr:(NSString *)formotStr{
    //@"EEE MMM dd HH:mm:ss ZZZ yyyy"
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formotStr];
    NSDate * date = [format dateFromString:str];
    return date;
}



@end
