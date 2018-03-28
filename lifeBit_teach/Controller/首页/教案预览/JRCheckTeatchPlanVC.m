//
//  JRCheckTeatchPlanVC.m
//  lifeBit_teach
//
//  Created by joyskim-ios1 on 16/9/5.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "JRCheckTeatchPlanVC.h"
#import "JRCheckTeachPlanCell.h"
#import "JRChangeTeachPlanVC.h"
#import "JRCallNameVC.h"
#import "HJLessonPlanPhaseCell.h"
#import "HJPreviewNoAlertCell.h"



@interface JRCheckTeatchPlanVC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startBtnConstrint;

@property (weak, nonatomic) IBOutlet UIButton *startClassBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic,strong)HJBluetootManager *bluetootManager;

//本地手环的数量
@property (nonatomic,strong)NSMutableArray *allWatchArr;

// 是否观察同步完成的状态
@property (nonatomic,assign)BOOL isObserver;

@property (nonatomic,strong)NSTimer *timer;
@end

@implementation JRCheckTeatchPlanVC

-(void)dealloc{
    
    
    if (self.lessonPlanShowType == JRLessonPlanShowTypeNone){
        
    }else if (self.lessonPlanShowType == JRLessonPlanShowTypeLessonPlan) {
        
    }else if (self.lessonPlanShowType == JRLessonPlanShowTypeClass) {
        if (self.isObserver) {
            [self removeObserver:self forKeyPath:@"bluetootManager.asyncDone" context:nil];
            self.bluetootManager.asyncDone = NO;
        }
    }else if (self.lessonPlanShowType == JRLessonPlanShowTypeHome){
        if ( self.isObserver) {
            [self removeObserver:self forKeyPath:@"bluetootManager.asyncDone" context:nil];
            self.bluetootManager.asyncDone = NO;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置navi字体颜色
    [self setNavigationBarTitleTextColor:@"预览教案"];
    self.isObserver = NO;
    if (self.lessonPlanShowType == JRLessonPlanShowTypeNone){
        self.startBtnConstrint.constant = 0;
        self.startClassBtn.hidden = YES;
    }else if (self.lessonPlanShowType == JRLessonPlanShowTypeLessonPlan) {
        self.navigationController.navigationBar.hidden = NO;
        //设置右键按钮
        UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(tapRightBtnToKeep)];
        rightBtn.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = rightBtn;
        self.startBtnConstrint.constant = 0;
        self.startClassBtn.hidden = YES;
    }else if (self.lessonPlanShowType == JRLessonPlanShowTypeClass) {
        self.navigationController.navigationBar.hidden = NO;
        //设置右键按钮
        UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"更换教案" style:UIBarButtonItemStyleDone target:self action:@selector(tapRightBtnToChangeTeachPlan)];
        rightBtn.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = rightBtn;
        if (![self efIsInClassAndHaveClassModel:nil withClass:nil]) {
            // [[HJBluetootManager shareInstance] registerBlueToothManager];
            [self addObserver:self forKeyPath:@"bluetootManager.asyncDone" options:NSKeyValueObservingOptionNew context:nil];
            self.isObserver = YES;
        }

    }else if (self.lessonPlanShowType == JRLessonPlanShowTypeHome){
        self.navigationController.navigationBar.hidden = NO;
        //设置右键按钮
        UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"更换教案" style:UIBarButtonItemStyleDone target:self action:@selector(tapRightBtnToChangeTeachPlan)];
        rightBtn.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = rightBtn;
        if (![self efIsInClassAndHaveClassModel:nil withClass:nil]) {
          //  [[HJBluetootManager shareInstance] registerBlueToothManager];
            [self addObserver:self forKeyPath:@"bluetootManager.asyncDone" options:NSKeyValueObservingOptionNew context:nil];
             self.isObserver = YES;
        }

        
    }


}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //显示naviBar
    self.navigationController.navigationBar.hidden = NO;
    //显示返回按钮
    self.leftNavBtn.hidden = NO;
    //隐藏tabBar
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

-(void)initialize{
    UINib *cellNib1 = [UINib nibWithNibName:@"HJPreviewNoAlertCell" bundle:nil];
    [self.tableView registerNib:cellNib1 forCellReuseIdentifier:@"proviewNoAlertCell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.hidden = YES;
    self.startClassBtn.hidden = YES;
    [self getLessonPlanDetails];
}

-(void)naviBack{
  
    if (self.isObserver) {
        [self removeObserver:self forKeyPath:@"bluetootManager.asyncDone" context:nil];
        self.bluetootManager.asyncDone = NO;
        self.isObserver = NO;
    }

     [self.navigationController popViewControllerAnimated:YES];
}

-(HJBluetootManager *)bluetootManager{
    if (_bluetootManager == nil) {
        _bluetootManager = [HJBluetootManager shareInstance];
    }
    return _bluetootManager;
}
#pragma mark  更换教案
-(void)tapRightBtnToChangeTeachPlan
{
    JRChangeTeachPlanVC * jrChangeTeachPlanVc = [[JRChangeTeachPlanVC alloc]init];
    jrChangeTeachPlanVc.lessonPlanInfo = self.lessonPlanInfo;
    jrChangeTeachPlanVc.classInfo = self.classInfo;
    jrChangeTeachPlanVc.lessonPlanType = JRLessonPlanShowTypeClass;
    [self pushHiddenTabBar:jrChangeTeachPlanVc];

}
-(void)tapRightBtnToKeep{
    [self saveLessonPlanNetWork];
    
}

#pragma --mark-- 开始上课
- (IBAction)clickStartClassItem:(UIButton*)sender {
    NSLog(@"开始上课");
       switch (_lessonPlanShowType) {
        case JRLessonPlanShowTypeNone:{
        
        }
            break;
        case JRLessonPlanShowTypeHome:
        case JRLessonPlanShowTypeClass:{
            [sender setEnabled:YES];
            if ([self efIsInClassAndHaveClassModel:nil withClass:nil]) {
                [self showErroAlertWithTitleStr:@"正在上课中..."];
                return;
            }
            NSString *uuidStr = [[APPIdentificationManage  shareInstance] readUDID];
//            self.allWatchArr = [[LifeBitCoreDataManager shareInstance] efGetIpadIdentifyingAllWatchWith:uuidStr];
            
            NSMutableArray *  watchArr = [[LifeBitCoreDataManager shareInstance] efGetIpadIdentifyingAllWatchWith:uuidStr];
            NSArray *array2 = [watchArr sortedArrayUsingComparator:
                               ^NSComparisonResult(WatchModel *obj1, WatchModel *obj2) {
                                   if ([NSString isPureInt:obj1.watchNo] ) {
                                       if ([obj1.watchNo integerValue] > [obj2.watchNo integerValue]) {
                                           return (NSComparisonResult)NSOrderedDescending;
                                       }else if ([obj1.watchNo integerValue] < [obj2.watchNo integerValue]){
                                           return (NSComparisonResult)NSOrderedAscending;
                                       }
                                       else
                                           return (NSComparisonResult)NSOrderedSame;
                                   }
                                   // 先按照姓排序
                                   NSComparisonResult result = [obj1.watchNo compare:obj1.watchNo];
                                   // 如果有相同的姓，就比较名字
                                   if (result == NSOrderedAscending) {
                                       result = [obj1.watchNo compare:obj2.watchNo];
                                   }
                                   
                                   return result;
                               }];
            self.allWatchArr = [array2 mutableCopy];
            
            
           // if (self.bluetootManager.blueTools.scanWatchArray.count < self.allWatchArr.count) {
          //      [self otherAlertViewWithTitle:nil Content:@"手表未全部搜索到,请检查手表是否处于休眠状态。是否继续同步？" tag:100 delegate:self];
          //      return;
         //   }
            [self startClassClick];
        }
            break;
        case JRLessonPlanShowTypeLessonPlan:{
            
        }
            break;
            
        default:
            break;
    }
}

#pragma --mark-- 开始上课
-(void)startClassClick{
    
    //    让app不息屏
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [[HJAppObject sharedInstance] storeCode:@"callOver" andValue:@"2"];
    [[NSNotificationCenter defaultCenter] postNotificationName:KEnter_Class object:nil];
    [self showNetWorkAlertWithTitleStr:@"手表开启连续心率中"];
    
#warning - 连续心率模式 (开始上课)
    // 连续心率模式
    [self.bluetootManager performSelector:@selector(syncAssignClassAllWatch:) withObject:self.classInfo afterDelay:0];
   
    //            记录进入上课状态的时间
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:5*60];;
    self.classInfo.cStartTime = startDate;
    self.classInfo.cScheduleType = @(1);
    self.classInfo.cTeacherId = [HJUserManager shareInstance].user.uTeacherId;
    self.classInfo.cStatus = @"2";
    //    课程类型如果时课程中表中的类型
    if ([self.classInfo.cScheduleType intValue] == 1) {
        //    开始上课  更新课程表中教案的信息
        NSMutableArray *scheduleArr = [[LifeBitCoreDataManager shareInstance] efGetClassAllScheduleModelWith:[HJUserManager shareInstance].user.uTeacherId];
        for (ScheduleModel *scheduleModel in scheduleArr) {
            if ([scheduleModel.scheduleId isEqualToString:self.classInfo.cScheduleId]) {
                [[LifeBitCoreDataManager shareInstance] efDeleteScheduleModel:scheduleModel];
            }
        }
        
        
        ScheduleModel *scheduleModel = [HJClassInfo conversionScheduleModelWithClassInfo:self.classInfo];
        
        [[LifeBitCoreDataManager shareInstance] efAddScheduleModel:scheduleModel];
    }
    
    
    HaveClassModel *haveClassModel = [HJClassInfo conversionClassInfoWithHaveClassModel:self.classInfo];
    [[LifeBitCoreDataManager shareInstance] efAddHaveClassModel:haveClassModel];
    
    NSMutableArray *haveClassArr = [[LifeBitCoreDataManager shareInstance] efGetAllHaveClassModel];
    for (HaveClassModel*haveClassModel in haveClassArr) {
        NSLog(@"班级ID = %@========",haveClassModel.classId);
        NSLog(@"班级名称 = %@=======",haveClassModel.cClassname);
        NSLog(@"课时长 = %@=======",haveClassModel.classTime);
        NSLog(@"开始上课时间 = %@=======",haveClassModel.startDate);
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if (self.allWatchArr.count > 0) {
         [self showSuccessAlertWithTitleStr:@"同步完成"];
        [NSThread sleepForTimeInterval:0.5f];
    }
    
    JRCallNameVC* jrCallNameVc = [[JRCallNameVC alloc]init];
    jrCallNameVc.startClassInfo = self.classInfo;
    [self pushHiddenTabBar:jrCallNameVc];
   
    NSLog(@"同步完成");
}






#pragma mark   UITableViewDelegate方法

#pragma mark - UITableViewDataSource,UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.lessonPlanInfo.sPhaseArr.count + 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        //        阶段中的单元为cell的个数
        HJLessonPlanPhaseInfo *phaseInfo = self.lessonPlanInfo.sPhaseArr[section - 1];
        if (phaseInfo.pUnitArr.count <= 0) {
            return 0;
        }
        return phaseInfo.pUnitArr.count + 1;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
        UILabel* titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        titleLb.textColor = UIColorFromRGB(0x222222);
        titleLb.font = [UIFont systemFontOfSize:19];
        NSString *sportTitleStr = nil;
        if (self.lessonPlanInfo.sSportGrade.length <= 0) {
            sportTitleStr = self.lessonPlanInfo.sSportTitle;
        }else{
            sportTitleStr = [NSString stringWithFormat:@"%@(%@)",self.lessonPlanInfo.sSportTitle,self.lessonPlanInfo.sSportGrade];
        }
        titleLb.text = sportTitleStr;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        titleLb.textAlignment = NSTextAlignmentCenter;
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color_VCBG"]];
        [cell.contentView addSubview:titleLb];
        return cell;
    }else{
        
        if (indexPath.row == 0) {
            HJLessonPlanPhaseInfo *phaseInfo = self.lessonPlanInfo.sPhaseArr[indexPath.section - 1];
            if (phaseInfo.pUnitArr.count <= 0) {
                return nil;
            }
            HJLessonPlanPhaseCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"HJLessonPlanPhaseCell" owner:nil options:nil] lastObject];
            
            cell.totalTimeLb.text = [NSString stringWithFormat:@"总用时%@分钟",phaseInfo.pPhaseTime];
            cell.phaseLb.text = phaseInfo.pTitle;
            
            return cell;
        }
        
        HJPreviewNoAlertCell  *preNoCell = [[[NSBundle mainBundle] loadNibNamed:@"HJPreviewNoAlertCell" owner:nil options:nil] lastObject];
        preNoCell.lessonPlanNumLb.text = [NSString stringWithFormat:@"%ld、",indexPath.row];
        HJLessonPlanPhaseInfo *phaseInfo = self.lessonPlanInfo.sPhaseArr[indexPath.section - 1];
        HJLessonPlanUnitInfo *unitInfo = phaseInfo.pUnitArr[indexPath.row - 1];
        [preNoCell efUpdateSelfUi:unitInfo];
        return preNoCell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 60;
    }else{
        if (indexPath.row == 0) {
            HJLessonPlanPhaseInfo *phaseInfo = self.lessonPlanInfo.sPhaseArr[indexPath.section - 1];
            if (phaseInfo.pUnitArr.count <= 0) {
                return 1;
            }
            return 50;
        }
        HJPreviewNoAlertCell *cell  = [self.tableView dequeueReusableCellWithIdentifier:@"proviewNoAlertCell"];
        HJLessonPlanPhaseInfo *phaseInfo = self.lessonPlanInfo.sPhaseArr[indexPath.section - 1];
        HJLessonPlanUnitInfo *unitInfo = phaseInfo.pUnitArr[indexPath.row - 1];
        
        cell.unitDetailsLb.text = unitInfo.uUnitDetails;
        CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
//        NSLog(@"h=%f", size.height + 1);
        return 53 + size.height + 1;
    }

}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else{
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        sectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return sectionView;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}



#pragma --mark-- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    NSLog(@"%ld",(long)buttonIndex);
    switch (buttonIndex) {
        case 0:{
            [self startClassClick];
        }
            break;
        case 1:{
            [[HJBluetootManager shareInstance] stopScanWatch];
            [self showNetWorkAlertWithTitleStr:@"搜索中"];
            [[HJBluetootManager shareInstance] refreshScanAllWatch];
            self.timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(detectionScanWatch:) userInfo:nil repeats:YES];
        }
            break;
            
        default:
            break;
    }
}



static int timeCount = 0;

-(void)detectionScanWatch:(NSTimer*)timer{
    if (timeCount == 20) {
        [self showErroAlertWithTitleStr:@"搜索失败，请检查手表是否有电或损坏"];
        [timer invalidate];
        timeCount = 0;
        return;
    }
    if (self.bluetootManager.blueTools.scanWatchArray.count == self.allWatchArr.count) {
        [self showSuccessAlertWithTitleStr:@"搜索完成"];
        [self.bluetootManager.blueTools stopScan];
        [timer invalidate];
    }
    timeCount++;
}



#pragma --mark-- 网络
#pragma mark   查看教案详情接口
// 获取教案详情
-(void)getLessonPlanDetails{
    if (![[HttpHelper JSONRequestManager] isNetWork]) {
        LessonPlanModel * lessonPlanModel = [[LifeBitCoreDataManager shareInstance] efGetLessonPlanModelWithLessonPlan:self.lessonPlanInfo.sId];
        self.lessonPlanInfo = [HJLessonPlanInfo CreatLessonPlanInfoWithLessonPlanModel:lessonPlanModel];
        [self.tableView reloadData];
        self.tableView.hidden = NO;
        self.startClassBtn.hidden = NO;
        return;
    }
    
    NSMutableDictionary* parameters =[ @{
                                 @"bookId":self.lessonPlanInfo.sId
                                        } mutableCopy];
    if (!self.isCourse) {
        if (!self.isPlatform) {
            if (self.lessonPlanInfo.sLessonPlanSource.length <= 0 || self.lessonPlanInfo.sLessonPlanSource == nil) {
                [parameters setValue:@"1" forKey:@"type"];
            }else{
                [parameters setValue:@"2" forKey:@"type"];
            }
        }else{
            [parameters setValue:@"0" forKey:@"type"];
        }
    }else{
         [parameters setValue:@"2" forKey:@"type"];
    }



    
    NSString *newInterface = KLessonPlan_LessonPlanDeatils;
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self POSTAndLoading:newInterface parameters:parameters andSuccess:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 0) {
            self.tableView.hidden = NO;
            self.startClassBtn.hidden = NO;
            
            NSDictionary *feedbackDic = [responseObject objectForKey:@"feedback"];
//            self.lessonPlanInfo = [[HJLessonPlanInfo alloc] init];
            [self.lessonPlanInfo setLessonPlanAttributes:feedbackDic];
            [self showSuccessAlertWithTitleStr:@"加载成功"];
            [self.tableView reloadData];
            
        }else{
            [self showErroAlertWithTitleStr:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"message"]]];
        }

    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
         [self showNetWorkAlertWithTitleStr:@"加载失败"];
    }];
    
}




-(void)saveLessonPlanNetWork{
    
    NSMutableDictionary* parameters =[ @{
                                 @"bookId":self.lessonPlanInfo.sId,
                                 @"teacherId":[HJUserManager shareInstance].user.uId
                                 
                                 } mutableCopy];
    if (!self.isPlatform) {
        if (self.lessonPlanInfo.sLessonPlanSource.length <= 0 || self.lessonPlanInfo.sLessonPlanSource == nil) {
            [parameters setValue:@"3" forKey:@"resourceType"];
        }else{
            [parameters setValue:@"4" forKey:@"resourceType"];
        }
    }else{
        [parameters setValue:@"2" forKey:@"resourceType"];
    }
    NSString *newInterface = KCopeLessonPlan_update;
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self POSTAndLoading:newInterface parameters:parameters andSuccess:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 0) {
            [HJLessonPlanInfo saveConversionLessonPlanInfoWithLessonPlanModel:self.lessonPlanInfo];
            [self.navigationController popViewControllerAnimated:YES];
            [self showSuccessAlertWithTitleStr:@"保存成功"];
        }else{
            [self showErroAlertWithTitleStr:[NSString stringAwayFromNSNULL:[responseObject objectForKey:@"message"]]];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    
}
@end
