//
//  HJLessonPlanPhaseInfo.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/4.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJLessonPlanPhaseInfo.h"

@implementation HJLessonPlanPhaseInfo
-(void)setAttributes:(NSDictionary *)attributes{
    self.pId = [NSString stringAwayFromNSNULL:[NSString stringWithFormat:@"%@",[attributes objectForKey:@"status"]]];
    switch ([self.pId intValue]) {
        case 0:
            self.pTitle = @"准备阶段";
            break;
        case 1:
            self.pTitle = @"开始阶段";
            break;
        case 2:
            self.pTitle = @"基本阶段";
            break;
        case 3:
            self.pTitle = @"结束阶段";
            break;
            
        default:
            break;
    }
    
    self.pUnitArr = [NSMutableArray array];
    int pharseTime = 0;
    NSArray *unitArr = [attributes objectForKey:@"unit"];
    if (unitArr.count > 0) {
        for (NSDictionary *unitDic in unitArr) {
            HJLessonPlanUnitInfo *unitInfo = [[HJLessonPlanUnitInfo alloc] init];
            pharseTime += [[NSString stringAwayFromNSNULL:[unitDic objectForKey:@"unitMinutes"]] intValue];
            [unitInfo setLessonPlanAttributes:unitDic];
            [self.pUnitArr addObject:unitInfo];
        }
    }
    
    self.pPhaseTime = [NSString stringAwayFromNSNULL:[NSString stringWithFormat:@"%d",pharseTime]];
    
}

-(NSString *)pPhaseTime{
    if (_pPhaseTime == nil) {
        _pPhaseTime = @"0";
    }
    return _pPhaseTime;
}
@end
