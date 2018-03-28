//
//  LBLessonPlanUnitCell.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/5/12.
//  Copyright © 2016年 joyskim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJLessonPlanUnitInfo.h"

@interface JRAddPlanCell : UITableViewCell
-(void)efUpdateSelfUi:(HJLessonPlanUnitInfo*)unitInfo;

@property (nonatomic,strong)void (^selectUnitBlock)(JRAddPlanCell* selfCell);
-(void)setSelectUnitBlock:(void (^)(JRAddPlanCell *selfCell))selectUnitBlock;

-(void)selectUniClick;
-(void)exitSelectUnitClick;
@end
