//
//  HJGreadInfo.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/22.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJGreadInfo.h"
@implementation HJSubClassInfo
-(void)setAttributes:(NSDictionary *)attributes{
    self.sClassID = [NSString stringAwayFromNSNULL:[attributes objectForKey:@"CLASS_ID"]];
    self.sClassName = [NSString stringAwayFromNSNULL:[attributes objectForKey:@"NAME"]];
    self.sMax_Rate = [NSString stringAwayFromNSNULL:[attributes objectForKey:@"MAX_RATE"]];
    self.sMin_Rate = [NSString stringAwayFromNSNULL:[attributes objectForKey:@"MIN_RATE"]];
}
@end
@implementation HJGreadInfo

-(void)setAttributes:(NSDictionary *)attributes{
    self.gGreadID = [NSString stringAwayFromNSNULL:[attributes objectForKey:@"GRADE"]];
    self.gGreadName = [NSString stringAwayFromNSNULL:[attributes objectForKey:@"GRADE_NAME"]];
    self.gClassArr = [NSMutableArray array];
    NSArray *classArr = [attributes objectForKey:@"CLAZZS"];
    for (NSDictionary *classDic in classArr) {
        HJSubClassInfo *subClassInfo = [[HJSubClassInfo alloc] init];
        [subClassInfo setAttributes:classDic];
        [self.gClassArr addObject:subClassInfo];
    }
}

@end
