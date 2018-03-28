//
//  NSTimer+Expand.m
//  PersonalLibrary
//
//  Created by Caesar on 16/1/26.
//  Copyright © 2016年 Caesar. All rights reserved.
//

#import "NSTimer+Expand.h"

static BOOL isRunningPositiveTimekeeping = NO;
static BOOL isRunningInvertedTimekeeping = NO;
static BOOL isRunningHeartbeat  = NO;

@implementation NSTimer (Expand)


/**
 *  开启全局正计时器(计时内不可开启新的)
 *
 *  @param seconds 计时秒数
 *  @param timing  值变更回调(当前剩余, 是否归零)
 */
+ (void)ibGlobalPositiveTimekeeping:(BOOL (^)(NSInteger totalSeconds, NSString * fomatString))timing {
    
    if (isRunningPositiveTimekeeping) {
        return;
    }
    isRunningPositiveTimekeeping = YES;
    __block NSInteger timekeepingSeconds = 0;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        timekeepingSeconds++;
        
        NSString * formatStr = [self timeformatFromSeconds:timekeepingSeconds];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            BOOL isContinue = timing(timekeepingSeconds, formatStr);
            
            if (!isContinue) {
                dispatch_source_cancel(_timer);
                isRunningPositiveTimekeeping = NO;
            }
        });        
    });
    dispatch_resume(_timer);
}




/**
 *  开启全局倒计时器(计时内不可开启新的)
 *
 *  @param seconds 计时秒数
 *  @param timing  值变更回调(当前剩余, 是否归零)
 */
+ (void)ibGlobalInvertedTimekeeping:(int)seconds 
                             timing:(void (^)(int value, BOOL isArriving))timing {
    
    if (isRunningInvertedTimekeeping) {
        return;
    }
    isRunningInvertedTimekeeping = YES;
    __block int timekeepingSeconds = seconds + 1;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        timekeepingSeconds--;
        
        if (timekeepingSeconds <= 0) {
            dispatch_source_cancel(_timer);
            isRunningInvertedTimekeeping = NO;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (timing) {
                    timing(timekeepingSeconds, !isRunningInvertedTimekeeping);
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{                
                if (timing) {
                    timing(timekeepingSeconds, !isRunningInvertedTimekeeping);
                }
            });
        }
    });
    dispatch_resume(_timer);
}







/**
 *  开启局部倒计时器(同时开启多个)
 *
 *  @param seconds 计时秒数
 *  @param timing  值变更回调(当前剩余, 是否归零)
 */
+ (void)ibLocalInvertedTimekeeping:(int)seconds
                            timing:(void (^)(int value, BOOL isArriving))timing {
    
    __block int timekeepingSeconds = seconds + 1;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        timekeepingSeconds--;
        
        if (timekeepingSeconds <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (timing) {
                    timing(timekeepingSeconds, YES);
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (timing) {
                    timing(timekeepingSeconds, NO);
                }
            });
        }
    });
    dispatch_resume(_timer);
}



/**
 *  开启全局心跳
 *
 *  @param frequency 心跳频率
 *  @param heartbeat 心跳回调(频率)
 */
+ (void)ibGlobalHeartbeatWithFrequency:(int)frequency
                            heartbeat:(void (^)(int frequency))heartbeat { 
    
    if (isRunningHeartbeat) {
        return;
    };
    isRunningHeartbeat = YES;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), frequency * NSEC_PER_SEC, 0); 
    dispatch_source_set_event_handler(_timer, ^{
        
        if (isRunningHeartbeat) {
            if (heartbeat) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    heartbeat(frequency);
                });
            }
        } else {
            dispatch_source_cancel(_timer);
        }
    });
    dispatch_resume(_timer);
}



/**
 *  关闭全局心跳
 */
+ (void)ibGlobalHeartbeatCancel {
    
    isRunningHeartbeat = NO;
}



#pragma mark - 
+(NSString*)timeformatFromSeconds:(NSInteger)seconds {
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02d", (int)(seconds / 3600)];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02d",(int)((seconds % 3600) / 60)];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02d", (int)(seconds % 60)];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@", str_hour, str_minute, str_second];
    return format_time;
}



@end
