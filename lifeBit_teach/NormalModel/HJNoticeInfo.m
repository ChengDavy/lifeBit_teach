//
//  HJNoticeInfo.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/10/19.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJNoticeInfo.h"

@implementation HJNoticeInfo
-(void)setAttributes:(NSDictionary *)attributes{
    self.nNoticeId = [NSString stringWithFormat:@"%@",[attributes objectForKey:@"ID"]];
    self.nNoticeTitle = [NSString stringWithFormat:@"%@",[attributes objectForKey:@"NAME"]];
    self.nNoticeIntroduction = [NSString stringWithFormat:@"%@",[attributes objectForKey:@"INTRODUCTION"]];
    self.nNoticeType = [NSString stringWithFormat:@"%@",[attributes objectForKey:@"TYPE"]];
    self.nNoticeURL = [NSString stringWithFormat:@"%@",[attributes objectForKey:@"URL"]];
    self.nNoticeContent = [NSString stringWithFormat:@"%@",[attributes objectForKey:@"NOTE"]];
    self.nNoticeRecMan = [NSString stringWithFormat:@"%@",[attributes objectForKey:@"REC_MAN"]];
    self.nNoticeRecDate = [NSString stringWithFormat:@"%@",[attributes objectForKey:@"REC_DATE"]];
    self.nNoticeState = [NSString stringWithFormat:@"%@",[attributes objectForKey:@"STATE"]];
    self.nNoticeTime = [NSString stringWithFormat:@"%@",[attributes objectForKey:@"PUB_DATE"]];
    self.nNoticeSchoolId = [NSString stringWithFormat:@"%@",[attributes objectForKey:@"SCHOOL_ID"]];
    
}
@end
