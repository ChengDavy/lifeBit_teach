//
//  LifeBitCoreDataManager.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/1.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataManager.h"
#define  kStudentModel    @"StudentModel" //学生表
#define  kLessonPlanIdUnitModel    @"LessonPlanIdUnitModel" //教案单元
#define  kLessonPlanModel    @"LessonPlanModel" //教案
#define  kScheduleModel    @"ScheduleModel" //课程表
#define  kScoreModel    @"ScoreModel" //成绩表
#define  kWatchModel    @"WatchModel" //手表
#define KBluetoothDataModel @"BluetoothDataModel" // 数据
#define KHaveClassModel @"HaveClassModel" // 已上课程
#define KTestModel @"TestModel" // 已上课程
#define KHistoryTestModel @"HistoryTestModel" // 课程历史记录
#define KNotStudentModel @"NotStudentModel" // 未点名学生
#define KUserModel @"UserModel"
#define KVersionModel @"VersionModel"


@interface LifeBitCoreDataManager : NSObject
+(instancetype)shareInstance;

#pragma mark - 版本信息
//==============================================================================

/* 版本信息*/

//==============================================================================
/**
 *  创建老师用户
 *
 *  @return VersionModel
 */
-(VersionModel*)efCraterVersionModel;
/**
 *  获取所有版本信息
 *
 *  @return VersionModel
 */
-(NSMutableArray*)efGetAllVersionModel;

/**
 *  添加版本信息
 *
 *  @param UserModel
 *
 *  @return
 */
-(BOOL)efAddVersionModel:(VersionModel *)user;

/**
 *  根据老师id获取版本信息
 *
 *  @param 老师id
 *
 *  @return
 */
-(VersionModel*)efGetVersionModelWithTeacherId:(NSString*)teacherId;


/**
 *  删除指定老师的版本
 *
 *  @param UserModel
 *
 *  @return
 */
-(BOOL)efDeleteVersionModel:(VersionModel *)versionModel;

/**
 *  更新老师版本信息
 *
 *  @param VersionModel
 *
 *  @return
 */
-(BOOL)efUpdateVersionModel:(VersionModel *)versionModel;

/**
 *  清空所有版本信息
 *
 *  @return
 */
-(BOOL)efDeleteAllVersionModel;



#pragma mark - 用户信息
//==============================================================================

/*老师用户*/

//==============================================================================
/**
 *  创建老师用户
 *
 *  @return UserModel
 */
-(UserModel*)efCraterUserModel;
/**
 *  获取所有老师
 *
 *  @return studentModel
 */
-(NSMutableArray*)efGetAllUserModel;

/**
 *  添加老师用户到数据库
 *
 *  @param UserModel
 *
 *  @return
 */
-(BOOL)efAddUserModel:(UserModel *)user;

/**
 *  根据学校id获取学校老师
 *  @param 老师ID
 *  @return
 */
-(NSMutableArray *)efGetSchoolAllUserModelWith:(NSString*)schoolId;

/**
 *  根据老师账号和密码获取用户信息
 *
 *  @param uId
 *
 *  @return
 */
-(UserModel *)efGetUserModelMobile:(NSString *)mobileStr andPassword:(NSString*)password;

/**
 *  删除老师用户信息
 *
 *  @param UserModel
 *
 *  @return
 */
-(BOOL)efDeleteUserModel:(UserModel *)user;

/**
 *  更新老师用户信息
 *
 *  @param UserModel
 *
 *  @return
 */
-(BOOL)efUpdateUserModel:(UserModel *)user;

/**
 *  清空所有用户
 *
 *  @return
 */
-(BOOL)efDeleteAllUserModel;


#pragma mark - 学生信息
//==============================================================================

/*学生*/

//==============================================================================
/**
 *  创建学生
 *
 *  @return studentModel
 */
-(StudentModel*)efCraterStudentModel;
/**
 *  获取所有学生信息
 *
 *  @return studentModel
 */
-(NSMutableArray*)efGetAllStudentModel;

/**
 *  添加学生到数据库
 *
 *  @param studentModel
 *
 *  @return
 */
-(BOOL)efAddStudentModel:(StudentModel *)student;

/**
 *  根据学生班级获取学生列表
 *  @param 学生班级ID
 *  @return
 */
-(NSMutableArray *)efGetClassAllStudentWith:(NSString*)classID;

/**
 *  根据学生uId获取学生详情
 *
 *  @param uId
 *
 *  @return
 */
-(StudentModel *)efGetStudentDetailedById:(NSString*)uId;

/**
 *  删除学生信息
 *
 *  @param stuentModel
 *
 *  @return
 */
-(BOOL)efDeleteStudentModel:(StudentModel *)student;

/**
 *  更新学生信息
 *
 *  @param stuentModel
 *
 *  @return
 */
-(BOOL)efUpdateStudent:(StudentModel *)student;

/**
 *  清空学生信息
 *
 *  @return
 */
-(BOOL)efDeleteAllStudentModel;


#pragma --mark-- 未点名学生
/**
 *  创建未点名学生
 *
 *  @return studentModel
 */
-(NotStudentModel*)efCraterNotStudentModel;
/**
 *  获取未点名学生信息
 *
 *  @return studentModel
 */
-(NSMutableArray*)efGetAllNotStudentModel;
/**
 *  添加未上课学生到数据库
 *
 *  @param studentModel
 *
 *  @return
 */
-(BOOL)efAddNotStudentModel:(NotStudentModel *)student;
/**
 *  根据学生班级获取学生列表
 *  @param 学生班级ID
 *  @return
 */
-(NSMutableArray *)efGetClassAllNotStudentModelWith:(NSString*)classID withStartDate:(NSDate*)startTime;
/**
 *  根据学生uId获取学生详情
 *
 *  @param uId
 *
 *  @return
 */
-(NotStudentModel *)efGetNotStudentModelDetailedById:(NSString*)uId;
/**
 *  删除未点名学生信息
 *
 *  @param NotStudentModel
 *
 *  @return
 */
-(BOOL)efDeleteNotStudentModel:(NotStudentModel *)student;
/**
 *  更新为点名学生信息
 *
 *  @param stuentModel
 *
 *  @return
 */
-(BOOL)efUpdateNotStudentModel:(NotStudentModel *)student;
/**
 *  清空所有未点名学生信息
 *
 *  @return
 */
-(BOOL)efDeleteAllNotStudentModel;
#pragma --mark-- 手表管理
//==============================================================================

/*手表管理*/

//==============================================================================
/**
 *  创建手环
 *
 *  @return WatchModel
 */
-(WatchModel*)efCraterWatchModel;
/**
 *  获取所有手环
 *
 *  @return [WatchModel]
 */
-(NSMutableArray*)efGetAllWatchModel;


/**
 *  获取老师的手环
 *
 *  @return [WatchModel]
 */
-(NSMutableArray*)efGetTearchAllWatchModel:(NSString*)tearchId;

/**
 *  删除老师的手环
 *
 *  @return [WatchModel]
 */
-(BOOL)efDeleteTearchAllWatchModel:(NSString*)tearchId;

/**
 *  添加手环到数据库
 *
 *  @param WatchModel
 *
 *  @return
 */
-(BOOL)efAddWatchModel:(WatchModel *)watch;
/**
 *  根据手表Id获取手表详情
 *
 *  @param watchId
 *
 *  @return
 */
-(WatchModel *)efGetWatchDetailedById:(NSString*)watchId;
/**
 *  根据手表Id判断mac地址是否在教具箱中存在
 *
 *  @param 手表mac地址
 *
 *  @return
 */
-(BOOL)efGetBoxIsWatch:(NSString*)mac;

/**
 *  根据ipad标识获取手环列表
 *  @param ipad标识
 *  @return
 */
-(NSMutableArray *)efGetIpadIdentifyingAllWatchWith:(NSString*)ipadIdentifying;



/**
 *  删除手表信息
 *
 *  @param WatchModel
 *
 *  @return
 */
-(BOOL)efDeleteWatchModel:(WatchModel *)watch;



/**
 *  清空所有手表信息
 *
 *  @return
 */
-(BOOL)efDeleteAllWatchModel;


#pragma --mark-- 成绩管理
//==============================================================================

/*成绩管理*/

//==============================================================================
/**
 *  创建成绩实体
 *
 *  @return ScoreModel
 */
-(ScoreModel*)efCraterScoreModel;
/**
 *  获取所有成绩
 *
 *  @return [WatchModel]
 */
-(NSMutableArray*)efGetAllScoreModel;

/**
 *  添加学生成绩到数据库
 *
 *  @param ScoreModel
 *
 *  @return
 */
-(BOOL)efAddScoreModel:(ScoreModel *)watch;
/**
 *  根据学生Id获取成绩详情
 *
 *  @param studentId
 *
 *  @return
 */
-(ScoreModel *)efGetScoreModelDetailedById:(NSString*)studentId withRecordDate:(NSDate*)recordDate;

/**
 *  根据班级id获取学生列表
 *  @param 班级id
 *  @return
 */
-(NSMutableArray *)efGetClassAllStudentSecoreWith:(NSString*)classID withRecordDate:(NSDate*)recordDate ;


/**
 *  更新学生成绩
 *
 *  @param stuentModel
 *
 *  @return
 */
-(BOOL)efUpdateStudentScore:(ScoreModel *)score;

/**
 *  删除成绩信息
 *
 *  @param WatchModel
 *
 *  @return
 */
-(BOOL)efDeleteStudentScore:(ScoreModel *)score;



/**
 *  清空所有成绩信息
 *
 *  @return
 */
-(BOOL)efDeleteAllScoreModel;
#pragma --mark-- 课表管理
//==============================================================================

/*课表管理*/

//==============================================================================
/**
 *  创建课程实体
 *
 *  @return ScoreModel
 */
-(ScheduleModel*)efCraterScheduleModel;
/**
 *  获取所有课程
 *
 *  @return [ScheduleModel]
 */
-(NSMutableArray*)efGetAllScheduleModel;

/**
 *  添加课程成绩到数据库
 *
 *  @param ScheduleModel
 *
 *  @return
 */
-(BOOL)efAddScheduleModel:(ScheduleModel *)schedule;
/**
 *  根据老师Id和课程id获取课程详情
 *
 *  @param scheduleId 课程ID
 *  @return
 */
-(ScheduleModel *)efGetScheduleModeldWithSchedule:(NSString*)scheduleId;

/**
 *  根据星期几来获取课程
 *
 *  @param week 课程ID
 *  @return
 */
-(NSMutableArray *)efGetScheduleModeldWithWeek:(NSString*)week;
/**
 *  根据老师Id获取课程详情
 *  @param teacherId
 *  @return
 */
-(NSMutableArray *)efGetClassAllScheduleModelWith:(NSString*)teacherId;

/**
 *  删除课程信息
 *
 *  @param ScheduleModel
 *
 *  @return
 */
-(BOOL)efDeleteScheduleModel:(ScheduleModel *)schedule;

/**
 *  清空所有课程
 *
 *  @return
 */
-(BOOL)efDeleteAllScheduleModel;


#pragma --mark-- 教案管理
//==============================================================================

/*教案管理*/

//==============================================================================
/**
 *  创建教案
 *
 *  @return LessonPlanModel
 */
-(LessonPlanModel*)efCraterLessonPlanModel;
/**
 *  获取所有教案
 *
 *  @return [LessonPlanModel]
 */
-(NSMutableArray*)efGetAllLessonPlanModel;

/**
 *  获取指定老师的所有教案
 *
 *  @return [LessonPlanModel]
 */
-(NSMutableArray*)efGetAllLessonPlanModelWithTearchId;
/**
 *  添加教案到数据库
 *
 *  @param LessonPlanModel
 *
 *  @return
 */
-(BOOL)efAddLessonPlanModel:(LessonPlanModel *)lessonPlan;
/**
 *  根据教案id获取教案
 *
 *  @param teacherId 老师id
 *  @param 教案id lessonPlanId
 *  @return
 */
-(LessonPlanModel *)efGetLessonPlanModelWithLessonPlan:(NSString*)lessonPlanId;

/**
 *  根据老师Id获取教案详情
 *  @param teacherId
 *  @return
 */
-(NSMutableArray *)efGetClassAllLessonPlanModel:(NSString*)teacherId;

/**
 *  删除教案信息
 *
 *  @param LessonPlanModel
 *
 *  @return
 */
-(BOOL)efDeleteLessonPlanModel:(LessonPlanModel *)lessonPlan;

/**
 *  清空所有教案
 *
 *  @return
 */
-(BOOL)efDeleteAllLessonPlanModel;



#pragma --mark-- 教案单元管理
//==============================================================================

/*教案单元管理*/

//==============================================================================
/**
 *  创建教案单元
 *
 *  @return LessonPlanModel
 */
-(LessonPlanIdUnitModel*)efCraterLessonPlanIdUnitModel;
/**
 *  获取所有教案单元
 *
 *  @return [LessonPlanIdUnitModel]
 */
-(NSMutableArray*)efGetAllLessonPlanUnitModel;

/**
 *  添加教案单元到数据库
 *
 *  @param LessonPlanIdUnitModel
 *
 *  @return
 */
-(BOOL)efAddLessonPlanUnitModel:(LessonPlanIdUnitModel *)lessonPlanUnit;
/**
 *  根据教案id和阶段id获取每个教案阶段对应的单元数组
 *
 *  @param lessonPlanId 教案id
 *  @param phase 阶段
 *  @return
 */
-(NSMutableArray  *)efGetLessonPlanModelWithLessonPlan:(NSString*)lessonPlanId withLessonPlanPhase:(NSString*)phase;


/**
 *  删除单元
 *
 *  @param LessonPlanIdUnitModel
 *
 *  @return
 */
-(BOOL)efDeleteLessonPlanIdUnitModel:(LessonPlanIdUnitModel *)unit;


/**
 *  清空所有单元
 *
 *  @return
 */
-(BOOL)efDeleteAllLessonPlanModelUnit;



#pragma --mark-- 同步数据管理
//==============================================================================

/*同步数据管理*/

//==============================================================================
/**
 *  创建数据
 *
 *  @return BluetoothDataModel
 */
-(BluetoothDataModel*)efCraterBluetoothDataModel;
/**
 *  获取数据
 *
 *  @return [BluetoothDataModel]
 */
-(NSMutableArray*)efGetAllBluetoothDataModel;

/**
 *  获取指定老师所有数据
 *
 *  @return [BluetoothDataModel]
 */
-(NSMutableArray*)efGetTearcherAllBluetoothDataModel;

/**
 *  添加教案到数据库
 *
 *  @param LessonPlanModel
 *
 *  @return
 */
-(BOOL)efAddBluetoothDataModel:(BluetoothDataModel *)bluetoothDataModel;
/**
 *  根据MAC地址和时间获取指定类型的数据
 *
 *  @param timeDate 指定时间
 *  @param DataType 指定的数据类型
 *  @param macStr 手表mac地址
 *  @return
 */
-(BluetoothDataModel *)efGetBluetoothDataModelWithDate:(NSDate*)timeDate withDataType:(NSString*)dataType withMAC:(NSString*)macStr;


/**
 *  根据MAC地址和时间获取指定类型的数据
 *
 *  @param startDate 开始时间
 *  @param endDate 结束时间
 *  @param dataType 数据时间
 *  @param macStr 手表mac地址
 *  @return
 */
-(NSMutableArray *)efGetBluetoothDataModelWithStartDate:(NSDate*)startDate WithendDate:(NSDate*)endDate withDataType:(NSString*)dataType withMAC:(NSString*)macStr;


/**
 *  根据MAC地址和时间获取指定类型的数据
 *
 *  @param startDate 开始时间
 *  @param endDate 结束时间
 *  @param dataType 数据时间
 *  @return
 */
-(NSMutableArray *)efGetBluetoothDataModelWithStartDate:(NSDate*)startDate WithendDate:(NSDate*)endDate withDataType:(NSString*)dataType;
/**
 *  删除指定的同步数据
 *
 *  @param LessonPlanModel
 *
 *  @return
 */
-(BOOL)efDeleteBluetoothDataModel:(BluetoothDataModel *)bluetoothDataModel;
/**
 *  清空所有同步数据
 *
 *  @return
 */
-(BOOL)efDeleteAllBluetoothDataModel;



#pragma --mark-- 已经上课课程
//==============================================================================

/*已经上课课程*/

//==============================================================================
/**
 *  创建已上课程
 *
 *  @return HaveClassModel
 */
-(HaveClassModel*)efCraterHaveClassModel;
/**
 *  获取所有所有已经上课课程
 *
 *  @return [HaveClassModel]
 */
-(NSMutableArray*)efGetAllHaveClassModel;

/**
 *  添加课程到已上课程列表中
 *
 *  @param HaveClassModel
 *
 *  @return
 */
-(BOOL)efAddHaveClassModel:(HaveClassModel *)classModel;
/**
 *  根据课程ID获取详情
 *
 *  @param classID    课程ID
 *  @param startDate 开始上课时间
 *  @return
 */
-(HaveClassModel *)efGetHaveClassModelDetailedWithclassId:(NSString*)classId andStart:(NSDate*)startDate;


/**
 *  根据课程来源和上课状态获取课程
 *
 *  @param sourceType    来源类型 课程来源类型（1 课程表 ,2 自定义）
 *  @param scheduleStatus  课程状态
 *  @return
 */
-(NSMutableArray *)efGetHaveClassModelWithSourceType:(NSNumber*)sourceType andScheduleStatus:(NSString*)scheduleStatus;



/**
 *  删除课程表信息
 *
 *  @param HaveClassModel
 *
 *  @return
 */
-(BOOL)efDeleteHaveClassModel:(HaveClassModel *)haveClassModel;



/**
 *  清空所有已上课信息
 *
 *  @return
 */
-(BOOL)efDeleteAllHaveClassModel;

#pragma --mark-- 保存的测试班级信息
//==============================================================================

/*成绩未上传成功上课班级列表*/

//==============================================================================
/**
 *  创建未上传记录对象
 *
 *  @return TestModel
 */
-(TestModel*)efCraterTestModel;
/**
 *  获取所有未上传成绩的几率
 *
 *  @return [TestModel]
 */
-(NSMutableArray*)efGetAllTestModel;

/**
 *  添加未上传的记录到数据库中
 *
 *  @param TestModel
 *
 *  @return
 */
-(BOOL)efAddTestModel:(TestModel *)testModel;
/**
 *  查看详情
 *
 *  @param TestModel
 *
 *  @return
 */
-(TestModel *)efGetTestModelDetailedWithclassId:(NSString*)classId andStart:(NSDate*)startDate;
/**
 *  删除测试记录
 *
 *  @param HaveClassModel
 *
 *  @return
 */
-(BOOL)efDeleteTestModel:(TestModel *)testModel;


/**
 *  清空所有已上课信息
 *
 *  @return
 */
-(BOOL)efDeleteAllTestModel;


#pragma --mark-- 保存的测试历史数据
//==============================================================================

/*保存的测试历史数据*/

//==============================================================================
/**
 *  创建所有测试历史数据
 *
 *  @return TestModel
 */
-(HistoryTestModel*)efCraterHistoryTestModel;
/**
 *  获取所有测试历史
 *
 *  @return [TestModel]
 */
-(NSMutableArray*)efGetAllHistoryTestModel;

/**
 *  添加测试历史数据
 *
 *  @param TestModel
 *
 *  @return
 */
-(BOOL)efAddHistoryTestModel:(HistoryTestModel *)historyTestModel;

/**
 *  删除测试历史数据
 *
 *  @param HaveClassModel
 *
 *  @return
 */
-(BOOL)efDeleteHistoryTestModel:(HistoryTestModel *)historyTestModel;


/**
 *  清空所有已测试历史数据
 *
 *  @return
 */
-(BOOL)efDeleteAllHistoryTestModel;


@end
