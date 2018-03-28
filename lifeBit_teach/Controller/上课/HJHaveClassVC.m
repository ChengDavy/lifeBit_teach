//
//  HJHaveClassVC.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/2.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJHaveClassVC.h"
#import "AppDelegate.h"
#import "RDVTabBarController.h"
#import "JRCusClassVC.h"
#import "JRCallNameVC.h"
#import "JRNameButten.h"
#import "HJStartClassVC.h"
#import "JRCheckTeatchPlanVC.h"
#import "NSDate+Categories.h"
#import "HJClassInfo.h"
#import "JRChangeTeachPlanVC.h"
#import "HJCustomClassCell.h"
@interface HJHaveClassVC()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *itemView;

@property (strong, nonatomic) IBOutletCollection(JRNameButten) NSArray *classBtnArr;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintsHeight;

// 自定义上课中
@property (nonatomic,strong) NSMutableArray *inClassArr;

// 课程班级数组
@property (nonatomic,strong)NSMutableArray *classArr;
@end


@implementation HJHaveClassVC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"上课";
    }
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    //设置navi字体颜色
    [self setNavigationBarTitleTextColor:@"上课"];
    
    //设置右键按钮
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"自定义课程" style:UIBarButtonItemStyleDone target:self action:@selector(tapRightBtn)];
    rightBtn.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    //self.constraintsHeight.constant = (kScreenWidth - 2* 15)/6;
}



// 获取上课中班级
-(NSMutableArray *)inClassArr{
    if (_inClassArr == nil) {
        _inClassArr = [NSMutableArray array];
    }
    return _inClassArr;
}

-(NSMutableArray *)classArr{
    if (_classArr == nil) {
        _classArr = [NSMutableArray array];

    }
    return _classArr;
}

-(void)initialize{
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)refershScheduleClick{
    [self.classArr removeAllObjects];
    [HJBluetootManager shareInstance].blueTools.scanWatchArray;
    //        获取课程表所有课程
    NSMutableArray *scheduleArr = [[LifeBitCoreDataManager shareInstance] efGetClassAllScheduleModelWith:[HJUserManager shareInstance].user.uTeacherId];
    for (int i = 0; i < scheduleArr.count; i++) {
        
        ScheduleModel *scheduleModel = [scheduleArr objectAtIndexWithSafety:i];
        NSLog(@"classname = %@----gradeName =%@",scheduleModel.classname,scheduleModel.gradeName);
        HJClassInfo *classInfo = [HJClassInfo createClassInfoWithScheduleModel:scheduleModel];
        //             设置课程表类型
        classInfo.cScheduleType = @(1);
        [self.classArr addObject:classInfo];
    }
//    添加课程按钮的状态
    for (HJClassInfo *classInfo in self.classArr) {
        NSInteger tagIndex = [classInfo.cWeek integerValue] * 10 +  [classInfo.cperiod integerValue];
        for (JRNameButten *btn in self.classBtnArr) {
            JRClsssStatusType type;
            if (btn.tag == tagIndex) {
                switch ([classInfo.cStatus intValue]) {
                    case 0:
                        type = JRClsssStatusTypeUndefined;
                        break;
                    case 1:
                        type = JRClsssStatusTypeReady;
                        break;
                    case 2:
                        type = JRClsssStatusTypeNamedClasses;
                        break;
                    case 3:
                        type = JRClsssStatusTypeInClass;
                        break;
                        
                    default:
                        break;
                }
                [btn alertClassMessageWithClassName:classInfo andClassType:type];
            }
        }
    }
    
    
    [self.inClassArr removeAllObjects];
    NSMutableArray *arr = [[LifeBitCoreDataManager shareInstance] efGetHaveClassModelWithSourceType:@(0) andScheduleStatus:@"2"];
    NSMutableArray *inclassArr1 = [[LifeBitCoreDataManager shareInstance] efGetHaveClassModelWithSourceType:@(0) andScheduleStatus:@"3"];
    for (HaveClassModel *haveClassModel in inclassArr1) {
        [arr addObject:haveClassModel];
    }
    for (HaveClassModel *haveClassModel in arr) {
        NSDate *startDate = haveClassModel.startDate;
        NSTimeInterval timeInterval= [startDate timeIntervalSinceReferenceDate];
        timeInterval +=[haveClassModel.classTime integerValue] * 60;
        NSDate *endDate = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
        NSComparisonResult  Comparison = [endDate compare:[NSDate date]];
        switch (Comparison) {
            case NSOrderedAscending:{
                if ([haveClassModel.scheduleType intValue] == 1) {
                    [self efResetCallOverStudent:haveClassModel.classId];
                    //        更新课表中数据信息
                    ScheduleModel *scheduleModel = [[LifeBitCoreDataManager shareInstance] efGetScheduleModeldWithSchedule:haveClassModel.scheduleId];
                    scheduleModel.classStatus = @"1";
                    [[LifeBitCoreDataManager shareInstance] efAddScheduleModel:scheduleModel];
                }
                //                如果时间超过  设置为准备上课
                haveClassModel.classStatus = @"3";
                [[LifeBitCoreDataManager shareInstance] efAddHaveClassModel:haveClassModel];
            }
                break;
            case NSOrderedSame:{
                if ([haveClassModel.scheduleType intValue] == 1) {
                    [self efResetCallOverStudent:haveClassModel.classId];
                    //        更新课表中数据信息
                    ScheduleModel *scheduleModel = [[LifeBitCoreDataManager shareInstance] efGetScheduleModeldWithSchedule:haveClassModel.scheduleId];
                    scheduleModel.classStatus = @"1";
                    [[LifeBitCoreDataManager shareInstance] efAddScheduleModel:scheduleModel];
                }
                haveClassModel.classStatus = @"3";
                [[LifeBitCoreDataManager shareInstance] efAddHaveClassModel:haveClassModel];
            }
                break;
            case NSOrderedDescending:{
                if ([haveClassModel.scheduleType intValue] == 2) {
                    HJClassInfo * classInfo = [HJClassInfo createClassInfoWithHaveClassModel:haveClassModel];
                    [self.inClassArr addObject:classInfo];
                }
               
            }
                break;
            default:
                break;
        }
        
        

    }
    [self.tableView reloadData];
}

#pragma mark  点击右键按钮 -- 进入个人中心
-(void)tapRightBtn
{
    if ([self efIsInClassAndHaveClassModel:nil withClass:nil]) {
        [self showErroAlertWithTitleStr:@"正在上课中..."];
        return;
    }else{
        JRCusClassVC* jrCusClassVc = [[JRCusClassVC alloc]init];
        [self pushHiddenTabBar:jrCusClassVc];
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([HJBluetootManager shareInstance].blueTools.scanWatchArray.count <= 0) {
        [[HJBluetootManager shareInstance] refreshScanAllWatch];
    }

    
    //显示naviBar
    self.navigationController.navigationBar.hidden = NO;
    //隐藏返回按钮
    self.leftNavBtn.hidden = YES;
    //显示tabBar
    [self showTabBar];
    [self refershScheduleClick];
}
-(void)showTabBar{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    RDVTabBarController *tabBar =(RDVTabBarController*) app.viewController;
    [tabBar setTabBarHidden:NO animated:NO];
}



-(IBAction)clickTapClassItem:(JRNameButten*)sender{
    if (sender.classStatusType == JRClsssStatusTypeNone) {
        return;
    }
    switch (sender.classStatusType) {
        case JRClsssStatusTypeUndefined:{
            NSLog(@"未设置教");
            JRChangeTeachPlanVC *changeTeachPlanVC = [[JRChangeTeachPlanVC alloc] init];
            changeTeachPlanVC.lessonPlanType = JRLessonPlanShowTypeClass;
            changeTeachPlanVC.classInfo = sender.classDataInfo;
            [self pushHiddenTabBar:changeTeachPlanVC];
        }
            
            break;
        case JRClsssStatusTypeReady:{
            NSLog(@"准备上课");
            HJLessonPlanInfo *lessonPlanInfo = [[HJLessonPlanInfo alloc] init];
            lessonPlanInfo.sId = sender.classDataInfo.cLessonPlanId;
            
            JRCheckTeatchPlanVC *checkTeatchPlanVc = [[JRCheckTeatchPlanVC alloc] init];
            checkTeatchPlanVc.isCourse = YES;
            checkTeatchPlanVc.lessonPlanShowType = JRLessonPlanShowTypeClass;
            checkTeatchPlanVc.classInfo = sender.classDataInfo;
            checkTeatchPlanVc.lessonPlanInfo = lessonPlanInfo;
            [self pushHiddenTabBar:checkTeatchPlanVc];
        }

            break;
        case JRClsssStatusTypeNamedClasses:{
            
            AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
            if (app.inClassVC != nil) {
                [self pushHiddenTabBar:app.inClassVC];
            }else{
                switch ([[[HJAppObject sharedInstance] getCode:@"callOver"] intValue]) {
                    case 1:
                    {
                        NSMutableArray * haveClassModelArr = [[LifeBitCoreDataManager shareInstance] efGetHaveClassModelWithSourceType:@(1) andScheduleStatus:@"3"];
                        for (HaveClassModel *haveClassModel in haveClassModelArr) {
                            if ([haveClassModel.scheduleId isEqualToString:sender.classDataInfo.cScheduleId]) {
                                sender.classDataInfo.cStartTime = haveClassModel.startDate;
                            }
                        }
                        
                        
   
                        
                        
                        HJStartClassVC *startClassVc = [[HJStartClassVC alloc] init];
                        NSMutableArray *allStudentArr =  [self efClassAllStudent:sender.classDataInfo.cClassId];
                        NSMutableArray *callOverArr = [self efFilterCallOverStudent:sender.classDataInfo.cClassId];
                        
//                        NSMutableArray *notCallOverArr = [self];
                        
                        startClassVc.studentArr = allStudentArr;
                        startClassVc.signInStudentArr = callOverArr;
                        startClassVc.inClassInfo = sender.classDataInfo;
                        [self pushHiddenTabBar:startClassVc];
                        
                    }
                        break;
                    case 2:
                    {
                        NSMutableArray * haveClassModelArr = [[LifeBitCoreDataManager shareInstance] efGetHaveClassModelWithSourceType:@(1) andScheduleStatus:@"2"];
                        for (HaveClassModel *haveClassModel in haveClassModelArr) {
                            if ([haveClassModel.scheduleId isEqualToString:sender.classDataInfo.cScheduleId] ) {
                                sender.classDataInfo.cStartTime = haveClassModel.startDate;
                            }
                        }
                        JRCallNameVC *callNameVc = [[JRCallNameVC alloc] init];
                        callNameVc.startClassInfo = sender.classDataInfo;
                        [self pushHiddenTabBar:callNameVc];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
        }
            break;
        case JRClsssStatusTypeInClass:{
            NSLog(@"上课中");
            
            AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
            if (app.inClassVC != nil) {
                
                [self pushHiddenTabBar:app.inClassVC];
                
            } else {
                switch ([[[HJAppObject sharedInstance] getCode:@"callOver"] intValue]) {
                    case 1:
                    {
                        HJStartClassVC *startClassVc = [[HJStartClassVC alloc] init];
                        NSMutableArray *allStudentArr =  [self efClassAllStudent:sender.classDataInfo.cClassId];
                        NSMutableArray *callOverArr = [self efFilterCallOverStudent:sender.classDataInfo.cClassId];
                        startClassVc.studentArr = allStudentArr;
                        startClassVc.signInStudentArr = callOverArr;
                        startClassVc.inClassInfo = sender.classDataInfo;
                        [self pushHiddenTabBar:startClassVc];
                        
                    }
                        break;
                    case 2:
                    {
                        JRCallNameVC *callNameVc = [[JRCallNameVC alloc] init];
                        callNameVc.startClassInfo = sender.classDataInfo;
                        [self pushHiddenTabBar:callNameVc];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
           
            

        }
            break;
            
        default:
            break;
    }
}

#pragma --mark-- UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.inClassArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJCustomClassCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"HJCustomClassCell" owner:nil options:nil] lastObject];
    __weak typeof(self) weakSelf = self;
    [cell setTapGotoInClassBlock:^(UITableViewCell *classCell, HJClassInfo *classInfo) {
        AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;

        if (app.inClassVC) {
            [self pushHiddenTabBar:app.inClassVC];
            return;
        }
        switch ([[[HJAppObject sharedInstance] getCode:@"callOver"] intValue]) {
            case 1:
            {
                HJStartClassVC *startClassVc = [[HJStartClassVC alloc] init];
                NSMutableArray *allStudentArr =  [weakSelf efClassAllStudent:classInfo.cClassId];
                NSMutableArray *callOverArr = [weakSelf efFilterCallOverStudent:classInfo.cClassId];
                startClassVc.studentArr = allStudentArr;
                startClassVc.signInStudentArr = callOverArr;
                startClassVc.inClassInfo = classInfo;
                [self pushHiddenTabBar:startClassVc];
                
            }
                break;
            case 2:
            {
                JRCallNameVC *callNameVc = [[JRCallNameVC alloc] init];
                callNameVc.startClassInfo = classInfo;
                [self pushHiddenTabBar:callNameVc];

            }
                break;
                
            default:
                break;
        }

    }];
    HJClassInfo *classInfo = self.inClassArr[indexPath.row];
    [cell updateSelfUi:classInfo];
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}



@end
