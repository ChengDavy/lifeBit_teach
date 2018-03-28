//
//  HJLessonPlanPhaseInfo.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/4.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "BaseModel.h"
#import "HJLessonPlanUnitInfo.h"

@interface HJLessonPlanPhaseInfo : BaseModel
/*
 *阶段ID
 */
@property (nonatomic,strong)NSString *pId;

/*
 *阶段标题
 */
@property (nonatomic,strong)NSString *pTitle;
/*
 *单元数组
 */
@property (nonatomic,strong)NSMutableArray *pUnitArr;

/*
 *阶段总时间
 */
@property (nonatomic,strong)NSString *pPhaseTime;
@end
