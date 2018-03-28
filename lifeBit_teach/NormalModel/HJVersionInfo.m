//
//  HJVersionInfo.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/10/13.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJVersionInfo.h"

@implementation HJVersionInfo
-(void)setAttributes:(NSDictionary *)attributes{
    self.uTeacherId = [HJUserManager shareInstance].user.uTeacherId;
    self.books_v = [NSString stringAwayFromNSNULL:[attributes objectForKey:@"BOOKS_V"]];
    self.grade_v = [NSString stringAwayFromNSNULL:[attributes objectForKey:@"GRADE_V"]];
    self.mac_v = [NSString stringAwayFromNSNULL:[attributes objectForKey:@"MAC_V"]];
    self.project_v = [NSString stringAwayFromNSNULL:[attributes objectForKey:@"PROJECT_V"]];
    self.books_Classify_v = [NSString stringAwayFromNSNULL:[attributes objectForKey:@"BOOKS_CLASSIFY_V"]];
    self.student_v = [NSString stringAwayFromNSNULL:[attributes objectForKey:@"STUDENTS_V"]];
    self.courses_v = [NSString stringAwayFromNSNULL:[attributes objectForKey:@"COURSES_V"]];

}

+(HJVersionInfo*)createVersionInfoWithVersionModel:(VersionModel*)versionModel{
    HJVersionInfo *versionInfo = [[HJVersionInfo alloc] init];
    versionInfo.uTeacherId = [HJUserManager shareInstance].user.uTeacherId;
    versionInfo.books_v = versionModel.books_v;
    versionInfo.grade_v = versionModel.grade_v;
    versionInfo.mac_v = versionModel.mac_v;
    versionInfo.project_v = versionModel.project_v;
    versionInfo.books_Classify_v = versionModel.books_Classify_v;
    versionInfo.student_v = versionModel.student_v;
    versionInfo.courses_v = versionModel.courses_v;
    
    return versionInfo;
}

+(VersionModel*)convertVersionModelWithVersionInfo:(HJVersionInfo*)versionInfo{
    VersionModel *versionModel = [[LifeBitCoreDataManager shareInstance] efCraterVersionModel];
    versionModel.uTeacherId = [HJUserManager shareInstance].user.uTeacherId;
    versionModel.books_v = versionInfo.books_v;
    versionModel.grade_v = versionInfo.grade_v;
    versionModel.mac_v = versionInfo.mac_v;
    versionModel.project_v = versionInfo.project_v;
    versionModel.books_Classify_v = versionInfo.books_Classify_v;
    versionModel.student_v = versionInfo.student_v;
    versionModel.courses_v = versionInfo.courses_v;
    return versionModel;
}
@end
