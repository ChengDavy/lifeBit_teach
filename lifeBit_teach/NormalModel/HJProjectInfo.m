//
//  HJProjectInfo.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/22.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJProjectInfo.h"
@implementation HJSubProjectInfo
-(void)setAttributes:(NSDictionary *)attributes{
    self.sId = [attributes objectForKey:@"id"];
    self.sName = [attributes objectForKey:@"name"];
}
@end
@implementation HJProjectInfo
-(void)setAttributes:(NSDictionary *)attributes{
    self.pProjectID = [NSString stringAwayFromNSNULL:[attributes objectForKey:@"PROJECT_ID"]];
    self.pProjectName = [NSString stringAwayFromNSNULL:[attributes objectForKey:@"PROJECT_NAME"]];
    self.pProjectType = [NSString stringAwayFromNSNULL:[attributes objectForKey:@"DATA_TYPE"]];
    self.pScoreGood = [NSString stringAwayFromNSNULL:[attributes objectForKey:@"GOOD"]];
    self.pScorePass = [NSString stringAwayFromNSNULL:[attributes objectForKey:@"PASS"]];
    self.pScoreNoPass = [NSString stringAwayFromNSNULL:[attributes objectForKey:@"NO_PASS"]];
    self.pProjectRemark = [NSString stringAwayFromNSNULL:[attributes objectForKey:@"REMARK"]];
    self.pProjectUnit = [NSString stringAwayFromNSNULL:[attributes objectForKey:@"UNIT"]];
}


-(void)setModelAttributes:(NSDictionary *)attributes{
    self.pProjectID =[NSString stringWithFormat:@"%@",[attributes objectForKey:@"id"]];
    self.pProjectName =[NSString stringWithFormat:@"%@",[attributes objectForKey:@"name"]];
    self.pSubProjectArr = [[NSMutableArray alloc] init];
    NSArray *childrenArr =[attributes objectForKey:@"children"];
    for (NSDictionary *projectSubDic in childrenArr) {
        HJSubProjectInfo *projectSubInfo = [[HJSubProjectInfo alloc] init];
        [projectSubInfo setAttributes:projectSubDic];
        [self.pSubProjectArr addObject:projectSubInfo];
    }
}


+(HJProjectInfo*)converHistoryTestFromProject:(HistoryTestModel*)historyTestModel{
    HJProjectInfo *projectInfo = [[HJProjectInfo alloc] init];
    projectInfo.pProjectClassId = historyTestModel.classId;
    projectInfo.pProjectClass = historyTestModel.classname;
    projectInfo.pProjectGradeId = historyTestModel.greadId;
    projectInfo.pProjectGrade = historyTestModel.greadName;
    projectInfo.pProjectName = historyTestModel.projectName;
    projectInfo.pProjectID = historyTestModel.projectId;
    projectInfo.pProjectUnit = historyTestModel.projectUnit;
    projectInfo.pProjectType = historyTestModel.data_type;
    projectInfo.pScoreGood =historyTestModel.remark;
    projectInfo.pScoreGood = historyTestModel.good;
    projectInfo.pScorePass = historyTestModel.pass;
    projectInfo.pScoreNoPass = historyTestModel.no_pass;
    historyTestModel.startDate = [NSDate date];
    historyTestModel.teacherId = [HJUserManager shareInstance].user.uTeacherId;
    return projectInfo;
}


@end
