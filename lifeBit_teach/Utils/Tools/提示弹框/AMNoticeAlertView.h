//
//  AMNoticeAlertView.h
//  AMToolsDemo
//
//  Created by Aimi on 15/8/31.
//  Copyright (c) 2015年 Aimi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AMNoticeAlertType) {
    AMNoticeAlertTypeSuccess =1,
    AMNoticeAlertTypeError = 2,
    AMNoticeAlertTypeNetWork = 3
};

#define kTitleLableHeight 40

@interface AMNoticeAlertView : UIView

@property(nonatomic)BOOL isNeting;
@property(nonatomic,strong)NSTimer* alertTimer;
@property(nonatomic)NSTimeInterval animationTime;

//创建
+(instancetype)noticeAlertWithType:(AMNoticeAlertType)type andTitleStr:(NSString*)str;

//更改网络状态为成功
-(void)changeNetAnimationToSuccessAnimationWithTitleStr:(NSString*)titleStr WithDelayTime:(NSTimeInterval)delayTime;

//更改网络状态为出错
-(void)changeNetAnimationToErrorAnimationWithTitleStr:(NSString*)titleStr WithDelayTime:(NSTimeInterval)delayTime;

//直接隐藏网络请求
-(void)endNetAnimationWithNoMessage;

//  version 1.0.3 updata in 15/9/25 (by aimi)
//  使用UIViewController+AMNoticeAlertView 进行调用

@end
