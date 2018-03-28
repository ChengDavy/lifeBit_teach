//
//  AQAppObject.h
//  AQSDK
//
//  Created by 严伟强 on 15/3/27.
//  Copyright (c) 2015年 AQiang. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface HJAppObject : NSObject
//初始化单例
+(HJAppObject*)sharedInstance;
+(void)cleanObject;
-(void)storeCode:(NSString *)code andValue:(NSString*)valueStr;

@property (nonatomic,strong) NSString* testIndexStr;

-(NSString *)getCode:(NSString*)key;

// 判断是否登录
-(BOOL)aQIsLogin;
#pragma mark - 常用方法







#pragma mark - 自定义属性
@property (strong, nonatomic) UIColor *tintColor;

#pragma mark - 自定义方法
// 获取自定义项目列表
-(NSMutableArray*)getProjectList;
// 获取学校年级班级信息
-(NSMutableArray*)getSchoolAllGreadMsg;
// 获取所有教案类型
-(NSMutableArray*)getAllLessonPlanType;

@end

