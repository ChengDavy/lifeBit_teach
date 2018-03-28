//
//  JRCallNameVC.m
//  lifeBit_teach
//
//  Created by joyskim-ios1 on 16/9/7.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "JRCallNameVC.h"
#import "HJCallOverView.h"
#import "HJStartClassVC.h"
#import "HJStudentInfo.h"
#import "AppDelegate.h"
#import "HJCallOverBtn.h"

@interface JRCallNameVC ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet HJCallOverView *callOverView;

// 学生数组
@property (nonatomic,strong)NSMutableArray *studentArr;

@property (nonatomic,assign)BOOL isAllSelect;

@end

@implementation JRCallNameVC
// 取消点名重置所有的手表状态
-(void)dealloc{
//    [[HJBluetootManager shareInstance] buyBackAllSyncWatchStatus];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}



-(void)initialize{
    [self setNavigationBarTitleTextColor:@"点名"];
    
    for (LBWatchPerModel* watch in [HJBluetootManager shareInstance].blueTools.scanWatchArray) {
        watch.type = LBWatchTypeUnConnected;
        watch.syncType = AMLBSyncTypeNotWorking;
    }
    
    self.isAllSelect = NO;
    //设置右键按钮
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"全部点名" style:UIBarButtonItemStyleDone target:self action:@selector(callAllStudentNameClick)];
    rightBtn.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
     [[HJAppObject sharedInstance] storeCode:@"callOver" andValue:@"2"];
    // 筛选出点名的学生
    NSMutableArray *callOverArr = [self efFilterCallOverStudent:self.startClassInfo.cClassId];
    
    // 更新ui
    [self.callOverView showStudentView:self.studentArr withCallOverArr:callOverArr];
    
    __weak typeof(self) weakSelf = self;
    [self.callOverView setStartClassTapBlock:^{
        // 判断是否点名
        if (weakSelf.callOverView.callOverArr == nil || weakSelf.callOverView.callOverArr.count <= 0) {
            [self showErroAlertWithTitleStr:@"开始上课请先点名"];
            return ;
        }
        
        // 筛选出未点名的学生
        NSMutableString *str = [NSMutableString string];
        for (HJStudentInfo *stu in weakSelf.studentArr) {
            BOOL isCun = NO;
            for (HJStudentInfo* stu1 in weakSelf.callOverView.callOverArr) {
                if ([stu.studentId isEqualToString:stu1.studentId]) {
                    isCun = YES;
                }
            }
            if (!isCun) {
                if (str.length > 0) {
                    [str appendString:@","];
                }
                [str appendString:stu.studentName];
                
            }
        }
        if (str.length > 0) {
            NSString *tishiStr = [NSString stringWithFormat:@"%@等人未参加上课，是否继续上课？",str];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:tishiStr delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            alertView.tag = 2000;
            [alertView show];
            return;
        }
        
        
        // 开始上课
        [self startClassBeginsClick];
        
        
        
        
    }];

}

-(void)callAllStudentNameClick{
    
    if (!self.isAllSelect) {
        self.callOverView.callOverArr = [self.studentArr mutableCopy];
    }else{
        self.callOverView.callOverArr = [NSMutableArray array];
    }
    
//    self.isAllSelect = !self.isAllSelect;
    
}


// 开始上课
-(void)startClassBeginsClick{
    for (HJStudentInfo *s in self.studentArr) {
        if (![self.callOverView.callOverArr containsObject:s]) {
            NotStudentModel *notStudentModel = [HJStudentInfo convertStudentInfoWithNotStudentModel:s];
            notStudentModel.sStartTime = self.startClassInfo.cStartTime;
            notStudentModel.teacherId = [HJUserManager shareInstance].user.uTeacherId;
            [[LifeBitCoreDataManager shareInstance] efAddNotStudentModel:notStudentModel];
        }
    }
    
    NSMutableArray *notStudentModelArr =  [[LifeBitCoreDataManager shareInstance] efGetClassAllNotStudentModelWith:self.startClassInfo.cClassId withStartDate:self.startClassInfo.cStartTime];
    for (NotStudentModel*notSudentModel in notStudentModelArr) {
        NSLog(@"name = %@",notSudentModel.studentName);
        NSLog(@"studentNo = %@",notSudentModel.studentNo);
        NSLog(@"sStartTime = %@",notSudentModel.sStartTime);
        NSLog(@"sClassName = %@",notSudentModel.sClassName);
    }
    HJStartClassVC *startClassVc = [[HJStartClassVC alloc] init];
    startClassVc.inClassInfo = self.startClassInfo;
    startClassVc.studentArr = self.studentArr;
    startClassVc.signInStudentArr = self.callOverView.callOverArr;
    [self.navigationController pushViewController:startClassVc animated:YES];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2000) {
        if (buttonIndex == 1) {
             [self startClassBeginsClick];
        }
    }
}



-(void)naviBack{
//    后退重新搜索蓝牙
   // [[HJBluetootManager shareInstance] refreshScanAllWatch];
    //     记录上课中页面
    AppDelegate *app =(AppDelegate*) [UIApplication sharedApplication].delegate;
    app.inClassVC = self;
   
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
// 更改记录的课程上课状态
-(void)changerClassStatus:(NSString*)status{
    NSMutableArray *haveClassArr = [[LifeBitCoreDataManager shareInstance] efGetAllHaveClassModel];
    for (HaveClassModel *haveClassModel in haveClassArr) {
        if (([haveClassModel.scheduleId isEqualToString:self.startClassInfo.cScheduleId] || (haveClassModel.scheduleId == nil || self.startClassInfo.cScheduleId == nil)) && [haveClassModel.startDate compare:self.startClassInfo.cStartTime] == NSOrderedSame){
            [[LifeBitCoreDataManager shareInstance] efDeleteHaveClassModel:haveClassModel];
        }
    }
    self.startClassInfo.cStatus = status;
    HaveClassModel *haveClassModel = [HJClassInfo conversionClassInfoWithHaveClassModel:self.startClassInfo];
    [[LifeBitCoreDataManager shareInstance] efAddHaveClassModel:haveClassModel];
}

// 更改记录课程表的状态
-(void)changerScheduleStatus:(NSString*)status{
    self.startClassInfo.cStatus = status;
    ScheduleModel *scheduleModel = [HJClassInfo conversionScheduleModelWithClassInfo:self.startClassInfo];
    [[LifeBitCoreDataManager shareInstance] efAddScheduleModel:scheduleModel];
}

-(NSMutableArray *)studentArr{
    if (_studentArr == nil) {
        _studentArr = [NSMutableArray array];
        NSMutableArray *classStudentArr = [[LifeBitCoreDataManager shareInstance] efGetClassAllStudentWith:self.startClassInfo.cClassId];
        for (StudentModel*studentModel in classStudentArr) {
            HJStudentInfo *studentInfo = [HJStudentInfo createClassInfoWithStudentModel:studentModel];
            
//            NSLog(@",studentInfo.studentNo  %@",studentInfo.studentNo);
//
            [_studentArr addObject:studentInfo];
        }
        
        
        // 利用block进行排序
        NSArray *array2 = [_studentArr sortedArrayUsingComparator:
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

        _studentArr = [array2 mutableCopy];
        // 指定排序的比较方法
//        NSSortDescriptor *studentNoDesc = [NSSortDescriptor sortDescriptorWithKey:@"studentNo" ascending:YES];
//        NSArray *descs = @[studentNoDesc];
//        NSArray *array2 = [_studentArr sortedArrayUsingDescriptors:descs];
        
    }
    return _studentArr;
}




@end
