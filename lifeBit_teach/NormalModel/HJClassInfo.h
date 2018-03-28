//
//  HJClassInfo.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/13.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "BaseModel.h"
#import "HaveClassModel.h"
#import "TestModel.h"
#import "ScheduleModel.h"

@interface HJClassInfo : BaseModel
/*
 * 班级ID
 */
@property (nonatomic,strong)NSString *cClassId;
/*
 *课程ID
 */
@property (nonatomic,strong)NSString *cScheduleId;

/*
 * 班级名称
 */
@property (nonatomic,strong)NSString *cClassName;
// 年级ID
@property (nonatomic, retain) NSString *cGradeId;
// 年级名称
@property (nonatomic, retain) NSString *cGradeName;

/*
 * 班级学生数量
 */
@property (nonatomic,strong)NSString *cStudentNumber;
/*
 * 开始上课时间
 */
@property (nonatomic,strong)NSDate *cStartTime;
/*
 * 班级对应的老师ID
 */
@property (nonatomic,strong)NSString *cTeacherId;
/*
 * 班级对应的课时长
 */
@property (nonatomic,strong)NSNumber *cClassTime;

/*
 * 星期几的课
 */
@property (nonatomic,strong)NSString *cWeek;

/*
 * 第几节课
 */
@property (nonatomic,strong)NSString *cperiod;

/*
 * 上课状态
 */
@property (nonatomic,strong)NSString* cStatus;

/*
 * 课程对应的教案ID
 */
@property (nonatomic,strong)NSString * cLessonPlanId;

/*
 * 课程来源类型（1 课程表 ,2 自定义）
 */
@property (nonatomic,strong)NSNumber * cScheduleType;

/*
 * 项目名称
 */
@property (nonatomic,strong)NSString* cProjectName;
/*
 * 项目id
 */
@property (nonatomic,strong)NSString* cProjectId;

/*
 * 项目单位
 */
@property (nonatomic,strong)NSString * cProjectUnit;

/*
 * 项目类型
 */
@property (nonatomic,strong)NSString * cProjectType;

/*
 * 最大心率值
 */
@property (nonatomic,strong)NSString * cMaxRate;
/*
 * 最大心率值
 */
@property (nonatomic,strong)NSString * cMinRate;

+(HJClassInfo*)createClassInfoWithHaveClassModel:(HaveClassModel *)haveClassModel;
// 根据上课班级，转换成数据库中对象
+(HaveClassModel*)conversionClassInfoWithHaveClassModel:(HJClassInfo *)classInfo;
// 根据记录的测试记录，转换成班级
+(HJClassInfo*)createClassInfoWithTestModel:(TestModel *)testModel;
// 课程表转换成班级
+(HJClassInfo*)createClassInfoWithScheduleModel:(ScheduleModel *)scheduleModel;

// 班级转换成课程表
+(ScheduleModel*)conversionScheduleModelWithClassInfo:(HJClassInfo *)classInfo;
@end
