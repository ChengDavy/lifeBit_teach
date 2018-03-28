//
//  UIViewController+AMNoticeAlertView.m
//  AMToolsDemo
//
//  Created by Aimi on 15/9/1.
//  Copyright (c) 2015年 Aimi. All rights reserved.
//

#import "UIViewController+AMNoticeAlertView.h"
#import <objc/runtime.h>

@interface UIViewController()


@end;

@implementation UIViewController (AMNoticeAlertView)

static char AMNoticeAlertKey;

-(void)setNoticeAlert:(AMNoticeAlertView *)noticeAlert{
    [self willChangeValueForKey:@"AMNoticeAlertKey"];
    objc_setAssociatedObject(self, &AMNoticeAlertKey,
                             noticeAlert,
                             OBJC_ASSOCIATION_ASSIGN);
    
    [self didChangeValueForKey:@"AMNoticeAlertKey"];

}

-(AMNoticeAlertView *)noticeAlert{
    return objc_getAssociatedObject(self, &AMNoticeAlertKey);

}

static char AMNoticeAnimationEndKey;
-(void)setNoticeAnimationAutoEnd:(NSNumber *)noticeAnimationAutoEnd{
    [self willChangeValueForKey:@"AMNoticeAnimationEndKey"];
    objc_setAssociatedObject(self, &AMNoticeAnimationEndKey,
                             noticeAnimationAutoEnd,
                             OBJC_ASSOCIATION_ASSIGN);
    
    [self didChangeValueForKey:@"AMNoticeAnimationEndKey"];

}

-(NSNumber *)noticeAnimationAutoEnd{
    return objc_getAssociatedObject(self, &AMNoticeAnimationEndKey);

}

static char AMNoticeAnimationCountKey;

-(void)setNoticeAnimationCount:(NSNumber *)noticeAnimationCount{
    [self willChangeValueForKey:@"AMNoticeAnimationCountKey"];
    objc_setAssociatedObject(self, &AMNoticeAnimationCountKey,
                             noticeAnimationCount,
                             OBJC_ASSOCIATION_ASSIGN);
    
    [self didChangeValueForKey:@"AMNoticeAnimationEndKey"];
    
}

-(NSNumber *)noticeAnimationCount{
    return objc_getAssociatedObject(self, &AMNoticeAnimationCountKey);
    
}



#pragma mark ------正式代码------

//成功提示
-(void)showSuccessAlertWithTitleStr:(NSString *)titleStr{
    NSNumber* autoEnd = [NSNumber numberWithBool:NO];
    self.noticeAnimationAutoEnd = autoEnd;
    if (!self.noticeAlert) {
        AMNoticeAlertView* noticeAlert = [AMNoticeAlertView noticeAlertWithType:AMNoticeAlertTypeSuccess andTitleStr:titleStr];
        CGFloat offSet  = 0.0f;
            if (!self.extendedLayoutIncludesOpaqueBars) {
                offSet = 64;
            }
        UIWindow* window = [UIApplication sharedApplication].windows[0];
        noticeAlert.center = CGPointMake(window.center.x, window.center.y - offSet);
        [[UIApplication sharedApplication].windows[0] addSubview:noticeAlert];
        
        [UIView animateWithDuration:.3 delay:1.5 options:0 animations:^{
            noticeAlert.transform = CGAffineTransformMakeScale(.2, .2);
            noticeAlert.alpha = 0;
        } completion:^(BOOL finished) {
            NSInteger count = [self.noticeAnimationCount integerValue];
            if (!count) {
                [noticeAlert removeFromSuperview];
            }
        }];
    }else{
        [self changeNetToSuccessWithTitleStr:titleStr];
    }
}


//出错提示
-(void)showErroAlertWithTitleStr:(NSString *)titleStr{
    NSNumber* autoEnd = [NSNumber numberWithBool:NO];
    self.noticeAnimationAutoEnd = autoEnd;
    
    if (!self.noticeAlert) {
        AMNoticeAlertView* noticeAlert = [AMNoticeAlertView noticeAlertWithType:AMNoticeAlertTypeError andTitleStr:titleStr];
        CGFloat offSet  = 0.0f;
            if (!self.extendedLayoutIncludesOpaqueBars) {
                offSet = 64;
            }
        UIWindow* window = [UIApplication sharedApplication].windows[0];
        noticeAlert.center = CGPointMake(window.center.x, window.center.y - offSet);
        [[UIApplication sharedApplication].windows[0] addSubview:noticeAlert];
        
        [UIView animateWithDuration:.3 delay:2 options:0 animations:^{
            noticeAlert.transform = CGAffineTransformMakeScale(.2, .2);
            noticeAlert.alpha = 0;
        } completion:^(BOOL finished) {
            NSInteger count = [self.noticeAnimationCount integerValue];
            if (!count) {
                [noticeAlert removeFromSuperview];

            }
        }];
    }else{
        [self changeNetToErrorWithTitleStr:titleStr];
    }
}


//网络请求菊花
-(void)showNetWorkAlertWithTitleStr:(NSString*)titleStr{
    NSLog(@"showNetWorkAlertWithTitleStr  currentThread=%@",[NSThread currentThread]);
    //先判断菊花的引用计数器是否有值 没有则创建菊花  有则引用计数器+1
    if (self.noticeAnimationCount) {
        NSInteger count = [self.noticeAnimationCount integerValue];
        if (!count) {
           [self performSelector:@selector(addNetWorkAlertWithTitleStr:) withObject:titleStr afterDelay:0.5];
            self.view.userInteractionEnabled = NO;
        }
        
        //创建菊花时 设置需要自动消失
        NSNumber* autoEnd = [NSNumber numberWithBool:YES];
        self.noticeAnimationAutoEnd = autoEnd;
        
        count++;
        self.noticeAnimationCount = @(count);
    }else{
       [self performSelector:@selector(addNetWorkAlertWithTitleStr:) withObject:titleStr afterDelay:0];
    
        self.view.userInteractionEnabled = NO;

        
        //创建菊花时 设置需要自动消失
        NSNumber* autoEnd = [NSNumber numberWithBool:YES];
        self.noticeAnimationAutoEnd = autoEnd;
        self.noticeAnimationCount = @(1);
    }
}



-(void)showNetWorkAlertAndCannotPopWithTitleStr:(NSString*)titleStr{
    //先判断菊花的引用计数器是否有值 没有则创建菊花  有则引用计数器+1
    if (self.noticeAnimationCount) {
        NSInteger count = [self.noticeAnimationCount integerValue];
        if (!count) {
           [self performSelector:@selector(addNetWorkAlertWithTitleStr:) withObject:titleStr afterDelay:.0];
            self.view.userInteractionEnabled = NO;
            if (self.navigationController) {
                self.navigationController.navigationBar.userInteractionEnabled = NO;
            }
        }
        
        //创建菊花时 设置需要自动消失
        NSNumber* autoEnd = [NSNumber numberWithBool:YES];
        self.noticeAnimationAutoEnd = autoEnd;
        
        count++;
        self.noticeAnimationCount = @(count);
    }else{
        [self performSelector:@selector(addNetWorkAlertWithTitleStr:) withObject:titleStr afterDelay:.0];
        
        self.view.userInteractionEnabled = NO;
        if (self.navigationController) {
            self.navigationController.navigationBar.userInteractionEnabled = NO;
        }

        
        //创建菊花时 设置需要自动消失
        NSNumber* autoEnd = [NSNumber numberWithBool:YES];
        self.noticeAnimationAutoEnd = autoEnd;
        self.noticeAnimationCount = @(1);
    }
}


-(void)addNetWorkAlertWithTitleStr:(NSString *)titleStr{
    NSInteger count = [self.noticeAnimationCount integerValue];
    if (count) {
        AMNoticeAlertView* noticeAlert = [AMNoticeAlertView noticeAlertWithType:AMNoticeAlertTypeNetWork andTitleStr:titleStr];
        CGFloat offSet  = 0.0f;
        if (!self.extendedLayoutIncludesOpaqueBars) {
            offSet = 64;
        }
        UIWindow* window = [UIApplication sharedApplication].windows[0];
        noticeAlert.center = CGPointMake(window.center.x, window.center.y - offSet);
        
        [self.view addSubview:noticeAlert];
        self.noticeAlert = noticeAlert;
    }
}





//将网络请求菊花更改为成功提示
-(void)changeNetToSuccessWithTitleStr:(NSString*)titleStr{
    if (!self.noticeAlert) {
        return;
    }

    //将菊花的引用计数器清空
//    NSInteger count = [self.noticeAnimationCount integerValue];
    NSInteger  count = 0;
    self.noticeAnimationCount = @(count);
    
    int runCount = (self.noticeAlert.animationTime+.05)/1.3;
//    NSLog(@"已运行时间  %.2f   已运行次数: %d",self.noticeAlert.animationTime,runCount);
    NSTimeInterval delayTime = (runCount+1)*1.3 - self.noticeAlert.animationTime;
    if (delayTime > 1.25) {
        delayTime = 0;
    }else{
        delayTime -= 0.1;
    }
    
    [self.noticeAlert changeNetAnimationToSuccessAnimationWithTitleStr:titleStr WithDelayTime:delayTime];
    
    [UIView animateWithDuration:.3 delay:1.7+delayTime options:0 animations:^{
        self.noticeAlert.transform = CGAffineTransformMakeScale(.2, .2);
        self.noticeAlert.alpha = 0;
    } completion:^(BOOL finished) {
        NSInteger count = [self.noticeAnimationCount integerValue];
        if (!count) {
            [self.noticeAlert removeFromSuperview];
            self.noticeAlert = nil;
            self.view.userInteractionEnabled = YES;
            if (self.navigationController) {
                self.navigationController.navigationBar.userInteractionEnabled = YES;
            }
        }
    }];
}


//将网络请求菊花更改为出错提示
-(void)changeNetToErrorWithTitleStr:(NSString*)titleStr{
    
    if (!self.noticeAlert) {
        return;
    }
     //将菊花的引用计数器清空
//    NSInteger count = [self.noticeAnimationCount integerValue];
    NSInteger count = 0;
    self.noticeAnimationCount = @(count);
    
    int runCount = (self.noticeAlert.animationTime+.05)/1.3;
    NSTimeInterval delayTime = (runCount+1)*1.3 - self.noticeAlert.animationTime;
    if (delayTime > 1.25) {
        delayTime = 0;
    }else{
        delayTime -= 0.1;
    }
    
     [self.noticeAlert changeNetAnimationToErrorAnimationWithTitleStr:titleStr WithDelayTime:delayTime];
    
    [UIView animateWithDuration:.3 delay:1.7+delayTime options:0 animations:^{
        self.noticeAlert.transform = CGAffineTransformMakeScale(.2, .2);
        self.noticeAlert.alpha = 0;
    } completion:^(BOOL finished) {
        NSInteger count = [self.noticeAnimationCount integerValue];
        if (!count) {
            [self.noticeAlert removeFromSuperview];
            self.noticeAlert = nil;
            self.view.userInteractionEnabled = YES;
            if (self.navigationController) {
                self.navigationController.navigationBar.userInteractionEnabled = YES;
            }
        }
    }];
    
}

//网络结束后必须调用代码段
-(void)endNetWorkAlertWithNoMessage{
    NSInteger count = [self.noticeAnimationCount integerValue];
    //若引用计数器有值 才进行计数器--  若计数器为0 则销毁菊花
    if (count>0) {
        count -- ;
        self.noticeAnimationCount = @(count);
        if (!count) {
            self.view.userInteractionEnabled = YES;
            [self twoEndNetWorkAlertWithNoMessage];
        }
    }
    
    
}

-(void)twoEndNetWorkAlertWithNoMessage{
    BOOL autoEnd = [self.noticeAnimationAutoEnd boolValue];
    if (autoEnd && !self.noticeAnimationCount.integerValue) {
        AMNoticeAlertView* noticeAlert = self.noticeAlert;
        if (autoEnd&& noticeAlert) {
            [UIView animateWithDuration:.3 delay:.5 options:0 animations:^{
                self.noticeAlert.transform = CGAffineTransformMakeScale(.2, .2);
                self.noticeAlert.alpha = 0;
            } completion:^(BOOL finished) {
                NSInteger count = [self.noticeAnimationCount integerValue];
                if (!count) {
                    [self.noticeAlert endNetAnimationWithNoMessage];
                    [self.noticeAlert removeFromSuperview];
                    self.view.userInteractionEnabled = YES;
                    if (self.navigationController) {
                        self.navigationController.navigationBar.userInteractionEnabled = YES;
                    }
                    self.noticeAlert = nil;
                }
            }];
        }
    }
    
}


-(void)showSuccessAlertAndPopVCWithTitleStr:(NSString *)titleStr{
    NSNumber* autoEnd = [NSNumber numberWithBool:NO];
    self.noticeAnimationAutoEnd = autoEnd;
    if (!self.noticeAlert) {
        AMNoticeAlertView* noticeAlert = [AMNoticeAlertView noticeAlertWithType:AMNoticeAlertTypeSuccess andTitleStr:titleStr];
        CGFloat offSet  = 0.0f;
            if (!self.extendedLayoutIncludesOpaqueBars) {
                offSet = 64;
            }
        UIWindow* window = [UIApplication sharedApplication].windows[0];
        noticeAlert.center = CGPointMake(window.center.x, window.center.y - offSet);
        
        [[UIApplication sharedApplication].windows[0] addSubview:noticeAlert];
        
        if (self.navigationController) {
            self.navigationController.navigationBar.userInteractionEnabled = NO;
            [self performSelector:@selector(popVC) withObject:nil afterDelay:.8];
            
        }
        
        [UIView animateWithDuration:.3 delay:1.5 options:0 animations:^{
            noticeAlert.transform = CGAffineTransformMakeScale(.2, .2);
            noticeAlert.alpha = 0;
        } completion:^(BOOL finished) {
            NSInteger count = [self.noticeAnimationCount integerValue];
            if (!count) {
                [noticeAlert removeFromSuperview];
            }
        }];
    }else{
        [self changeNetToSuccessAndPopVCWithTitleStr:titleStr];
    }
}


-(void)changeNetToSuccessAndPopVCWithTitleStr:(NSString*)titleStr{
    if (!self.noticeAlert) {
        return;
    }
    
    //将菊花的引用计数器清空
//    NSInteger count = [self.noticeAnimationCount integerValue];
    NSInteger count = 0;
    self.noticeAnimationCount = @(count);
    
    int runCount = (self.noticeAlert.animationTime+.05)/1.3;
    //    NSLog(@"已运行时间  %.2f   已运行次数: %d",self.noticeAlert.animationTime,runCount);
    NSTimeInterval delayTime = (runCount+1)*1.3 - self.noticeAlert.animationTime;
    if (delayTime > 1.25) {
        delayTime = 0;
    }else{
        delayTime -= 0.1;
    }
    
    [self.noticeAlert changeNetAnimationToSuccessAnimationWithTitleStr:titleStr WithDelayTime:delayTime];
    
    if (self.navigationController) {
        self.navigationController.navigationBar.userInteractionEnabled = NO;
        [self performSelector:@selector(popVC) withObject:nil afterDelay:delayTime+1.2];
    }
    
    [UIView animateWithDuration:.3 delay:1.7+delayTime options:0 animations:^{
        self.noticeAlert.transform = CGAffineTransformMakeScale(.2, .2);
        self.noticeAlert.alpha = 0;
    } completion:^(BOOL finished) {
        NSInteger count = [self.noticeAnimationCount integerValue];
        if (!count) {
            [self.noticeAlert removeFromSuperview];
            self.noticeAlert = nil;
            self.view.userInteractionEnabled = YES;
            if (self.navigationController) {
                self.navigationController.navigationBar.userInteractionEnabled = YES;
            }
        }
    }];
}

-(void)popVC{
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    [self.navigationController popViewControllerAnimated:YES];

}



@end
