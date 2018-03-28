//
//  LifeBitCoreDataManager.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/1.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "LifeBitCoreDataManager.h"
static LifeBitCoreDataManager *_coreData = nil;
@implementation LifeBitCoreDataManager
+(instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _coreData = [[self alloc] init];
    });
    return _coreData;
}

+(void)destroyInstance{
    if (_coreData) {
        _coreData = nil;
    }
}
#pragma mark - 版本信息
//==============================================================================

/* 版本信息*/

//==============================================================================
/**
 *  创建老师用户
 *
 *  @return VersionModel
 */
-(VersionModel*)efCraterVersionModel{
    VersionModel *versionModel = (VersionModel*)[[CoreDataManager shareInstance] CreateObjectWithTable:KVersionModel];
    return  versionModel;

}
/**
 *  获取所有版本信息
 *
 *  @return VersionModel
 */
-(NSMutableArray*)efGetAllVersionModel{
    NSMutableArray *versionArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KVersionModel sortByKey:nil];
    return versionArr;
}

/**
 *  添加版本信息
 *
 *  @param UserModel
 *
 *  @return
 */
-(BOOL)efAddVersionModel:(VersionModel *)versionModel{
    BOOL isSuccess = NO;
    VersionModel *mo = [self efGetVersionModelWithTeacherId:versionModel.uTeacherId];
    
    if (versionModel) {
        if (!(versionModel == mo)) {
            [self efDeleteVersionModel:mo];
            mo = versionModel;
        }
        
        
    }
    isSuccess = [[CoreDataManager shareInstance] saveContext];
    return isSuccess;
}

/**
 *  根据老师id获取版本信息
 *
 *  @param 老师id
 *
 *  @return
 */
-(VersionModel*)efGetVersionModelWithTeacherId:(NSString*)teacherId{
    NSMutableArray *versionArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KVersionModel condition:[NSString stringWithFormat:@"uTeacherId = %@",teacherId] sortByKey:nil];
    if (versionArr.count > 0) {
        VersionModel *versionModel = [versionArr objectAtIndexWithSafety:0];
        return versionModel;
    }
    return [self efCraterVersionModel];
}


/**
 *  删除指定老师的版本
 *
 *  @param UserModel
 *
 *  @return
 */
-(BOOL)efDeleteVersionModel:(VersionModel *)versionModel{
    return  [[CoreDataManager shareInstance] deleteWithObject:versionModel];
}

/**
 *  更新老师版本信息
 *
 *  @param VersionModel
 *
 *  @return
 */
-(BOOL)efUpdateVersionModel:(VersionModel *)versionModel{
    return  [self efAddVersionModel:versionModel];
}

/**
 *  清空所有版本信息
 *
 *  @return
 */
-(BOOL)efDeleteAllVersionModel{
    BOOL flag = YES;
    for (VersionModel* versionModel in [self efGetAllVersionModel]) {
        if (![self efDeleteVersionModel:versionModel]) {
            flag = NO;
        }
    }
    return flag;
}
#pragma mark - 用户信息
//==============================================================================

/*老师用户*/

//==============================================================================
/**
 *  创建老师用户
 *
 *  @return UserModel
 */
-(UserModel*)efCraterUserModel{
    UserModel *userModel = (UserModel*)[[CoreDataManager shareInstance] CreateObjectWithTable:KUserModel];
    return  userModel;
}
/**
 *  获取所有老师
 *
 *  @return studentModel
 */
-(NSMutableArray*)efGetAllUserModel{
    NSMutableArray *userArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KUserModel sortByKey:nil];
    return userArr;
}

/**
 *  添加老师用户到数据库
 *
 *  @param UserModel
 *
 *  @return
 */
-(BOOL)efAddUserModel:(UserModel *)user{
    BOOL isSuccess = NO;
    UserModel *mo = [self efGetUserModelMobile:user.uAccount andPassword:user.uPassword];
    
    if (user) {
        if (!(user == mo)) {
            [self efDeleteUserModel:mo];
            mo = user;
        }
        
        
    }
    isSuccess = [[CoreDataManager shareInstance] saveContext];
    return isSuccess;
}

/**
 *  根据学校id获取学校老师
 *  @param 老师ID
 *  @return
 */
-(NSMutableArray *)efGetSchoolAllUserModelWith:(NSString*)schoolId{
    NSString *conditionStr = [NSString stringWithFormat:@"uSchoolId = '%@'",schoolId];
    NSMutableArray *studentArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KUserModel condition:conditionStr sortByKey:@"uTeacherId" limit:100 ascending:YES];
    return studentArr;
}

/**
 *  根据老师用户Id获取详情
 *
 *  @param uId
 *
 *  @return
 */
-(UserModel *)efGetUserModelMobile:(NSString *)mobileStr andPassword:(NSString*)password{
    NSMutableArray *userArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KUserModel condition:[NSString stringWithFormat:@"uAccount = '%@' and uPassword = '%@'",mobileStr,password] sortByKey:nil];
    if (userArr.count > 0) {
        UserModel *userModel = [userArr objectAtIndexWithSafety:0];
        return userModel;
    }
    return [self efCraterUserModel];
}

/**
 *  删除老师用户信息
 *
 *  @param UserModel
 *
 *  @return
 */
-(BOOL)efDeleteUserModel:(UserModel *)user{
    return  [[CoreDataManager shareInstance] deleteWithObject:user];
}

/**
 *  更新老师用户信息
 *
 *  @param UserModel
 *
 *  @return
 */
-(BOOL)efUpdateUserModel:(UserModel *)user{
     return  [self efAddUserModel:user];
}

/**
 *  清空所有用户
 *
 *  @return
 */
-(BOOL)efDeleteAllUserModel{
    BOOL flag = YES;
    for (UserModel* user in [self efGetAllUserModel]) {
        if (![self efDeleteUserModel:user]) {
            flag = NO;
        }
    }
    return flag;
}




#pragma --mark-- 学生管理
/**
 *  创建学生
 *
 *  @return studentModel
 */
-(StudentModel*)efCraterStudentModel{
    StudentModel *studentModel = (StudentModel*)[[CoreDataManager shareInstance] CreateObjectWithTable:kStudentModel];
   return  studentModel;
}

/**
 *  获取所有学生信息
 *
 *  @return studentModel
 */
-(NSMutableArray*)efGetAllStudentModel{
    NSMutableArray *studentArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kStudentModel sortByKey:nil];
    return studentArr;
}

/**
 *  添加学生到数据库
 *
 *  @param studentModel
 *
 *  @return
 */
-(BOOL)efAddStudentModel:(StudentModel *)student{
    BOOL isSuccess = NO;
    StudentModel *mo = [self efGetStudentDetailedById:student.studentId];
    
    if (student) {
        if (!(student == mo)) {
            [self efDeleteStudentModel:mo];
            mo = student;
        }
        
        
    }
    isSuccess = [[CoreDataManager shareInstance] saveContext];
    return isSuccess;
}

/**
 *  根据学生班级获取学生列表
 *  @param 学生班级ID
 *  @return
 */
-(NSMutableArray *)efGetClassAllStudentWith:(NSString*)classID{
    NSString *conditionStr = [NSString stringWithFormat:@"sClassId = '%@'",classID];
    NSMutableArray *studentArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kStudentModel condition:conditionStr sortByKey:@"studentNo" limit:100 ascending:YES];
    return studentArr;
}

/**
 *  根据学生uId获取学生详情
 *
 *  @param uId
 *
 *  @return
 */
-(StudentModel *)efGetStudentDetailedById:(NSString*)uId{
    NSMutableArray *studentArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kStudentModel condition:[NSString stringWithFormat:@"studentId='%@'",uId] sortByKey:nil];
    if (studentArr.count > 0) {
        StudentModel *studentModel = [studentArr objectAtIndexWithSafety:0];
         return studentModel;
    }
    return [self efCraterStudentModel];
}

/**
 *  删除学生信息
 *
 *  @param stuentModel
 *
 *  @return
 */
-(BOOL)efDeleteStudentModel:(StudentModel *)student{
    return  [[CoreDataManager shareInstance] deleteWithObject:student];
}


/**
 *  更新学生信息
 *
 *  @param stuentModel
 *
 *  @return
 */
-(BOOL)efUpdateStudent:(StudentModel *)student{
    return  [self efAddStudentModel:student];
}

/**
 *  清空学生信息
 *
 *  @return
 */
-(BOOL)efDeleteAllStudentModel{
    BOOL flag = YES;
    for (StudentModel* student in [self efGetAllStudentModel]) {
        if (![self efDeleteStudentModel:student]) {
            flag = NO;
        }
    }
    return flag;
}


#pragma --mark-- 未点名学生
/**
 *  创建未点名学生
 *
 *  @return studentModel
 */
-(NotStudentModel*)efCraterNotStudentModel{
    NotStudentModel *notStudentModel = (NotStudentModel*)[[CoreDataManager shareInstance] CreateObjectWithTable:KNotStudentModel];
    return  notStudentModel;
}

/**
 *  获取未点名学生信息
 *
 *  @return studentModel
 */
-(NSMutableArray*)efGetAllNotStudentModel{
    NSMutableArray *studentArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KNotStudentModel sortByKey:nil];
    return studentArr;
}

/**
 *  添加未上课学生到数据库
 *
 *  @param studentModel
 *
 *  @return
 */
-(BOOL)efAddNotStudentModel:(NotStudentModel *)student{
    BOOL isSuccess = NO;
    NotStudentModel *mo = [self efGetNotStudentModelDetailedById:student.studentId];
    
    if (student) {
        if (!(student == mo)) {
            [self efDeleteNotStudentModel:mo];
            mo = student;
        }
        
        
    }
    isSuccess = [[CoreDataManager shareInstance] saveContext];
    return isSuccess;
}

/**
 *  根据学生班级获取学生列表
 *  @param 学生班级ID
 *  @return
 */
-(NSMutableArray *)efGetClassAllNotStudentModelWith:(NSString*)classID withStartDate:(NSDate*)startTime{
//    NSString *conditionStr = [NSString stringWithFormat:@"teacherId = %@ and sClassId = %@ sStartTime = %@",[HJUserManager shareInstance].user.uTeacherId,classID,startTime];
    //查询查询条件 and (recordDate = %@
    NSPredicate *predicateCondition = [NSPredicate predicateWithFormat:@"sClassId = %@ and teacherId = %@ and sStartTime = %@",classID,[HJUserManager shareInstance].user.uTeacherId,startTime];
    NSString *key = @"studentNo";
    BOOL isAscending = YES;
    NSInteger limit = NSIntegerMax;
    NSMutableArray *notStudentArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KNotStudentModel PredicateCondition:predicateCondition sortByKey:key limit:limit ascending:isAscending];
    return notStudentArr;

}

/**
 *  根据学生uId获取学生详情
 *
 *  @param uId
 *
 *  @return
 */
-(NotStudentModel *)efGetNotStudentModelDetailedById:(NSString*)uId{
    NSMutableArray *studentArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KNotStudentModel condition:[NSString stringWithFormat:@"teacherId = %@ and studentId = '%@'",[HJUserManager shareInstance].user.uTeacherId,uId] sortByKey:nil];
    if (studentArr.count > 0) {
        NotStudentModel *studentModel = [studentArr objectAtIndexWithSafety:0];
        return studentModel;
    }
    return [self efCraterNotStudentModel];
}

/**
 *  删除未点名学生信息
 *
 *  @param NotStudentModel
 *
 *  @return
 */
-(BOOL)efDeleteNotStudentModel:(NotStudentModel *)student{
    return  [[CoreDataManager shareInstance] deleteWithObject:student];
}


/**
 *  更新为点名学生信息
 *
 *  @param stuentModel
 *
 *  @return
 */
-(BOOL)efUpdateNotStudentModel:(NotStudentModel *)student{
    return  [self efAddNotStudentModel:student];
}

/**
 *  清空所有未点名学生信息
 *
 *  @return
 */
-(BOOL)efDeleteAllNotStudentModel{
    BOOL flag = YES;
    for (NotStudentModel* student in [self efGetAllNotStudentModel]) {
        if (![self efDeleteNotStudentModel:student]) {
            flag = NO;
        }
    }
    return flag;
}





#pragma --mark-- 手表管理
//==============================================================================

/*手表管理*/

//==============================================================================
/**
 *  创建手环
 *
 *  @return WatchModel
 */
-(WatchModel*)efCraterWatchModel{
    WatchModel *watch =  (WatchModel*)[[CoreDataManager shareInstance] CreateObjectWithTable:kWatchModel];
    return watch;
}
/**
 *  获取所有手环
 *
 *  @return [WatchModel]
 */
-(NSMutableArray*)efGetAllWatchModel {
    
    NSMutableArray *watchArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kWatchModel condition:nil sortByKey:@"watchNo"];
    return watchArr;
}


-(NSMutableArray*)efGetTearchAllWatchModel:(NSString*)tearchId{
    NSString *uuidStr = [[APPIdentificationManage  shareInstance] readUDID];
    NSString *conditionStr = [NSString stringWithFormat:@"ipadIdentifying = '%@' and teacherId = '%@'",uuidStr,tearchId];
    NSMutableArray *watchArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kWatchModel condition:conditionStr sortByKey:@"watchNo"];
    return watchArr;
}

-(BOOL)efDeleteTearchAllWatchModel:(NSString*)tearchId{
    BOOL isSuccess = NO;
    NSMutableArray *watchArr = [self efGetTearchAllWatchModel:tearchId];
    for (WatchModel *watch  in watchArr) {
        isSuccess = [[CoreDataManager shareInstance] deleteWithObject:watch];
    }
    return isSuccess;
}

/**
 *  添加手环到数据库
 *
 *  @param WatchModel
 *
 *  @return
 */
-(BOOL)efAddWatchModel:(WatchModel *)watch{
    BOOL isSuccess = NO;
    WatchModel *mo = [self efGetWatchDetailedById:watch.watchMAC];
    if (mo) {
        if (!(mo == watch)) {
            [self efDeleteWatchModel:mo];
            mo = watch;
        }
        
    }
    isSuccess = [[CoreDataManager shareInstance] saveContext];
    return isSuccess;
}

/**
 *  根据手表Id获取手表详情
 *
 *  @param watchId
 *
 *  @return
 */
-(WatchModel *)efGetWatchDetailedById:(NSString*)watchId{
    NSString *uuidStr = [[APPIdentificationManage  shareInstance] readUDID];
    NSMutableArray *watchArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kWatchModel condition:[NSString stringWithFormat:@"watchMAC = '%@' and ipadIdentifying = '%@'",watchId,uuidStr] sortByKey:nil];
    if (watchArr.count > 0) {
        WatchModel *watchModel = [watchArr objectAtIndexWithSafety:0];
        return watchModel;
    }
    return [self efCraterWatchModel];
}
/**
 *  根据手表Id判断mac地址是否在教具箱中存在
 *
 *  @param 手表mac地址
 *
 *  @return
 */
-(BOOL)efGetBoxIsWatch:(NSString*)mac {
    
    NSString *uuidStr = [[APPIdentificationManage  shareInstance] readUDID];
//    NSLog(@"UUIDString ======== %@",uuidStr);
   NSMutableArray *watchArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kWatchModel condition:[NSString stringWithFormat:@"watchMAC = '%@' and ipadIdentifying = '%@' and teacherId = '%@'",mac,uuidStr,[HJUserManager shareInstance].user.uTeacherId] sortByKey:nil];
    NSMutableArray* watchArr1 = [self efGetAllWatchModel];
//    NSLog(@"watchArr1 = %ld",watchArr1.count);
    if (watchArr.count > 0) {
        return YES;
    }
    return NO;
}

/**
 *  根据ipad标识获取手环列表
 *  @param ipad标识
 *  @return
 */
-(NSMutableArray *)efGetIpadIdentifyingAllWatchWith:(NSString*)ipadIdentifying{
    NSString *condition = [NSString stringWithFormat:@"ipadIdentifying = '%@'",ipadIdentifying];
    NSMutableArray *watchArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kWatchModel condition:condition sortByKey:@"watchNo" limit:100 ascending:YES];
    return watchArr;
}



/**
 *  删除手表信息
 *
 *  @param WatchModel
 *
 *  @return
 */
-(BOOL)efDeleteWatchModel:(WatchModel *)watch{
    return  [[CoreDataManager shareInstance] deleteWithObject:watch];
}



/**
 *  清空所有手表信息
 *
 *  @return
 */
-(BOOL)efDeleteAllWatchModel{
    BOOL flag = YES;
    for (WatchModel* watch in [self efGetAllWatchModel]) {
        if (![self efDeleteWatchModel:watch]) {
            flag = NO;
        }
    }
    return flag;
}

#pragma --mark-- 成绩管理
//==============================================================================

/*成绩管理*/

//==============================================================================
/**
 *  创建成绩实体
 *
 *  @return ScoreModel
 */
-(ScoreModel*)efCraterScoreModel{
    ScoreModel *scoreModel = (ScoreModel*)[[CoreDataManager shareInstance] CreateObjectWithTable:kScoreModel];
    return  scoreModel;
}
/**
 *  获取所有成绩
 *
 *  @return [ScoreModel]
 */
-(NSMutableArray*)efGetAllScoreModel{
    NSString *conditionStr = [NSString stringWithFormat:@"teachId = '%@'",[HJUserManager shareInstance].user.uTeacherId];
    return  [[CoreDataManager shareInstance] QueryObjectsWithTable:kScoreModel condition:conditionStr sortByKey:@"studentNo" limit:1000 ascending:YES];
}

/**
 *  添加学生成绩到数据库
 *
 *  @param ScoreModel
 *
 *  @return
 */
-(BOOL)efAddScoreModel:(ScoreModel *)scoreModel{
    BOOL isSuccess = NO;
    ScoreModel *mo = [self efGetScoreModelDetailedById:scoreModel.studentId  withRecordDate:scoreModel.startDate];
    if (mo) {
        if (!(mo == scoreModel)) {
            [self efDeleteStudentScore:mo];
            mo = scoreModel;
        }
        
    }
    isSuccess = [[CoreDataManager shareInstance] saveContext];
    return isSuccess;
}
/**
 *  根据学生Id获取成绩详情
 *
 *  @param studentId
 *
 *  @return
 */
-(ScoreModel *)efGetScoreModelDetailedById:(NSString*)studentId withRecordDate:(NSDate*)recordDate{

    
    //查询查询条件 and (recordDate = %@
    NSPredicate *predicateCondition = [NSPredicate predicateWithFormat:@"teachId = %@ and studentId = %@ and startDate = %@",[HJUserManager shareInstance].user.uTeacherId,studentId,recordDate];
    NSString *key = @"studentNo";
    BOOL isAscending = YES;
    NSInteger limit = NSIntegerMax;
    NSMutableArray *scoreArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kScoreModel PredicateCondition:predicateCondition sortByKey:key limit:limit ascending:isAscending];
    if (scoreArr.count > 0 ) {
        for (ScoreModel *scoreModel in scoreArr) {
            if ([scoreModel.studentId isEqualToString:studentId] && [scoreModel.startDate compare:recordDate] == NSOrderedSame) {
                //                HaveClassModel *haveClassModel = [haveClassModelArr objectAtIndexWithSafety:0];
                return scoreModel;
            }
        }
    }
    ScoreModel *scoreModel = [self efCraterScoreModel];
    
    return scoreModel;
    

}

/**
 *  根据班级id获取学生列表
 *  @param 班级id
 *  @return
 */
-(NSMutableArray *)efGetClassAllStudentSecoreWith:(NSString*)classID withRecordDate:(NSDate*)recordDate{
    //查询查询条件 and (recordDate = %@
    NSPredicate *predicateCondition = [NSPredicate predicateWithFormat:@"studentClassId = %@ and teachId = %@ and startDate = %@",classID,[HJUserManager shareInstance].user.uTeacherId,recordDate];
    NSString *key = @"studentNo";
    BOOL isAscending = YES;
    NSInteger limit = NSIntegerMax;
    NSMutableArray *scoreArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kScoreModel PredicateCondition:predicateCondition sortByKey:key limit:limit ascending:isAscending];
    return scoreArr;
}


/**
 *  更新学生成绩
 *
 *  @param stuentModel
 *
 *  @return
 */
-(BOOL)efUpdateStudentScore:(ScoreModel *)score{
    return  [self efAddScoreModel:score];
}

/**
 *  删除成绩信息
 *
 *  @param WatchModel
 *
 *  @return
 */
-(BOOL)efDeleteStudentScore:(ScoreModel *)score{
    return  [[CoreDataManager shareInstance] deleteWithObject:score];
}



/**
 *  清空所有成绩信息
 *
 *  @return
 */
-(BOOL)efDeleteAllScoreModel{
    BOOL flag = YES;
    for (ScoreModel* score in [self efGetAllScoreModel]) {
        if (![self efDeleteStudentScore:score]) {
            flag = NO;
        }
    }
    return flag;
}


#pragma --mark-- 课表管理
//==============================================================================

/*课表管理*/

//==============================================================================
/**
 *  创建课程实体
 *
 *  @return ScoreModel
 */
-(ScheduleModel*)efCraterScheduleModel{
    ScheduleModel* scheduleModel = (ScheduleModel*)[[CoreDataManager shareInstance] CreateObjectWithTable:kScheduleModel];
    return scheduleModel;
}
/**
 *  获取所有课程
 *
 *  @return [ScheduleModel]
 */
-(NSMutableArray*)efGetAllScheduleModel{
    return  [[CoreDataManager shareInstance] QueryObjectsWithTable:kScheduleModel condition:nil sortByKey:nil];;
    
    
}

/**
 *  添加课程成绩到数据库
 *
 *  @param ScheduleModel
 *
 *  @return
 */
-(BOOL)efAddScheduleModel:(ScheduleModel *)schedule{
    BOOL isSuccess = NO;
    ScheduleModel *mo = [self efGetScheduleModel:schedule];
    if (mo) {
        if (!(mo == schedule)) {
            [self efDeleteScheduleModel:mo];
            mo = schedule;
        }
    }
    isSuccess = [[CoreDataManager shareInstance] saveContext];
    return isSuccess;
}
/**
 *  根据老师Id和课程id获取课程详情
 *
 *  @param scheduleId 课程ID
 *  @return
 */
-(ScheduleModel *)efGetScheduleModeldWithSchedule:(NSString*)scheduleId{
    NSString *condition = [NSString stringWithFormat:@"scheduleId='%@' and teacherId = '%@'",scheduleId,[HJUserManager shareInstance].user.uTeacherId];
    NSMutableArray *scheduleArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kScheduleModel condition:condition sortByKey:nil limit:1000 ascending:NO];
    if (scheduleArr.count > 0) {
        ScheduleModel *schedule = [scheduleArr objectAtIndexWithSafety:0];
        for (int i = 1; i < scheduleArr.count - 1; i++) {
            ScheduleModel *scheduleModel = scheduleArr[i];
            [self efDeleteScheduleModel:scheduleModel];
        }
        return schedule;
    }
    ScheduleModel *schedule = (ScheduleModel *)[[CoreDataManager shareInstance] CreateObjectWithTable:kScheduleModel];
    return schedule;
}

-(ScheduleModel *)efGetScheduleModel:(ScheduleModel *)scheduleModel{
    NSString *condition = [NSString stringWithFormat:@"scheduleId='%@' and teacherId = '%@'",scheduleModel.scheduleId,[HJUserManager shareInstance].user.uTeacherId];
    NSMutableArray *scheduleArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kScheduleModel condition:condition sortByKey:nil limit:1000 ascending:NO];
    if (scheduleArr.count > 0) {
        for (ScheduleModel *s in scheduleArr) {
            if (scheduleModel == s) {
                return s;
            }
        }
        ScheduleModel *scheduleModel = scheduleArr[0];
        return scheduleModel;
    }
    ScheduleModel *schedule = (ScheduleModel *)[[CoreDataManager shareInstance] CreateObjectWithTable:kScheduleModel];
    return schedule;
}


/**
 *  根据星期几来获取课程
 *
 *  @param week 课程ID
 *  @return
 */
-(NSMutableArray *)efGetScheduleModeldWithWeek:(NSString*)week{
    NSString *condition = [NSString stringWithFormat:@"week = %@  and teacherId = '%@'",week,[HJUserManager shareInstance].user.uTeacherId];
    NSMutableArray *scheduleArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kScheduleModel condition:condition sortByKey:@"period" limit:1000 ascending:YES];
    
    return scheduleArr;
}

/**
 *  根据老师Id获取课程列表
 *  @param teacherId
 *  @return
 */
-(NSMutableArray *)efGetClassAllScheduleModelWith:(NSString*)teacherId{
    NSString *conditionStr = [NSString stringWithFormat:@"teacherId = '%@'",[HJUserManager shareInstance].user.uTeacherId];
    return  [[CoreDataManager shareInstance] QueryObjectsWithTable:kScheduleModel condition:conditionStr sortByKey:@"scheduleId" limit:1000 ascending:YES];
}


/**
 *  删除课表
 *
 *  @param ScheduleModel
 *
 *  @return
 */
-(BOOL)efDeleteScheduleModel:(ScheduleModel *)schedule{
     return  [[CoreDataManager shareInstance] deleteWithObject:schedule];
}
/**
 *  清空所有课程
 *
 *  @return
 */
-(BOOL)efDeleteAllScheduleModel{
    BOOL flag = YES;
    for (ScheduleModel* schedule in [self efGetClassAllScheduleModelWith:[HJUserManager shareInstance].user.uTeacherId]) {
        if (![self efDeleteScheduleModel:schedule]) {
            flag = NO;
        }
    }
    return flag;
}



#pragma --mark-- 教案管理
//==============================================================================

/*教案管理*/

//==============================================================================
/**
 *  创建教案
 *
 *  @return LessonPlanModel
 */
-(LessonPlanModel*)efCraterLessonPlanModel{
    LessonPlanModel *lessonPlanModel = (LessonPlanModel*)[[CoreDataManager shareInstance] CreateObjectWithTable:kLessonPlanModel];
    return lessonPlanModel;
}
/**
 *  获取所有教案
 *
 *  @return [LessonPlanModel]
 */
-(NSMutableArray*)efGetAllLessonPlanModel{
    NSMutableArray *lessonPlanArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kLessonPlanModel sortByKey:nil];
    return lessonPlanArr;
}

/**
 *  获取指定老师的所有教案
 *
 *  @return [LessonPlanModel]
 */
-(NSMutableArray*)efGetAllLessonPlanModelWithTearchId{
    NSMutableArray *lessonPlanArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kLessonPlanModel condition:[NSString stringWithFormat:@"teachId = '%@'",[HJUserManager shareInstance].user.uTeacherId] sortByKey:nil];
    return lessonPlanArr;
}

/**
 *  添加教案到数据库
 *
 *  @param LessonPlanModel
 *
 *  @return
 */
-(BOOL)efAddLessonPlanModel:(LessonPlanModel *)lessonPlan{
    BOOL isSuccess = NO;
    LessonPlanModel *mo = [self efGetLessonPlanModelWithLessonPlan:lessonPlan.lessonPlanId];
    if (mo) {
        if (!(mo == lessonPlan)) {
            [self efDeleteLessonPlanModel:mo];
            mo = lessonPlan;
        }
    }
    isSuccess = [[CoreDataManager shareInstance] saveContext];
    return isSuccess;
}
/**
 *  根据教案id获取教案
 *
 *  @param teacherId 老师id
 *  @param 教案id lessonPlanId
 *  @return
 */
-(LessonPlanModel *)efGetLessonPlanModelWithLessonPlan:(NSString*)lessonPlanId{
    NSMutableArray *lessonPlanArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kLessonPlanModel condition:[NSString stringWithFormat:@"teachId = '%@' and lessonPlanId = '%@'",[HJUserManager shareInstance].user.uTeacherId,lessonPlanId] sortByKey:nil];
    if (lessonPlanArr.count > 0) {
        LessonPlanModel *lessonPlan = [lessonPlanArr objectAtIndexWithSafety:0];
        return lessonPlan;
    }
    LessonPlanModel *lessonPlan = (LessonPlanModel*)[[CoreDataManager shareInstance] CreateObjectWithTable:kLessonPlanModel];
    return lessonPlan;
}

/**
 *  根据老师Id获取老师教案
 *  @param teacherId
 *  @return
 */
-(NSMutableArray *)efGetClassAllLessonPlanModel:(NSString*)teacherId{
    NSMutableArray *lessonPlanArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kLessonPlanModel condition:[NSString stringWithFormat:@"tearchId = %@",[HJUserManager shareInstance].user.uTeacherId] sortByKey:nil];
    return lessonPlanArr;
}

/**
 *  删除教案信息
 *
 *  @param LessonPlanModel
 *
 *  @return
 */
-(BOOL)efDeleteLessonPlanModel:(LessonPlanModel *)lessonPlan{
      return  [[CoreDataManager shareInstance] deleteWithObject:lessonPlan];
}

/**
 *  清空所有教案
 *
 *  @return
 */
-(BOOL)efDeleteAllLessonPlanModel{
    BOOL flag = YES;
    for (LessonPlanModel* lessonPlan in [self efGetAllLessonPlanModel]) {
        if (![self efDeleteLessonPlanModel:lessonPlan]) {
            flag = NO;
        }
    }
    return flag;
}


#pragma --mark-- 教案单元管理
//==============================================================================

/*教案单元管理*/

//==============================================================================
/**
 *  创建教案单元
 *
 *  @return LessonPlanModel
 */
-(LessonPlanIdUnitModel*)efCraterLessonPlanIdUnitModel{
    LessonPlanIdUnitModel *unit = (LessonPlanIdUnitModel*)[[CoreDataManager shareInstance] CreateObjectWithTable:kLessonPlanIdUnitModel];
    return unit;
}
/**
 *  获取所有教案单元
 *
 *  @return [LessonPlanIdUnitModel]
 */
-(NSMutableArray*)efGetAllLessonPlanUnitModel{
    NSMutableArray *unitArr =[[CoreDataManager shareInstance] QueryObjectsWithTable:kLessonPlanIdUnitModel sortByKey:nil];
    return unitArr;
}

/**
 *  添加教案单元到数据库
 *
 *  @param LessonPlanIdUnitModel
 *
 *  @return
 */
-(BOOL)efAddLessonPlanUnitModel:(LessonPlanIdUnitModel *)lessonPlanUnit{
    BOOL isSuccess = NO;
    LessonPlanIdUnitModel *mo = [self efGetLessonPlanModelWithLessonPlan:lessonPlanUnit.lessonPlanId withLessonPlanUnit:lessonPlanUnit.unitId];
    if (mo) {
        if (!(lessonPlanUnit == mo)) {
            [self efDeleteLessonPlanIdUnitModel:mo];
            mo = lessonPlanUnit;
        }
    }
    isSuccess = [[CoreDataManager shareInstance] saveContext];
    return isSuccess;
}


/**
 *  根据教案id和教案单元id获取教案
 *
 *  @param lessonPlanId 教案id
 *  @param unit 教案单元ID
 *  @return
 */
-(LessonPlanIdUnitModel *)efGetLessonPlanModelWithLessonPlan:(NSString*)lessonPlanId withLessonPlanUnit:(NSString*)unitId{
    NSString *conditionStr = [NSString stringWithFormat:@"teachId = '%@' and lessonPlanId = '%@' and lessonPlanPhase = '%@'",[HJUserManager shareInstance].user.uTeacherId,lessonPlanId,unitId];
    NSMutableArray *unitArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kLessonPlanIdUnitModel condition:conditionStr sortByKey:nil];
    if (unitArr.count > 0) {
        LessonPlanIdUnitModel *unitModel = [unitArr objectAtIndexedSubscript:0];
        return unitModel;
    }
    LessonPlanIdUnitModel *unitModel = (LessonPlanIdUnitModel*)[[CoreDataManager shareInstance] CreateObjectWithTable:kLessonPlanIdUnitModel];
    return unitModel;
}



/**
 *  根据教案id和阶段id获取每个教案阶段对应的单元数组
 *
 *  @param lessonPlanId 教案id
 *  @param phase 阶段
 *  @return
 */
-(NSMutableArray *)efGetLessonPlanModelWithLessonPlan:(NSString*)lessonPlanId withLessonPlanPhase:(NSString*)phase{
    NSString *conditionStr = [NSString stringWithFormat:@"teachId = '%@' and lessonPlanId = '%@' and lessonPlanPhase = '%@'",[HJUserManager shareInstance].user.uTeacherId,lessonPlanId,phase];
    NSMutableArray *unitArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kLessonPlanIdUnitModel condition:conditionStr sortByKey:@"unitNo" limit:100 ascending:YES];
    return unitArr;
}




/**
 *  删除单元
 *
 *  @param LessonPlanIdUnitModel
 *
 *  @return
 */
-(BOOL)efDeleteLessonPlanIdUnitModel:(LessonPlanIdUnitModel *)unit{
    return  [[CoreDataManager shareInstance] deleteWithObject:unit];
}

/**
 *  清空所有单元
 *
 *  @return
 */
-(BOOL)efDeleteAllLessonPlanModelUnit{
    NSString *conditionStr = [NSString stringWithFormat:@"teachId = %@",[HJUserManager shareInstance].user.uTeacherId];
    NSMutableArray *unitArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:kLessonPlanIdUnitModel condition:conditionStr sortByKey:nil];
    BOOL flag = YES;
    for (LessonPlanIdUnitModel* lessonPlanUnit in unitArr) {
        if (![self efDeleteLessonPlanIdUnitModel:lessonPlanUnit]) {
            flag = NO;
        }
    }
    return flag;
}


#pragma --mark-- 同步数据管理
//==============================================================================

/* 同步数据管理*/

//==============================================================================
/**
 *
 *
 *  @return LessonPlanModel
 */
-(BluetoothDataModel*)efCraterBluetoothDataModel{
    BluetoothDataModel *bluetoothDataModel = (BluetoothDataModel*)[[CoreDataManager shareInstance] CreateObjectWithTable:KBluetoothDataModel];
    return bluetoothDataModel;
}
/**
 *  获取所有数据
 *
 *  @return [BluetoothDataModel]
 */
-(NSMutableArray*)efGetAllBluetoothDataModel{
    NSMutableArray *bluetoothDataModelArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KBluetoothDataModel sortByKey:nil];
    return bluetoothDataModelArr;
}


/**
 *  获取指定老师所有数据
 *
 *  @return [BluetoothDataModel]
 */
-(NSMutableArray*)efGetTearcherAllBluetoothDataModel{
    //查询查询条件 and (recordDate = %@
    NSPredicate *predicateCondition = [NSPredicate predicateWithFormat:@"teacherId=%@",[HJUserManager shareInstance].user.uTeacherId];
    NSString *key = @"recordDate";
    BOOL isAscending = YES;
    NSInteger limit = NSIntegerMax;
    NSMutableArray *bluetoothDataModelArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KBluetoothDataModel PredicateCondition:predicateCondition sortByKey:key limit:limit ascending:isAscending];
    return bluetoothDataModelArr;
}
/**
 *  添加数据
 *
 *  @param BluetoothDataModel
 *
 *  @return
 */
-(BOOL)efAddBluetoothDataModel:(BluetoothDataModel *)bluetoothDataModel{
    BOOL isSuccess = NO;
    BluetoothDataModel *mo = [self efGetBluetoothDataModelWithDate:bluetoothDataModel.recordDate withDataType:bluetoothDataModel.dataType withMAC:bluetoothDataModel.watchMac];
    if (mo) {
        if (!(mo == bluetoothDataModel)) {
            [self efDeleteBluetoothDataModel:mo];
            mo = bluetoothDataModel;
        }
    }
    isSuccess = [[CoreDataManager shareInstance] saveContext];
    return isSuccess;
}
/**
 *  根据MAC地址和时间获取指定类型的数据
 *
 *  @param timeDate 指定时间
 *  @param DataType 指定的数据类型
 *  @param macStr 手表mac地址
 *  @return
 */
-(BluetoothDataModel *)efGetBluetoothDataModelWithDate:(NSDate*)timeDate withDataType:(NSString*)dataType withMAC:(NSString*)macStr {
    //查询查询条件 and (recordDate = %@
    NSPredicate *predicateCondition = [NSPredicate predicateWithFormat:@"dataType = %@ and watchMac = %@ and (recordDate = %@)",dataType,macStr,timeDate];
    NSString *key = @"recordDate";
    BOOL isAscending = YES;
    NSInteger limit = NSIntegerMax;
    NSMutableArray *bluetoothDataModelArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KBluetoothDataModel PredicateCondition:predicateCondition sortByKey:key limit:limit ascending:isAscending];
    if (bluetoothDataModelArr.count > 0) {
        BluetoothDataModel *bluetoothDataModel = [bluetoothDataModelArr objectAtIndexWithSafety:0];
        return bluetoothDataModel;
    }
    BluetoothDataModel *bluetoothDataModel = (BluetoothDataModel*)[[CoreDataManager shareInstance] CreateObjectWithTable:KBluetoothDataModel];
    return bluetoothDataModel;
}

/**
 *  根据MAC地址和时间获取指定类型的数据
 *
 *  @param startDate 开始时间
 *  @param endDate 结束时间
 *  @param dataType 数据时间
 *  @param macStr 手表mac地址
 *  @return
 */
-(NSMutableArray *)efGetBluetoothDataModelWithStartDate:(NSDate*)startDate WithendDate:(NSDate*)endDate withDataType:(NSString*)dataType withMAC:(NSString*)macStr {
    //查询查询条件 and (recordDate = %@
    NSPredicate *predicateCondition = [NSPredicate predicateWithFormat:@"dataType = %@ and watchMac = %@ and (recordDate > %@ and recordDate < %@)",dataType,macStr,startDate,endDate];
    NSString *key = @"recordDate";
    BOOL isAscending = YES;
    NSInteger limit = NSIntegerMax;
    NSMutableArray *bluetoothDataModelArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KBluetoothDataModel PredicateCondition:predicateCondition sortByKey:key limit:limit ascending:isAscending];
    return bluetoothDataModelArr;
}

/**
 *  根据MAC地址和时间获取指定类型的数据
 *
 *  @param startDate 开始时间
 *  @param endDate 结束时间
 *  @param dataType 数据时间
 *  @return
 */
-(NSMutableArray *)efGetBluetoothDataModelWithStartDate:(NSDate*)startDate WithendDate:(NSDate*)endDate withDataType:(NSString*)dataType{
    //查询查询条件 and (recordDate = %@
    if (dataType.length <=0 || dataType == nil) {
        dataType = @"";
    }
    NSPredicate *predicateCondition = [NSPredicate predicateWithFormat:@"dataType = %@  and (recordDate > %@ and  recordDate < %@)",dataType,startDate,endDate];
    NSString *key = @"recordDate";
    BOOL isAscending = YES;
    NSInteger limit = NSIntegerMax;
    NSMutableArray *bluetoothDataModelArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KBluetoothDataModel PredicateCondition:predicateCondition sortByKey:key limit:limit ascending:isAscending];
    return bluetoothDataModelArr;
}

/**
 *  删除指定的同步数据
 *
 *  @param LessonPlanModel
 *
 *  @return
 */
-(BOOL)efDeleteBluetoothDataModel:(BluetoothDataModel *)bluetoothDataModel{
    return  [[CoreDataManager shareInstance] deleteWithObject:bluetoothDataModel];
}

/**
 *  清空所有同步数据
 *
 *  @return
 */
-(BOOL)efDeleteAllBluetoothDataModel{
    BOOL flag = YES;
    for (BluetoothDataModel* bluetoothDataModel in [self efGetAllBluetoothDataModel]) {
        if (![self efDeleteBluetoothDataModel:bluetoothDataModel]) {
            flag = NO;
        }
    }
    return flag;
}



#pragma --mark-- 已经上课课程
//==============================================================================

/*已经上课课程*/

//==============================================================================
/**
 *  创建已上课程
 *
 *  @return HaveClassModel
 */
-(HaveClassModel*)efCraterHaveClassModel{
    HaveClassModel *haveClassModel = (HaveClassModel*)[[CoreDataManager shareInstance] CreateObjectWithTable:KHaveClassModel];
    return haveClassModel;
}
/**
 *  获取所有所有已经上课课程
 *
 *  @return [HaveClassModel]
 */
-(NSMutableArray*)efGetAllHaveClassModel{
    NSString *conditionStr = [NSString stringWithFormat:@"teacherId = '%@'",[HJUserManager shareInstance].user.uTeacherId];

    NSMutableArray *haveClassModelArr =[[CoreDataManager shareInstance] QueryObjectsWithTable:KHaveClassModel  condition:conditionStr sortByKey:@"startDate" limit:100 ascending:YES];
    return haveClassModelArr;
}

/**
 *  添加课程到已上课程列表中
 *
 *  @param HaveClassModel
 *
 *  @return
 */
-(BOOL)efAddHaveClassModel:(HaveClassModel *)classModel{
    BOOL isSuccess = NO;
    HaveClassModel *mo = [self efGetHaveClassModelDetailedWithclassId:classModel.classId andStart:classModel.startDate];
    if (mo) {
        if (!(mo == classModel)) {
            [self efDeleteHaveClassModel:mo];
            mo = classModel;
        }
    }
    isSuccess = [[CoreDataManager shareInstance] saveContext];
    return isSuccess;

}
/**
 *  根据课程ID获取详情
 *
 *  @param classID    课程ID
 *  @param startDate 开始上课时间
 *  @return
 */
-(HaveClassModel *)efGetHaveClassModelDetailedWithclassId:(NSString*)classId andStart:(NSDate*)startDate{
    //查询查询条件 and (recordDate = %@
    NSPredicate *predicateCondition = [NSPredicate predicateWithFormat:@"teacherId = %@ and classId = %@ and (startDate >= %@)",[HJUserManager shareInstance].user.uTeacherId,classId,startDate];
    NSString *key = @"startDate";
    BOOL isAscending = YES;
    NSInteger limit = NSIntegerMax;
    NSMutableArray *haveClassModelArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KHaveClassModel PredicateCondition:predicateCondition sortByKey:key limit:limit ascending:isAscending];
    if (haveClassModelArr.count > 0 ) {
        for (HaveClassModel *haveClassModel in haveClassModelArr) {
            if ([haveClassModel.classId isEqualToString:classId] && [haveClassModel.startDate compare:startDate] == NSOrderedSame) {
                
                return haveClassModel;
            }
        }
    }
    HaveClassModel *haveClassModel = [self efCraterHaveClassModel];
    return haveClassModel;
}

/**
 *  根据课程来源和上课状态获取课程
 *
 *  @param sourceType    来源类型 课程来源类型（1 课程表 ,2 自定义）
 *  @param scheduleStatus  课程状态
 *  @return
 */
-(NSMutableArray *)efGetHaveClassModelWithSourceType:(NSNumber*)sourceType andScheduleStatus:(NSString*)scheduleStatus{
    NSString *predicateFormat = nil;
    if ([sourceType intValue] == 0) {
        predicateFormat = [NSString stringWithFormat:@"classStatus = %@ and teacherId = %@",scheduleStatus,[HJUserManager shareInstance].user.uTeacherId];
    }else {
        predicateFormat = [NSString stringWithFormat:@"classStatus = %@ and scheduleType = %@ and teacherId = %@",scheduleStatus,sourceType,[HJUserManager shareInstance].user.uTeacherId];
    }
    //查询查询条件 and (recordDate = %@
    NSPredicate *predicateCondition = [NSPredicate predicateWithFormat:predicateFormat];
    NSString *key = @"startDate";
    BOOL isAscending = YES;
    NSInteger limit = NSIntegerMax;
    NSMutableArray *haveClassModelArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KHaveClassModel PredicateCondition:predicateCondition sortByKey:key limit:limit ascending:isAscending];
    
    return haveClassModelArr;
}








/**
 *  删除课程表信息
 *
 *  @param HaveClassModel
 *
 *  @return
 */
-(BOOL)efDeleteHaveClassModel:(HaveClassModel *)haveClassModel{
    return  [[CoreDataManager shareInstance] deleteWithObject:haveClassModel];
}



/**
 *  清空所有已上课信息
 *
 *  @return
 */
-(BOOL)efDeleteAllHaveClassModel{
    BOOL flag = YES;
    for (HaveClassModel* haveClassModel in [self efGetAllHaveClassModel]) {
        if (![self efDeleteHaveClassModel:haveClassModel]) {
            flag = NO;
        }
    }
    return flag;
}


#pragma --mark-- 保存的测试班级信息
//==============================================================================

/*成绩未上传成功上课班级列表*/

//==============================================================================
/**
 *  创建未上传记录对象
 *
 *  @return TestModel
 */
-(TestModel*)efCraterTestModel{
    TestModel *testModel = (TestModel*)[[CoreDataManager shareInstance] CreateObjectWithTable:KTestModel];
    return testModel;
}
/**
 *  获取所有未上传成绩的几率
 *
 *  @return [TestModel]
 */
-(NSMutableArray*)efGetAllTestModel{
    NSString *conditionStr = [NSString stringWithFormat:@"teacherId = '%@'",[HJUserManager shareInstance].user.uTeacherId];
    return  [[CoreDataManager shareInstance] QueryObjectsWithTable:KTestModel condition:conditionStr sortByKey:@"startTime" limit:1000 ascending:YES];
    
}

/**
 *  添加未上传的记录到数据库中
 *
 *  @param TestModel
 *
 *  @return
 */
-(BOOL)efAddTestModel:(TestModel *)testModel{
    BOOL isSuccess = NO;
    isSuccess = [[CoreDataManager shareInstance] saveContext];
    return isSuccess;
}

/**
 *  根据时间和班级id获取
 *
 *  @param classID    课程ID
 *  @param startDate 开始上课时间
 *  @return
 */
-(TestModel *)efGetTestModelDetailedWithclassId:(NSString*)classId andStart:(NSDate*)startDate{
    //查询查询条件 and (recordDate = %@
    NSPredicate *predicateCondition = [NSPredicate predicateWithFormat:@"classId = %@ and (startTime >= %@)",classId,startDate];
    NSString *key = @"startTime";
    BOOL isAscending = YES;
    NSInteger limit = NSIntegerMax;
    NSMutableArray *haveClassModelArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KHaveClassModel PredicateCondition:predicateCondition sortByKey:key limit:limit ascending:isAscending];
    if (haveClassModelArr.count > 0) {
        TestModel *testModel = [haveClassModelArr objectAtIndexWithSafety:0];
        return testModel;
    }
    TestModel *testModel = [self efCraterTestModel];
    return testModel;
}

/**
 *  删除测试记录
 *
 *  @param HaveClassModel
 *
 *  @return
 */
-(BOOL)efDeleteTestModel:(TestModel *)testModel{
    return  [[CoreDataManager shareInstance] deleteWithObject:testModel];
}

/**
 *  清空所有已上课信息
 *
 *  @return
 */
-(BOOL)efDeleteAllTestModel{
    BOOL flag = YES;
    for (TestModel* testModel in [self efGetAllTestModel]) {
        if (![self efDeleteTestModel:testModel]) {
            flag = NO;
        }
    }
    return flag;
}


#pragma --mark-- 保存的测试历史数据
//==============================================================================

/*保存的测试历史数据*/

//==============================================================================
/**
 *  创建所有测试历史数据
 *
 *  @return TestModel
 */
-(HistoryTestModel*)efCraterHistoryTestModel{
    HistoryTestModel *testModel = (HistoryTestModel*)[[CoreDataManager shareInstance] CreateObjectWithTable:KHistoryTestModel];
    return testModel;
}
/**
 *  获取所有测试历史
 *
 *  @return [TestModel]
 */
-(NSMutableArray*)efGetAllHistoryTestModel{
    NSString *conditionStr = [NSString stringWithFormat:@"teacherId = '%@'",[HJUserManager shareInstance].user.uTeacherId];
    return  [[CoreDataManager shareInstance] QueryObjectsWithTable:KHistoryTestModel condition:conditionStr sortByKey:nil limit:1000 ascending:nil];
}

/**
 *  添加测试历史数据
 *
 *  @param TestModel
 *
 *  @return
 */
-(BOOL)efAddHistoryTestModel:(HistoryTestModel *)historyTestModel{
    BOOL isSuccess = NO;
    HistoryTestModel *mo = [self efGetHistoryTestModelDetailedWithclassId:historyTestModel.teacherId andStart:historyTestModel.startDate];
    if (mo) {
        if (!(mo == historyTestModel)) {
            [self efDeleteHistoryTestModel:mo];
            mo = historyTestModel;
        }
    }
    isSuccess = [[CoreDataManager shareInstance] saveContext];
    return isSuccess;
}

/**
 *  根据时间和班级id获取
 *
 *  @param classID    课程ID
 *  @param startDate 开始上课时间
 *  @return
 */
-(HistoryTestModel *)efGetHistoryTestModelDetailedWithclassId:(NSString*)teachId andStart:(NSDate*)startDate{
    //查询查询条件 and (recordDate = %@
//    NSString *predicateStr = [NSString stringWithFormat:];
    NSPredicate *predicateCondition = [NSPredicate predicateWithFormat:@"(teacherId = %@) and (startDate >= %@)",[HJUserManager shareInstance].user.uTeacherId,startDate];
    BOOL isAscending = NO;
    NSInteger limit = NSIntegerMax;
    NSMutableArray *haveClassModelArr = [[CoreDataManager shareInstance] QueryObjectsWithTable:KHistoryTestModel PredicateCondition:predicateCondition sortByKey:nil limit:limit ascending:isAscending];
    if (haveClassModelArr.count > 0) {
        HistoryTestModel *historyTestModel = [haveClassModelArr objectAtIndexWithSafety:0];
        return historyTestModel;
    }
    HistoryTestModel *historyTestModel = [self efCraterHistoryTestModel];
    return historyTestModel;
}

/**
 *  删除测试历史数据
 *
 *  @param HaveClassModel
 *
 *  @return
 */
-(BOOL)efDeleteHistoryTestModel:(HistoryTestModel *)historyTestModel{
     return  [[CoreDataManager shareInstance] deleteWithObject:historyTestModel];
}


/**
 *  清空所有已测试历史数据
 *
 *  @return
 */
-(BOOL)efDeleteAllHistoryTestModel{
    BOOL flag = YES;
    for (HistoryTestModel* historyTestModel in [self efGetAllHistoryTestModel]) {
        if (![self efDeleteHistoryTestModel:historyTestModel]) {
            flag = NO;
        }
    }
    return flag;
}

@end
