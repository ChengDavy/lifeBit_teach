//
//  HJStudentInfo.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/13.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJStudentInfo.h"

@implementation HJStudentInfo
+(HJStudentInfo*)createClassInfoWithStudentModel:(StudentModel *)studentModel{
    HJStudentInfo *studentInfo = [[HJStudentInfo alloc] init];
    studentInfo.sSex = studentModel.sSex;
    studentInfo.sBirthDate = studentModel.sBirthDate;
    studentInfo.sClassName = studentModel.sClassName;
    studentInfo.sNational = studentModel.sNational;
    studentInfo.studentId = studentModel.studentId;
    studentInfo.studentName = studentModel.studentName;
    studentInfo.studentNo = studentModel.studentNo;
    studentInfo.sClassId = studentModel.sClassId;
    studentInfo.sIsCallOver = studentModel.sIsCallOver;
    studentInfo.sGradeName = studentModel.sGradeName;
    studentInfo.sGradeId = studentModel.sGradeId;
    return studentInfo;
}


+(StudentModel*)convertStudentModelWithClassInfo:(HJStudentInfo *)studentInfo{
    StudentModel *studentModel = [[LifeBitCoreDataManager shareInstance] efCraterStudentModel];
    studentModel.sSex = studentInfo.sSex;
    studentModel.sBirthDate = studentInfo.sBirthDate;
    studentModel.sClassName = studentInfo.sClassName;
    studentModel.sNational = studentInfo.sNational;
    studentModel.studentId = studentInfo.studentId;
    studentModel.studentName = studentInfo.studentName;
    studentModel.studentNo = studentInfo.studentNo;
    studentModel.sClassId = studentInfo.sClassId;
    studentModel.sIsCallOver = studentInfo.sIsCallOver;
    studentModel.sGradeId = studentInfo.sGradeId;
    studentModel.sGradeName = studentInfo.sGradeName;
    return studentModel;
}


+(HJStudentInfo*)createScoreInfoWithScoreModel:(ScoreModel *)scoreModel{
    HJStudentInfo *studentInfo = [[HJStudentInfo alloc] init];
    studentInfo.studentId = scoreModel.studentId;
    studentInfo.sGradeId = scoreModel.gradeId;
    studentInfo.sGradeName = scoreModel.gradeName;
    studentInfo.sClassId = scoreModel.studentClassId;
    studentInfo.sClassName = scoreModel.studentClassName;
    studentInfo.sProjectName = scoreModel.projectName;
    studentInfo.sProjectId = scoreModel.projectId;
    studentInfo.sSex = scoreModel.studentSex;
    studentInfo.sScoreArr = scoreModel.scoreArr;
    studentInfo.sTeachId = scoreModel.teachId;
    studentInfo.studentNo = scoreModel.studentNo;
     studentInfo.studentName = scoreModel.studentName;
    studentInfo.sClassId = scoreModel.classId;
    studentInfo.sProjectType = scoreModel.projectType;
    studentInfo.sClassName = scoreModel.cClassName;
    studentInfo.sStartDate = scoreModel.startDate;
    return studentInfo;
}

+(ScoreModel*)convertScoreInfoWithScoreModel:(HJStudentInfo *)studentInfo{
    ScoreModel* scoreModel = [[LifeBitCoreDataManager shareInstance] efCraterScoreModel];
    scoreModel.studentId = studentInfo.studentId;
    scoreModel.gradeId = studentInfo.sGradeId;
    scoreModel.gradeName = studentInfo.sGradeName;
    scoreModel.studentClassId = studentInfo.sClassId;
    scoreModel.studentClassName = studentInfo.sClassName;
    scoreModel.projectName = studentInfo.sProjectName;
    scoreModel.projectId = studentInfo.sProjectId;
    scoreModel.studentSex = studentInfo.sSex;
    scoreModel.scoreArr = studentInfo.sScoreArr;
    scoreModel.teachId = studentInfo.sTeachId;
    scoreModel.studentNo = studentInfo.studentNo;
    scoreModel.studentName = studentInfo.studentName;
    scoreModel.classId = studentInfo.sClassId;
    scoreModel.projectType = studentInfo.sProjectType;
    scoreModel.cClassName = studentInfo.sClassName;
    scoreModel.startDate = studentInfo.sStartDate;
    scoreModel.teachId = [HJUserManager shareInstance].user.uTeacherId;
    return scoreModel;
}

+(HJStudentInfo*)createStudentInfoWithNotStudentModel:(NotStudentModel *)notStudentModel{
    HJStudentInfo *studentInfo = [[HJStudentInfo alloc] init];
    studentInfo.sSex = notStudentModel.sSex;
    studentInfo.sClassName = notStudentModel.sClassName;
    studentInfo.studentId = notStudentModel.studentId;
    studentInfo.studentName = notStudentModel.studentName;
    studentInfo.studentNo = notStudentModel.studentNo;
    studentInfo.sClassId = notStudentModel.sClassId;
    studentInfo.sGradeName = notStudentModel.sGradeName;
    studentInfo.sGradeId = notStudentModel.sGradeId;
    studentInfo.sStartDate = notStudentModel.sStartTime;
    studentInfo.sTeachId = notStudentModel.teacherId;
    return studentInfo;

}

+(NotStudentModel*)convertStudentInfoWithNotStudentModel:(HJStudentInfo *)studentInfo{
    NotStudentModel* notStudentModel = [[LifeBitCoreDataManager shareInstance] efCraterNotStudentModel];
    notStudentModel.sSex = studentInfo.sSex;
    notStudentModel.sClassName = studentInfo.sClassName;
    notStudentModel.studentId = studentInfo.studentId;
    notStudentModel.studentName = studentInfo.studentName;
    notStudentModel.studentNo = studentInfo.studentNo;
    notStudentModel.sClassId = studentInfo.sClassId;
    notStudentModel.sGradeName = studentInfo.sGradeName;
    notStudentModel.sGradeId = studentInfo.sGradeId;
    notStudentModel.sStartTime = studentInfo.sStartDate;
    notStudentModel.teacherId = studentInfo.sTeachId;
    
    return notStudentModel;
}
@end
