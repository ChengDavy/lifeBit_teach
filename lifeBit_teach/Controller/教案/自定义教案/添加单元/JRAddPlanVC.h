//
//  JRAddPlanVC.h
//  lifeBit_teach
//
//  Created by joyskim-ios1 on 16/9/7.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJBaseVC.h"

@interface JRAddPlanVC : HJBaseVC

@property (nonatomic,strong)NSString *phares;
//已选择需要添加的要领
@property (strong ,nonatomic) NSMutableArray* selectYaoLingArr;


@property (nonatomic,strong)void (^arrWitnArrSelectBlock)(NSMutableArray* array);
-(void)setArrWitnArrSelectBlock:(void (^)(NSMutableArray* array))arrWitnArrSelectBlock;

@end
