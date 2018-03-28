//
//  Tools.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/4.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#ifndef Tools_h
#define Tools_h






typedef NS_ENUM(NSInteger, LBSetType) {
    LBSetTypeSet,   // 设置教案
    LBSetTypeReplace, // 更换
    LBSetTypeReference, // 首页引用教案
};
typedef NS_ENUM(NSInteger,JRSynHeartSoureType) {
    JRSynHeartSoureTypePerson,  // 从个人中心进入同步界面
    JRSynHeartSoureTypeClass // 从上课进入同步页面
};
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeitht [UIScreen mainScreen].bounds.size.height
//颜色获取
#define UIColorFromRGB(rgbValue)                             [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorWithAlphaFromRGB(rgbValue,alpha)              [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alpha]

#define UITonalityColor [UIColor colorWithRed:((float)49.0/255.0 green:((float)142.0/255.0 blue:((float)255.0)/255.0 alpha:1.0]

#pragma --mark-- 通知名
#define KNotification_Network @"Notification_Network"
#define KEnter_Class @"Enter_Class"
#define KDefaultPassword @"888888"
#define KAddNewWatchNotification @"addNewWatchNotification"



// 判断系统的版本
#define kISIOS7DOWN ([[UIDevice currentDevice].systemVersion floatValue] < 7.0)
#define kISIOS7ANDUP ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
#define kISIOS8AndUP ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
#define kISIOS9AndUP ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)
#define kISIOS10AndUP ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)

#endif /* Tools_h */
