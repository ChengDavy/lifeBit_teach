//
//  Singleton.h
//  lifeBit_teach
//
//  Created by 介岳西 on 2017/5/23.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject

@property (nonatomic, assign) BOOL isSynchronization;  /// 数据同步中（手表 到 ipad）
@property (nonatomic, assign) BOOL isUploading;        /// 数据上传中（ipad 到 服务器）

+ (Singleton *)sharedInstance;

@end
