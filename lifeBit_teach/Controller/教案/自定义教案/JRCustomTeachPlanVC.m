//
//  LBAlertLessonPlanVC.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/5/12.
//  Copyright © 2016年 joyskim. All rights reserved.
//

#import "JRCustomTeachPlanVC.h"
#import "AppDelegate.h"
#import "JRCusTeaPlanBtnCell.h"
#import "JRAddPlanVC.h"
#import "JRCusTeaPlanLbCell.h"
#import "HJInputScoreView.h"

@interface JRCustomTeachPlanVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footView;

@property (weak, nonatomic) IBOutlet UILabel *totalTimeLb;
//教案名称
@property (weak, nonatomic) IBOutlet UITextField *lessonPlanNameTF;
// 关键词
@property (weak, nonatomic) IBOutlet UITextField *lessonPlanKeyTF;


@property (weak, nonatomic) IBOutlet UITextField *lessonPlanTypeTF;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *gradeBtnArr;

@property (nonatomic,strong)HJLessonPlanInfo *lessonPlanInfo;
@property (nonatomic,strong)NSMutableArray *selectGradeArr;

@property (nonatomic,strong)NSMutableArray *lessonPlanTypeArr;
@end

@implementation JRCustomTeachPlanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)initialize{
    [self setNavigationBarTitleTextColor:@"制作教案"];
    self.tableView.tableFooterView = self.footView;
    self.totalTimeLb.text = [NSString stringWithFormat:@"全部时间：%@分钟",self.lessonPlanInfo.sTotalTime];
    
    UIButton* submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [submitBtn setTitle:@"保存" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:submitBtn];
    
    self.lessonPlanTypeArr = [[HJAppObject sharedInstance] getAllLessonPlanType];
    
    
    for (UIButton *btn in self.gradeBtnArr) {
        btn.layer.borderColor = UIColorFromRGB(0x222222).CGColor;
        btn.layer.borderWidth = 0.5;
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        [btn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateHighlighted];
        [btn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateSelected];
        [btn setBackgroundColor:[UIColor clearColor]];
    }
}

-(NSMutableArray *)selectGradeArr{
    if (_selectGradeArr == nil) {
        _selectGradeArr = [NSMutableArray array];
    }
    return _selectGradeArr;
}

#pragma mark - 事件
-(void)rightItemClick:(UIButton*)sender{
    
    if (self.lessonPlanNameTF.text.length <= 0) {
        [self showErroAlertWithTitleStr:@"请输入教案名称"];
        return;
    }
    
    if (self.lessonPlanInfo.sSportSkillID.length <= 0) {
        [self showErroAlertWithTitleStr:@"请选择教案使用分类"];
        return;
    }
    
    if (self.selectGradeArr.count <= 0) {
        [self showErroAlertWithTitleStr:@"请选择适用年级"];
        return;
    }
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[HJUserManager shareInstance].user.uId forKey:@"teacherId"];
    [parameters setValue:self.lessonPlanNameTF.text forKey:@"bookName"];
    [parameters setValue:self.lessonPlanInfo.sTotalTime forKey:@"bookMinutes"];
    [parameters setValue:[self.selectGradeArr copy] forKey:@"grades"];
    [parameters setValue:self.lessonPlanInfo.sSportSkillID forKey:@"typeId"];
    [parameters setValue:self.lessonPlanKeyTF.text forKey:@"code"];
    NSMutableArray *phaseArr = [NSMutableArray array];
//     阶段
    for (HJLessonPlanPhaseInfo*phaseInfo in self.lessonPlanInfo.sPhaseArr) {
        NSMutableDictionary *phaseDic = [NSMutableDictionary dictionary];
        [phaseDic setValue:phaseInfo.pId forKey:@"status"];
        NSMutableArray *unitArr = [NSMutableArray array];
        for (HJLessonPlanUnitInfo*unitInfo in phaseInfo.pUnitArr) {
            NSMutableDictionary *unitDic = [NSMutableDictionary dictionary];
            [unitDic setValue:unitInfo.uUnitId forKey:@"unitId"];
            [unitDic setValue:unitInfo.uUnitTime forKey:@"unitMinutes"];
            [unitArr addObject:unitDic];
        }
        [phaseDic setValue:[unitArr copy] forKey:@"unit"];
        [phaseArr addObject:phaseDic];
    }
    
    
    [parameters setValue:phaseArr forKey:@"pharse"];
    NSString *newInterface = KCustomLessonPlan_Save;

    [self POSTAndLoading:newInterface parameters:parameters andSuccess:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 0) {
            
            [HJLessonPlanInfo saveConversionLessonPlanInfoWithLessonPlanModel:self.lessonPlanInfo];
            
            [self.navigationController popViewControllerAnimated:YES];
            [self showSuccessAlertWithTitleStr:[NSString stringAwayFromNSNULL:[responseObject objectForKey:@"details"]]];
        }else{
            [self showErroAlertWithTitleStr:[NSString stringAwayFromNSNULL:[responseObject objectForKey:@"message"]]];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


// 选择班级
- (IBAction)clickSelectClassItem:(UIButton *)sender {
    NSNumber *tagNumber= [NSNumber numberWithInteger:sender.tag];
    if ([self.selectGradeArr containsObject:tagNumber]) {
        sender.layer.borderColor = UIColorFromRGB(0x222222).CGColor;
        sender.layer.borderWidth = 0.5;
        [sender setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
        [sender setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateHighlighted];
        [sender setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateSelected];
        [sender setBackgroundColor:[UIColor clearColor]];
        [self.selectGradeArr removeObject:tagNumber];
    }else{
        sender.layer.borderColor = UIColorFromRGB(0x2876FE).CGColor;
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [sender setBackgroundColor:UIColorFromRGB(0x2876FE)];
        [self.selectGradeArr addObject:tagNumber];
    }
    
    
    
    
}

// 选择项目类型
- (IBAction)clickSelectSoureItem:(UIButton *)sender {
    NSLog(@"选择项目类型");
    if (self.lessonPlanTypeArr.count <= 0) {
        [self showErroAlertWithTitleStr:@"没有更新分类信息"];
        return;
    }
    [self.lessonPlanTypeArr removeObjectAtIndex:0];
    HJLinkagePickerView *pickerView = [HJLinkagePickerView createSelectPickerWithDataSource:self.lessonPlanTypeArr andWithTitle:@"选择分类" WithType:HJLinkagePickerTypeLessonType] ;
    __weak typeof(self) weakSelf = self;
    
    [pickerView setSelectPickerBlock:^(NSInteger comperOne,NSInteger comerTwo) {
        HJProjectInfo *projectInfo =  [weakSelf.lessonPlanTypeArr objectAtIndexWithSafety:comperOne];
        HJSubProjectInfo *subClassInfo = [projectInfo.pSubProjectArr objectAtIndexWithSafety:comerTwo];
        weakSelf.lessonPlanTypeTF.text = [NSString stringWithFormat:@"%@-%@",projectInfo.pProjectName,subClassInfo.sName];
        weakSelf.lessonPlanInfo.sSportSkillID = subClassInfo.sId;
        weakSelf.lessonPlanInfo.sSportSkill = subClassInfo.sName;
    }];
    [UIView animateWithDuration:0.5 animations:^{
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:pickerView];
    }];
}


#pragma --mark-- 初始化数据
-(HJLessonPlanInfo *)lessonPlanInfo{
    if (_lessonPlanInfo == nil) {
        _lessonPlanInfo = [[HJLessonPlanInfo alloc] init];
        //        阶段
        _lessonPlanInfo.sPhaseArr = [NSMutableArray array];
        for (int i = 1; i < 5; i++) {
            HJLessonPlanPhaseInfo *phaseInfo = [[HJLessonPlanPhaseInfo alloc] init];
            switch (i) {
                case 1:
                {
                    phaseInfo.pId = @"0";
                    phaseInfo.pTitle = @"开始阶段";
                }
                    
                    break;
                case 2:
                {
                    phaseInfo.pId = @"1";
                    phaseInfo.pTitle = @"准备阶段";
                }
                    
                    break;
                case 3:
                {
                    phaseInfo.pId = @"2";
                    phaseInfo.pTitle = @"基本阶段";
                }
                   
                    break;
                case 4:
                {
                    phaseInfo.pId = @"3";
                    phaseInfo.pTitle = @"结束阶段";
                }
                    
                    break;
                    
                default:
                    break;
            }
            phaseInfo.pUnitArr = [NSMutableArray array];
            [_lessonPlanInfo.sPhaseArr addObject:phaseInfo];
        }
    }
    return _lessonPlanInfo;
}


#pragma --mark-- UITableViewDataSource,UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.lessonPlanInfo.sPhaseArr.count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        //        阶段中的单元为cell的个数
        HJLessonPlanPhaseInfo *phaseInfo = self.lessonPlanInfo.sPhaseArr[section];
        return phaseInfo.pUnitArr.count + 1;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJLessonPlanPhaseInfo *phaseInfo = self.lessonPlanInfo.sPhaseArr[indexPath.section];
    
    if (indexPath.row == 0) {
        JRCusTeaPlanBtnCell *cusTeaPlanBtnCell = [[[NSBundle mainBundle] loadNibNamed:@"JRCusTeaPlanBtnCell" owner:nil options:nil] lastObject];
        __weak NSIndexPath *weakIndexPath = indexPath;
        __weak HJLessonPlanPhaseInfo *weakPhaseInfo = phaseInfo;
        __weak JRCustomTeachPlanVC *weakSelf = self;
        [cusTeaPlanBtnCell setBlockClickLessonPlanUnit:^(JRCusTeaPlanBtnCell *selfCell) {
            NSLog(@"添加单元");
            JRAddPlanVC* unitVc = [[JRAddPlanVC alloc] init];
            unitVc.phares = [NSString stringWithFormat:@"%ld",weakIndexPath.section];
            [unitVc setArrWitnArrSelectBlock:^(NSArray *selectUnitArr) {
                [weakPhaseInfo.pUnitArr addObjectsFromArray:selectUnitArr];
//                阶段总时间
                NSInteger pharesTotal = 0;
                for (HJLessonPlanUnitInfo *unitInfo in weakPhaseInfo.pUnitArr) {
                    pharesTotal += [unitInfo.uUnitTime integerValue];
                }
//                阶段时间的改变量
                NSInteger changeTime = pharesTotal - [weakPhaseInfo.pPhaseTime integerValue];
                
//                改变教案总时间
                weakSelf.lessonPlanInfo.sTotalTime =  [NSString stringWithFormat:@"%ld",[weakSelf.lessonPlanInfo.sTotalTime integerValue] + changeTime];
//                改变阶段时间
                weakPhaseInfo.pPhaseTime = [NSString stringWithFormat:@"%ld",pharesTotal];
                //一个section刷新
//                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:weakIndexPath.section];
//                [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                
                weakSelf.totalTimeLb.text = [NSString stringWithFormat:@"全部时间：%@分钟",weakSelf.lessonPlanInfo.sTotalTime];
                [weakSelf.tableView reloadData];
            }];
            [self.navigationController pushViewController:unitVc animated:YES];
        }];
        
        
        [cusTeaPlanBtnCell efUpdateSelfUi:phaseInfo];
        return cusTeaPlanBtnCell;
    }
    HJLessonPlanUnitInfo *unitInfo = phaseInfo.pUnitArr[indexPath.row - 1];
    JRCusTeaPlanLbCell *alertUnitCell = [[[NSBundle mainBundle] loadNibNamed:@"JRCusTeaPlanLbCell" owner:nil options:nil] lastObject];
    [alertUnitCell efUpdateSelfUi:unitInfo];
    alertUnitCell.numberLb.text = [NSString stringWithFormat:@"%ld、",indexPath.row];
    
    
    __weak JRCusTeaPlanLbCell *tempWeakCell = alertUnitCell;
    __weak JRCustomTeachPlanVC *weakSelf = self;
    __weak HJLessonPlanPhaseInfo *weakPhaseInfo = phaseInfo;
    __weak HJLessonPlanUnitInfo *weakUnitInfo = unitInfo;
    __weak NSIndexPath *weakIndexPath = indexPath;
    // 修改时间
    [alertUnitCell setChangeTimeBlock:^(JRCusTeaPlanLbCell *tempSelf) {
        
        HJInputScoreView* braceletSelectView = [HJInputScoreView createInputScoreViewWithScore:nil];
        [braceletSelectView setInputScoreSureBlock:^(NSString *score) {
            tempWeakCell.numberLb.text = score;
            
            int amountTime = [score intValue] - [weakUnitInfo.uUnitTime intValue];
            if (amountTime > 0) {
                weakSelf.lessonPlanInfo.sTotalTime = [NSString stringWithFormat:@"%d",([weakSelf.lessonPlanInfo.sTotalTime intValue] + amountTime)];
                weakPhaseInfo.pPhaseTime = [NSString stringWithFormat:@"%d",([weakPhaseInfo.pPhaseTime intValue] + amountTime)];
            }else{
                weakSelf.lessonPlanInfo.sTotalTime = [NSString stringWithFormat:@"%d",([weakSelf.lessonPlanInfo.sTotalTime intValue] + amountTime)];
                weakPhaseInfo.pPhaseTime = [NSString stringWithFormat:@"%d",([weakPhaseInfo.pPhaseTime intValue] + amountTime)];
            }
            
            weakUnitInfo.uUnitTime = score;
            //一个section刷新
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:weakIndexPath.section];
            [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            weakSelf.totalTimeLb.text = [NSString stringWithFormat:@"全部时间：%@分钟",weakSelf.lessonPlanInfo.sTotalTime];

        }];
        [UIView animateWithDuration:0.5 animations:^{
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app.window addSubview:braceletSelectView];
        }];
        
    }];

    
    return alertUnitCell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    HJLessonPlanUnitInfo *unitInfo = phaseInfo.pUnitArr[indexPath.row - 1];
    if (indexPath.row == 0) {
        HJLessonPlanPhaseInfo *phaseInfo = self.lessonPlanInfo.sPhaseArr[indexPath.section];
        HJLessonPlanPhaseInfo *phaseInfo1 = nil;
        if (indexPath.section > 0) {
            phaseInfo1 = self.lessonPlanInfo.sPhaseArr[indexPath.section - 1];
        }
         return 80;
//        if (phaseInfo.pUnitArr.count <= 0 && (phaseInfo1 != nil  && phaseInfo1.pUnitArr.count > 0)) {
//            return 80;
//        }else{
//            return 60;
//        }
    }
   
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[JRCusTeaPlanLbCell class]]) {
//        HJLessonPlanPhaseInfo *phaseInfo = self.lessonPlanInfo.sPhaseArr[indexPath.section];
//        HJLessonPlanUnitInfo *unitInfo = phaseInfo.pUnitArr[indexPath.row - 1];
//        LBUnitDetailsVC *detailsVc = [[LBUnitDetailsVC alloc] init];
//        detailsVc.unitInfo = unitInfo;
//        [self.navigationController pushViewController:detailsVc animated:YES];
    }
    
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[JRCusTeaPlanLbCell class]]) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        HJLessonPlanPhaseInfo *phaseInfo = self.lessonPlanInfo.sPhaseArr[indexPath.section];
        [phaseInfo.pUnitArr removeObjectAtIndex:indexPath.row - 1];
        
        
        //                阶段总时间
        NSInteger pharesTotal = 0;
        for (HJLessonPlanUnitInfo *unitInfo in phaseInfo.pUnitArr) {
            pharesTotal += [unitInfo.uUnitTime integerValue];
        }
        //                阶段时间的改变量
        NSInteger changeTime = pharesTotal - [phaseInfo.pPhaseTime integerValue];
        
        //                改变教案总时间
        self.lessonPlanInfo.sTotalTime =  [NSString stringWithFormat:@"%ld",[self.lessonPlanInfo.sTotalTime integerValue] + changeTime];
        //                改变阶段时间
        phaseInfo.pPhaseTime = [NSString stringWithFormat:@"%ld",pharesTotal];
        //一个section刷新
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        
        self.totalTimeLb.text = [NSString stringWithFormat:@"全部时间：%@分钟",self.lessonPlanInfo.sTotalTime];
        
        // Delete the row from the data source.
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


//#pragma --mark-- 网络
//
//
//
//// 设置教案
//-(void)setCourseLessonPlan:(NSString*)alertLessonPlanId{
//    
//    NSMutableDictionary* parameters = [@{
//                                         @"bookId":alertLessonPlanId,
//                                         @"planId":self.courseInfo.cRowClassId,
//                                         @"teacherId":[HJUserManager shareInstance].user.uTeacherId
//                                         } mutableCopy];
//    
//    
//    NSString *newInterface = KCourse_LessonPlanSet;
//    [self creatPostBlock:newInterface andDictionary:parameters andSuccessBlock:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
//        if ([[responseDic objectForKey:@"status"] intValue] == 0) {
//            [self showSuccessAlertWithTitleStr:@"设置课程教案成功"];
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }
//    } andFailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
//    
//}
//// 更换教案
//-(void)replaceLessonPlanClick:(NSString*)alertLessonPlanId{
//    
//    NSMutableDictionary* parameters = [@{
//                                         @"bookId":alertLessonPlanId,
//                                         @"curriculumId":self.courseInfo.cCurriculumId,
//                                         @"teacherId":[HJUserManager shareInstance].user.uTeacherId
//                                         } mutableCopy];
//    
//    
//    
//    
//    
//    NSString *newInterface = KreplaceLessonPlan_update;
//    [self creatPostBlock:newInterface andDictionary:parameters andSuccessBlock:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
//        if ([[responseDic objectForKey:@"status"] intValue] == 0) {
//            [self showSuccessAlertWithTitleStr:@"课程教案更换成功"];
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }
//    } andFailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
//    
//}

@end
