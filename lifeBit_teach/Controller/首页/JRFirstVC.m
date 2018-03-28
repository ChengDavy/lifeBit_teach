
//
//  JRFirstVC.m
//  手表
//
//  Created by joyskim-ios1 on 16/8/25.
//  Copyright © 2016年 joyskim. All rights reserved.
//

#import "JRFirstVC.h"
#import "JRPerCenterVC.h"
#import "JRFirstCell.h"
#import "AMDriftScrollPicView.h"
#import "AppDelegate.h"
#import "RDVTabBarController.h"
#import "JRCheckTeatchPlanVC.h"
#import "JRChangeTeachPlanVC.h"
#import "HJStartClassVC.h"
#import "NSDate+Categories.h"
#import "HJAppObject.h"
#import "HttpHelper.h"
#import "RDVTabBarItem.h"
#import "JRCallNameVC.h"
#import "HJNoticeInfo.h"
#import "JRSynHeartVC.h"
#import "HJRealTimeRateVC.h"
#import "Singleton.h"

@interface JRFirstVC ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIAlertViewDelegate>{
    dispatch_queue_t queue;
}

//背景ScrollView
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;
//tableView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//tableView的headerView
@property (strong, nonatomic) IBOutlet UIView *headerView;
//tableView的headerView里面的label
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;


@property (strong, nonatomic)  UILabel *announcementLb; // 公告
@property (strong, nonatomic)  UIView *tishiView;
@property (nonatomic,assign)NSInteger versionUploadCount;


@property (nonatomic,strong)NSMutableArray *noticeArr;

@property (nonatomic,strong)NSMutableArray *currentClassArr;

@property (nonatomic,strong)NSTimer *timer;

@property (nonatomic,strong)NSTimer *timer1;


// 是否获取版本号中
@property (nonatomic,assign)BOOL isSync;
@end

@implementation JRFirstVC

-(void)dealloc{
     [[NSNotificationCenter defaultCenter] removeObserver:self name:KEnter_Class object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotification_Network object:nil];
    [self removeObserver:self forKeyPath:@"versionUploadCount"];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"首页";
    }
    return self;
}

-(NSMutableArray *)currentClassArr{
    if (_currentClassArr == nil) {
        _currentClassArr = [NSMutableArray array];
           }
    return _currentClassArr;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    //设置navi字体颜色
    [self setNavigationBarTitleTextColor:@"首页"];
    
    //设置右键按钮
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
//    rightView.backgroundColor = [UIColor blueColor];
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:rightView.bounds];
    [rightBtn setTitle:@"个人中心" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [rightBtn addTarget:self action:@selector(tapRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:rightBtn];
    
    self.tishiView = [[UIView alloc] initWithFrame:CGRectMake(rightView.bounds.size.width - 14, 8, 12, 12)];
    self.tishiView.backgroundColor = [UIColor redColor];
    self.tishiView.layer.cornerRadius = self.tishiView.bounds.size.width/2;
    self.tishiView.layer.masksToBounds = YES;
    self.tishiView.hidden = YES;
    [rightView addSubview:self.tishiView];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    

    self.versionUploadCount = 0;
    [self addObserver:self forKeyPath:@"versionUploadCount" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    

    
    
    if ([HttpHelper JSONRequestManager].isNetWork) {
        
        if ([self efGetNotUploadDataCount] 
            && ![[Singleton sharedInstance] isSynchronization] 
            && ![[Singleton sharedInstance] isUploading]) {
            UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还有未上传心率数据和测试成绩，请及时上传，以免数据丢失！" delegate:self cancelButtonTitle:@"去上传" otherButtonTitles:@"稍后上传", nil];
            alert.tag=1000;
            [alert show];
        }
        [self getVersionClick];        
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
    [self getCurretnClassClick];
}



-(void)initialize {
    
    [self showBanner];
    self.isSync = NO;
    if ([self efIsInClassAndHaveClassModel:nil withClass:@selector(classClick:)]) {
        if (!self.timer) {
          self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(checkClassStatusClick:) userInfo:nil repeats:YES];
        }
    }
    
    if (!self.timer1) {
        self.timer1 = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(checkValidationClick:) userInfo:nil repeats:YES];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanager:) name:KNotification_Network object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterClassClick:) name:KEnter_Class object:nil];
}



-(void)checkValidationClick:(NSTimer*)timer{
    if (![[HJUserManager shareInstance] efIsLogin]) {
        [timer invalidate];
        timer = nil;
        return;
    }
    
    if ([HttpHelper JSONRequestManager].isNetWork && !self.isSync) {
        self.isSync = YES;
        [self getVersionClick];
    }
    
    if (![HttpHelper JSONRequestManager].isNetWork) {
        [timer invalidate];
        timer = nil;
    }
}

- (NSString *)ToHex:(uint16_t)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    uint16_t ttmpig;
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
            default:
                nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    return str;
}










-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"versionUploadCount"]) {
        id oldValue = [change objectForKey:@"old"];
        
        JRFirstVC *firstVc = (JRFirstVC*)object;
//        NSLog(@"newValue == %ld && oldValue = %@",firstVc.versionUploadCount,oldValue);
        if (firstVc.versionUploadCount == 0 && [oldValue intValue] == 1) {
            [self performSelector:@selector(showSuccessAlertWithTitleStr:) withObject:@"更新成功" afterDelay:0];
//            [self showSuccessAlertWithTitleStr:@"更新成功"];
//            NSLog(@"observeValueForKeyPath currentThread = %@",[NSThread currentThread]);
        }else if(firstVc.versionUploadCount == 1  && [oldValue intValue] == 0){
             [self performSelector:@selector(showNetWorkAlertWithTitleStr:) withObject:@"数据更新中..." afterDelay:0];
//            [self showNetWorkAlertWithTitleStr:@"数据更新中..."];
//            NSLog(@"observeValueForKeyPath currentThread = %@",[NSThread currentThread]);
        }
        
    }
//    NSLog(@"observer = %@",keyPath);
}



-(void)networkChanager:(NSNotification*)notification{
    if ([HttpHelper JSONRequestManager].isNetWork) {
        
#warning 提示
        if ([self efGetNotUploadDataCount] 
            && ![[Singleton sharedInstance] isSynchronization] 
            && ![[Singleton sharedInstance] isUploading]) {
            UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还有未上传心率数据和测试成绩，请及时上传，以免数据丢失！" delegate:self cancelButtonTitle:@"去上传" otherButtonTitles:@"稍后上传", nil];
            alert.tag=1000;
            [alert show];
        }
        
       
        
        if (!self.timer1) {
            self.timer1 = [NSTimer scheduledTimerWithTimeInterval:1000.0 target:self selector:@selector(checkValidationClick:) userInfo:nil repeats:YES];
        }
    }
}

-(void)enterClassClick:(NSNotification*)notification{
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(checkClassStatusClick:) userInfo:nil repeats:YES];
    }
}

-(BOOL)isNotUploadHeard{
     NSMutableArray * haveClassArr = [[LifeBitCoreDataManager shareInstance] efGetAllHaveClassModel];
    if (haveClassArr.count > 0) {
        return YES;
    }
    return YES;
}




-(void)checkClassStatusClick:(NSTimer*)timer{
    
     // 判断是否有在上课状态的课程
    if ([[[HJAppObject sharedInstance] getCode:@"callOver"] intValue] > 0) {
        if (![self efIsInClassAndHaveClassModel:@selector(updateClassAllMeg:) withClass:nil]) {
            AppDelegate *app =(AppDelegate*) [UIApplication sharedApplication].delegate;
            app.inClassVC = nil;
            
            [[HJAppObject sharedInstance] storeCode:@"callOver" andValue:@"0"];
            
            if ([HttpHelper JSONRequestManager].isNetWork) {
                UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"完成上课，是否去同步数据？同步上传数据可能会要较长时间" delegate:self cancelButtonTitle:@"暂不同步数据" otherButtonTitles:@"去同步数据", nil];
                alert.tag = 100;
                [alert show];
                
            }else{
                
                UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"当前为无网络状态，请有网络的环境同步蓝牙数据<个人中心->同步蓝牙数据>，上传心率数据<上传心率数据>到服务器" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                alert.tag = 1001;
                [alert show];
            }
        }

    }
}

-(void)updateClassAllMeg:(HJClassInfo*)classInfo{
    [self efResetCallOverStudent:classInfo.cClassId];
}

-(void)classClick:(HJClassInfo*)classInfo{
    switch ([classInfo.cStatus intValue]) {
        case 2:
             [[HJAppObject sharedInstance] storeCode:@"callOver" andValue:@"2"];
            break;
        case 3:
             [[HJAppObject sharedInstance] storeCode:@"callOver" andValue:@"1"];
            break;
            
        default:
            break;
    }
}


#pragma --mark-- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    

    if (alertView.tag == 100) {
        //     去除记录
        if (buttonIndex == 1) {
            JRSynHeartVC* jrSynHeartVc = [[JRSynHeartVC alloc]init];
            jrSynHeartVc.synHeartSoureType = JRSynHeartSoureTypeClass;
            
            AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
            UIViewController *vc = app.window.rootViewController;
            RDVTabBarController *tabBar = nil;
            if (![vc isKindOfClass:[RDVTabBarController class]]) {
                tabBar = (RDVTabBarController*)app.viewController;
            }else{
                tabBar = (RDVTabBarController*)vc;
            }
            UINavigationController *naVc = [tabBar.viewControllers objectAtIndexWithSafety:tabBar.selectedIndex];
            [tabBar setTabBarHidden:YES animated:NO];
            [naVc pushViewController:jrSynHeartVc animated:YES];
            
        } else {
            
            AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
            UIViewController *vc = app.window.rootViewController;
            RDVTabBarController *tabBar = nil;
            if (![vc isKindOfClass:[RDVTabBarController class]]) {
                tabBar = (RDVTabBarController*)app.viewController;
            } else {
                tabBar = (RDVTabBarController*)vc;
            }
            UINavigationController *naVc = [tabBar.viewControllers objectAtIndexWithSafety:tabBar.selectedIndex];
            UIViewController *lastVc = [naVc.viewControllers lastObject];
            if ([lastVc isKindOfClass:[JRCallNameVC class]] || [lastVc isKindOfClass:[HJStartClassVC class]] || [lastVc isKindOfClass:[HJRealTimeRateVC class]]) {
                [naVc  popToRootViewControllerAnimated:YES];
            }
            
        }
    } else if(alertView.tag == 1001) {
        
        AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        if ([app.window.rootViewController isKindOfClass:[RDVTabBarController class]]) {
            RDVTabBarController *tabBar =(RDVTabBarController*)app.window.rootViewController;
            UINavigationController *naVc = [tabBar.viewControllers objectAtIndexWithSafety:tabBar.selectedIndex];
            UIViewController *vc = [naVc.viewControllers lastObject];
            if ([vc isKindOfClass:[JRCallNameVC class]] || [vc isKindOfClass:[HJStartClassVC class]]  || [vc isKindOfClass:[HJRealTimeRateVC class]]) {
                [naVc  popToRootViewControllerAnimated:YES];
            }
        } else {
            RDVTabBarController *tabBar = (RDVTabBarController*)app.viewController;;
            UINavigationController *naVc = [tabBar.viewControllers objectAtIndexWithSafety:tabBar.selectedIndex];
            UIViewController *vc = [naVc.viewControllers lastObject];
            if ([vc isKindOfClass:[JRCallNameVC class]] || [vc isKindOfClass:[HJStartClassVC class]]  || [vc isKindOfClass:[HJRealTimeRateVC class]]) {
                [naVc  popToRootViewControllerAnimated:YES];
            }

        }
        
       
        
       
    }else if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            
        }else{
            JRPerCenterVC* jrPerCenterVc = [[JRPerCenterVC alloc]init];
            [self pushHiddenTabBar:jrPerCenterVc];
        }
    }
}




-(void)getCurretnClassClick{
    [self.currentClassArr removeAllObjects];
    NSLog(@"dataCurrentFromaWeek %ld",(long)[NSDate dataCurrentFromaWeek]);
    NSMutableArray *scheduleArr = [[LifeBitCoreDataManager shareInstance] efGetScheduleModeldWithWeek:[NSString stringWithFormat:@"%ld",(long)[NSDate dataCurrentFromaWeek]]];
    for (ScheduleModel *schedule in scheduleArr) {
        HJClassInfo *classInfo = [HJClassInfo createClassInfoWithScheduleModel:schedule];
        classInfo.cScheduleType = @(1);
        
        [self.currentClassArr addObject:classInfo];
    }
    

    if ([self efGetNotUploadDataCount] > 0) {
        self.tishiView.hidden = NO;
    }else{
        self.tishiView.hidden = YES;
    }

    
    
    [self.tableView reloadData];
}

-(void)showTabBar{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    RDVTabBarController *tabBarController =(RDVTabBarController*) app.viewController;
    
    [tabBarController setTabBarHidden:NO animated:NO];
}

#pragma mark  点击右键按钮 -- 进入个人中心
-(void)tapRightBtn
{
    JRPerCenterVC* jrPerCenterVc = [[JRPerCenterVC alloc]init];
    [self pushHiddenTabBar:jrPerCenterVc];
}


#pragma mark  banner显示
-(void)showBanner{

    NSMutableArray *mutArr =  [@[@"home_lunbo",@"home_lunbo",@"home_lunbo"] mutableCopy];
    
    CGSize size=[self imageCompressForWidth:[UIImage imageNamed:@"home_lunbo"] targetWidth:kScreenWidth].size;
    
    AMDriftScrollPicView* scrollView =  [AMDriftScrollPicView driftScrollPicViewWithFrame:CGRectMake(0, 64, kScreenWidth, size.height) imageNameArray:mutArr needPageControl:YES didTapPicBlock:^(NSInteger index) {
        NSLog(@"banner点击事件");
        
    }];
    
    [scrollView startAutoScrollAnimationWithEachTime:4];
    
    CGRect frame = self.tableView.frame;
    frame = CGRectMake(0, size.height+64, kScreenWidth, kScreenHeitht-size.height-64-44);
    self.tableView.frame = frame;
    if (self.announcementLb == nil) {
        self.announcementLb = [[UILabel alloc] initWithFrame:CGRectMake(20 , size.height - 70, kScreenWidth - 2 * 20, 30)];
        self.announcementLb.font = [UIFont systemFontOfSize:18];
        self.announcementLb.textColor = UIColorFromRGB(0x222222);
//        self.announcementLb.backgroundColor = [UIColor redColor];
        [scrollView addSubview:self.announcementLb];
    }
    
    
    

    [self.backScrollView addSubview:scrollView];
    
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.navigationController.viewControllers.count <= 2){//关闭主界面的右滑返回
        return NO;
    }else{
        return YES;
    }
}


#pragma mark   UITableViewDelegate方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.currentClassArr.count > 0) {
        return self.currentClassArr.count;
    }
    return 1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.currentClassArr.count <= 0) {
        HJEmptyCell *emptyCell = [[[NSBundle mainBundle] loadNibNamed:@"HJEmptyCell" owner:nil options:nil] lastObject];

        return emptyCell;
        
    }
    
    
    JRFirstCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JRFirstCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JRFirstCell" owner:nil options:nil] lastObject];
    }
    HJClassInfo *classInfo =self.currentClassArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    [cell setGotoCheckPlanBlock:^(UITableViewCell *cell, HJClassInfo *classInfo) {
        switch ([classInfo.cStatus intValue]) {
            case 0:{
                JRChangeTeachPlanVC *changeTeachPlanVC = [[JRChangeTeachPlanVC alloc] init];
                changeTeachPlanVC.lessonPlanType = JRLessonPlanShowTypeHome;
                changeTeachPlanVC.classInfo = classInfo;
                [weakSelf pushHiddenTabBar:changeTeachPlanVC];
            }
                break;
            case 1:{
                
                HJLessonPlanInfo *lessonPlanInfo = [[HJLessonPlanInfo alloc] init];
                lessonPlanInfo.sId = classInfo.cLessonPlanId;
                
                JRCheckTeatchPlanVC* jrCheckTeachPlanVc = [[JRCheckTeatchPlanVC alloc]init];
                jrCheckTeachPlanVc.lessonPlanShowType = JRLessonPlanShowTypeHome;
                jrCheckTeachPlanVc.classInfo = classInfo;
                jrCheckTeachPlanVc.isCourse = YES;
                jrCheckTeachPlanVc.lessonPlanInfo = lessonPlanInfo;
                [weakSelf pushHiddenTabBar:jrCheckTeachPlanVc];
            }
                break;
            case 2:{
                NSLog(@"上课点名");
                AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
                if (app.inClassVC != nil) {
                    [self pushHiddenTabBar:app.inClassVC];
                }else{
                    switch ([[[HJAppObject sharedInstance] getCode:@"callOver"] intValue]) {
                        case 1:
                        {
                            HJStartClassVC *startClassVc = [[HJStartClassVC alloc] init];
                            NSMutableArray *allStudentArr =  [self efClassAllStudent:classInfo.cClassId];
                            NSMutableArray *callOverArr = [self efFilterCallOverStudent:classInfo.cClassId];
                            startClassVc.studentArr = allStudentArr;
                            startClassVc.signInStudentArr = callOverArr;
                            NSMutableArray * haveClassModelArr = [[LifeBitCoreDataManager shareInstance] efGetHaveClassModelWithSourceType:@(1) andScheduleStatus:@"3"];
                            for (HaveClassModel *haveClassModel in haveClassModelArr) {
                                if ([haveClassModel.scheduleId isEqualToString:classInfo.cScheduleId]) {
                                    classInfo.cStartTime = haveClassModel.startDate;
                                }
                            }
                            startClassVc.inClassInfo = classInfo;
                            [self pushHiddenTabBar:startClassVc];
                            
                        }
                            break;
                        case 2:
                        {
                            NSMutableArray * haveClassModelArr = [[LifeBitCoreDataManager shareInstance] efGetHaveClassModelWithSourceType:@(1) andScheduleStatus:@"2"];
                            for (HaveClassModel *haveClassModel in haveClassModelArr) {
                                if ([haveClassModel.scheduleId isEqualToString:classInfo.cScheduleId]) {
                                    classInfo.cStartTime = haveClassModel.startDate;
                                }
                            }
                            JRCallNameVC *callNameVc = [[JRCallNameVC alloc] init];
                            callNameVc.startClassInfo = classInfo;
                            [self pushHiddenTabBar:callNameVc];
                        }
                            break;
                            
                        default:
                            break;
                    }
                }

            }
                break;
            case 3:{
                NSLog(@"上课中");
                
                AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
                if (app.inClassVC != nil) {
                    [self pushHiddenTabBar:app.inClassVC];
                }else{
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
                }

            }
                break;
                
            default:
                break;
        }
        
    }];
    [cell updateSelfUi:classInfo];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.currentClassArr.count <= 0) {
        return self.tableView.bounds.size.height;
    }
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 60);
    self.headerView.backgroundColor = UIColorFromRGB(0XEDEDED);
//    self.headerView.backgroundColor = [UIColor redColor];
    self.headerLabel.text = [NSString stringWithFormat:@"%@老师今天有%lu节课",[HJUserManager shareInstance].user.uTeacherName,(unsigned long)self.currentClassArr.count];
    return self.headerView;
    
    
}





// 获取消息咨询
-(void)getMessageConsulting{
    
    NSDictionary* parameters = @{
                                 @"from":KMessage_Consulting,
                                 @"baseUser.userid":[HJUserManager shareInstance].user.uId,
                                 @"searchVo.signer":[HJUserManager shareInstance].user.uSigner,
                                 @"baseUser.usertype":@"3"};
    NSString *oldInterface = KOld_Interface;
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self POST:oldInterface parameters:parameters andSuccess:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"result"] boolValue]) {
            NSDictionary *dataDic = [responseObject objectForKey:@"data"];
            NSArray *messageNoticeArr = [dataDic objectForKey:@"messageNotice"];
            if (messageNoticeArr.count > 0) {
                for (NSDictionary *noticeDic in messageNoticeArr) {
                    HJNoticeInfo *noticeInfo = [[HJNoticeInfo alloc] init];
                    [noticeInfo setAttributes:noticeDic];
                    [self.noticeArr addObject:noticeInfo];
                }
                HJNoticeInfo * noticeInfo = self.noticeArr[0];
                self.announcementLb.text = [NSString stringWithFormat:@"公告：%@",noticeInfo.nNoticeTitle];
            }else{
                self.announcementLb.text = @"公告：暂无公告";
            }
        }else{
            [self showErroAlertWithTitleStr:[responseObject objectForKey:@"message"]];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

#pragma --mark-- 获取版本号接口
-(void)getVersionClick{
    if (![[HJUserManager shareInstance] efIsLogin]) {
        return;
    }
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"SCHOOL_ID":[HJUserManager shareInstance].user.uSchoolId};
    [self POST:KGet_Version parameters:parameters andSuccess:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] intValue] == 1) {
            self.isSync = NO;
            NSArray *versionList = [responseObject objectForKey:@"versionList"];
            NSDictionary *versionDic = nil;
            if (versionList.count > 0) {
                versionDic = [versionList objectAtIndexWithSafety:0];
            }else{
                versionDic = [NSDictionary new];
            }

            VersionModel *versionModel = [[LifeBitCoreDataManager shareInstance] efGetVersionModelWithTeacherId:[HJUserManager shareInstance].user.uTeacherId];
            HJVersionInfo *versionInfo = [HJVersionInfo createVersionInfoWithVersionModel:versionModel];
            for (NSString *keyStr in versionDic.allKeys) {
                NSString *oldValue = nil;
                NSString *newValue = [NSString stringAwayFromNSNULL:[versionDic objectForKey:keyStr]];
                if ([keyStr isEqualToString:@"BOOKS_V"]) {
                    oldValue = versionInfo.books_v;
                    if ([newValue intValue] > [oldValue intValue] ) {
                        versionInfo.books_v = newValue;
                        self.versionUploadCount++;
                        [self uploadWithSpecifiedKey:keyStr];
                    }
                }else if ([keyStr isEqualToString:@"GRADE_V"]){
                    oldValue = versionInfo.grade_v;
                    if ([newValue intValue] > [oldValue intValue] ) {
                        versionInfo.grade_v = newValue;
                        self.versionUploadCount++;
                        [self uploadWithSpecifiedKey:keyStr];
                    }
                }else if ([keyStr isEqualToString:@"MAC_V"]){
                    oldValue = versionInfo.mac_v;
                    if ([newValue intValue] > [oldValue intValue] ) {
                        versionInfo.mac_v = newValue;
                        self.versionUploadCount++;
                        [self uploadWithSpecifiedKey:keyStr];
                    }
                }else if ([keyStr isEqualToString:@"PROJECT_V"]){
                    oldValue = versionInfo.project_v;
                    if ([newValue intValue] > [oldValue intValue] ) {
                        versionInfo.project_v = newValue;
                        self.versionUploadCount++;
                        [self uploadWithSpecifiedKey:keyStr];
                    }
                }else if ([keyStr isEqualToString:@"BOOKS_CLASSIFY_V"]){
                    oldValue = versionInfo.books_Classify_v;
                    if ([newValue intValue] > [oldValue intValue] ) {
                        versionInfo.books_Classify_v = newValue;
                        self.versionUploadCount++;
                        [self uploadWithSpecifiedKey:keyStr];
                    }

                }else if ([keyStr isEqualToString:@"STUDENTS_V"]){
                    oldValue = versionInfo.student_v;
                    if ([newValue intValue] > [oldValue intValue] ) {
                        versionInfo.student_v = newValue;
                        self.versionUploadCount++;
                        [self uploadWithSpecifiedKey:keyStr];
                    }
                }else if ([keyStr isEqualToString:@"COURSES_V"]){
                    oldValue = versionInfo.courses_v;
                    if ([newValue intValue] > [oldValue intValue] ) {
                        versionInfo.courses_v = newValue;
                        self.versionUploadCount++;
                        [self uploadWithSpecifiedKey:keyStr];
                    }
                }
            }
            NSArray *s = [[LifeBitCoreDataManager shareInstance] efGetAllVersionModel];
//            NSLog(@"%ld",s.count);
            [[LifeBitCoreDataManager shareInstance] efDeleteVersionModel:versionModel];
            VersionModel *versionModel1 = [HJVersionInfo convertVersionModelWithVersionInfo:versionInfo];
            [[LifeBitCoreDataManager shareInstance] efAddVersionModel:versionModel1];
        }else{
            
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [self showErroAlertWithTitleStr:@"连接超时"];
    }];
}

#pragma --mark-- 更新数据
-(void)uploadWithSpecifiedKey:(NSString*)keyValue{
    if ([keyValue isEqualToString:@"BOOKS_V"]) {
      
        [self performSelector:@selector(getLessonPlanProjectTypeList) withObject:nil afterDelay:0.5];
//        [self getLessonPlanProjectTypeList];
    }else if ([keyValue isEqualToString:@"GRADE_V"]){
//        获取年级列表
//        [self getSchoolGreadList];
        [self performSelector:@selector(getSchoolGreadList) withObject:nil afterDelay:0.5];
    }else if ([keyValue isEqualToString:@"MAC_V"]){
//        获取教具箱列表
//        [self getSchoolChestClick];
        [self performSelector:@selector(getSchoolChestClick) withObject:nil afterDelay:0.5];
    }else if ([keyValue isEqualToString:@"PROJECT_V"]){
//         获取标准项目
//        [self getTestProjectList];
        [self performSelector:@selector(getTestProjectList) withObject:nil afterDelay:0.5];
    }else if ([keyValue isEqualToString:@"BOOKS_CLASSIFY_V"]){
//        获取我的教案
//         [self getMyLessonPlan];
         [self performSelector:@selector(getMyLessonPlan) withObject:nil afterDelay:0.5];
//        self.versionUploadCount--;
    
    }else if ([keyValue isEqualToString:@"STUDENTS_V"]){
//        获取学生列表
//        [self getSchoolAllStudentList];
         [self performSelector:@selector(getSchoolAllStudentList) withObject:nil afterDelay:0.5];
    }else if ([keyValue isEqualToString:@"COURSES_V"]){
//        获取课程表
//        [self getScheduleList];
        [self performSelector:@selector(getScheduleList) withObject:nil afterDelay:0.5];
    }
}


#pragma --mark-- 获取全校学生列表



-(void)getSchoolAllStudentList {
    
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"SCHOOL_ID":[HJUserManager shareInstance].user.uSchoolId};
   
    [self POST:KGet_SchoolAllStudent parameters:parameters andSuccess:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] boolValue]) {
            self.versionUploadCount--;
//            [[LifeBitCoreDataManager shareInstance] efDeleteAllStudentModel];
            NSArray *studentListArr = [responseObject objectForKey:@"studentsList"];
//            NSLog(@"studentListArrstudentListArr  %@",studentListArr);
            for (NSDictionary *studentDic in studentListArr) {
                StudentModel *studentModel1 = [[LifeBitCoreDataManager shareInstance] efGetStudentDetailedById:[NSString stringAwayFromNSNULL:[studentDic objectForKey:@"ID"]]];
                StudentModel *studentModel = [[LifeBitCoreDataManager shareInstance] efCraterStudentModel];
                studentModel.sBirthDate = [NSString stringAwayFromNSNULL:[studentDic objectForKey:@"BIRTH_DATE"]];
                studentModel.sClassId = [NSString stringAwayFromNSNULL:[studentDic objectForKey:@"CLASS_ID"]];
                studentModel.sClassName = [NSString stringAwayFromNSNULL:[studentDic objectForKey:@"CLASS_NAME"]];
                studentModel.sGradeId = [NSString stringAwayFromNSNULL:[studentDic objectForKey:@"GRADE"]];
                studentModel.sGradeName = [NSString stringAwayFromNSNULL:[studentDic objectForKey:@"GRADE_NAME"]];
                studentModel.studentId = [NSString stringAwayFromNSNULL:[studentDic objectForKey:@"ID"]];
                studentModel.studentName = [NSString stringAwayFromNSNULL:[studentDic objectForKey:@"NAME"]];
                studentModel.sNational = [NSString stringAwayFromNSNULL:[studentDic objectForKey:@"NATIONAL"]];
                studentModel.sSex = [NSString stringAwayFromNSNULL:[studentDic objectForKey:@"SEX"]];
                studentModel.studentNo = [NSString stringAwayFromNSNULL:[studentDic objectForKey:@"STUDENT_NO"]];
                studentModel.sIsCallOver = [studentModel1.sIsCallOver copy];
                [[LifeBitCoreDataManager shareInstance] efDeleteStudentModel:studentModel1];
                [[LifeBitCoreDataManager shareInstance] efAddStudentModel:studentModel];
            }
            NSLog(@"self.versionUploadCount = %ld",(long)self.versionUploadCount);
        } else {
            [self showErroAlertWithTitleStr:@"返回数据错误"];
        }

    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErroAlertWithTitleStr:@"连接超时"];
        self.versionUploadCount--;
    }];
  
}

#pragma --mark--  获取教具箱信息
-(void)getSchoolChestClick {
    
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{ @"SCHOOL_ID":[HJUserManager shareInstance].user.uSchoolId,
                                  @"IPAD_MARK":[[APPIdentificationManage shareInstance] readUDID] };
    
    [self POST:KGet_IpadCases parameters:parameters andSuccess:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            if ([[responseObject objectForKey:@"success"] boolValue]) {
                
                self.versionUploadCount--;
                [[LifeBitCoreDataManager shareInstance] efDeleteTearchAllWatchModel:[HJUserManager shareInstance].user.uTeacherId];
                
                NSMutableArray *deviceList = [responseObject objectForKey:@"devicesList"];
                
                if (deviceList.count > 0) {
                    
                    NSDictionary* devicesDic = [deviceList objectAtIndexWithSafety:0];
                    NSMutableArray *deviceArr = [devicesDic objectForKey:@"DEVICES"];
                    
                    NSLog(@"deviceArr    %@",devicesDic);
                    
                    for (NSDictionary * dic in deviceArr) {
                        
                        WatchModel*watchModel = [[LifeBitCoreDataManager shareInstance] efCraterWatchModel];
                        
                        watchModel.watchMAC = [NSString stringAwayFromNSNULL:[dic objectForKey:@"DEVICE_MAC"]];
                        watchModel.watchNo = [NSString stringAwayFromNSNULL:[dic objectForKey:@"DEVICE_ID"]];
                        
                        watchModel.ipadIdentifying = [NSString stringAwayFromNSNULL:[devicesDic objectForKey:@"IPAD_MARK"]];
                        watchModel.teachBoxId = [NSString stringAwayFromNSNULL:[devicesDic objectForKey:@"EQUIPMENT_ID"]];
                        watchModel.teachBoxName = [NSString stringAwayFromNSNULL:[devicesDic objectForKey:@"EQUIPMENT_NAME"]];
                        watchModel.teacherId = [HJUserManager shareInstance].user.uTeacherId;
                        [[LifeBitCoreDataManager shareInstance] efAddWatchModel:watchModel];
#warning 添加手表了同志们
                    }
                }
                 NSLog(@"self.versionUploadCount = %ld",(long)self.versionUploadCount);
            } else {
                [self showErroAlertWithTitleStr:@"返回数据错误"];
            }
        } else {
            [self showErroAlertWithTitleStr:@"返回数据错误"];
        }
        
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErroAlertWithTitleStr:@"连接超时"];
        self.versionUploadCount--;
    }];
 
}



#pragma --mark-- 获取教案项目分类列表
-(void)getLessonPlanProjectTypeList {
    
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{};
    
    [self POST:KProject_Type parameters:parameters andSuccess:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        
        if ([[responseObject objectForKey:@"status"] intValue] == 0) {
            self.versionUploadCount--;
            NSArray *feedbackArr = [responseObject objectForKey:@"feedback"];
            NSString* documentPath = [NSString GetDocumentsPath];
            NSString *namePath = [NSString stringWithFormat:@"feedback_v_%@.plist",[HJUserManager shareInstance].user.uId];
            NSString* path1 = [documentPath stringByAppendingPathComponent:namePath];
            [feedbackArr writeToFile:path1 atomically:YES];
             NSLog(@"self.versionUploadCount = %ld",(long)self.versionUploadCount);
        }else{
            
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErroAlertWithTitleStr:@"连接超时"];
        self.versionUploadCount--;
    }];
   
}

#pragma --mark-- 获取课表列表
-(void)getScheduleList {
    
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{ @"TEACHER_ID": [HJUserManager shareInstance].user.uTeacherId };
    
    [self POST:KGet_ScheduleList parameters:parameters andSuccess:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        
        if ([[responseObject objectForKey:@"success"] intValue] == 1) {
            NSArray *versionListArr = [responseObject objectForKey:@"versionList"];
            NSMutableArray *haveClassArr = [[LifeBitCoreDataManager shareInstance] efGetAllHaveClassModel];
            self.versionUploadCount--;
            NSMutableArray *teacherScheduleArr = [[LifeBitCoreDataManager shareInstance] efGetClassAllScheduleModelWith:[HJUserManager shareInstance].user.uTeacherId];
            for (ScheduleModel *scheduleModel in teacherScheduleArr) {
                [[LifeBitCoreDataManager shareInstance] efDeleteScheduleModel:scheduleModel];
            }
            for (NSDictionary *scheduleDic in versionListArr) {
                
                ScheduleModel *scheduleModel = [[LifeBitCoreDataManager shareInstance] efCraterScheduleModel];
                scheduleModel.teacherId = [HJUserManager shareInstance].user.uTeacherId;
                scheduleModel.lessonPlanId = [NSString stringAwayFromNSNULL:[scheduleDic objectForKey:@"LESSON_ID"]];
                scheduleModel.scheduleId = [NSString stringAwayFromNSNULL:[scheduleDic objectForKey:@"SUBJECT_ID"]];
                BOOL isSet = NO;
                for (HaveClassModel *haveClassModel in haveClassArr) {
                    if ([haveClassModel.scheduleId isEqualToString:scheduleModel.scheduleId]) {
                        if ([haveClassModel.classStatus isEqualToString:@"2"]) {
                            isSet = YES;
                            scheduleModel.classStatus = haveClassModel.classStatus;
                        }else if ([haveClassModel.classStatus isEqualToString:@"1"] || [haveClassModel.classStatus isEqualToString:@"3"]){
                            isSet = YES;
                            scheduleModel.classStatus = @"1";
                        }else{
                            isSet = YES;
                            scheduleModel.classStatus = @"0";
                        }
                    }
                }
                
                if (!isSet) {
                    scheduleModel.classStatus = [NSString stringWithFormat:@"%d",((scheduleModel.lessonPlanId.length > 0)?1: 0)];
                }
                scheduleModel.week = [NSString stringAwayFromNSNULL:[scheduleDic objectForKey:@"WEEK"]];
                scheduleModel.rowClassName = [NSString stringAwayFromNSNULL:[scheduleDic objectForKey:@"SUBJECT_NAME"]];
                scheduleModel.period = [NSString stringAwayFromNSNULL:[scheduleDic objectForKey:@"PERIOD"]];
                
                scheduleModel.minRate = [NSString stringAwayFromNSNULL:[scheduleDic objectForKey:@"MIN_RATE"]];
                scheduleModel.maxRate = [NSString stringAwayFromNSNULL:[scheduleDic objectForKey:@"MAX_RATE"]];
                scheduleModel.classname = [NSString stringAwayFromNSNULL:[scheduleDic objectForKey:@"CLASS_NAME"]];
                scheduleModel.classId = [NSString stringAwayFromNSNULL:[scheduleDic objectForKey:@"CLASS_ID"]];
                scheduleModel.gradeName = [NSString stringAwayFromNSNULL:[scheduleDic objectForKey:@"GRADE_NAME"]];
                scheduleModel.gradeId = [NSString stringAwayFromNSNULL:[scheduleDic objectForKey:@"GRADE_ID"]];
                scheduleModel.classTime = [NSNumber numberWithInt:[[NSString stringAwayFromNSNULL:[scheduleDic objectForKey:@"DURATION"]] intValue]];
                
                NSLog(@"classname = %@----gradeName =%@",scheduleModel.classname,scheduleModel.gradeName);
                if (scheduleModel.scheduleId.length > 0) {
                    [[LifeBitCoreDataManager shareInstance] efAddScheduleModel:scheduleModel];
                }
                [self getCurretnClassClick];
            }
             NSLog(@"self.versionUploadCount = %ld",(long)self.versionUploadCount);

        }else{
            
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErroAlertWithTitleStr:@"连接超时"];
        self.versionUploadCount--;
    }];
    
}

#pragma --mark-- 测试项目分类
-(void)getTestProjectList {
    
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"SCHOOL_ID":[HJUserManager shareInstance].user.uSchoolId};
    
    [self POST:KGet_TestProject parameters:parameters andSuccess:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        
        if ([[responseObject objectForKey:@"success"] intValue] == 1) {
            self.versionUploadCount--;
            NSArray *projectListArr = [responseObject objectForKey:@"projectList"];
            NSString* documentPath = [NSString GetDocumentsPath];
            NSString *namePath = [NSString stringWithFormat:@"project_v_%@.plist",[HJUserManager shareInstance].user.uId];
            NSString* path1 = [documentPath stringByAppendingPathComponent:namePath];
//             去除null
            NSMutableArray *saveArr = [NSMutableArray array];
            for (NSDictionary *dic in projectListArr) {
                NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
                for (NSString *key in dic.allKeys) {
                    [tempDic setValue:[NSString stringAwayFromNSNULL:[dic objectForKey:key]] forKey:key];
                }
                [saveArr addObject:tempDic];
            }
      
            if ([saveArr writeToFile:path1 atomically:YES]) {
                NSLog(@"保存成功");
            }
            
             NSLog(@"self.versionUploadCount = %ld",(long)self.versionUploadCount);
  
        }else{
            
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErroAlertWithTitleStr:@"连接超时"];
        self.versionUploadCount--;
    }];
    
}



#pragma --mark-- 获取年级信息
-(void)getSchoolGreadList {
    
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"TEACHER_ID":[HJUserManager shareInstance].user.uTeacherId};
    
    [self POST:KGet_SchoolGread parameters:parameters andSuccess:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
     
        if ([[responseObject objectForKey:@"success"] intValue] == 1) {
            self.versionUploadCount--;
            NSArray *gradesArr = [responseObject objectForKey:@"grades"];
            NSString* documentPath = [NSString GetDocumentsPath];
            NSString *namePath = [NSString stringWithFormat:@"grade_v_%@.plist",[HJUserManager shareInstance].user.uId];
            NSString* path1 = [documentPath stringByAppendingPathComponent:namePath];
            if ([gradesArr writeToFile:path1 atomically:YES]) {
                NSLog(@"保存成功");
            }
             NSLog(@"self.versionUploadCount = %ld",(long)self.versionUploadCount);;
            
        }else{
            
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.versionUploadCount--;
        [self showErroAlertWithTitleStr:@"连接超时"];
    }];
}



-(void)getMyLessonPlan {
    
    NSDictionary* parameters = @{ @"teacherId": [HJUserManager shareInstance].user.uId } ;
    NSString *newInterface = KCope_LessonPlan;
    
    [self POST:newInterface parameters:parameters andSuccess:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        
        if ([[responseObject objectForKey:@"status"] intValue] == 0) {
            NSArray *feedbackArr = [responseObject objectForKey:@"feedback"];
            NSLog(@"self.versionUploadCount = %ld",self.versionUploadCount);
            NSMutableArray *lessonPlanInfoArr = [NSMutableArray array];
            for (NSDictionary* lessonDic in feedbackArr) {
                HJLessonPlanInfo *lessonPlanInfo  = [[HJLessonPlanInfo alloc] init];
                [lessonPlanInfo setLessonPlanAttributes:lessonDic];
                [lessonPlanInfoArr addObject:lessonPlanInfo];
            }
            
            for (HJLessonPlanInfo *lessonPlanInfo in lessonPlanInfoArr) {
                [HJLessonPlanInfo saveConversionLessonPlanInfoWithLessonPlanModel:lessonPlanInfo];
            }
            
            NSMutableArray *arr =   [[LifeBitCoreDataManager shareInstance] efGetAllLessonPlanModel];
            for (LessonPlanModel *lessonPlanModel in arr) {
                NSArray *planPhaseArr = (NSArray*)lessonPlanModel.lessonPlanPhase;
                
                NSLog(@"lessonPlanName = %@,lessonPlanPhase Count= %ld",lessonPlanModel.lessonPlanName,planPhaseArr.count);
                
                for (NSString *phase in planPhaseArr) {
                    NSMutableArray*unitArr = [[LifeBitCoreDataManager shareInstance] efGetLessonPlanModelWithLessonPlan:lessonPlanModel.lessonPlanId withLessonPlanPhase:phase];
                    NSLog(@"phase = %@   ===  lessonPlanUnit Count= %ld",phase,unitArr.count);
                }
            }
            self.versionUploadCount--;
        }else{
                
            }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErroAlertWithTitleStr:@"连接超时"];
        self.versionUploadCount--;
    }];}


#pragma --mark-- 获取教案列表
// 获取我的教案列表(本地最多缓存20条)
-(void)getLessonPlanList{
    NSDictionary* parameters = @{ @"type":@(2), 
                                  @"grade":@"",
                                  @"typeId":@"",
                                  @"currentPage":@(0),
                                  @"pageSize":@(30),
                                  @"referId":[HJUserManager shareInstance].user.uId } ;
    
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *newInterface = KPlatform_LessonPlanList;
    
    [self POST:newInterface parameters:parameters andSuccess:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
       
        if ([[responseObject objectForKey:@"status"] intValue] == 0) {
            self.versionUploadCount--;
            NSArray *feedbackArr = [responseObject objectForKey:@"feedback"];
             NSLog(@"self.versionUploadCount = %ld",self.versionUploadCount);
            for (NSDictionary* lessonDic in feedbackArr) {

            }
    
        }else{
            
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErroAlertWithTitleStr:@"连接超时"];
        self.versionUploadCount--;
    }];
    
}


@end
