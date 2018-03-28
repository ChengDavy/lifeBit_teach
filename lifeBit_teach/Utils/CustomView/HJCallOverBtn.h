//
//  HJCallOverBtn.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/8.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJStudentInfo.h"
typedef NS_ENUM(NSInteger, HJCallOverStatusType){
    HJCallOverStatusTypeNone,    // 未点名
    HJCallOverStatusTypeSelect    // 点名
};
@interface HJCallOverBtn : UIButton

@property (nonatomic,strong)HJStudentInfo *studentInfo;

-(void)updateBtnUi:(HJStudentInfo*)studentInfo;

@property (nonatomic,assign)HJCallOverStatusType callOverBtnStatus;

// 更新按钮的状态
-(void)updateSelfStatus:(HJCallOverStatusType)callOverBtnStatus;

@end
