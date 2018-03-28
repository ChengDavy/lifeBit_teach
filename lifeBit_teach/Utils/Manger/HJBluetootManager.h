//
//  HJBluetootManager.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/5.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMLifeBitBlueTools.h"
#import "LBWatchPerModel.h"

@interface HJBluetootManager : NSObject
+(instancetype)shareInstance;
@property(nonatomic,strong)AMLifeBitBlueTools* blueTools;
@property(nonatomic)LBWatchPerModel* connectingWatch;

// 同步完成
@property (nonatomic,assign)BOOL asyncDone;

// 开始搜索
-(void)stepBlueStateChangeBlock;

// 设置同步班级
-(void)syncAssignClassAllWatch:(HJClassInfo*)classInfo;

-(void)syncAllWatch;

-(void)stopScanWatch;

// 置回Watch的所有状态
-(void)buyBackAllSyncWatchStatus;

#pragma --mark-- 重新搜索手表
- (void)refreshScanAllWatch;

-(void)registerBlueToothManager;

@end
