//
//  APPIdentificationManage.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/11.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPIdentificationManage : NSObject
+(instancetype)shareInstance;
#pragma mark 获取UUID

/**
 
 *此uuid在相同的一个程序里面-相同的vindor-相同的设备下是不会改变的
 *此uuid是唯一的，但应用删除再重新安装后会变化，采取的措施是：只获取一次保存在钥匙串中，之后就从钥匙串中获取
 
 **/

- (NSString *)openUDID;
#pragma mark 保存UUID到钥匙串
- (void)saveUDID:(NSString *)udid;
#pragma mark 读取UUID

/**
 *先从内存中获取uuid，如果没有再从钥匙串中获取，如果还没有就生成一个新的uuid，并保存到钥匙串中供以后使用
 **/

- (id)readUDID;
#pragma mark 删除UUID

- (void)deleteUUID;
@end
