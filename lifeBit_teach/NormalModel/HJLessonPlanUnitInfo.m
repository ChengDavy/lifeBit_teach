//
//  HJLessonPlanUnitInfo.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/4.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJLessonPlanUnitInfo.h"

@implementation HJLessonPlanUnitInfo
-(void)setAttributes:(NSDictionary *)attributes{
    self.uUnitId = [NSString stringWithFormat:@"%@",[attributes objectForKey:@"unitId"]];
    self.uUnitTitle = [NSString stringWithFormat:@"%@",[attributes objectForKey:@"name"]];
    
    self.uUnitDetails = [NSString stringWithFormat:@"%@",[NSString stringAwayFromNSNULL:[attributes objectForKey:@"content"]]];
    int timeInt = [[NSString stringWithFormat:@"%@",[NSString stringAwayFromNSNULL:[attributes objectForKey:@"minutes"]]] intValue];
    if (timeInt <= 0) {
        self.uUnitTime = @"0";
    }else{
        self.uUnitTime = [NSString stringWithFormat:@"%d",timeInt];
    }
}


-(void)setLessonPlanAttributes:(NSDictionary *)attributes{
    self.uUnitId = [NSString stringWithFormat:@"%@",[NSString stringAwayFromNSNULL:[attributes objectForKey:@"unitId"]]];
    self.uUnitTitle = [NSString stringWithFormat:@"%@",[NSString stringAwayFromNSNULL:[attributes objectForKey:@"unitName"]]];
    self.uUnitDetails = [NSString stringWithFormat:@"%@",[NSString stringAwayFromNSNULL:[attributes objectForKey:@"unitContetnt"]]];
    int timeInt = [[NSString stringWithFormat:@"%@",[NSString stringAwayFromNSNULL:[attributes objectForKey:@"unitMinutes"]]] intValue];
    if (timeInt <= 0) {
        self.uUnitTime = @"0";
    }else{
        self.uUnitTime = [NSString stringWithFormat:@"%d",timeInt];
    }
    
}

-(NSString *)uUnitTime{
    if (_uUnitTime == nil) {
        return @"0";
    }
    return _uUnitTime;
}
@end
