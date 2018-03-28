//
//  UIViewController+AMNoticeAlertView.h
//  AMToolsDemo
//
//  Created by Aimi on 15/9/1.
//  Copyright (c) 2015年 Aimi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMNoticeAlertView.h"

@interface UIViewController (AMNoticeAlertView)
@property (weak, nonatomic) AMNoticeAlertView *noticeAlert;
@property(nonatomic,strong)NSNumber* noticeAnimationAutoEnd;
@property(nonatomic,strong)NSNumber* noticeAnimationCount;


//show 成功提示
-(void)showSuccessAlertWithTitleStr:(NSString*)titleStr;

//成功操作后返回上级界面
-(void)showSuccessAlertAndPopVCWithTitleStr:(NSString*)titleStr;

//show 错误提示
-(void)showErroAlertWithTitleStr:(NSString*)titleStr;


//show 网络请求
-(void)showNetWorkAlertWithTitleStr:(NSString*)titleStr;

//show 网络请求时禁用navigationbar
-(void)showNetWorkAlertAndCannotPopWithTitleStr:(NSString*)titleStr;

//无提示的结束网络请求
-(void)endNetWorkAlertWithNoMessage;


//将网络请求菊花更改为成功提示
-(void)changeNetToSuccessWithTitleStr:(NSString*)titleStr;

//将网络请求菊花更改为出错提示
-(void)changeNetToErrorWithTitleStr:(NSString*)titleStr;

//将网络请求菊花更改为成功提示 并pop界面
-(void)changeNetToSuccessAndPopVCWithTitleStr:(NSString*)titleStr;



#pragma mark  -----版本------

//  version 1.0.4 updata in 15/10/26 （by Aimi）
/*
 1.网络请求较快时 不增加转圈
 */


//  version 1.0.3 updata in 15/9/25 （by Aimi）
/*
 1.修正了多界面同时加载数据时的切换问题
 2.将loading框至于view层
 3.增加了网络请求时 禁用navigationbar的方法
 4.去除了需要在basecontroller里写代码的傻逼规定
 */


//  version 1.0.2 updata in 15/9/10 （by Aimi）
/*
 1.增加changeNetWork方法 网络请求之后的失败后的错误提示 请使用changeNetWorkToError方法
 避免页面返回后 菊花消失 但仍会弹出超时提示的bug
 */


//  version 1.0.1 updata in 15/9/10 （by Aimi）
/*
    1.修正了notieceAlert部分情况不释放问题
    2.修正了网络加载中退出应用后再返回 菊花不动的问题
    3.更改了 basecontroller 中 viewWillDisAppear 中需要的代码块
 */

@end
