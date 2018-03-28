//
//  HJStartClassVC.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/9.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJStartClassVC.h"
#import "HJClassStudentCell.h"
#import "HJPageView.h"
#import "HJRealTimeRateVC.h"
#import "AppDelegate.h"
#import "JRSynHeartVC.h"
#import "NSString+Category.h"

@interface HJStartClassVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet HJPageView *pageView;

@property (nonatomic,strong)NSMutableArray *showStudentArr;

@property (nonatomic,strong)NSMutableArray *watchModelArr;

// 检查课程的状态
@property (nonatomic,strong)NSTimer *timer;

@end

@implementation HJStartClassVC

-(void)dealloc{
     [[NSNotificationCenter defaultCenter] removeObserver:self name:KAddNewWatchNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];

//    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}


-(void)initialize{
    [self setNavigationBarTitleTextColor:@"上课中"];
    
    __weak typeof(self) weakSelf = self;
    [self.pageView setTapPageClickBlock:^(NSInteger selectIndex, UIButton *selectBtn) {
        [weakSelf refreshStudentWithSex:selectIndex];
    }];
    self.pageView.pageItemArr = @[@"全部学生",@"男生",@"女生"];
    if ([[[HJAppObject sharedInstance] getCode:@"callOver"] intValue] != 1) {
        [[HJAppObject sharedInstance] storeCode:@"callOver" andValue:@"1"];
        [self changerClassStatus:@"3"];
    }
    
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"课后" style:UIBarButtonItemStyleDone target:self action:@selector(tapRightBtn)];
    rightBtn.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    // 利用block进行排序
    NSArray *array2 = [self.studentArr sortedArrayUsingComparator:
                       ^NSComparisonResult(HJStudentInfo *obj1, HJStudentInfo *obj2) {

                           if ([NSString isPureInt:obj1.studentNo] ) {
                               if ([obj1.studentNo integerValue] > [obj2.studentNo integerValue]) {
                                   return (NSComparisonResult)NSOrderedDescending;
                               }else if ([obj1.studentNo integerValue] < [obj2.studentNo integerValue]){
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

    self.studentArr = [array2 mutableCopy];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWatchStatusClick:) name:KAddNewWatchNotification object:nil];
}


-(void)refreshWatchStatusClick:(NSNotification*)notication{
   LBWatchPerModel *perModel = [notication.userInfo objectForKey:@"addWatch"];
   NSInteger index = [self getPeripheralWatchModelAndIndex:perModel];
    if (index < 0 || index >= self.studentArr.count) {
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)naviBack{
    //     记录上课中页面
    AppDelegate *app =(AppDelegate*) [UIApplication sharedApplication].delegate;
    app.inClassVC = self;
    
    [self.navigationController popToRootViewControllerAnimated:YES];

}





#pragma --mark-- 改变数据库中上课状态

-(void)changerClassStatus:(NSString*)status {
    
    NSMutableArray *haveClassArr = [[LifeBitCoreDataManager shareInstance] efGetAllHaveClassModel];
    for (HaveClassModel *haveClassModel in haveClassArr) {
        if (([haveClassModel.scheduleId isEqualToString:self.inClassInfo.cScheduleId] || (haveClassModel.scheduleId == nil || self.inClassInfo.cScheduleId == nil)) && [haveClassModel.startDate compare:self.inClassInfo.cStartTime] == NSOrderedSame) {
            [[LifeBitCoreDataManager shareInstance] efDeleteHaveClassModel:haveClassModel];
        }
    }
    HaveClassModel *haveClassModel = [HJClassInfo conversionClassInfoWithHaveClassModel:self.inClassInfo];
    haveClassModel.classStatus = status;
    [[LifeBitCoreDataManager shareInstance] efAddHaveClassModel:haveClassModel];
}


// 更改记录课程表的状态
-(void)changerScheduleStatus:(NSString*)status {
    
    NSMutableArray *scheduleArr = [[LifeBitCoreDataManager shareInstance] efGetClassAllScheduleModelWith:[HJUserManager shareInstance].user.uTeacherId];
    for (ScheduleModel *scheduleModel in scheduleArr) {
        if ([scheduleModel.scheduleId isEqualToString:self.inClassInfo.cScheduleId]) {
            [[LifeBitCoreDataManager shareInstance] efDeleteScheduleModel:scheduleModel];
        }
    }
    ScheduleModel *scheduleModel = [[LifeBitCoreDataManager shareInstance] efGetScheduleModeldWithSchedule:self.inClassInfo.cScheduleId];
    scheduleModel.classStatus = status;
    [[LifeBitCoreDataManager shareInstance] efAddScheduleModel:scheduleModel];
}



-(NSMutableArray *)watchModelArr {
    
    if (_watchModelArr == nil) {
        NSMutableArray *watchArr = [[LifeBitCoreDataManager  shareInstance] efGetIpadIdentifyingAllWatchWith:[[APPIdentificationManage shareInstance] readUDID]];
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
        self.watchModelArr  = [array2 mutableCopy];
        
    }
    return _watchModelArr;
}

-(void)tapRightBtn{
    NSLog(@"点击课后");
    if ([self efIsInClassAndHaveClassModel:nil withClass:nil]) {
        [self showErroAlertWithTitleStr:@"不能中途结束课程"];
        return;
    }
    //     去除记录
    AppDelegate *app =(AppDelegate*) [UIApplication sharedApplication].delegate;
    app.inClassVC = nil;
//    改变课程状态
    [self changerClassStatus:@"4"];
    if ([self.inClassInfo.cScheduleType intValue] == 1) {
        [self changerScheduleStatus:@"1"];
    }
    [self efResetCallOverStudent:self.inClassInfo.cClassId];
    if ([HttpHelper JSONRequestManager].isNetWork) {
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"同步上传数据可能会要较长时间" delegate:self cancelButtonTitle:@"暂不同步上传" otherButtonTitles:@"去同步上传", nil];
        alert.tag = 100;
        [alert show];
        
    }else{
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"当前为无网络状态，请有网络的环境同步蓝牙数据<个人中心->同步蓝牙数据>，上传心率数据<上传心率数据>到服务器" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alert.tag = 10001;
        [alert show];
    }
}

-(void)refreshStudentWithSex:(NSInteger)sexIndex{
    [self.showStudentArr removeAllObjects];
    if (sexIndex == 1) {
        
        // 利用block进行排序
        NSArray *array2 = [self.studentArr sortedArrayUsingComparator:
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


#pragma --mark-- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  
    //     去除记录
    AppDelegate *app =(AppDelegate*) [UIApplication sharedApplication].delegate;
    app.inClassVC = nil;
    //    改变课程状态
    [self changerClassStatus:@"4"];
    if ([self.inClassInfo.cScheduleType intValue] == 1) {
        [self changerScheduleStatus:@"1"];
    }
    [self efResetCallOverStudent:self.inClassInfo.cClassId];
    if (alertView.tag == 100) {
        
        if (buttonIndex == 1) {
            
            JRSynHeartVC* jrSynHeartVc = [[JRSynHeartVC alloc]init];
            jrSynHeartVc.synHeartSoureType = JRSynHeartSoureTypeClass;
            [self pushHiddenTabBar:jrSynHeartVc];
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else if(alertView.tag == 10001){
        [self.navigationController  popToRootViewControllerAnimated:YES];
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
    
    HJClassStudentCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"HJClassStudentCell" owner:nil options:nil] lastObject];
    
    cell.macWatchLb.font = [UIFont systemFontOfSize:18];
    cell.macWatchLb.layer.masksToBounds = YES;
    cell.macWatchLb.layer.borderWidth = 1;
    cell.macWatchLb.layer.cornerRadius = 5;
    
    
    HJStudentInfo *studentInfo = [self.showStudentArr objectAtIndexWithSafety:indexPath.row];
    
    [cell updateSelfUi:studentInfo];
   
    BOOL isCunZai = NO;
    for (HJStudentInfo *s in self.signInStudentArr) {
        if ([s.studentId isEqualToString:studentInfo.studentId]) {
            isCunZai = YES;
        }
        
    }
   
    if (isCunZai) {
        
//        NSInteger index = [self.studentArr indexOfObject:studentInfo];
        
        NSLog(@"studentInfo.studentNo    %@",studentInfo.studentNo);
        
        NSInteger index = 0;
        
        if (studentInfo.studentNo.length>2) {
            
            index =[[studentInfo.studentNo substringFromIndex:[studentInfo.studentNo length] - 2] intValue] - 1;
            
        }else{
            index = [studentInfo.studentNo integerValue] - 1;
        }
        
        WatchModel *watchModel1 = nil;
 
        for (WatchModel * watchModel in self.watchModelArr) {
            
            if (index == [watchModel.watchNo intValue]) {
             
                watchModel1 = watchModel;
                
                break;
            }
            
            if ([studentInfo.studentNo integerValue] == [watchModel.watchNo integerValue]) {
                 watchModel1 = watchModel;
                
                break;
            }
        }
        
        NSLog(@"name = %@   watchModel.watchMAC    %@   watchid %@",studentInfo.
              studentName,watchModel1.watchMAC  , watchModel1.watchNo);
        
        LBWatchPerModel *watchPerModel = [self getPeripheralWithMac:watchModel1.watchMAC];
        
        if (watchPerModel == nil) {
            cell.macWatchLb.text = @"未搜索到手表";
            cell.macWatchLb.layer.borderColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color_VCBG"]].CGColor;
            cell.macWatchLb.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color_VCBG"]];
            cell.heatBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color_VCBG"]];
            cell.heatBtn.enabled = NO;
        } else {
            NSInteger index = [self.studentArr indexOfObject:studentInfo];
//            cell.macWatchLb.text = [NSString stringWithFormat:@"手表%ld",index + 1];
            
            cell.macWatchLb.text = [NSString stringWithFormat:@"手表%@",watchModel1.watchNo];
            
            cell.macWatchLb.layer.borderColor =  UIColorFromRGB(0x2876FE).CGColor;
            cell.macWatchLb.textColor =  UIColorFromRGB(0x2876FE);

            cell.heatBtn.backgroundColor = UIColorFromRGB(0x2876FE);
            cell.heatBtn.enabled = YES;
        }

    }else{
        cell.macWatchLb.text = @"未参与点名";
        cell.macWatchLb.layer.borderColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color_VCBG"]].CGColor;
        cell.macWatchLb.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color_VCBG"]];
        cell.heatBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color_VCBG"]];
        cell.heatBtn.enabled = NO;
    }
    
    
    
    __weak typeof(self) weakSelf = self;
    [cell setShowHeartRateClickBlock:^(HJStudentInfo *studentInfo) {
        NSLog(@"点击查看实时心率");  
        
        LBWatchPerModel * watchPerModel = nil;

        for (WatchModel * watchModel in self.watchModelArr) {
            
            NSLog(@"------>>>>>>>>>>>>>>>>>>>>>> %@", studentInfo.studentNo    ,watchModel.watchNo);
            
            if ([[studentInfo.studentNo substringFromIndex:[studentInfo.studentNo length] - 2] intValue] == [watchModel.watchNo intValue]) {
                 NSLog(@"------>>>>>>>>>>>>>>>>>>>>>> %@,        >>>>>>>>>>>>>>>>>>>%@", studentInfo.studentNo    ,watchModel.watchNo);
                watchPerModel = [weakSelf getPeripheralWithMac:watchModel.watchMAC];
                break;
            }
            
            if ([studentInfo.studentNo integerValue] == [watchModel.watchNo integerValue]) {
                watchPerModel = [weakSelf getPeripheralWithMac:watchModel.watchMAC];
                break;
            }
        }
        
        if (watchPerModel) {
            
            HJRealTimeRateVC *realTimeRateVc = [[HJRealTimeRateVC alloc] init];
            realTimeRateVc.watchPerModel = watchPerModel;
            realTimeRateVc.min_Hear = [self.inClassInfo.cMinRate intValue];
            realTimeRateVc.police_Hear = [self.inClassInfo.cMaxRate integerValue];
            realTimeRateVc.studentInfo = studentInfo;
            [weakSelf pushHiddenTabBar:realTimeRateVc];
            
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未搜索到该学生对应的手表，请检查手表！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
    }];
     
    
    return cell;
} 


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"查看学生详情");
}


#pragma --mrak-- 根据指定的mac地址获取周边对应
-(LBWatchPerModel*)getPeripheralWithMac:(NSString*)macStr{
    NSMutableArray *perArr = [HJBluetootManager shareInstance].blueTools.scanWatchArray;
    for (LBWatchPerModel*watch in perArr) {
        NSString* localName =watch.peripheral.name;
        NSArray* arr = [localName componentsSeparatedByString:@"-"];
        if ([[arr objectAtIndexWithSafety:1] isEqualToString:macStr]) {
            return watch ;
        }
    }
    return nil;
    
}

-(NSInteger)getPeripheralWatchModelAndIndex:(LBWatchPerModel*)perModel{
    NSString* localName =perModel.peripheral.name;
    NSArray* arr = [localName componentsSeparatedByString:@"-"];
    for (int i = 0; i < self.watchModelArr.count; i++) {
        WatchModel *watchModel = self.watchModelArr[i];
        if ([watchModel.watchMAC isEqualToString:[arr objectAtIndexWithSafety:1]] ) {
            return i;
        }
    }
    return -1;
}

@end
