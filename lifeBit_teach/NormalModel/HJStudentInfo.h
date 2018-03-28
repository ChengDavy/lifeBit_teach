//
//  HJStudentInfo.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/13.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "BaseModel.h"
#import "StudentModel.h"

@interface HJStudentInfo : BaseModel
// 学生的出生日期
@property ( nonatomic, strong) NSString *sBirthDate;
// 学生的班级名称
@property (nonatomic, strong) NSString *sClassName;
// 学生民族
@property (nonatomic, strong) NSString *sNational;
// 性别
@property (nonatomic, strong) NSString *sSex;
// 学生id
@property (nonatomic, strong) NSString *studentId;
// 学生姓名
@property (nonatomic, strong) NSString *studentName;
// 学生学号
@property (nonatomic, strong) NSString *studentNo;

// 班级ID
@property (nonatomic, strong) NSString *sClassId;
//年级ID
@property ( nonatomic, strong) NSString *sGradeId;
//年级名称
@property ( nonatomic, strong) NSString *sGradeName;

// 项目成绩类型
@property (nonatomic, strong) NSString *sProjectType;
//测试项目名称
@property ( nonatomic, strong) NSString *sProjectName;
//项目单位
@property ( nonatomic, strong) NSString *sProjectUnit;

//项目ID
@property ( nonatomic, strong) NSString *sProjectId;
//成绩数组
@property ( nonatomic, strong) NSMutableArray *sScoreArr;
//测试老师
@property ( nonatomic, strong) NSString *sTeachId;

// 是否被点名
@property (nonatomic,strong)NSNumber *sIsCallOver;

// 心率数据
@property (nonatomic,strong)NSMutableArray *headDataArr;

// 步数数据
@property (nonatomic,strong)NSMutableArray *weakDataArr;
// 开始记录成绩时间
@property (nonatomic,strong)NSDate *sStartDate;

// 对应的学生手表
@property (nonatomic,strong)NSString *macStr;


+(HJStudentInfo*)createClassInfoWithStudentModel:(StudentModel *)haveClassModel;
+(StudentModel*)convertStudentModelWithClassInfo:(HJStudentInfo *)studentInfo;
// 将CoreData的对象转换成info对象
+(HJStudentInfo*)createScoreInfoWithScoreModel:(ScoreModel *)scoreModel;
// 讲info对象转换成coredata对象
+(ScoreModel*)convertScoreInfoWithScoreModel:(HJStudentInfo *)scoreInfo;

+(HJStudentInfo*)createStudentInfoWithNotStudentModel:(NotStudentModel *)notStudentModel;
+(NotStudentModel*)convertStudentInfoWithNotStudentModel:(HJStudentInfo *)studentInfo;
@end
