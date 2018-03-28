//
//  HJGreadInfo.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/22.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "BaseModel.h"
//
@interface HJSubClassInfo :BaseModel
/*
 * 班级ID
 */
@property (nonatomic,strong)NSString *sClassID;
/*
 * 班级名称
 */
@property (nonatomic,strong)NSString *sClassName;
/*
 * 最大心率
 */
@property (nonatomic,strong)NSString *sMax_Rate;
/*
 * 最小心率
 */
@property (nonatomic,strong)NSString *sMin_Rate;
@end

@interface HJGreadInfo : BaseModel
/*
 * 年级ID
 */
@property (nonatomic,strong)NSString *gGreadID;
/*
 * 年级名称
 */
@property (nonatomic,strong)NSString *gGreadName;
/*
 * 年级对应的班级数组[HJSubClassInfo]
 */
@property (nonatomic,strong)NSMutableArray *gClassArr;
@end


