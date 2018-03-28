//
//  HJLessonPlanUnitInfo.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/4.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "BaseModel.h"

@interface HJLessonPlanUnitInfo : BaseModel
/*
 *单元ID
 */
@property (nonatomic,strong)NSString *uUnitId;

/*
 *单元标题
 */
@property (nonatomic,strong)NSString *uUnitTitle;


/*
 *单元详情
 */
@property (nonatomic,strong)NSString *uUnitDetails;

/*
 *单元运动时间
 */
@property (nonatomic,strong)NSString *uUnitTime;

/*
 *适用年级
 */
@property (nonatomic,strong)NSString *uUnitClass;

-(void)setLessonPlanAttributes:(NSDictionary *)attributes;
@end
