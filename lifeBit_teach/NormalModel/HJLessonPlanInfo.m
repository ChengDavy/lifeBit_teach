//
//  HJLessonPlanInfo.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/4.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJLessonPlanInfo.h"

@implementation HJLessonPlanInfo
-(void)setAttributes:(NSDictionary *)attributes{
    self.sId = [NSString stringAwayFromNSNULL:[attributes objectForKey:@"bookId"]];
    self.sSportTitle = [NSString stringAwayFromNSNULL:[attributes objectForKey:@"name"]];
    self.sLessonPlanSource = [NSString stringAwayFromNSNULL:[attributes objectForKey:@"resource"]];
    self.sLessonPlanShare = [NSString stringWithFormat:@"%@",[NSString stringAwayFromNSNULL:[attributes objectForKey:@"share"]]];
}


-(void)setLessonPlanAttributes:(NSDictionary*)attributes{
    self.sId = [NSString stringWithFormat:@"%@",[NSString stringAwayFromNSNULL:[attributes objectForKey:@"bookId"]]];
    self.sSportTitle = [NSString stringAwayFromNSNULL:[attributes objectForKey:@"bookName"]];
    self.sTotalTime = [NSString stringAwayFromNSNULL:[attributes objectForKey:@"bookMinutes"]];
    self.sLessonPlanShare = [NSString stringAwayFromNSNULL:[attributes objectForKey:@"shareStatus"]];
    self.sSportSkillID = [NSString stringAwayFromNSNULL:[attributes objectForKey:@"typeId"]];
//    self.sLessonPlanSource = [NSString stringWithFormat:@"%@",[NSString stringAwayFromNSNULL:[attributes objectForKey:@"resourceType"]]];
    NSArray * gradeArr = [attributes objectForKey:@"grade"];
    if ([gradeArr isKindOfClass:[NSArray class]]  ) {
        self.sSportGrades = [NSMutableArray arrayWithArray:gradeArr];
    
    
    if (gradeArr.count > 0) {
        self.sSportGrade = [NSMutableString string];
        for (NSString*gradeStr in gradeArr) {
            switch ([gradeStr intValue]) {
                case 1:
                    [self.sSportGrade appendFormat:@"%@,",@"一年级"];
                    break;
                case 2:
                    [self.sSportGrade appendFormat:@"%@,",@"二年级"];
                    break;
                case 3:
                    [self.sSportGrade appendFormat:@"%@,",@"三年级"];
                    break;
                case 4:
                    [self.sSportGrade appendFormat:@"%@,",@"四年级"];
                    break;
                case 5:
                    [self.sSportGrade appendFormat:@"%@,",@"五年级"];
                    break;
                case 6:
                    [self.sSportGrade appendFormat:@"%@,",@"六年级"];
                    break;
                case 7:
                    [self.sSportGrade appendFormat:@"%@,",@"七年级"];
                    break;
                case 8:
                    [self.sSportGrade appendFormat:@"%@,",@"八年级"];
                    break;
                case 9:
                    [self.sSportGrade appendFormat:@",%@",@"九年级"];
                    break;
                    
                default:
                    break;
            }
        }
    }
    }
    self.sPhaseArr = [NSMutableArray array];
    NSMutableArray *startArr = [NSMutableArray array];
    NSMutableArray *prepareArr = [NSMutableArray array];
    NSMutableArray *basicArr = [NSMutableArray array];
    NSMutableArray *endArr = [NSMutableArray array];
    
    
    
    NSArray *pharseArr = [attributes objectForKey:@"pharse"];
    if (![pharseArr isKindOfClass:[NSArray class]]) {
        return;
    }
    if (pharseArr.count > 0) {
        for (NSDictionary *phaseDic in pharseArr) {
            switch ([[phaseDic objectForKey:@"status"] intValue]) {
                case 0:
                {
                    [startArr addObjectsFromArray:[phaseDic objectForKey:@"unit"]];
                }
                    break;
                case 1:
                {
                    [prepareArr addObjectsFromArray:[phaseDic objectForKey:@"unit"]];
                }
                    break;
                case 2:
                {
                    [basicArr addObjectsFromArray:[phaseDic objectForKey:@"unit"]];
                }
                    break;
                case 3:
                {
                    [endArr addObjectsFromArray:[phaseDic objectForKey:@"unit"]];
                }
                    break;
                    
                default:
                    break;
            }
            
        }
        
        NSDictionary *startDic = @{@"status":@"0",@"unit":startArr};
        NSDictionary *prepareDic = @{@"status":@"1",@"unit":prepareArr};
        NSDictionary *basicDic = @{@"status":@"2",@"unit":basicArr};
        NSDictionary *endDic = @{@"status":@"3",@"unit":endArr};
        
        NSArray *tempArr = @[startDic,prepareDic,basicDic,endDic];
        
        for (NSDictionary *dic in tempArr) {
            HJLessonPlanPhaseInfo *phaseInfo = [[HJLessonPlanPhaseInfo alloc] init];
            [phaseInfo setAttributes:dic];
            [self.sPhaseArr addObject:phaseInfo];
        }
        
        
    }
}

-(void)setModelAttributes:(NSDictionary *)attributes{
    self.sId = [NSString stringAwayFromNSNULL:[attributes objectForKey:@"LESSON_ID"]];
    self.sSportTitle = [NSString stringAwayFromNSNULL:[attributes objectForKey:@"NAME"]];
    self.sLessonPlanSource = [NSString stringAwayFromNSNULL:[attributes objectForKey:@"RESOURCE_TYPE"]];
    NSString *gradeStr = [NSString stringWithFormat:@"%@",[NSString stringAwayFromNSNULL:[attributes objectForKey:@"GRADE"]]];
    NSArray *gradeArr = [gradeStr componentsSeparatedByString:@","];
    self.sSportGrades = [gradeArr mutableCopy];
}


+(HJLessonPlanInfo *)creatLessonPlanInfoWithModel:(LessonPlanModel*)lessonPlanModel{
    HJLessonPlanInfo *lessonPlanInfo = [[HJLessonPlanInfo alloc] init];
    lessonPlanInfo.sId = lessonPlanModel.lessonPlanId;
    lessonPlanInfo.sSportTitle = lessonPlanModel.lessonPlanName;
    lessonPlanInfo.sLessonPlanSource = lessonPlanModel.lessonPlanSource;
    NSString *gradeStr = [NSString stringWithFormat:@"%@",[NSString stringAwayFromNSNULL:lessonPlanModel.grade]];
    NSArray *gradeArr = [gradeStr componentsSeparatedByString:@","];
    lessonPlanInfo.sSportGrade  = [gradeArr mutableCopy];
    
    return lessonPlanInfo;
}

+(LessonPlanModel *)saveConversionLessonPlanInfoWithLessonPlanModel:(HJLessonPlanInfo*)lessonPlanInfo{
    LessonPlanModel *lessonPlanModel = [[LifeBitCoreDataManager shareInstance] efCraterLessonPlanModel];
    lessonPlanModel.grade = lessonPlanInfo.sSportGrade;
    NSMutableArray *phaseModelArr = [NSMutableArray array];
    for (HJLessonPlanPhaseInfo*phaseInfo in lessonPlanInfo.sPhaseArr) {
//        教案的项目id
        [phaseModelArr addObject:phaseInfo.pId];
        for (int i = 0; i < phaseInfo.pUnitArr.count; i++) {
            HJLessonPlanUnitInfo*unitInfo = phaseInfo.pUnitArr[i];
            LessonPlanIdUnitModel *unitModel = [[LifeBitCoreDataManager shareInstance] efCraterLessonPlanIdUnitModel];
            unitModel.unitId = unitInfo.uUnitId;
            unitModel.unitContent = unitInfo.uUnitDetails;
            unitModel.unitTime = unitInfo.uUnitTime;
            unitModel.unitName = unitInfo.uUnitTitle;
            unitModel.lessonPlanId = lessonPlanInfo.sId;
            unitModel.teachId = [HJUserManager shareInstance].user.uTeacherId;
            unitModel.lessonPlanPhase = phaseInfo.pId;
            unitModel.unitNo = [NSNumber numberWithInt:i];
            [[LifeBitCoreDataManager shareInstance] efAddLessonPlanUnitModel:unitModel];
        }
        
        
        
    }
    lessonPlanModel.lessonPlanPhase = phaseModelArr;
    lessonPlanModel.lessonPlanId = lessonPlanInfo.sId;
    lessonPlanModel.lessonPlanName = lessonPlanInfo.sSportTitle;
    lessonPlanModel.lessonPlanSource = lessonPlanInfo.sLessonPlanSource;
    lessonPlanModel.lessonPlanTime = lessonPlanInfo.sTotalTime;
    lessonPlanModel.sSportSkillID = lessonPlanInfo.sSportSkillID;
    lessonPlanModel.sSportSkill = lessonPlanInfo.sSportSkill;
    lessonPlanModel.teachId = [HJUserManager shareInstance].user.uTeacherId;
    [[LifeBitCoreDataManager shareInstance] efAddLessonPlanModel:lessonPlanModel];
    return lessonPlanModel;
}


+(HJLessonPlanInfo *)CreatLessonPlanInfoWithLessonPlanModel:(LessonPlanModel*)lessonPlanModel{
    HJLessonPlanInfo *lessonPlanInfo = [[HJLessonPlanInfo alloc] init];
    lessonPlanInfo.sId = lessonPlanModel.lessonPlanId;
    lessonPlanInfo.sSportTitle = lessonPlanModel.lessonPlanName;
    lessonPlanInfo.sTotalTime = lessonPlanModel.lessonPlanTime;;
    lessonPlanInfo.sSportSkillID = lessonPlanModel.sSportSkillID;
    lessonPlanInfo.sSportSkill = lessonPlanModel.sSportSkill;
    lessonPlanInfo.sLessonPlanSource = lessonPlanModel.lessonPlanSource;
    lessonPlanInfo.sSportGrade = [lessonPlanModel.grade mutableCopy];
    lessonPlanInfo.sPhaseArr = [NSMutableArray array];
    NSMutableArray *startArr = [NSMutableArray array];
    NSMutableArray *prepareArr = [NSMutableArray array];
    NSMutableArray *basicArr = [NSMutableArray array];
    NSMutableArray *endArr = [NSMutableArray array];
    
    
    
    NSArray *pharseArr = (NSArray*)lessonPlanModel.lessonPlanPhase;
//    if (![pharseArr isKindOfClass:[NSArray class]]) {
//        return;
//    }
    if (pharseArr.count > 0) {
        for (NSString *status in pharseArr) {
            HJLessonPlanPhaseInfo *phaseInfo = [[HJLessonPlanPhaseInfo alloc] init];
            phaseInfo.pUnitArr = [NSMutableArray array];
            switch ([phaseInfo.pId intValue]) {
                case 0:
                    phaseInfo.pTitle = @"准备阶段";
                    break;
                case 1:
                    phaseInfo.pTitle = @"开始阶段";
                    break;
                case 2:
                    phaseInfo.pTitle = @"基本阶段";
                    break;
                case 3:
                    phaseInfo.pTitle = @"结束阶段";
                    break;
                    
                default:
                    break;
            }
             phaseInfo.pId = status;
            
            switch ([status intValue]) {
                case 0:
                {
                    NSMutableArray *unitArr = [[LifeBitCoreDataManager shareInstance] efGetLessonPlanModelWithLessonPlan:lessonPlanModel.lessonPlanId withLessonPlanPhase:status];
                    int pharseTime = 0;
                    for (LessonPlanIdUnitModel *unitModel in unitArr) {
                        HJLessonPlanUnitInfo *unitInfo = [[HJLessonPlanUnitInfo alloc] init];
                        unitInfo.uUnitTime = unitModel.unitTime;
                        unitInfo.uUnitId = unitModel.unitId;
                        unitInfo.uUnitDetails = unitModel.unitContent;
                        unitInfo.uUnitTitle = unitModel.unitName;
                        pharseTime += [[NSString stringAwayFromNSNULL:unitInfo.uUnitTime] intValue];
                        [startArr addObject:unitInfo];
                    }
                    phaseInfo.pPhaseTime = [NSString stringWithFormat:@"%d",pharseTime];
                    [phaseInfo.pUnitArr addObjectsFromArray:startArr];
                    [lessonPlanInfo.sPhaseArr addObject:phaseInfo];
                    
                }
                    break;
                case 1:
                {
                    NSMutableArray *unitArr = [[LifeBitCoreDataManager shareInstance] efGetLessonPlanModelWithLessonPlan:lessonPlanModel.lessonPlanId withLessonPlanPhase:status];
                    int pharseTime = 0;
                    for (LessonPlanIdUnitModel *unitModel in unitArr) {
                        HJLessonPlanUnitInfo *unitInfo = [[HJLessonPlanUnitInfo alloc] init];
                        unitInfo.uUnitTime = unitModel.unitTime;
                        unitInfo.uUnitId = unitModel.unitId;
                        unitInfo.uUnitDetails = unitModel.unitContent;
                        unitInfo.uUnitTitle = unitModel.unitName;
                        pharseTime += [[NSString stringAwayFromNSNULL:unitInfo.uUnitTime] intValue];
                        [prepareArr addObject:unitInfo];
                    }
                    phaseInfo.pPhaseTime = [NSString stringWithFormat:@"%d",pharseTime];
                    [phaseInfo.pUnitArr addObjectsFromArray:prepareArr];
                    [lessonPlanInfo.sPhaseArr addObject:phaseInfo];
                }
                    break;
                case 2:
                {
                    NSMutableArray *unitArr = [[LifeBitCoreDataManager shareInstance] efGetLessonPlanModelWithLessonPlan:lessonPlanModel.lessonPlanId withLessonPlanPhase:status];
                    int pharseTime = 0;
                    for (LessonPlanIdUnitModel *unitModel in unitArr) {
                        HJLessonPlanUnitInfo *unitInfo = [[HJLessonPlanUnitInfo alloc] init];
                        unitInfo.uUnitTime = unitModel.unitTime;
                        unitInfo.uUnitId = unitModel.unitId;
                        unitInfo.uUnitDetails = unitModel.unitContent;
                        unitInfo.uUnitTitle = unitModel.unitName;
                        pharseTime += [[NSString stringAwayFromNSNULL:unitInfo.uUnitTime] intValue];
                        [basicArr addObject:unitInfo];
                    }
                    phaseInfo.pPhaseTime = [NSString stringWithFormat:@"%d",pharseTime];
                    [phaseInfo.pUnitArr addObjectsFromArray:basicArr];
                    [lessonPlanInfo.sPhaseArr addObject:phaseInfo];
                }
                    break;
                case 3:
                {
                    NSMutableArray *unitArr = [[LifeBitCoreDataManager shareInstance] efGetLessonPlanModelWithLessonPlan:lessonPlanModel.lessonPlanId withLessonPlanPhase:status];
                    int pharseTime = 0;
                    for (LessonPlanIdUnitModel *unitModel in unitArr) {
                        HJLessonPlanUnitInfo *unitInfo = [[HJLessonPlanUnitInfo alloc] init];
                        unitInfo.uUnitTime = unitModel.unitTime;
                        unitInfo.uUnitId = unitModel.unitId;
                        unitInfo.uUnitDetails = unitModel.unitContent;
                        unitInfo.uUnitTitle = unitModel.unitName;
                        pharseTime += [[NSString stringAwayFromNSNULL:unitInfo.uUnitTime] intValue];
                        [endArr addObject:unitInfo];
                    }
                    phaseInfo.pPhaseTime = [NSString stringWithFormat:@"%d",pharseTime];
                    [phaseInfo.pUnitArr addObjectsFromArray:basicArr];
                    [lessonPlanInfo.sPhaseArr addObject:phaseInfo];
                }
                    break;
                    
                default:
                    break;
            }
            

        }
        
        
}

    
    return lessonPlanInfo;
}

-(NSString *)sTotalTime{
    if (_sTotalTime == nil) {
        return @"0";
    }
    return _sTotalTime;
}


@end
