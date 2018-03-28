//
//  HJBluetootManager.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/5.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJBluetootManager.h"


#define LBLog(fmt, ...) NSLog((@"LBLog: "fmt), ##__VA_ARGS__);


static HJBluetootManager *_bluetootManager = nil;
@interface HJBluetootManager()


@property(nonatomic,strong)NSMutableArray* waitingConnectArray;

@property(nonatomic)BOOL isAutoSync;

// 同步班级
@property (nonatomic,strong) HJClassInfo *asynClassInfo;



// 同步完成的周边
@property (nonatomic,strong)CBPeripheral *syncSuccess;

@end
@implementation HJBluetootManager


-(void)registerBlueToothManager {
    
    _bluetootManager.waitingConnectArray = [NSMutableArray array];
    _bluetootManager.blueTools = [AMLifeBitBlueTools instance];
    _bluetootManager.isAutoSync = NO;
    //配置蓝牙状态更改回调
    [_bluetootManager stepBlueStateChangeBlock];
    
    //配置蓝牙设备断连回调
    [_bluetootManager stepBlueDisConnectBlock];
    [self addObserver:self forKeyPath:@"waitingConnectArray" options:NSKeyValueObservingOptionNew context:nil];

}


+(instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _bluetootManager = [[HJBluetootManager alloc] init];
        _bluetootManager.asyncDone = NO;
    });
    return _bluetootManager;
}

+(void)destroyInstance {
    
    if (_bluetootManager) {
        _bluetootManager = nil;
    }
}



//当前没有连接中的设备时,自动检测等待队列
-(void)setConnectingWatch:(LBWatchPerModel *)connectingWatch {
    
    if (connectingWatch) {
        _connectingWatch = connectingWatch;
    } else {
        
        _connectingWatch = nil;
//        [self performSelector:@selector(syncWatchInWaitingQueue) withObject:nil afterDelay:0];
    }
}



#pragma --mark-- 同步指定班级所有手表进入连续心率模式
// 设置同步班级
-(void)syncAssignClassAllWatch:(HJClassInfo*)classInfo {
    
    self.asynClassInfo = classInfo;
    [self syncAllWatch];
}


#pragma --mark--  配置蓝牙状态更变的回调
//配置蓝牙状态更变的回调
-(void)stepBlueStateChangeBlock{
    __weak HJBluetootManager* blockSelf = self;
    [self.blueTools setDidUpdateStateBlock:^(CBCentralManager *centralManager) {
//        NSLog(@"状态改变回调了");
        
        switch (centralManager.state) {
                
            case CBCentralManagerStateUnknown: NSLog( @"蓝牙初始化中...");
                break;
            case CBCentralManagerStateResetting: NSLog(@"Resetting...");
                break;
            case CBCentralManagerStateUnsupported: NSLog(@"您的设备不支持蓝牙");
                break;
            case CBCentralManagerStateUnauthorized: NSLog(@"您的设备蓝牙未授权");
                break;
            case CBCentralManagerStatePoweredOff: NSLog(@"您的设备未打开蓝牙,请打开蓝牙");
                break;
            case CBCentralManagerStatePoweredOn: {
                NSLog(@"搜索...");
                if (blockSelf.blueTools.scanWatchArray.count) {
                    blockSelf.isAutoSync = NO;
                    NSLog(@"蓝牙瞬断了");
                    
                    UIAlertView* alert =  [[UIAlertView alloc]initWithTitle:nil message:@"设备蓝牙刚才断开了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    
                    for (LBWatchPerModel* watch in blockSelf.blueTools.scanWatchArray) {
                        if (watch.type != LBWatchTypeDone && watch.type !=LBWatchTypeUnConnected) {
                            watch.type = LBWatchTypeDisConnected;
                            blockSelf.waitingConnectArray = nil;
                            blockSelf.connectingWatch = nil;
                        }
                    }
                    [blockSelf.blueTools.scanWatchArray removeAllObjects];
                    return ;
                }
                //开始扫描
                
                if (!blockSelf.waitingConnectArray) {
                    blockSelf.waitingConnectArray = [@[] mutableCopy];
                }
                
                [blockSelf.blueTools startScanWithResultBlock:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
                    
                    if (peripheral.name && [peripheral.name hasPrefix:@"SmartAM"]) {
                        
                        if ([[LifeBitCoreDataManager shareInstance] efGetBoxIsWatch:[[peripheral.name componentsSeparatedByString:@"-"] objectAtIndex:1]]) {
                            
                            LBWatchPerModel* watch =[LBWatchPerModel watchPerWithPeripheral:peripheral];
                            
                            CBPeripheral * tempPeripheral = nil;
                            for (LBWatchPerModel * watch in blockSelf.blueTools.scanWatchArray) {
                                if ([watch.peripheral.name isEqualToString:peripheral.name]) {
                                    tempPeripheral = peripheral;
                                    break;
                                }
                            }
                            
                            if (!tempPeripheral) {
                                [blockSelf.blueTools.scanWatchArray addObject:watch];
                                LBLog(@"////////////////////////////// Scan Count: %ld", blockSelf.blueTools.scanWatchArray.count);
                                NSDictionary *userInfo = @{ @"addWatch": watch };
                                [[NSNotificationCenter defaultCenter] postNotificationName:KAddNewWatchNotification object:nil userInfo:userInfo];
                                
//                                if (![blockSelf.waitingConnectArray containsObject:watch]) {
//                                    [blockSelf.waitingConnectArray addObject:watch];
//                                    NSLog(@"*************** Waiting Count: %ld", blockSelf.waitingConnectArray.count);
//                                }
                            }
                        }
                    }

                }];
                break;
            }
        }
    }];
}


//配置蓝牙断连回调
-(void)stepBlueDisConnectBlock{
    
    __weak HJBluetootManager* blockSelf = self;
    [self.blueTools setDisconnectPeripheralBlock:^(CBCentralManager *central, LBWatchPerModel * watch) {
        
        if (watch.type != LBWatchTypeDone) {
            
            NSLog(@"异常断开连接%@",watch.peripheral.name);
            watch.type = LBWatchTypeDisConnected;
    
            //连接时断开
            if (watch == blockSelf.connectingWatch) {
//                NSLog(@"连接时异常导致断开%@",watch.peripheral.name);
                watch.type = LBWatchTypeDisConnected;
                blockSelf.connectingWatch = nil;
            }
            
            ///   caesar edit
            if ([self.waitingConnectArray count]) {
                
                LBWatchPerModel * watch = [self.waitingConnectArray firstObject];
                
                if (watch) {
                    [self toConnectWithWatch:watch];
                }
            }
            ///   caesar edit
            
        } else {
            NSLog(@"%@: 断开成功",watch.peripheral.name);
        }
        if (blockSelf.isAutoSync) {
            [blockSelf syncAllWatch];
        }
    }];
}


//同步所有手表


//------------------------------------- Test watch began

-(void)syncAllWatch {
    
    self.waitingConnectArray = self.blueTools.scanWatchArray;
    
    if (self.waitingConnectArray.count) {
        [self toConnectWithWatch:[self.waitingConnectArray firstObject]];
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath 
                      ofObject:(id)object 
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change 
                       context:(void *)context {
    
    if ([keyPath isEqualToString:@"waitingConnectArray"]) {
        
        if ([self.waitingConnectArray count]) {
            
            LBWatchPerModel * watch = [self.waitingConnectArray firstObject];
            
            if (watch) {
                [self toConnectWithWatch:watch];
            }
            
        } else {
            self.asyncDone = YES;
            LBLog(@"当前所有设备已全部同步完成");
        }
    }
}

    
- (void)toConnectWithWatch:(LBWatchPerModel *)watchModel {
    
    NSLog(@"---------------------------------------TotalCount: %ld,  conntct: %ld", self.waitingConnectArray.count, [self.waitingConnectArray indexOfObject:watchModel]);

    
    __weak HJBluetootManager* blockSelf = self;
    
    [self.blueTools connectWatch:watchModel andSuccess:^(CBPeripheral *peripheral) {
       
        LBLog(@"%@: 连接成功",watchModel.peripheral.name);
        watchModel.type = LBWatchTypeConnected;
        [blockSelf toSyncTimeWithWatch:watchModel];

        
    } andFail:^(NSString * errorStr) {
        
        LBLog(@"%@: 连接失败, 重操作",watchModel.peripheral.name);
        [self toConnectWithWatch:watchModel];
    }];
}


// 开始上课时不再清除手表数据（暂不用）
-(void)toCleanWatch:(LBWatchPerModel *)watchModel {
    
    __weak HJBluetootManager * blockSelf = self;
    
    [watchModel orderCleanSuccess:^(NSObject *anyObj) {
        
        LBLog(@"%@: 清理成功",watchModel.peripheral.name);
        [blockSelf toSyncTimeWithWatch:watchModel];
        
    } fail:^(NSString *errorStr) {
        
        LBLog(@"%@: 清理失败, 重操作",watchModel.peripheral.name);
        [blockSelf toCleanWatch:watchModel];
    }];
}



-(void)toSyncTimeWithWatch:(LBWatchPerModel *)watchModel {
    
    __weak HJBluetootManager* blockSelf = self;
    
    [watchModel syncTimeWithSuccess:^(NSObject *anyObj) {
        
        LBLog(@"%@: 时间成功",watchModel.peripheral.name);
        [blockSelf toSetWorkTimeWithWatch:watchModel];
        
    } fail:^(NSString *errorStr) {
        
        LBLog(@"%@: 时间失败, 重操作",watchModel.peripheral.name);
        [self toSyncTimeWithWatch:watchModel];
        
    }];
}


//设置工作时间
-(void)toSetWorkTimeWithWatch:(LBWatchPerModel *)watchModel {
    
    __weak HJBluetootManager* blockSelf = self;
    
    NSString * classTime = [NSString stringWithFormat:@"%d",[self.asynClassInfo.cClassTime intValue] + 5];
    
    [watchModel orderWorkTime:classTime Success:^(NSObject *anyObj) {
        
        LBLog(@"%@: 工时成功",watchModel.peripheral.name);
        [blockSelf toStartContinuousHeartRate:watchModel];
        
    } fail:^(NSString *errorStr) {
        
        LBLog(@"%@: 工时失败, 重操作",watchModel.peripheral.name);
        [self toSetWorkTimeWithWatch:watchModel];
        
    }];
}
    

//开始连续心率
-(void)toStartContinuousHeartRate:(LBWatchPerModel *)watchModel {
    
    __weak HJBluetootManager* blockSelf = self;
    
    [watchModel orderHeartContinue:^(NSObject *anyObj) {
        
        LBLog(@"%@: 模式成功",watchModel.peripheral.name);
        watchModel.type = LBWatchTypeDone;
        watchModel.syncType = AMLBSyncTypeNotWorking;
        self.syncSuccess = watchModel.peripheral;
        
        [blockSelf.blueTools cancelPeripheralConnection:watchModel.peripheral];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([self.waitingConnectArray count]) {
                [[self mutableArrayValueForKey:@"waitingConnectArray"] removeObjectAtIndex:0];
            }
        });
        
        
    } fail:^(NSString *errorStr) {
        
        LBLog(@"%@: 模式失败, 重操作",watchModel.peripheral.name);
        [self toStartContinuousHeartRate:watchModel];
    }];
}




//------------------------------------- Test watch end


//同步某一个设备
-(void)syncWatch:(LBWatchPerModel*)watch{
    
    if (watch.type!= LBWatchTypeWait && !watch.isConnected) {
        
        watch.type = LBWatchTypeWait;
    
        
        NSLog(@"将%@加入等待连接列表",watch.peripheral.name);
        
        if (![self.waitingConnectArray containsObject:watch] && self.connectingWatch!= watch) {
            [self.waitingConnectArray addObject:watch];
        }
    }
    //当前正有设备在连接中
    if (self.connectingWatch) {
        
    }else{
        [self syncWatchInWaitingQueue];
    }
}


//同步等待队列中的手表
-(void)syncWatchInWaitingQueue{
    NSLog(@"准备连接等待队列中的设备");
    
    if (!self.waitingConnectArray.count) {
        NSLog(@"没有设备在等待队列中");
        return;
    }
    LBWatchPerModel* watch = self.waitingConnectArray[0];
    //进行设备的连接
    if (watch.type == LBWatchTypeDisConnected) {
        NSLog(@"准备重连%@",watch.peripheral.name);
        [self performSelector:@selector(prepareConnectWatch:) withObject:watch afterDelay:0];
    }else{
        [self prepareConnectWatch:watch];
    }
}



-(void)prepareConnectWatch:(LBWatchPerModel*)watch {
    
    __weak HJBluetootManager *weakSelf = self;
    weakSelf.connectingWatch = watch;
    [weakSelf.waitingConnectArray removeObject:watch];
    
    NSLog(@"正在连接%@",watch.peripheral.name);
    
    watch.type = LBWatchTypeConnecting;
    
    // 延迟2秒执行：
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // code to be executed on the main queue after delay
        [weakSelf connectWatch:watch];
    });
}

-(void)connectWatch:(LBWatchPerModel*)watch {
    
    __weak HJBluetootManager* blockSelf = self;
    [self.blueTools connectWatch:watch andSuccess:^(CBPeripheral *peripheral) {
        NSLog(@"连接成功%@",watch.peripheral.name);
        blockSelf.connectingWatch = nil;
        watch.type = LBWatchTypeConnected;
        [blockSelf syncTimeWithWatch:watch];
        
    } andFail:^(NSString * errorStr) {
        NSLog(@"连接失败%@",watch.peripheral.name);
        blockSelf.connectingWatch = nil;
         watch.type = LBWatchTypeDisConnected;
        
        [blockSelf.blueTools cancelPeripheralConnection:watch.peripheral];
    }];
}


//同步时间
-(void)syncTimeWithWatch:(LBWatchPerModel*)watch {
    __weak HJBluetootManager* blockSelf = self;
    [watch syncTimeWithSuccess:^(NSObject *anyObj) {
         [blockSelf orderWorkTimeWithWatch:watch];
    } fail:^(NSString *errorStr) {
        watch.type = LBWatchTypeDisConnected;
     
        [blockSelf.blueTools cancelPeripheralConnection:watch.peripheral];
    }];
}


//设置工作时间
-(void)orderWorkTimeWithWatch:(LBWatchPerModel*)watch{
    __weak HJBluetootManager* blockSelf = self;
    NSString * classTime = [NSString stringWithFormat:@"%d",[self.asynClassInfo.cClassTime intValue] + 5];
    [watch orderWorkTime:classTime Success:^(NSObject *anyObj) {
        NSLog(@"------------\n 设置工作时间成功---------\n");
        
         [blockSelf goContinuousHeartRate:watch];
        
    } fail:^(NSString *errorStr) {
        watch.type = LBWatchTypeDisConnected;
        [blockSelf.blueTools cancelPeripheralConnection:watch.peripheral];
    }];
}


//开始连续心率
-(void)goContinuousHeartRate:(LBWatchPerModel*)watch{
    __weak HJBluetootManager* blockSelf = self;

    [watch orderHeartContinue:^(NSObject *anyObj) {
        
        [blockSelf syncDoneWithWatch:watch];
        
    } fail:^(NSString *errorStr) {
        
        
    }];
}



//同步数据完成
-(void)syncDoneWithWatch:(LBWatchPerModel*)watch{
    watch.type = LBWatchTypeDone;
    watch.syncType = AMLBSyncTypeNotWorking;
    self.syncSuccess = watch.peripheral;
    [self.blueTools cancelPeripheralConnection:watch.peripheral];
//    [self orderSleepWithWatch:watch];
}


//进入休眠
-(void)orderSleepWithWatch:(LBWatchPerModel*)watch{
    [watch orderSleep];
}



//停止搜索
-(void)stopScanWatch{
    [self.blueTools.scanWatchArray removeAllObjects];
    [self.blueTools  cancelAllBluePeripheral];
    [self.waitingConnectArray removeAllObjects];
    [self.blueTools stopScan];
}



#pragma --mark--
-(void)buyBackAllSyncWatchStatus{
    for (LBWatchPerModel*watchModel in self.blueTools.scanWatchArray) {
        watchModel.type = LBWatchTypeUnConnected;
        watchModel.syncType = AMLBSyncTypeNotWorking;
    }
}



#pragma --mark-- 重新搜索手表
- (void)refreshScanAllWatch {
    self.isAutoSync = NO;
    [self.waitingConnectArray removeAllObjects];
    self.asynClassInfo =  nil;
    self.connectingWatch = nil;

    [self.blueTools stopScan];
    [self.blueTools cancelAllBluePeripheral];
    self.blueTools = [AMLifeBitBlueTools instance];
    [self.blueTools registerBlueToothManager];
    [self stepBlueStateChangeBlock];
    [self stepBlueDisConnectBlock];
}



@end



