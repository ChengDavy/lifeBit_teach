//
//  JRCusTeaPlanBtnCell.h
//  lifeBit_teach
//
//  Created by joyskim-ios1 on 16/9/7.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JRCusTeaPlanBtnCell : UITableViewCell



#pragma --mark-- 点击加号出发的block
@property (nonatomic,strong)void (^blockClickLessonPlanUnit)(JRCusTeaPlanBtnCell *selfCell);
-(void)setBlockClickLessonPlanUnit:(void (^)(JRCusTeaPlanBtnCell *selfCell))blockClickLessonPlanUnit;

-(void)efUpdateSelfUi:(HJLessonPlanPhaseInfo*)phaseInfo;
@end
