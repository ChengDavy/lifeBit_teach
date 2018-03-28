//
//  HJUploadHeartDataVC.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/13.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJUploadHeartDataVC.h"
#import "HJClassInfo.h"
#import "HJUploadClassMsgCell.h"
#import "HJClassStudentVC.h"
#import "HJBluetoothDataInfo.h"
#import "NSDate+Categories.h"
#import "Singleton.h"

@interface HJUploadHeartDataVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *haveClassArr;

// 存储异常手环学生对象
@property (nonatomic,strong)NSMutableArray *exceptionWatchArr;

@end

@implementation HJUploadHeartDataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark 所有返回按钮响应
-(void)naviBack{
    if (self.synHeartSoureType == JRSynHeartSoureTypePerson) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
-(void)initialize{
    [self setNavigationBarTitleTextColor:@"上传心率数据"];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self getHaveClassList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getHaveClassList{
    self.haveClassArr = [[LifeBitCoreDataManager shareInstance] efGetAllHaveClassModel];
}

#pragma --mark-- UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.haveClassArr.count <= 0) {
        return 1;
    }
    return self.haveClassArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.haveClassArr.count <= 0) {
        HJEmptyCell *emptyCell = [[[NSBundle mainBundle] loadNibNamed:@"HJEmptyCell" owner:nil options:nil] lastObject];
        return emptyCell;
    }
    
    
    HJUploadClassMsgCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"HJUploadClassMsgCell" owner:nil options:nil] lastObject];
    HaveClassModel *haveClassModel = self.haveClassArr[indexPath.row];
    HJClassInfo *classInfo = [HJClassInfo createClassInfoWithHaveClassModel:haveClassModel];
    
    
//   判断指定班级是否同步数据
    NSDate *startDate = classInfo.cStartTime;
    NSTimeInterval timeInterval= [startDate timeIntervalSinceReferenceDate];
    timeInterval +=[classInfo.cClassTime integerValue] * 60;
    NSDate *endDate = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
    
    // 获取指定学生心率数据，并判断是否有异常
    
    NSLog(@"start = %@    end = %@", startDate, endDate);
    
    NSMutableArray * dataArr = [[LifeBitCoreDataManager shareInstance] efGetBluetoothDataModelWithStartDate:startDate WithendDate:endDate withDataType:@"1"];
    
    if (dataArr.count > 0) {
        cell.uploadBtn.backgroundColor = UIColorFromRGB(0x2876FE);
        cell.uploadBtn.enabled = YES;
    }else{
        cell.uploadBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color_VCBG"]];
        cell.uploadBtn.enabled = NO;
    }
    
    [cell updateSelfUi:classInfo];
    
    
    __weak typeof(self) weakSelf = self;
    [cell setTapUploadDataBlock:^(HJClassInfo *classInfo) {
        NSLog(@"点击了上传数据");
        if (![[HttpHelper JSONRequestManager] isNetWork]) {
            
            [weakSelf showErroAlertWithTitleStr:@"请在有网络的环境下，上传运动数据"];
            return ;
        }
        [self showNetWorkAlertWithTitleStr:@"上传中"];
        /*
         cClassId = 823;
         cClassName = "\U521d\U4e098\U73ed";
         cClassTime = 45;
         cGradeId = 9;
         cGradeName = "\U4e5d\U5e74\U7ea7";
         cLessonPlanId = 8a996bce582e16f801583c8bc9ba0005;
         cMaxRate = 200;
         cMinRate = 60;
         cScheduleType = 2;
         cStartTime = "2017-03-17 08:09:36 +0000";
         cStatus = 4;
         cTeacherId = 698;
         */
        NSMutableArray *studentDataArr = [weakSelf getWatchAssignWithType:1 andWithClassInfo:classInfo];
        
        [weakSelf netForSyncHeartContinueWatch:classInfo WithStudentData:studentDataArr];
    }];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.haveClassArr.count <= 0) {
        return self.tableView.bounds.size.height;
    }
    return 60;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma --mark-- 构建数据上传数据类型
-(NSMutableArray*)getWatchAssignWithType:(NSInteger)type andWithClassInfo:(HJClassInfo*)classInfo{
    NSMutableArray *classDataArr = [NSMutableArray array];
    NSMutableArray *studentInfoArr = [self getWatchDataAndClassInfo:classInfo];
    
        for (HJStudentInfo *studentInfo in studentInfoArr) {
  
             [classDataArr addObject:[self coverUploadDatasWithType:type tudentInfo:studentInfo]];
#warning --mark-- 此处以后做异常处理
        }
    return classDataArr;
}


-(NSDictionary *)coverUploadDatasWithType:(NSInteger)type tudentInfo:(HJStudentInfo*)studentInfo {
    
    NSMutableArray *countData= nil;
    if (type == 1 ) {
        countData = studentInfo.headDataArr;
        
    } else {
        countData = studentInfo.weakDataArr;
    }
    NSMutableData *typeData = [NSMutableData data];
    
    NSMutableDictionary *studentDic = [NSMutableDictionary dictionary];
    //            拼接每个学生的数据
    NSMutableString *attStr = [NSMutableString string];
    
    for (HJBluetoothDataInfo * bluetoothDataInfo in countData) {
        [typeData appendData:bluetoothDataInfo.recordDateData];
        [typeData appendData:bluetoothDataInfo.recordDataData];
        NSString *dateStr = [NSDate stringFromDate:bluetoothDataInfo.recordDate format:@"yyyy-MM-dd HH:mm:ss"];
        [attStr appendString:dateStr];
        [attStr appendString:@","];
        [attStr appendString:bluetoothDataInfo.recordData];
        [attStr appendString:@"\n"];
        Byte f4[] = {0xF4};
        [typeData appendBytes:f4 length:1];
    }
    
    NSLog(@"学校id ＝ %@ 学生姓名 ＝ %@ ， 学生数据 ＝ %@",studentInfo.studentId,studentInfo.studentName,attStr);
    if (typeData.length >1) {
        NSString* typeDataStr = [typeData base64EncodedStringWithOptions:0];
//        NSLog(@"%@",typeData);
        [studentDic setValue:typeDataStr forKey:(type == 1)?@"data":@"data"];
        [studentDic setValue:studentInfo.studentId forKey:@"studentId"];
        return studentDic;
    }
    [studentDic setValue:@"" forKey:(type == 1)?@"data":@"data"];
    [studentDic setValue:studentInfo.studentId forKey:@"studentId"];
    return studentDic;
}






#pragma --mark-- 根据index获取手环数据
// 获取手表的心率数据和步数数据没有问题的studentInfo对象
-(NSMutableArray*)getWatchDataAndClassInfo:(HJClassInfo*)classInfo {
    
    if (self.exceptionWatchArr == nil) {
        self.exceptionWatchArr = [NSMutableArray array];
    }
    // 删除记录的问题数据
    [self.exceptionWatchArr removeAllObjects];
    // 获取所有的手环
    NSMutableArray* watchMACArr = [[LifeBitCoreDataManager shareInstance] efGetAllWatchModel];
    // 根据班级获取所有学生数据
    NSMutableArray *classStudentArr = [[LifeBitCoreDataManager shareInstance] efGetClassAllStudentWith:classInfo.cClassId];
    
    NSMutableArray *studentArr = [NSMutableArray array];
    // 将所有学生的model转换成学生
    for (StudentModel*studentModel in classStudentArr) {
        
        HJStudentInfo *studentInfo = [HJStudentInfo createClassInfoWithStudentModel:studentModel];
        [studentArr addObject:studentInfo];
    }
    // 先按照姓排序(如果有相同的姓，就比较名字)
    NSArray * array2 = [studentArr sortedArrayUsingComparator:
                        ^NSComparisonResult(HJStudentInfo *obj1, HJStudentInfo *obj2) {
                            
                            if ([NSString isPureInt:obj1.studentNo] ) {
                                if ([obj1.studentNo integerValue] > [obj2.studentNo integerValue]) {
                                    return (NSComparisonResult)NSOrderedDescending;
                                } else if ([obj1.studentNo integerValue] < [obj2.studentNo integerValue]){
                                    return (NSComparisonResult)NSOrderedAscending;
                                } else {
                                    return (NSComparisonResult)NSOrderedSame;
                                }
                            }
                            
                            NSComparisonResult result = [obj1.studentNo compare:obj1.studentNo];
                            
                            if (result == NSOrderedAscending) {
                                result = [obj1.studentNo compare:obj2.studentNo];
                            }
                            return result;
                        }];
    
    
    
    NSMutableArray *sortStudentArr  = [array2 mutableCopy];
    
    NSMutableArray *successfulStudentArr = [NSMutableArray array];
    // 判断手表多还是学生多
    NSInteger count = 0;
    if (watchMACArr.count >= sortStudentArr.count) {
        count = sortStudentArr.count;
    }else{
        count = watchMACArr.count;
    }
    
    // 获取正常时间段内蓝牙手环应该记录数据心率数据的条数
    NSInteger secTime = [classInfo.cClassTime intValue] * 60;
    // 每秒记录5条数据
    NSInteger recordCount = secTime / 5;
    NSInteger maxRecordCount = recordCount * 1.2;
    NSInteger minRecordCount = recordCount * 0.8;
    
    for (int i = 0; i < count; i++) {
        HJStudentInfo * studentInfo = sortStudentArr[i];

        BOOL isNot = [self isNotClass:classInfo callOvew:studentInfo]; //判断是否参加上课，未上课无数据
        if (!isNot) {
            continue;  // 如果未点名，说明就无数据，点名了就有数据
        }
        // 初始化心率数组和步数数组
        studentInfo.headDataArr = [NSMutableArray array];
        studentInfo.weakDataArr = [NSMutableArray array];
        // 获取手环对象
        WatchModel *watchModel =  [watchMACArr objectAtIndexWithSafety:i];
        
        NSDate *startDate = classInfo.cStartTime;
        
        NSTimeInterval timeInterval= [startDate timeIntervalSinceReferenceDate];
        timeInterval +=[classInfo.cClassTime integerValue] * 60;
        NSDate *endDate = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
        // 获取指定学生心率数据，并判断是否有异常
        NSMutableArray * dataArr = [[LifeBitCoreDataManager shareInstance] efGetBluetoothDataModelWithStartDate:startDate WithendDate:endDate withDataType:@"1" withMAC:watchModel.watchMAC];
        
        NSLog(@"watchModel: %@,  mac:%@", watchModel, watchModel.watchMAC);

        
        // 判断数据是否正常（大于正常数据的1.2倍 或者小于正常倍数的0.8倍 ，其余需要造加数据）
        if (dataArr.count < maxRecordCount && dataArr.count > minRecordCount) {
            for (BluetoothDataModel *bluetoothDataModel in dataArr) {
                
                HJBluetoothDataInfo *bluetoothDataInfo = [HJBluetoothDataInfo createBluetoothDataInfoWithBluetoothDataModel:bluetoothDataModel];
                [studentInfo.headDataArr addObject:bluetoothDataInfo];
            }
             [successfulStudentArr addObject:studentInfo];
        } else {
            
#warning --mark-- 记录学生有问题的数据
            if (dataArr.count < minRecordCount) {
                
                [self.exceptionWatchArr addObject:studentInfo];
              //  [self uploadExceptionWatchWithMac:watchModel.watchMAC andExcType:0];
                NSLog(@"参加上课没有记录数据");
            }else if(dataArr.count > maxRecordCount){
//                大于正常数据，删除多余的数据
            }
        }
        
        
//       获取指定步数数据，并判断是否有异常
        NSMutableArray * dataArr1 = [[LifeBitCoreDataManager shareInstance] efGetBluetoothDataModelWithStartDate:startDate WithendDate:endDate withDataType:@"2" withMAC:watchModel.watchMAC];
        
        for (BluetoothDataModel *bluetoothDataModel in dataArr1) {
            HJBluetoothDataInfo *bluetoothDataInfo = [HJBluetoothDataInfo createBluetoothDataInfoWithBluetoothDataModel:bluetoothDataModel];
            [studentInfo.weakDataArr addObject:bluetoothDataInfo];
        }
        
    }
    
    
    
    return successfulStudentArr;
}

#pragma --mark-- 获取未点名的学生
-(NSMutableArray*)getNotClassStudent:(HJClassInfo*)classInfo{
    NSMutableArray *notStudentModelArr =  [[LifeBitCoreDataManager shareInstance] efGetClassAllNotStudentModelWith:classInfo.cClassId withStartDate:classInfo.cStartTime];
    NSMutableArray *notArr = [NSMutableArray array];
    for (NotStudentModel*notSudentModel in notStudentModelArr) {
        HJStudentInfo* studentInfo = [HJStudentInfo createStudentInfoWithNotStudentModel:notSudentModel];
        [notArr addObject:studentInfo];
        NSLog(@"name = %@",notSudentModel.studentName);
        NSLog(@"studentNo = %@",notSudentModel.studentNo);
        NSLog(@"sStartTime = %@",notSudentModel.sStartTime);
        NSLog(@"sClassName = %@",notSudentModel.sClassName);
    }
    
    return notArr;

}

-(NSMutableArray*)getClassAverageHear:(HJClassInfo*)classInfo withStudentMac:(NSString*)macStr{
//    存储正常心率学生
    NSMutableArray *averagerHearArr = [NSMutableArray array];
    NSMutableArray *normalHearArr = [NSMutableArray array];
    NSMutableArray* watchMACArr = [[LifeBitCoreDataManager shareInstance] efGetAllWatchModel];
    NSMutableArray *classStudentArr = [[LifeBitCoreDataManager shareInstance] efGetClassAllStudentWith:classInfo.cClassId];
    NSMutableArray *studentArr = [NSMutableArray array];
    for (StudentModel*studentModel in classStudentArr) {
        HJStudentInfo *studentInfo = [HJStudentInfo createClassInfoWithStudentModel:studentModel];
        [studentArr addObject:studentInfo];
    }
    // 指定排序的比较方法
//    NSSortDescriptor *studentNoDesc = [NSSortDescriptor sortDescriptorWithKey:@"studentNo" ascending:YES];
//    
//    NSArray *descs = @[studentNoDesc];
//    NSArray *array2 = [studentArr sortedArrayUsingDescriptors:descs];
    NSArray *array2 = [studentArr sortedArrayUsingComparator:
                       ^NSComparisonResult(HJStudentInfo *obj1, HJStudentInfo *obj2) {
                           if ([NSString isPureInt:obj1.studentNo] ) {
                               if ([obj1.studentNo integerValue] > [obj2.studentNo integerValue]) {
                                   return (NSComparisonResult)NSOrderedDescending;
                               }else if ([obj1.studentNo integerValue] < [obj2.studentNo integerValue]){
                                   return (NSComparisonResult)NSOrderedAscending;
                               }
                               else
                                   return (NSComparisonResult)NSOrderedSame;
                           }
                           // 先按照姓排序
                           NSComparisonResult result = [obj1.studentNo compare:obj1.studentNo];
                           // 如果有相同的姓，就比较名字
                           if (result == NSOrderedAscending) {
                               result = [obj1.studentNo compare:obj2.studentNo];
                           }
                           
                           return result;
                       }];
    NSMutableArray *sortStudentArr  = [array2 mutableCopy];
    
    NSInteger count = 0;
    if (watchMACArr.count >= sortStudentArr.count) {
        count = sortStudentArr.count;
    }else{
        count = watchMACArr.count;
    }
    //    获取正常时间段内蓝牙手环应该记录数据心率数据的条数
    NSInteger secTime = [classInfo.cClassTime intValue] * 60;
    NSInteger recordCount = secTime/5 - (secTime/5 * 0.2);
    for (int  i = 0;i < count; i++) {
        HJStudentInfo*studentInfo = sortStudentArr[i];
        studentInfo.headDataArr = [NSMutableArray array];
        studentInfo.weakDataArr = [NSMutableArray array];
        WatchModel *watchModel =  [watchMACArr objectAtIndexWithSafety:i];
        NSDate *startDate = classInfo.cStartTime;
        NSTimeInterval timeInterval= [startDate timeIntervalSinceReferenceDate];
        timeInterval +=[classInfo.cClassTime integerValue] * 60;
        NSDate *endDate = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
        //       获取指定学生心率数据，并判断是否有异常
        NSMutableArray * dataArr = [[LifeBitCoreDataManager shareInstance] efGetBluetoothDataModelWithStartDate:startDate WithendDate:endDate withDataType:@"1" withMAC:watchModel.watchMAC];
        
//        取出心率正常的的学生
        if (dataArr.count >= recordCount) {
            for (BluetoothDataModel *bluetoothDataModel in dataArr) {
                HJBluetoothDataInfo *bluetoothDataInfo = [HJBluetoothDataInfo createBluetoothDataInfoWithBluetoothDataModel:bluetoothDataModel];
                [studentInfo.headDataArr addObject:bluetoothDataInfo];
            }
             [normalHearArr addObject:studentInfo];
        }else{
            //                上传异常
         //    [self uploadExceptionWatchWithMac:macStr andExcType:0];
        }
       
    }
    
    
        for (int i = 0; i < recordCount; i++) {
            if (i == recordCount - 1) {
                
            }
            HJBluetoothDataInfo * averagerDataInfo = [[HJBluetoothDataInfo alloc] init];
            int sumHear = 0;
            for (int j = 0; j < normalHearArr.count; j++) {
                HJStudentInfo *s = normalHearArr[j];
                HJBluetoothDataInfo * bluetoothDataInfo = s.headDataArr[i];
                sumHear += [bluetoothDataInfo.recordData integerValue];
                if (normalHearArr.count - 1 == j) {
                    averagerDataInfo.recordDate = bluetoothDataInfo.recordDate;
                    averagerDataInfo.recordDateData = bluetoothDataInfo.recordDateData;
                    averagerDataInfo.dataType = bluetoothDataInfo.dataType;
                }
            }
            NSInteger averagerHear = sumHear/normalHearArr.count;
            averagerDataInfo.recordData = [NSString stringWithFormat:@"%ld",averagerHear];
            
//            十进制转换成16进制字符串
            NSString *hexStr = [self ToHex:averagerHear];
//            16进制字符串转换成NSData
            averagerDataInfo.recordDataData = [self convertHexStrToData:hexStr];
            
            [averagerHearArr addObject:averagerDataInfo];
        }

    return averagerHearArr;
}


#pragma --mark-- 十进制转16进制

-(NSString *)ToHex:(long long int)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%i",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;  
        }  
        
    }  
    return str;  
}


//字符串转16进制
- (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    return hexData;
}


#pragma --mark-- 判断学生是否点名
-(BOOL)isNotClass:(HJClassInfo*)classInfo  callOvew:(HJStudentInfo*)studentInfo{
    NSMutableArray *notStudentArr = [self getNotClassStudent:classInfo];
    BOOL isNot = YES;
    for (HJStudentInfo *s in notStudentArr) {
        if ([studentInfo.studentId isEqualToString:s.studentId]) {
            isNot = NO;
        }
    }
    return isNot;
    
}


#pragma --mark-- 网络上传数据

-(void)netForSyncHeartContinueWatch:(HJClassInfo*)classInfo WithStudentData:(NSMutableArray*)studentDataArr {
    
    [[Singleton sharedInstance] setIsUploading:YES];
    
    // 获取ipad对应的所有手表
    NSMutableArray* watchMACArr = [[LifeBitCoreDataManager shareInstance] efGetAllWatchModel];
    // 获取班级所有学生
    NSMutableArray *classStudentArr = [[LifeBitCoreDataManager shareInstance] efGetClassAllStudentWith:classInfo.cClassId];
    // model转换成studnetinfo
    NSMutableArray *studentArr = [NSMutableArray array];
    for (StudentModel*studentModel in classStudentArr) {
        HJStudentInfo *studentInfo = [HJStudentInfo createClassInfoWithStudentModel:studentModel];
        [studentArr addObject:studentInfo];
    }
    // 将所有学生按学号进行排序
    NSArray *array2 = [studentArr sortedArrayUsingComparator:
                       ^NSComparisonResult(HJStudentInfo *obj1, HJStudentInfo *obj2) {
                           if ([NSString isPureInt:obj1.studentNo] ) {
                               if ([obj1.studentNo integerValue] > [obj2.studentNo integerValue]) {
                                   return (NSComparisonResult)NSOrderedDescending;
                               } else if ([obj1.studentNo integerValue] < [obj2.studentNo integerValue]){
                                   return (NSComparisonResult)NSOrderedAscending;
                               } else {
                                   return (NSComparisonResult)NSOrderedSame;
                               }
                           }
                           // 先按照姓排序
                           NSComparisonResult result = [obj1.studentNo compare:obj1.studentNo];
                           // 如果有相同的姓，就比较名字
                           if (result == NSOrderedAscending) {
                               result = [obj1.studentNo compare:obj2.studentNo];
                           }
                           return result;
                       }];
    NSMutableArray *sortStudentArr  = [array2 mutableCopy];
    //遍历有异常的手表
    for (HJStudentInfo*studentInfo in self.exceptionWatchArr) {
        int indexTag = -1;
        for (int i = 0; i < sortStudentArr.count; i++) {
            HJStudentInfo *s = sortStudentArr[i];
            if ([s.studentId isEqualToString:studentInfo.studentId]) {
                indexTag = i;
                continue;
            }  
        }
        if (indexTag >= 0) {
            WatchModel *watchModel = [watchMACArr objectAtIndex:indexTag];
            //                小于正常数据，做数据补全
            studentInfo.headDataArr = [self getClassAverageHear:classInfo withStudentMac:watchModel.watchMAC];
           
            [studentDataArr addObject: [self coverUploadDatasWithType:1 tudentInfo:studentInfo]];
            //                上传异常
            [self uploadExceptionWatchWithMac:watchModel.watchMAC andExcType:0];
        }
    }
    
    NSString *startDateStr = [NSDate stringFromDate:classInfo.cStartTime format:@"yyyy-MM-dd HH:mm:ss"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:studentDataArr forKey:@"headData"];
    [parameters setValue:classInfo.cClassId forKey:@"classId"];
    [parameters setValue:startDateStr forKey:@"courseStartTime"];
    [parameters setValue:[classInfo.cClassTime stringValue] forKey:@"courseLong"];
    [parameters setValue:classInfo.cScheduleId forKey:@"courseId"];
    [parameters setValue:classInfo.cLessonPlanId forKey:@"bookId"];
    
    [self POST:KaddHeartRate parameters:parameters andSuccess:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] intValue] == 1) {
            [self deleteBluetoothDataWithClass:classInfo withType:@"1"];
            NSMutableArray *studentDataArr = [self getWatchAssignWithType:2 andWithClassInfo:classInfo];
            
            NSString *course_idStr = [NSString stringAwayFromNSNULL:[responseObject objectForKey:@"course_id"]];
            [self netForSyncWeakWatch:classInfo WithStudentData:studentDataArr withCourseId:course_idStr];
        }else{
            [self showErroAlertWithTitleStr:[NSString stringAwayFromNSNULL:[responseObject objectForKey:@"message"]]];
        }
        
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


// 上传步数的数据
-(void)netForSyncWeakWatch:(HJClassInfo*)classInfo WithStudentData:(NSArray*)studentDataArr withCourseId:(NSString*)courseId {
    
    NSString *startDateStr = [NSDate stringFromDate:classInfo.cStartTime format:@"yyyy-MM-dd HH:mm:ss"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:studentDataArr forKey:@"headData"];
    [parameters setValue:classInfo.cClassId forKey:@"classId"];
    [parameters setValue:startDateStr forKey:@"courseStartTime"];
    [parameters setValue:[classInfo.cClassTime stringValue] forKey:@"courseLong"];
    [parameters setValue:courseId forKey:@"courseId"];
    [parameters setValue:classInfo.cLessonPlanId forKey:@"bookId"];
    
    [self POST:KaddWatchSport parameters:parameters andSuccess:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        
        if ([[responseObject objectForKey:@"success"] intValue] == 1) {
            [self deleteBluetoothDataWithClass:classInfo withType:@"2"];
            
            [self.haveClassArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                HaveClassModel *haveClassModel =(HaveClassModel *)obj;
                if ([haveClassModel.classId isEqualToString:classInfo.cClassId] && [classInfo.cStartTime compare:haveClassModel.startDate] == NSOrderedSame) {
                    [[LifeBitCoreDataManager shareInstance] efDeleteHaveClassModel:haveClassModel];
                    *stop = YES;
                    
                    if (*stop == YES) {
                        [self.haveClassArr removeObject:haveClassModel];
                    }
                }
                if (*stop) {                    
                }
                
            }];
            
            NSMutableArray *notStudentArr =  [self getNotClassStudent:classInfo];
            for (HJStudentInfo *studentInfo in notStudentArr) {
                NotStudentModel *notStudentModel = [HJStudentInfo convertStudentInfoWithNotStudentModel:studentInfo];
                [[LifeBitCoreDataManager shareInstance] efDeleteNotStudentModel:notStudentModel];
            }
        
//        所有数据上传完  清除相关数据库中所有的数据
        if (self.haveClassArr.count <= 0) {
            [[LifeBitCoreDataManager shareInstance] efDeleteAllBluetoothDataModel];
            [[LifeBitCoreDataManager shareInstance] efDeleteAllNotStudentModel];
            [[LifeBitCoreDataManager shareInstance] efDeleteAllHaveClassModel];
        }
        
            [self.tableView reloadData];
            
            if (self.synHeartSoureType == JRSynHeartSoureTypePerson) {
                [self showSuccessAlertAndPopVCWithTitleStr:@"上传成功"];
            }else{
                [self showSuccessAlertWithTitleStr:@"上传成功"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            [[Singleton sharedInstance] setIsUploading:NO];

        }else{
            [self showErroAlertWithTitleStr:@"数据错误"];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


// 上传异常类型
-(void)uploadExceptionWatchWithMac:(NSString*)mac andExcType:(NSInteger)excType{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:mac forKey:@"MAC_ID"];
    NSString * remarkStr = nil;
    switch (excType) {
        case 0:
            remarkStr = @"手表收集数据异常";
            break;
            
        default:
            break;
    }
    [parameters setValue:remarkStr forKey:@"REMARK"];
    [self POST:KuploadException parameters:parameters andSuccess:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

// 根据班级id删除指定班级的数据
-(void)deleteBluetoothDataWithClass:(HJClassInfo*)classInfo withType:(NSString*)type{
    NSMutableArray* watchMACArr = [[LifeBitCoreDataManager shareInstance] efGetAllWatchModel];
    NSMutableArray *classStudentArr = [[LifeBitCoreDataManager shareInstance] efGetClassAllStudentWith:classInfo.cClassId];
    NSMutableArray *studentArr = [NSMutableArray array];
    for (StudentModel*studentModel in classStudentArr) {
        HJStudentInfo *studentInfo = [HJStudentInfo createClassInfoWithStudentModel:studentModel];
        [studentArr addObject:studentInfo];
    }
    // 指定排序的比较方法
//    NSSortDescriptor *studentNoDesc = [NSSortDescriptor sortDescriptorWithKey:@"studentNo" ascending:YES];
//    
//    NSArray *descs = @[studentNoDesc];
//    NSArray *array2 = [studentArr sortedArrayUsingDescriptors:descs];
    NSArray *array2 = [studentArr sortedArrayUsingComparator:
                       ^NSComparisonResult(HJStudentInfo *obj1, HJStudentInfo *obj2) {
                           if ([NSString isPureInt:obj1.studentNo] ) {
                               if ([obj1.studentNo integerValue] > [obj2.studentNo integerValue]) {
                                   return (NSComparisonResult)NSOrderedDescending;
                               }else if ([obj1.studentNo integerValue] < [obj2.studentNo integerValue]){
                                   return (NSComparisonResult)NSOrderedAscending;
                               }
                               else
                                   return (NSComparisonResult)NSOrderedSame;
                           }
                           // 先按照姓排序
                           NSComparisonResult result = [obj1.studentNo compare:obj1.studentNo];
                           // 如果有相同的姓，就比较名字
                           if (result == NSOrderedAscending) {
                               result = [obj1.studentNo compare:obj2.studentNo];
                           }
                           
                           return result;
                       }];
    NSMutableArray *sortStudentArr  = [array2 mutableCopy];
    
    NSInteger count = 0;
    if (watchMACArr.count >= sortStudentArr.count) {
        count = sortStudentArr.count;
    }else{
        count = watchMACArr.count;
    }
    
    for (int  i = 0;i < count; i++) {
        HJStudentInfo*studentInfo = sortStudentArr[i];
        studentInfo.headDataArr = [NSMutableArray array];
        studentInfo.weakDataArr = [NSMutableArray array];
        WatchModel *watchModel =  [watchMACArr objectAtIndexWithSafety:i];
        NSDate *startDate = classInfo.cStartTime;
        NSTimeInterval timeInterval= [startDate timeIntervalSinceReferenceDate];
        timeInterval +=[classInfo.cClassTime integerValue] * 60;
        NSDate *endDate = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
        NSMutableArray * dataArr = [[LifeBitCoreDataManager shareInstance] efGetBluetoothDataModelWithStartDate:startDate WithendDate:endDate withDataType:type withMAC:watchModel.watchMAC];
        for (BluetoothDataModel *bluetoothDataModel in dataArr) {
            [[LifeBitCoreDataManager shareInstance] efDeleteBluetoothDataModel:bluetoothDataModel];
        }
    
    }
}

@end
