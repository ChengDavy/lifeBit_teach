//
//  AudioPlayerManage.h
//  Mixc
//
//  Created by 陈双龙 on 13-1-16.
//  Copyright (c) 2013年 Donson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayerManager : NSObject <AVAudioPlayerDelegate>
{
    AVAudioPlayer *_audioPlayer;
}

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;


+ (AudioPlayerManager*)shareInstance;
+ (void)destroyInstance;

- (void)player:(NSString*) filename;

/*
 *@abstract 循环播放音频文件
 */
- (void)repeatPlay:(NSString *)filename;

- (void)stop;

/*
 *@abstract 播放系统声音
  @discusssion
 #if TARGET_OS_IPHONE
   kSystemSoundID_Vibrate              = 0x00000FFF   //震动
   #else
   kSystemSoundID_UserPreferredAlert   = 0x00001000,
  kSystemSoundID_FlashScreen           = 0x00000FFE,
  // this has been renamed to be consistent
   kUserPreferredAlert     = kSystemSoundID_UserPreferredAlert
    endif
 */
-(void)playSystemSoundWithSystemoSoundId:(SystemSoundID)systemSoudId;

//震动
-(void)playVibrate;
@end
