//
//  HJTestStudentVC.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/6.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJTestStudentVC.h"
#import "HJTestStudentCell.h"
#import "HJInputScoreView.h"
#import "AppDelegate.h"
#import "HJMeterTimeVC.h"
#import "HJUploadScoreErrorView.h"
#import "HJInputTimeScoreView.h"
#import "HJStudentInfo.h"

@interface HJTestStudentVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet HJPageView *pageView;

@property (weak, nonatomic) IBOutlet UIView *classNameBgView;

// 所有学生数组
@property (nonatomic,strong) NSMutableArray *studentArr;
//显示学生数组
@property (nonatomic,strong) NSMutableArray *showStudentArr;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLb;
@property (weak, nonatomic) IBOutlet UILabel *projectUnitLb;

// 选中学生数组
@property (nonatomic,strong) NSMutableArray *selectStudentArr;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HJTestStudentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


-(void)initialize{
    [self setNavigationBarTitleTextColor:@"学生列表"];
    self.classNameBgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color_VCBG"]];
    
    
    
    __weak typeof(self) weakSelf = self;
    [self.pageView setTapPageClickBlock:^(NSInteger selectIndex, UIButton *selectBtn) {
        [weakSelf refreshStudentWithSex:selectIndex];
    }];
    self.pageView.pageItemArr = @[@"全部学生",@"男生",@"女生"];
    
    self.projectNameLb.text = [NSString stringWithFormat:@"%@%@-%@",self.classInfo.cGradeName,self.classInfo.cClassName,self.projectInfo.pProjectName];
    self.projectUnitLb.text = [NSString stringWithFormat:@"单位：%@",self.projectInfo.pProjectUnit];
    
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存成绩到本地" style:UIBarButtonItemStyleDone target:self action:@selector(tapRightBtnClick)];
    rightBtn.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

-(void)refreshStudentWithSex:(NSInteger)sexIndex{
    [self.showStudentArr removeAllObjects];
    if (sexIndex == 1) {
        
        self.showStudentArr = [self.studentArr mutableCopy];
        
    }else if (sexIndex == 2) {
        
        for (HJStudentInfo*studentInfo in self.studentArr) {
            if ([studentInfo.sSex intValue] == 1) {
                [self.showStudentArr addObject:studentInfo];
            }
        }
        
    }else if (sexIndex ==3){
        
        for (HJStudentInfo*studentInfo in self.studentArr) {
            if ([studentInfo.sSex intValue] == 2) {
                [self.showStudentArr addObject:studentInfo];
            }
        }
        
    }
    
    [self.tableView reloadData];
    
}



-(NSMutableArray *)studentArr{
    if (_studentArr == nil) {
        _studentArr = [NSMutableArray array];
        NSMutableArray *classStudentArr = [[LifeBitCoreDataManager shareInstance] efGetClassAllStudentWith:self.classInfo.cClassId];
        for (StudentModel*studentModel in classStudentArr) {
            HJStudentInfo *studentInfo = [HJStudentInfo createClassInfoWithStudentModel:studentModel];
            studentInfo.sScoreArr = [NSMutableArray array];
            [_studentArr addObject:studentInfo];
        }
        // 指定排序的比较方法
//        NSSortDescriptor *studentNoDesc = [NSSortDescriptor sortDescriptorWithKey:@"studentNo" ascending:YES];
//        NSArray *descs = @[studentNoDesc];
//        NSArray *array2 = [_studentArr sortedArrayUsingDescriptors:descs];
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
        self.showStudentArr = [array2 mutableCopy];
    }
    return _studentArr;
}

-(NSMutableArray *)selectStudentArr{
    if (_selectStudentArr == nil) {
        _selectStudentArr = [NSMutableArray array];
    }
    return _selectStudentArr;
}


#pragma --mark-- 点击方法
-(void)tapRightBtnClick{
    [self saveAllStudentScoreLocain];
}
// 使用计时器
- (IBAction)tapTimeTestClick:(UIButton *)sender {
    NSMutableString *stuNmaeStr = [NSMutableString string];
    for (HJStudentInfo *stu in self.selectStudentArr) {
        if (stu.sScoreArr.count >= 5) {
            if (stuNmaeStr.length > 0) {
                [stuNmaeStr appendString:@","];
            }
            [stuNmaeStr appendString:stu.studentName];
        }
    }
    
    
    
    
    if (stuNmaeStr.length > 0) {
        NSString *msgStr = [NSString stringWithFormat:@"%@等同学不能添加新成绩",stuNmaeStr];
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"温馨提示" message:msgStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    HJMeterTimeVC *meterTimeVc = [[HJMeterTimeVC alloc] init];
    meterTimeVc.projectInfo = self.projectInfo;
    meterTimeVc.studentArr = self.selectStudentArr;
    [self.navigationController pushViewController:meterTimeVc animated:YES];
}

// 上传成绩
- (IBAction)uploadStudentScoreClick:(UIButton *)sender {
    NSMutableString *studentScoreStr = [NSMutableString  string];
    int count1 = 0;
    for (HJStudentInfo *studentInfo in self.studentArr) {
        if (studentInfo.sScoreArr == nil || studentInfo.sScoreArr.count <= 0) {
            [studentScoreStr appendString:studentInfo.studentName];
            count1++;
            if (studentScoreStr.length > 0) {
                [studentScoreStr appendString:@","];
            }
        }
    }
    
    if (studentScoreStr.length > 0) {
        NSString *messStr = nil;
        if (count1 == self.studentArr.count) {
            messStr = @"请先录入学生成绩，然后上传学校";
            [self showErroAlertWithTitleStr:messStr];
            return;
        }else{
            messStr = [NSString stringWithFormat:@"%@等同学没有录入成绩，确认要保存吗？",studentScoreStr];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:messStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
            alertView.tag = 2000;
            [alertView show];
            return;
        }
        
        

    }
    
    
    if (![HttpHelper JSONRequestManager].isNetWork) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"没有网络，请将成绩保存到本地，等有网络在上传。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
        alertView.tag = 2000;
        [alertView show];
        return;
    }
    [self uploadScoreClick];

}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2000) {
        if (buttonIndex == 0) {
            
        }else if (buttonIndex == 1){
            [self saveAllStudentScoreLocain];
        }
    }else if(alertView.tag == 200){
        if (buttonIndex == 1){
            [self saveScoreClick];
        }
    }
    
}
#pragma --mark-- UITableViewDataSource UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.showStudentArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJTestStudentCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"HJTestStudentCell" owner:nil options:nil] lastObject];
    
    __weak typeof(self) weakSelf = self;
//    选择学生
    [cell setSelectOrExitStudentBlock:^(HJTestStudentCell *testStudentCell, HJStudentInfo *selectStudent, UIButton *sender) {
        if ([weakSelf.selectStudentArr containsObject:selectStudent]) {
            [sender setImage:[UIImage imageNamed:@"select_kuang"] forState:UIControlStateNormal];
            [weakSelf.selectStudentArr removeObject:selectStudent];
        }else{
            [sender setImage:[UIImage imageNamed:@"testSelect_kuang"] forState:UIControlStateNormal];
            [weakSelf.selectStudentArr addObject:selectStudent];
        }
    }];
    
    __weak typeof(cell) weakCell = cell;
//    添加成绩
    [cell setInputStudentScoreBlock:^(HJTestStudentCell *testStudentCell, HJStudentInfo *inputStudent) {
        if ([weakSelf.projectInfo.pProjectType  intValue] == 1) {
            HJInputTimeScoreView *inputTimeScoreView = [HJInputTimeScoreView createInputTimeScoreViewWithScore:nil];
            [inputTimeScoreView setInputTimeScoreSureBlock:^(NSString *minStr, NSString *secStr, NSString *msecStr) {
                NSString *timeStr = [NSString stringWithFormat:@"%02d′%02d″%02d",[minStr intValue] <= 0 ?0:[minStr intValue],[secStr intValue] <= 0 ?0:[secStr intValue],[msecStr intValue] <= 0 ?0:[msecStr intValue] ];
                [weakCell addStudentScoreWithScore:timeStr];
            }];
            [UIView animateWithDuration:0.5 animations:^{
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [app.window addSubview:inputTimeScoreView];
            }];
        }else{
            HJInputScoreView* braceletSelectView = [HJInputScoreView createInputScoreViewWithScore:nil];
            [braceletSelectView setInputScoreSureBlock:^(NSString *score) {
                [weakCell addStudentScoreWithScore:score];
            }];
            [UIView animateWithDuration:0.5 animations:^{
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [app.window addSubview:braceletSelectView];
            }];
        }
        
    }];
    
//    点击成绩
    [cell setTapAlertScoreBlock:^(NSString *score, HJStudentInfo *scoreStudent, NSInteger tapTag) {
        if ([weakSelf.projectInfo.pProjectType  intValue] == 1) {
            HJInputTimeScoreView *inputTimeScoreView = [HJInputTimeScoreView createInputTimeScoreViewWithScore:score];
            [inputTimeScoreView setInputTimeScoreSureBlock:^(NSString *minStr, NSString *secStr, NSString *msecStr) {
                NSString *timeStr = [NSString stringWithFormat:@"%02d′%02d″%02d",[minStr intValue] <= 0 ?0:[minStr intValue],[secStr intValue] <= 0 ?0:[secStr intValue],[msecStr intValue] <= 0 ?0:[msecStr intValue] ];
                [weakCell alertStudentScoreWithScore:timeStr andIndex:tapTag];
            }];
            [UIView animateWithDuration:0.5 animations:^{
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [app.window addSubview:inputTimeScoreView];
            }];
        }else{
            HJInputScoreView* braceletSelectView = [HJInputScoreView createInputScoreViewWithScore:score];
            [braceletSelectView setInputScoreSureBlock:^(NSString *score) {
                [weakCell alertStudentScoreWithScore:score andIndex:tapTag];
            }];
            [UIView animateWithDuration:0.5 animations:^{
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [app.window addSubview:braceletSelectView];
            }];
        }
        
    }];
    
    HJStudentInfo *studentInfo = self.showStudentArr[indexPath.row];
    [cell updateSelfUi:studentInfo];
    
    
    if ([self.selectStudentArr containsObject:studentInfo]) {
        [cell setSelectStudentClick];
    }
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 73;
}





#pragma --mark--网络上传失败提示,学生成绩网络上传失败
-(void)scoreNetworkUploadError{
    __weak typeof(self) weakSelf = self;
    HJUploadScoreErrorView *errorView = [HJUploadScoreErrorView createUploadScoreStatusView];
    //     保存到本地回调
    [errorView setSaveScoreLocalBlock:^{
        [weakSelf saveAllStudentScoreLocain];
    }];
    //    重新上传的回调
    [errorView setAfreshUploadScoreBlock:^{
        [weakSelf uploadScoreClick];
    }];
    [UIView animateWithDuration:0.5 animations:^{
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:errorView];
    }];
}

// 保存所有成绩到本地
-(void)saveAllStudentScoreLocain{
    NSMutableString *str = [NSMutableString string];
    for (HJStudentInfo *stu in self.studentArr) {
        if (stu.sScoreArr.count <= 0) {
            if (str.length > 0) {
                [str appendString:@","];
            }
            [str appendString:stu.studentName];
        }
    }
    
    if (str.length > 0) {
        NSString *tishiStr = [NSString stringWithFormat:@"%@等人未录入成绩，是否继续保存成绩？",str];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:tishiStr delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alertView.tag = 200;
        [alertView show];
        return;
    }
    
    
    
    [self saveScoreClick];

}

-(void)saveScoreClick{
    [self showNetWorkAlertWithTitleStr:@"保存中..."];
    //        记录保存成绩的时间
    NSDate *startDate = [NSDate date];
    TestModel *testModel = [[LifeBitCoreDataManager shareInstance] efCraterTestModel];
    testModel.startTime = startDate;
    testModel.classId = self.classInfo.cClassId;
    testModel.classname = self.classInfo.cClassName;
    testModel.greadName = self.classInfo.cGradeName;
    testModel.greadId = self.classInfo.cGradeId;
    testModel.projectName = self.projectInfo.pProjectName;
    testModel.projectUnit = self.projectInfo.pProjectUnit;
    testModel.projectId = self.projectInfo.pProjectID;
    testModel.projectType = self.projectInfo.pProjectType;
    testModel.teacherId = [HJUserManager shareInstance].user.uTeacherId;
    
    [[LifeBitCoreDataManager shareInstance] efAddTestModel:testModel];
    //        保存成绩到本地
    BOOL isSaveSu = NO;
    int count = 0;
    for (int i = 0; i < self.studentArr.count; i++) {
        HJStudentInfo *studentInfo = self.studentArr[i];
        studentInfo.sStartDate = startDate;
        ScoreModel *scoreModel = [HJStudentInfo convertScoreInfoWithScoreModel:studentInfo];
        if ([[LifeBitCoreDataManager shareInstance] efAddScoreModel:scoreModel]) {
            NSLog(@"成绩保存成功");
            count++;
        }
        if (i == self.studentArr.count - 1 && count == self.studentArr.count) {
            isSaveSu = YES;
        }
    }
    
    if (isSaveSu) {
        [self showSuccessAlertAndPopVCWithTitleStr:@"保存成功"];
    }

}


#pragma --mark-- 网络
-(void)uploadScoreClick{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[self structureUploadScoreDataType] forKey:@"scoresList"];
    [parameters setValue:self.projectInfo.pProjectUnit forKey:@"UNIT"];
    [parameters setValue:self.projectInfo.pProjectType forKey:@"TYPE"];
    [parameters setValue:self.projectInfo.pProjectID forKey:@"PROJECT_ID"];
    [parameters setValue:self.classInfo.cClassId forKey:@"CLASS_ID"];
    
    [self POSTAndLoading:KuploadScore parameters:parameters andSuccess:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] intValue] == 1) {
            
            [self showSuccessAlertAndPopVCWithTitleStr:@"上传成功"];
        }else{
            [self scoreNetworkUploadError];
            
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self scoreNetworkUploadError];
    }];

    
}

// 成绩数据
-(NSMutableArray*)structureUploadScoreDataType{
    
    NSMutableArray *studentScoreArr = [NSMutableArray array];
    for (HJStudentInfo *studentInfo in self.studentArr) {
        NSMutableDictionary *stuDic = [NSMutableDictionary dictionary];
        [stuDic setValue:studentInfo.studentId forKey:@"studentId"];
        [stuDic setValue:studentInfo.sScoreArr forKey:@"scores"];
        [studentScoreArr addObject:stuDic];
    }
    for (HJStudentInfo *studentInfo in self.studentArr) {
        NSLog(@"项目类型＝ %@",studentInfo.sProjectType);
        NSLog(@"项目单位＝ %@",studentInfo.sProjectUnit);
        NSLog(@"成绩数据＝ %@",studentInfo.sScoreArr);
        NSLog(@"开始记录时间＝ %@",studentInfo.sStartDate);
    }
    
    return studentScoreArr;
}
@end
