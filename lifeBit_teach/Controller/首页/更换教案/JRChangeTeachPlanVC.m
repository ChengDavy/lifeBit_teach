//
//  JRChangeTeachPlanVC.m
//  lifeBit_teach
//
//  Created by joyskim-ios1 on 16/9/5.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "JRChangeTeachPlanVC.h"
#import "JRChangeTeachPlanCell.h"
#import "AppDelegate.h"
#import "HJCustomPickerView.h"
#import "JRCheckTeatchPlanVC.h"
#import "JRCallNameVC.h"
#import "YQTableView.h"
#import "NSDate+Categories.h"


@interface JRChangeTeachPlanVC ()<UITableViewDelegate,UITableViewDataSource>



@property (copy ,nonatomic) NSMutableArray * gradeArr;
@property (copy ,nonatomic) NSMutableArray * categoryArr;
//年级显示Label
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
//分类显示Label
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (weak, nonatomic) IBOutlet YQTableView *tableView;

@property (assign, nonatomic) NSInteger buttenIndex;

@property (nonatomic,strong)HJBluetootManager *bluetootManager;

@property (nonatomic,strong)NSMutableArray *selectLessonPlanArr;

// 教案数组
@property (nonatomic,strong)NSMutableArray *lessonPlanArr;
// 是否观察同步完成的状态
@property (nonatomic,assign)BOOL isObserver;

// 存储所有的ipad对应的所有手表
@property (nonatomic,strong)NSMutableArray *allWatchArr;

@property (nonatomic,strong)NSMutableArray *lessonPlanTypeArr;

@property (nonatomic,strong)NSTimer *timer;

@property (nonatomic,strong)NSString *scanGradeStr;
@property (nonatomic,strong)NSString *scanCategoryStr;

@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) BOOL isPage;
@end

@implementation JRChangeTeachPlanVC

-(void)dealloc{
    if (self.isObserver) {
        [self removeObserver:self forKeyPath:@"bluetootManager.asyncDone"];
        self.bluetootManager.asyncDone = NO;
    }
    
}

-(NSMutableArray *)categoryArr{
    if (!_categoryArr) {
        _categoryArr = [[NSMutableArray array] mutableCopy];
    }
    return _categoryArr;
}
-(NSMutableArray *)gradeArr{
    if (!_gradeArr) {
        _gradeArr = [[NSMutableArray array] mutableCopy];
    }
    return _gradeArr;
}

-(NSMutableArray *)lessonPlanArr{
    if (_lessonPlanArr == nil) {
        _lessonPlanArr = [NSMutableArray array];
    }
    return _lessonPlanArr;
}

-(NSMutableArray *)selectLessonPlanArr{
    if (_selectLessonPlanArr == nil) {
        _selectLessonPlanArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _selectLessonPlanArr;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isObserver = NO;
    if (self.lessonPlanType == JRLessonPlanShowTypeClass || self.lessonPlanType == JRLessonPlanShowTypeNoneClass) {
        if (!self.lessonPlanInfo) {
            //设置navi字体颜色
            [self setNavigationBarTitleTextColor:@"设置教案"];
            //设置右键按钮
            UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(tapRightBtn)];
            rightBtn.tintColor = [UIColor whiteColor];
            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            self.navigationItem.rightBarButtonItem = rightBtn;
            if (self.lessonPlanType == JRLessonPlanShowTypeNoneClass) {
                if (![self efIsInClassAndHaveClassModel:nil withClass:nil]) {
              //       [[HJBluetootManager shareInstance] registerBlueToothManager];
                    self.bluetootManager = [HJBluetootManager shareInstance];
                    [self addObserver:self forKeyPath:@"bluetootManager.asyncDone" options:NSKeyValueObservingOptionNew context:nil];
                    self.isObserver = YES;
                }
            }
            
            
        }else{
            //设置navi字体颜色
            [self setNavigationBarTitleTextColor:@"更换教案"];
            //设置右键按钮
            UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(tapRightBtn)];
            rightBtn.tintColor = [UIColor whiteColor];
            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            self.navigationItem.rightBarButtonItem = rightBtn;
        }

    }else if (self.lessonPlanType == JRLessonPlanShowTypeHome) {
        if (!self.lessonPlanInfo) {
            //设置navi字体颜色
            [self setNavigationBarTitleTextColor:@"设置教案"];
            //设置右键按钮
            UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(tapRightBtn)];
            rightBtn.tintColor = [UIColor whiteColor];
            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            self.navigationItem.rightBarButtonItem = rightBtn;
            
           

        }else{
            //设置navi字体颜色
            [self setNavigationBarTitleTextColor:@"更换教案"];
            //设置右键按钮
            UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(tapRightBtn)];
            rightBtn.tintColor = [UIColor whiteColor];
            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            self.navigationItem.rightBarButtonItem = rightBtn;
        }
    }

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
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

-(void)initialize{
    self.scanGradeStr = @"";
    self.scanCategoryStr = @"";
    self.lessonPlanTypeArr = [[HJAppObject sharedInstance] getAllLessonPlanType];
    
    
    [self initRefresh];
}

#pragma -- mark--  观察同步的进度
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (self.allWatchArr.count > 0) {
        [self showSuccessAlertWithTitleStr:@"同步完成"];
        [NSThread sleepForTimeInterval:0.5f];
    }
    
    JRCallNameVC* jrCallNameVc = [[JRCallNameVC alloc]init];
    jrCallNameVc.startClassInfo = self.classInfo;
    [self pushHiddenTabBar:jrCallNameVc];
    
    NSLog(@"同步完成，点名上课了");  //caesar
}



#pragma mark  点击右键按钮 -- 设置教案
-(void)tapRightBtn
{
    switch (self.lessonPlanType) {
        case JRLessonPlanShowTypeHome:
        {
            if (![[HttpHelper JSONRequestManager] isNetWork]) {
                [self saveClassData];
            }else{
                NSLog(@"如果有网络，先网络设置教案");
                [self clickSetClassLessonPlanItem];
            }
            
        }
            break;
        case JRLessonPlanShowTypeClass:{
            
            if (!self.lessonPlanInfo) {
                NSLog(@"如果是设置教案");
                if (![[HttpHelper JSONRequestManager] isNetWork]) {
// 课表无网络环境下设置教案
                    [self noNetworkSetLessonPlan];
                }else{
                     [self setCourseLessonPlan];
                }
                
                
            }else{
                NSLog(@"更换教案");
                if (![[HttpHelper JSONRequestManager] isNetWork]) {
                    // 课表无网络环境下设置教案
                    [self noNetworkSetLessonPlan];
                }else{
                    [self replaceCourseLessonPlan];
                }
                
            }
            
            
            
            
        }
            break;
        case JRLessonPlanShowTypeNoneClass:
        {
            if ([self efIsInClassAndHaveClassModel:nil withClass:nil]) {
                [self showErroAlertWithTitleStr:@"正在上课中..."];
                return;
            }
            if (![[HttpHelper JSONRequestManager] isNetWork]) {
                [self saveClassData];
                NSString *uuidStr = [[APPIdentificationManage  shareInstance] readUDID];
                
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
             
                if (self.bluetootManager.blueTools.scanWatchArray.count < self.allWatchArr.count) {
                    [self otherAlertViewWithTitle:nil Content:@"手表未全部搜索到,请检查手表是否处于休眠状态。是否继续同步？" tag:100 delegate:self];
                    return;
                }
                [self clickStartClass];
            }else{
                NSLog(@"如果有网络，先设置创建课程，再设置教案");
                [self createCourseNetWork];
            }
   
            

        }
            break;
        default:
            break;
    }
}

-(void)naviBack{
    if (self.isObserver) {
        [self removeObserver:self forKeyPath:@"bluetootManager.asyncDone" context:nil];
        self.bluetootManager.asyncDone = NO;
        self.isObserver = NO;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveClassData{
    
    if (self.selectLessonPlanArr.count <= 0 ) {
        [self showErroAlertWithTitleStr:@"请选择教案"];
        return;
    }
    HJLessonPlanInfo *lessonPlanInfo = self.selectLessonPlanArr[0];
    self.classInfo.cLessonPlanId = lessonPlanInfo.sId;
    
}


#pragma --mark-- 开始上课
-(void)clickStartClass{
    //    让app不息屏
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [[HJAppObject sharedInstance] storeCode:@"callOver" andValue:@"2"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KEnter_Class object:nil];
    
    [self showNetWorkAlertWithTitleStr:@"手表开启连续心率中"];
    
        //             开始同步所有手表进入连续心率模式
    [self.bluetootManager performSelector:@selector(syncAssignClassAllWatch:) withObject:self.classInfo afterDelay:0];
        NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:5*60];
        self.classInfo.cStartTime = startDate;
        self.classInfo.cTeacherId = [HJUserManager shareInstance].user.uTeacherId;
        self.classInfo.cScheduleType = @(2);
        self.classInfo.cStatus = @"2";
//    课程类型如果时课程中表中的类型
    if ([self.classInfo.cScheduleType intValue] == 1) {
        NSMutableArray *scheduleArr = [[LifeBitCoreDataManager shareInstance] efGetClassAllScheduleModelWith:[HJUserManager shareInstance].user.uTeacherId];
        for (ScheduleModel *scheduleModel in scheduleArr) {
            if ([scheduleModel.scheduleId isEqualToString:self.classInfo.cScheduleId]) {
                [[LifeBitCoreDataManager shareInstance] efDeleteScheduleModel:scheduleModel];
            }
        }
        //    开始上课  更新课程表中教案的信息
        
        ScheduleModel *scheduleModel = [HJClassInfo conversionScheduleModelWithClassInfo:self.classInfo];
        
        [[LifeBitCoreDataManager shareInstance] efAddScheduleModel:scheduleModel];
    }
        NSMutableArray *haveClassArr = [[LifeBitCoreDataManager shareInstance] efGetAllHaveClassModel];
        for (HaveClassModel *haveClassModel in haveClassArr) {
            if (([haveClassModel.scheduleId isEqualToString:self.classInfo.cScheduleId] || (haveClassModel.scheduleId == nil || self.classInfo.cScheduleId == nil)) && [haveClassModel.startDate compare:self.classInfo.cStartTime] == NSOrderedSame){
                [[LifeBitCoreDataManager shareInstance] efDeleteHaveClassModel:haveClassModel];
            }
        }
          HaveClassModel *haveClassModel = [HJClassInfo conversionClassInfoWithHaveClassModel:self.classInfo];
         [[LifeBitCoreDataManager shareInstance] efAddHaveClassModel:haveClassModel];
    
//        NSMutableArray *haveClassArr = [[LifeBitCoreDataManager shareInstance] efGetAllHaveClassModel];
        for (HaveClassModel * haveClassModel in haveClassArr) {
            
            NSLog(@"班级ID    = %@========",haveClassModel.classId);
            NSLog(@"班级名称  = %@=======",haveClassModel.cClassname);
            NSLog(@"课时长    = %@=======",haveClassModel.classTime);
            NSLog(@"开始上课时间 = %@=======",haveClassModel.startDate);
        }
}






#pragma mark   选择年级弹框
- (IBAction)chooceGrate:(UIButton *)sender {
    self.gradeArr =[ @[@"全部",@"一年级",@"二年级",@"三年级",@"四年级",@"五年级",@"六年级",@"七年级",@"八年级",@"九年级",@"十年级",@"十一年级",@"十二年级"] mutableCopy];
    HJCustomPickerView* picerView = [HJCustomPickerView createSelectPickerWithDataSource:self.gradeArr andWithTitle:@"分类选择"];
    __weak typeof(self) weakSelf = self;
    [picerView setSelectPickerBlock:^(NSString *sexType, NSInteger index) {
        self.gradeLabel.text = sexType;
        weakSelf.scanGradeStr = [NSString stringWithFormat:@"%ld",index];
        [weakSelf.tableView.header beginRefreshing];
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:picerView];
    }];
       
}
#pragma mark   选择分类弹框
- (IBAction)chooseCategory:(UIButton *)sender {
    if (self.lessonPlanTypeArr.count <= 0) {
        [self showErroAlertWithTitleStr:@"没有更新分类信息"];
        return;
    }
    HJLinkagePickerView *pickerView = [HJLinkagePickerView createSelectPickerWithDataSource:self.lessonPlanTypeArr andWithTitle:@"选择分类" WithType:HJLinkagePickerTypeLessonType] ;
    __weak typeof(self) weakSelf = self;
    
    [pickerView setSelectPickerBlock:^(NSInteger comperOne,NSInteger comerTwo) {
        HJProjectInfo *projectInfo =  [weakSelf.lessonPlanTypeArr objectAtIndexWithSafety:comperOne];
        HJSubProjectInfo *subClassInfo = [projectInfo.pSubProjectArr objectAtIndexWithSafety:comerTwo];
        weakSelf.categoryLabel.text = [NSString stringWithFormat:@"%@-%@",projectInfo.pProjectName,subClassInfo.sName];
        weakSelf.scanCategoryStr = [NSString stringWithFormat:@"%@",subClassInfo.sId];
        [weakSelf.tableView.header beginRefreshing];
    }];
    [UIView animateWithDuration:0.5 animations:^{
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:pickerView];
    }];
    
}


#pragma mark   UITableViewDelegate方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.lessonPlanArr.count <=  0) {
        return 1;
    }
    return self.lessonPlanArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.lessonPlanArr.count <= 0) {
        HJEmptyCell *emptyCell = [[[NSBundle mainBundle] loadNibNamed:@"HJEmptyCell" owner:nil options:nil] lastObject];
        return emptyCell;
    }
    
    JRChangeTeachPlanCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JRChangeTeachPlanCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JRChangeTeachPlanCell" owner:nil options:nil] lastObject];
    }
    cell.selectedBtn.tag = indexPath.row+1;
    cell.selectedBtn.selected = NO;
    __weak typeof(self) weakSelf = self;
    [cell setChangeButtenSelectedBlock:^(UIButton *butten,HJLessonPlanInfo *lessonPlanInfo) {
        if (butten.selected == YES) {
            [weakSelf.selectLessonPlanArr removeAllObjects];
            weakSelf.buttenIndex = butten.tag;
            [weakSelf.selectLessonPlanArr addObject:lessonPlanInfo];
        }else{
            [weakSelf.selectLessonPlanArr removeObject:lessonPlanInfo];
            weakSelf.buttenIndex = 0;
        }
        [weakSelf.tableView reloadData];
    }];
    if (self.buttenIndex >= 1) {
        if (indexPath.row == self.buttenIndex - 1) {
            NSLog(@"QQQ%ld",self.buttenIndex - 1);
            cell.selectedBtn.selected = YES;
        }
    }
    
    HJLessonPlanInfo *lessonPlanInfo = self.lessonPlanArr[indexPath.row];
    [cell updateSelfUi:lessonPlanInfo];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.lessonPlanArr.count <= 0) {
        return self.tableView.bounds.size.height;
    }
    return 60;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *sectionLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 40)];
    sectionLb.text = @"教案列表";
    sectionLb.textColor = UIColorFromRGB(0x666666);
    sectionLb.font = [UIFont systemFontOfSize:18];
    sectionLb.backgroundColor = UIColorFromRGB(0xEDEDED);
    return sectionLb;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[HJEmptyCell class]]) {
        return;
    }
    
    HJLessonPlanInfo *lessonPlanInfo = self.lessonPlanArr[indexPath.row];
    
    JRCheckTeatchPlanVC* jrCheckTeachPlanVc = [[JRCheckTeatchPlanVC alloc]init];
    jrCheckTeachPlanVc.lessonPlanShowType = JRLessonPlanShowTypeNone;
    jrCheckTeachPlanVc.classInfo = self.classInfo;
    jrCheckTeachPlanVc.isCourse = YES;
    jrCheckTeachPlanVc.lessonPlanInfo = lessonPlanInfo;
    [self pushHiddenTabBar:jrCheckTeachPlanVc];
}




#pragma --mark-- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
//    NSLog(@"%ld",buttonIndex);
    switch (buttonIndex) {
        case 0:{
            [[[HJBluetootManager shareInstance] blueTools] stopScan];
            [self clickStartClass]; //开课前同步手表的判断（没有发现全部手表）
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
//    if (timeCount == 20) {
//        [self showErroAlertWithTitleStr:@"搜索失败，请检查手表是否有电或损坏"];
//        [timer invalidate];
//        timeCount = 0;
//        return;
//    }
    if (self.bluetootManager.blueTools.scanWatchArray.count == self.allWatchArr.count) {
        [self showSuccessAlertWithTitleStr:@"搜索完成"];
        [self.bluetootManager.blueTools stopScan];
        [timer invalidate];
    }
    timeCount++;
}


-(void)initRefresh {
    
    self.isPage = YES;
    __weak typeof(self) weakSelf = self;
    // 下拉 调用的方法
    
    [self.tableView setEpDownPullClick:^{

        weakSelf.page = 1;
        weakSelf.isPage = YES;
        if (![[HttpHelper JSONRequestManager] isNetWork]) {
            
            [weakSelf.lessonPlanArr removeAllObjects];
            NSMutableArray *lessonPlanModelArr = [[LifeBitCoreDataManager shareInstance] efGetAllLessonPlanModelWithTearchId];
            
            for (LessonPlanModel *lessonPlanModel in lessonPlanModelArr) {
                HJLessonPlanInfo *lessonPlanInfo = [HJLessonPlanInfo creatLessonPlanInfoWithModel:lessonPlanModel];
                [weakSelf.lessonPlanArr addObject:lessonPlanInfo];
                [weakSelf.tableView.header endRefreshing];
                [weakSelf.tableView.footer endRefreshing];
                [weakSelf.tableView reloadData];
            }
            
        } else {
            [weakSelf getTeachMyLessonPlanList];
        }
    }];
    
    // 上拉拉 调用的方法
    [self.tableView setEpUpwardPullClick:^{
        ++weakSelf.page;
        weakSelf.isPage = NO;
        if (![[HttpHelper JSONRequestManager] isNetWork]) {
            [weakSelf.lessonPlanArr removeAllObjects];
            NSMutableArray *lessonPlanModelArr = [[LifeBitCoreDataManager shareInstance] efGetAllLessonPlanModelWithTearchId];
            for (LessonPlanModel *lessonPlanModel in lessonPlanModelArr) {
                HJLessonPlanInfo *lessonPlanInfo = [HJLessonPlanInfo creatLessonPlanInfoWithModel:lessonPlanModel];
                [weakSelf.lessonPlanArr addObject:lessonPlanInfo];
                [weakSelf.tableView.header endRefreshing];
                [weakSelf.tableView.footer endRefreshing];
                [weakSelf.tableView reloadData];
            }
        }else{
            [weakSelf getTeachMyLessonPlanList];
        }
    }];
    [self.tableView.header beginRefreshing];
}



#pragma --mark-- 网络请求
-(void)clickSetClassLessonPlanItem {
    
    switch (self.lessonPlanType) {
        case JRLessonPlanShowTypeNone: {
            
        }
            break;
            
        case JRLessonPlanShowTypeHome: {
            
            self.classInfo.cStartTime = [NSDate date];
          
            if (self.selectLessonPlanArr.count <= 0 ) {
                [self showErroAlertWithTitleStr:@"请选择教案"];
                return;
            }
            HJLessonPlanInfo *lessonPlanInfo = self.selectLessonPlanArr[0];
            self.classInfo.cLessonPlanId = lessonPlanInfo.sId;
            // 设置完教案更新课程的状态
            self.classInfo.cStatus = @"1";
            // 课程类型如果时课程中表中的类型
            if ([self.classInfo.cScheduleType intValue] == 1) {
                NSMutableArray *scheduleArr = [[LifeBitCoreDataManager shareInstance] efGetClassAllScheduleModelWith:[HJUserManager shareInstance].user.uTeacherId];
                for (ScheduleModel *scheduleModel in scheduleArr) {
                    if ([scheduleModel.scheduleId isEqualToString:self.classInfo.cScheduleId]) {
                        [[LifeBitCoreDataManager shareInstance] efDeleteScheduleModel:scheduleModel];
                    }
                }
                // 开始上课  更新课程表中教案的信息
                ScheduleModel *scheduleModel = [HJClassInfo conversionScheduleModelWithClassInfo:self.classInfo];
                [[LifeBitCoreDataManager shareInstance] efAddScheduleModel:scheduleModel];
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        case JRLessonPlanShowTypeClass: {
            
        }
            break;
        case JRLessonPlanShowTypeLessonPlan: {
            
        }
            break;
        default:break;
    }
}



#pragma mark   获取我的教案列表库
-(void)getTeachMyLessonPlanList{
    
    NSMutableDictionary *parameters = [@{
                                         @"type":[NSString stringWithFormat:@"%d",2],
                                         @"grade":self.scanGradeStr,
                                         @"typeId":self.scanCategoryStr,
                                         @"currentPage":[NSString stringWithFormat:@"%ld",(long)self.page],
                                         @"pageSize":@"10",
                                         @"referId":[HJUserManager shareInstance].user.uId
                                         } mutableCopy];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self POST:KPlatform_LessonPlanList parameters:parameters andSuccess:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 0) {
            if (self.isPage) {
                [self.lessonPlanArr removeAllObjects];
            }
            NSArray *feedbackArr = [responseObject objectForKey:@"feedback"];
            for (NSDictionary *lessonPlanDic in feedbackArr) {
                HJLessonPlanInfo *lessonPlanInfo = [[HJLessonPlanInfo alloc] init];
                [lessonPlanInfo setModelAttributes:lessonPlanDic];
                [self.lessonPlanArr addObject:lessonPlanInfo];
            }
            [self.tableView reloadData];
        }else{
            [self showErroAlertWithTitleStr:[NSString stringAwayFromNSNULL:[responseObject objectForKey:@"message"]]];
        }
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }];
    
    
}

#pragma --mark-- 课程表无网情况下，设置教案
-(void)noNetworkSetLessonPlan{
    if (self.selectLessonPlanArr.count <= 0 ) {
        [self showErroAlertWithTitleStr:@"请选择教案"];
        return;
    }
    HJLessonPlanInfo *lessonPlanInfo = self.selectLessonPlanArr[0];
    self.classInfo.cLessonPlanId = lessonPlanInfo.sId;
    NSMutableArray *scheduleArr = [[LifeBitCoreDataManager shareInstance] efGetClassAllScheduleModelWith:[HJUserManager shareInstance].user.uTeacherId];
    for (ScheduleModel *scheduleModel in scheduleArr) {
        if ([scheduleModel.scheduleId isEqualToString:self.classInfo.cScheduleId]) {
            [[LifeBitCoreDataManager shareInstance] efDeleteScheduleModel:scheduleModel];
        }
    }
    self.classInfo.cStatus = @"1";
    //    开始上课  更新课程表中教案的信息
    ScheduleModel *scheduleModel = [HJClassInfo conversionScheduleModelWithClassInfo:self.classInfo];
    [[LifeBitCoreDataManager shareInstance] efAddScheduleModel:scheduleModel];
    [self.navigationController popToRootViewControllerAnimated:YES];
    if (!self.lessonPlanInfo) {
        
        [self showSuccessAlertWithTitleStr:@"设置成功"];
    }else{
        [self showSuccessAlertWithTitleStr:@"更换成功"];
    }
    
}


#pragma --mark-- 有网情况下，设置教案
-(void)setCourseLessonPlan{
    if (self.selectLessonPlanArr.count <= 0 ) {
        [self showErroAlertWithTitleStr:@"请选择教案"];
        return;
    }
    HJLessonPlanInfo *lessonPlanInfo = self.selectLessonPlanArr[0];
    NSDictionary* parameters = @{
                                         @"bookId":lessonPlanInfo.sId,
                                         @"planId":self.classInfo.cScheduleId,
                                         @"teacherId":[HJUserManager shareInstance].user.uId
                                         };
    
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *newInterface = KCourse_LessonPlanSet;
    [self POSTAndLoading:newInterface parameters:parameters andSuccess:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 0) {
            
            self.classInfo.cLessonPlanId = lessonPlanInfo.sId;
            [self showSuccessAlertWithTitleStr:@"设置课程教案成功"];
//            如果没有课程id
            if (self.lessonPlanType == JRLessonPlanShowTypeNoneClass) {
                NSString *uuidStr = [[APPIdentificationManage  shareInstance] readUDID];
                
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
                
                if (self.bluetootManager.blueTools.scanWatchArray.count < self.allWatchArr.count) {
                    [self otherAlertViewWithTitle:nil Content:@"手表未全部搜索到,请检查手表是否处于休眠状态。是否继续同步？" tag:100 delegate:self];
                    return;
                }
                
                [self clickStartClass];
            }else{
                //    课程类型如果时课程中表中的类型
                if ([self.classInfo.cScheduleType intValue] == 1) {
                    NSMutableArray *scheduleArr = [[LifeBitCoreDataManager shareInstance] efGetClassAllScheduleModelWith:[HJUserManager shareInstance].user.uTeacherId];
                    for (ScheduleModel *scheduleModel in scheduleArr) {
                        if ([scheduleModel.scheduleId isEqualToString:self.classInfo.cScheduleId]) {
                            [[LifeBitCoreDataManager shareInstance] efDeleteScheduleModel:scheduleModel];
                        }
                    }
                    self.classInfo.cStatus = @"1";
                    //    开始上课  更新课程表中教案的信息
                    ScheduleModel *scheduleModel = [HJClassInfo conversionScheduleModelWithClassInfo:self.classInfo];
                    [[LifeBitCoreDataManager shareInstance] efAddScheduleModel:scheduleModel];
                }
                [self.navigationController popToRootViewControllerAnimated:YES];
                [self showSuccessAlertWithTitleStr:@"设置课程教案成功"];
            }
            
            
        }else{
            [self showSuccessAlertWithTitleStr:[NSString stringAwayFromNSNULL:[responseObject objectForKey:@"message"]]];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

    
}


-(void)createCourseNetWork{
    if (self.selectLessonPlanArr.count <= 0 ) {
        [self showErroAlertWithTitleStr:@"请选择教案"];
        return;
    }
    self.classInfo.cStartTime = [NSDate date];
    NSString *currentDateStr = [NSDate stringFromDate:self.classInfo.cStartTime format:@"yyyy-MM-dd HH:mm:ss"];
    HJLessonPlanInfo *lessonPlanInfo = self.selectLessonPlanArr[0];

    NSDictionary* parameters = @{
                                 @"CLASS_ID":self.classInfo.cClassId,
                                 @"TEACHER_ID":[HJUserManager shareInstance].user.uTeacherId,
                                 @"COURSE_START_TIME":currentDateStr,
                                 @"COURSE_LONG":[self.classInfo.cClassTime stringValue]
                                 };
    
    NSString *newInterface = KCustomCourse;
    [self POSTAndLoading:newInterface parameters:parameters andSuccess:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] intValue] == 1) {
            self.classInfo.cScheduleId = [NSString stringAwayFromNSNULL:[responseObject objectForKey:@"COURSE_ID"]];
            [self setCourseLessonPlan];
        }else{
            [self showSuccessAlertWithTitleStr:[NSString stringAwayFromNSNULL:[responseObject objectForKey:@"message"]]];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    

}

#pragma --mark-- 更换教案
-(void)replaceCourseLessonPlan{
    if (self.selectLessonPlanArr.count <= 0 ) {
        [self showErroAlertWithTitleStr:@"请选择教案"];
        return;
    }
    HJLessonPlanInfo *lessonPlanInfo = self.selectLessonPlanArr[0];
    NSDictionary* parameters = @{
                                 @"bookId":lessonPlanInfo.sId,
                                 @"curriculumId":self.classInfo.cScheduleId
                                 };
    
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *newInterface = KreplaceLessonPlan_update;
    [self POSTAndLoading:newInterface parameters:parameters andSuccess:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 0) {
            
            self.classInfo.cLessonPlanId = lessonPlanInfo.sId;
            //    课程类型如果时课程中表中的类型
            if ([self.classInfo.cScheduleType intValue] == 1) {
                NSMutableArray *scheduleArr = [[LifeBitCoreDataManager shareInstance] efGetClassAllScheduleModelWith:[HJUserManager shareInstance].user.uTeacherId];
                for (ScheduleModel *scheduleModel in scheduleArr) {
                    if ([scheduleModel.scheduleId isEqualToString:self.classInfo.cScheduleId]) {
                        [[LifeBitCoreDataManager shareInstance] efDeleteScheduleModel:scheduleModel];
                    }
                }
                self.classInfo.cStatus = @"1";
                //    开始上课  更新课程表中教案的信息
                ScheduleModel *scheduleModel = [HJClassInfo conversionScheduleModelWithClassInfo:self.classInfo];
                [[LifeBitCoreDataManager shareInstance] efAddScheduleModel:scheduleModel];
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
            [self showSuccessAlertWithTitleStr:@"课程更换教案成功"];
            
        }else{
            [self showSuccessAlertWithTitleStr:@"返回数据错误"];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    

}
@end
