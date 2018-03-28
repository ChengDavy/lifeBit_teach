//
//  NSTimer+Expand.h
//  PersonalLibrary
//
//  Created by Caesar on 16/1/26.
//  Copyright © 2016年 Caesar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Expand)



/**
 *  开启全局正计时器(计时内不可开启新的)
 *
 *  @param seconds 计时秒数
 *  @param timing  值变更回调(当前剩余, 是否归零)
 */
+ (void)ibGlobalPositiveTimekeeping:(BOOL (^)(NSInteger totalSeconds, NSString * fomatString))timing;


/**
 *  开启全局倒计时器(计时内不可开启新的)
 *
 *  @param seconds 计时秒数
 *  @param timing  值变更回调(当前剩余, 是否归零)
 */
+ (void)ibGlobalInvertedTimekeeping:(int)seconds timing:(void (^)(int value, BOOL isArriving))timing;


/**
 *  开启局部倒计时器(同时开启多个)
 *
 *  @param seconds 计时秒数
 *  @param timing  值变更回调(当前剩余, 是否归零)
 */
+ (void)ibLocalInvertedTimekeeping:(int)seconds timing:(void (^)(int value, BOOL isArriving))timing;


/**
 *  开启全局心跳
 *
 *  @param frequency 心跳频率
 *  @param heartbeat 心跳回调(频率)
 */
+ (void)ibGlobalHeartbeatWithFrequency:(int)frequency heartbeat:(void (^)(int frequency))heartbeat;


/**
 *  关闭全局心跳
 */
+ (void)ibGlobalHeartbeatCancel;




@end
