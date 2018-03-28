//
//  JRNameButten.h
//  lifeBit_teach
//
//  Created by joyskim-ios1 on 16/9/8.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJClassInfo.h"
typedef NS_ENUM(NSInteger, JRClsssStatusType){
    
    JRClsssStatusTypeUndefined,    // 未设置教案1
    JRClsssStatusTypeReady,    // 准备上课2
    JRClsssStatusTypeNamedClasses,    // 点名状态3
    JRClsssStatusTypeInClass,    // 上课中4
    JRClsssStatusTypeNone,    // 没有课0
};

@interface JRNameButten : UIButton

// 班级
@property (nonatomic,strong)NSString *classStr;
// 年级
@property (nonatomic,strong)NSString *greadStr;

// 按钮状态
@property (nonatomic,assign)JRClsssStatusType classStatusType;

@property (nonatomic,strong)HJClassInfo *classDataInfo;

-(void)alertClassMessageWithClassName:(HJClassInfo*)classInfo  andClassType:(JRClsssStatusType)type;

@end
