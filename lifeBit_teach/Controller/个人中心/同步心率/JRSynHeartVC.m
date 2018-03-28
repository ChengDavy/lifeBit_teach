//
//  JRSynHeartVC.m
//  手表
//
//  Created by joyskim-ios1 on 16/9/1.
//  Copyright © 2016年 joyskim. All rights reserved.
//

#import "JRSynHeartVC.h"
#import "HJSyncDataCell.h"
#import "HJUploadHeartDataVC.h"
#import "HJBluetoothDataInfo.h"
#import "NSDate+Categories.h"
#import "Singleton.h"

#define LBLog(fmt, ...) NSLog((@"LBLog: "fmt), ##__VA_ARGS__);


@interface JRSynHeartVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>


@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *sectionOneView;
@property (strong, nonatomic) IBOutlet UILabel *stateLB;

@property (nonatomic,strong)AMLifeBitBlueTools* blueTools;
@property (nonatomic)LBWatchPerModel* connectingWatch;
@property (nonatomic,strong)NSMutableArray* waitingConnectArray;
@property (nonatomic)BOOL isAutoSync;

@property (nonatomic,assign)BOOL isUpload;


@property (strong, nonatomic) IBOutlet UIButton * syncButton;
@property (strong, nonatomic) IBOutlet UIButton * syncUploadButton;


@property (nonatomic,strong)NSMutableArray *exceptionWatchArr;

@property (nonatomic,strong)NSMutableArray *haveClassArr;

// 上传数据成功个数
@property (nonatomic,assign)NSInteger successfulCount;

@property (nonatomic,assign)BOOL clearAllData;
@end

@implementation JRSynHeartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置navi字体颜色
    [self setNavigationBarTitleTextColor:@"同步心率"];
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"清除所有数据" style:UIBarButtonItemStyleDone target:self action:@selector(tapRightBtnClick)];
    rightBtn.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    self.clearAllData = NO;
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


-(void)viewWillDisappear:(BOOL)animated {
    
    [self.blueTools stopScan];
    
    [self.blueTools.scanWatchArray removeAllObjects];
    [self.waitingConnectArray removeAllObjects];
    [self.blueTools  cancelAllBluePeripheral];
    
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)tapRightBtnClick {
 
    if ([self efIsInClassAndHaveClassModel:nil withClass:nil]) {
        [self showErroAlertWithTitleStr:@"当前状态无法同步数据，因为在上课中，同步数据会导致心率不准确"];
        return;
    }
    
    if (self.isAutoSync) {
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"当前正在自动同步中" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
    } else {
        self.clearAllData = YES;
        [self syncAllWatch];
    }
}


- (void)naviBack {
    
        if (self.isAutoSync) {
            UIAlertView* alert =  [[UIAlertView alloc]initWithTitle:nil message:@"自动同步未完成,退出同步，会导致需要重新同步！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            alert.tag = 100;
            [alert show];
            return;
        }
        if (self.synHeartSoureType == JRSynHeartSoureTypeClass) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
}

-(void)initialize {
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    self.title = @"同步蓝牙数据";
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    self.waitingConnectArray = [NSMutableArray array];
    self.isAutoSync = NO;
    self.isUpload = NO;
    self.blueTools = [AMLifeBitBlueTools instance];
    //配置蓝牙状态更改回调
    [self stepBlueStateChangeBlock];
    
    //配置蓝牙设备断连回调
    [self stepBlueDisConnectBlock];
}


#pragma mark  ----按钮点击相关----


- (IBAction)tapAllSyncBtn:(id)sender {
    
    if ([self efIsInClassAndHaveClassModel:nil withClass:nil]) {
        [self showErroAlertWithTitleStr:@"当前状态无法同步数据，因为在上课中，同步数据会导致心率不准确"];
        return;
    }
    
    if ([[Singleton sharedInstance] isSynchronization]) { // 是否同步中
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"当前正在自动同步中" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
    } else {
        
        self.isUpload = NO;
        [self syncData];
    }
}




- (IBAction)tapSyncWithUploadClick:(UIButton *)sender {
    
    if ([self efIsInClassAndHaveClassModel:nil withClass:nil]) {
        [self showErroAlertWithTitleStr:@"当前状态无法同步数据，因为在上课中，同步数据会导致心率不准确"];
        return;
    }
    if ([[Singleton sharedInstance] isSynchronization]) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"当前正在自动同步中" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
    } else {
        
        if (![[HttpHelper JSONRequestManager] isNetWork]) {
            [self showErroAlertWithTitleStr:@"请在有网络的环境下，同步并上传所有数据"];
            return ;
        }
        self.successfulCount = 0;
        self.isUpload = YES;
        if (self.haveClassArr == nil) {
            self.haveClassArr = [[LifeBitCoreDataManager shareInstance] efGetAllHaveClassModel];
        }
        [self syncData];
    }
}


#pragma mark - Test code began
//-------------------------------------  Test code began

- (void)syncData {
    
    [self addObserver:self forKeyPath:@"waitingConnectArray" options:NSKeyValueObservingOptionNew context:nil];
    
    self.waitingConnectArray = self.blueTools.scanWatchArray;
    
    if ([self.waitingConnectArray count]) {
        
        [Singleton sharedInstance].isSynchronization = YES;
        [self toSendConnectWithWatch:[self.waitingConnectArray firstObject]];
    }
}






- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {

    if ([keyPath isEqualToString:@"waitingConnectArray"]) {
        
        if ([self.waitingConnectArray count]) {

            [Singleton sharedInstance].isSynchronization = YES;

            [self toSendConnectWithWatch:[self.waitingConnectArray firstObject]];
            NSLog(@"发起连接( %ld ) %@", self.waitingConnectArray.count, [[[self.waitingConnectArray firstObject] peripheral] name]);


        } else {

            NSLog(@"************************************************************");
            NSLog(@"************************ 同步完成了啊 ************************");
            NSLog(@"************************************************************");
            
            
            [Singleton sharedInstance].isSynchronization = NO;

            
            if (self.isUpload) {
                NSLog(@"点击了上传数据");
                if (![[HttpHelper JSONRequestManager] isNetWork]) {
                    [self showErroAlertWithTitleStr:@"请在有网络的环境下，上传运动数据"];
                    return ;
                }
                if (self.haveClassArr.count <= 0) {
                    [self showSuccessAlertAndPopVCWithTitleStr:@"数据同步成功，没有需要上传的课程"];
                    return;
                }
                [self showNetWorkAlertWithTitleStr:@"数据上传"];
                
                for (int i = 0; i < self.haveClassArr.count; i++) {
                    
                    self.successfulCount++;
                    HaveClassModel * haveClassModel = self.haveClassArr[i];
                    HJClassInfo * classInfo = [HJClassInfo createClassInfoWithHaveClassModel:haveClassModel];
                    NSMutableArray *studentDataArr = [self getWatchAssignWithType:1 andWithClassInfo:classInfo];
                    [self netForSyncHeartContinueWatch:classInfo WithStudentData:studentDataArr];
                }
                
            } else {
                
                if (self.synHeartSoureType != JRSynHeartSoureTypePerson) {
                    
                    HJUploadHeartDataVC *uploadHeartDataVc = [[HJUploadHeartDataVC alloc] init];
                    uploadHeartDataVc.synHeartSoureType = self.synHeartSoureType;
                    [self pushHiddenTabBar:uploadHeartDataVc];
                }
            }
  
        }
    }
}



- (void)toSendConnectWithWatch:(LBWatchPerModel *)watch {
    
    NSUInteger index = [self.blueTools.scanWatchArray indexOfObject:watch];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] 
                          atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    __weak JRSynHeartVC * blockSelf = self;
    
    watch.type = LBWatchTypeWait;
    
    [self.blueTools connectWatch:watch andSuccess:^(CBPeripheral *peripheral) {
       
        LBLog(@"连接成功 %@",watch.peripheral.name);
        watch.type = LBWatchTypeConnected;
        [blockSelf.tableView reloadData];
        [blockSelf toSyncWatchTime:watch];
        
    } andFail:^(NSString * errorStr) {
        
        LBLog(@"连接失败 %@",watch.peripheral.name);
        [self toSendConnectWithWatch:watch];
        
    }];    
}


// Sync watch - time
-(void)toSyncWatchTime:(LBWatchPerModel*)watch {
    
    __weak JRSynHeartVC* blockSelf = self;
    
    [watch syncTimeWithSuccess:^(NSObject *anyObj) {
        
        [blockSelf toSetWatchWorkTime:watch];
        LBLog(@"时间成功 %@",watch.peripheral.name);

        
    } fail:^(NSString *errorStr) {
        
        LBLog(@"时间失败 %@",watch.peripheral.name);
        
        if (watch.peripheral.state == CBPeripheralStateDisconnected) {
            [self toSendConnectWithWatch:watch];
        } else {
            [self toSyncWatchTime:watch];
        }
                
    }];
}
 


//设置工作时间
-(void)toSetWatchWorkTime:(LBWatchPerModel*)watch {
    
    __weak JRSynHeartVC * blockSelf = self;
    
    [watch orderWorkTimeSuccess:^(NSObject *anyObj) {

        LBLog(@"工时成功 %@",watch.peripheral.name);
        [blockSelf toSyncWalkWithWathch:watch];
        
    } fail:^(NSString *errorStr) {
        
        LBLog(@"工时失败 %@",watch.peripheral.name);
        if (watch.peripheral.state == CBPeripheralStateDisconnected) {
            [self toSendConnectWithWatch:watch];
        } else {
            [self toSetWatchWorkTime:watch];
        }
        
    }];
}



//同步计步数据
-(void)toSyncWalkWithWathch:(LBWatchPerModel*)watch {
    
    //已同步过步数数据
    if (watch.upDateWalkData.length > 1) {
        
        NSString* base64Str = [watch.upDateWalkData base64EncodedStringWithOptions:0];
        [self netForSyncWalkWatch:watch andDataBase:base64Str];
        return ;
    }
    
    watch.type = LBWatchTypeSyncWalk;
    [self.tableView reloadData];
    
    __weak JRSynHeartVC* blockSelf = self;
    
    
    [watch syncWalkWithProgress:^(NSObject *anyObj) {
        
        
    } Success:^(NSObject *anyObj) {
        
        watch.upDateWalkData = (NSData*)anyObj;
        watch.progressStr = @"";

        NSString * base64Str = [watch.upDateWalkData base64EncodedStringWithOptions:0];
        
        [blockSelf netForSyncWalkWatch:watch andDataBase:base64Str];
        LBLog(@"步数成功 %@ \n %@",watch.peripheral.name, anyObj);
        
        
    } fail:^(NSString *errorStr) {
        
        LBLog(@"步数失败 %@",watch.peripheral.name);
        
        if (watch.peripheral.state == CBPeripheralStateDisconnected) {
            [self toSendConnectWithWatch:watch];
        } else {
            [blockSelf toSyncWalkWithWathch:watch];
        }
        [blockSelf.tableView reloadData];
    }];
}



//同步连续心率
-(void)toSyncHearContinueWithWatch:(LBWatchPerModel*)watch{
    
    //已同步过连续心率
    if (watch.upDateHeartData.length > 1) {
        NSString* base64Str = [watch.upDateHeartData base64EncodedStringWithOptions:0];
        [self netForSyncHeartContinueWatch:watch andDataBase:base64Str];
        return ;
    }
    
    __weak JRSynHeartVC* blockSelf = self;
    
    watch.type = LBWatchTypeSyncHeart;
    [self.tableView reloadData];
    
    [watch syncHeartContinueWithProgress:^(NSObject *anyObj) {
        
        
    } Success:^(NSObject *anyObj) {
        
        watch.upDateHeartData = (NSData*)anyObj;
        LBLog(@"心率成功 %@ \n %@",watch.peripheral.name, anyObj);
        NSString* base64Str = [watch.upDateHeartData base64EncodedStringWithOptions:0];
        [blockSelf netForSyncHeartContinueWatch:watch andDataBase:base64Str];
        
    } fail:^(NSString * errorStr) {
        
        [blockSelf.tableView reloadData];
        LBLog(@"心率失败 %@",watch.peripheral.name);
        
        if (watch.peripheral.state == CBPeripheralStateDisconnected) {
            [self toSendConnectWithWatch:watch];
        } else {
            [blockSelf toSyncHearContinueWithWatch:watch];
        }
    }];
}


//同步数据完成
-(void)toSyncWatchCompleted:(LBWatchPerModel*)watch {

    watch.type = LBWatchTypeDone;
    [self.tableView reloadData];
    LBLog(@"同步完成 %@",watch.peripheral.name);
    [self.blueTools cancelPeripheralConnection:watch.peripheral];
    LBLog(@"请求断开 %@",watch.peripheral.name);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([self.waitingConnectArray count]) {
            [[self mutableArrayValueForKey:@"waitingConnectArray"] removeObjectAtIndex:0];
        }
    });
}





#pragma mark  ---接口相关----
-(void)netForSyncWalkWatch:(LBWatchPerModel*)watch andDataBase:(NSString*)dataBase{
    
    watch.type = LBWatchTypeupDataWalk;
    [self.tableView reloadData];
    [self toSyncHearContinueWithWatch:watch];    
}


-(void)netForSyncHeartContinueWatch:(LBWatchPerModel*)watch andDataBase:(NSString*)dataBase{
    
    watch.type = LBWatchTypeupDataHeart;
    [self.tableView reloadData];
    
    [self toCleanWatch:watch];    
}



-(void)toCleanWatch:(LBWatchPerModel *)watchModel {
    
    __weak HJBluetootManager * blockSelf = self;
    
    [watchModel orderCleanSuccess:^(NSObject *anyObj) {
        
        LBLog(@"%@: 清理成功",watchModel.peripheral.name);
        [self toSyncWatchCompleted:watchModel];
        
    } fail:^(NSString *errorStr) {
        
        LBLog(@"%@: 清理失败, 重操作",watchModel.peripheral.name);
        [self toCleanWatch:watchModel];    
    }];
}




//------------------------------------- Test code end
#pragma mark  Test code end
#pragma mark -








#pragma mark  ----蓝牙操作相关-----
//当前没有连接中的设备时,自动检测等待队列
-(void)setConnectingWatch:(LBWatchPerModel *)connectingWatch {
    
    if (connectingWatch) {
        _connectingWatch = connectingWatch;
    }else{        
        _connectingWatch = nil;
//        [self performSelector:@selector(syncWatchInWaitingQueue) withObject:nil afterDelay:0];
    }
}


//配置蓝牙状态更变的回调
-(void)stepBlueStateChangeBlock {
    
    __weak JRSynHeartVC* blockSelf = self;
    [self.blueTools setDidUpdateStateBlock:^(CBCentralManager *centralManager) {
        
        switch (centralManager.state) {
            case CBCentralManagerStateUnknown: blockSelf.stateLB.text = @"蓝牙初始化中...";
                break;
            case CBCentralManagerStateResetting: blockSelf.stateLB.text = @"Resetting...";
                break;
            case CBCentralManagerStateUnsupported: blockSelf.stateLB.text = @"您的设备不支持蓝牙";
                break;
            case CBCentralManagerStateUnauthorized: blockSelf.stateLB.text = @"您的设备蓝牙未授权";
                break;
            case CBCentralManagerStatePoweredOff: blockSelf.stateLB.text = @"您的设备未打开蓝牙,请打开蓝牙";
                break;
                
            case CBCentralManagerStatePoweredOn:{
                blockSelf.stateLB.text = @"正在搜索附近的手表";
                if (blockSelf.blueTools.scanWatchArray.count) {
                    blockSelf.isAutoSync = NO;
                    LBLog(@"蓝牙瞬断了");
                    
                    UIAlertView* alert =  [[UIAlertView alloc]initWithTitle:nil message:@"设备蓝牙刚才断开了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    
                    for (LBWatchPerModel* watch in blockSelf.blueTools.scanWatchArray) {
                        if (watch.type != LBWatchTypeDone && watch.type !=LBWatchTypeUnConnected) {
                            watch.type = LBWatchTypeDisConnected;
                            blockSelf.waitingConnectArray = nil;
//                            blockSelf.connectingWatch = nil;
                            [blockSelf.tableView reloadData];
                        }
                    }
                    [blockSelf.navigationController popViewControllerAnimated:YES];
                    return ;
                }
                
                //开始扫描
                [blockSelf.blueTools startScanWithResultBlock:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
                    
                    NSString* localName =advertisementData[@"kCBAdvDataLocalName"];
                    NSArray* arr = [localName componentsSeparatedByString:@"-"];
                    
                    //判断是否为lifeBit手表
                    if (arr && [arr[0] isEqualToString:@"SmartAM"]) {
                        if ([[LifeBitCoreDataManager shareInstance] efGetBoxIsWatch:[arr objectAtIndexWithSafety:1]]) {
                            LBWatchPerModel* watch =[LBWatchPerModel watchPerWithPeripheral:peripheral];
                            if (![blockSelf.blueTools.scanWatchArray containsObject:watch]) {
                                [blockSelf.blueTools.scanWatchArray addObject:watch];
                                [blockSelf.tableView reloadData];
                            }
                        }
                    }
                    
                }];
                break;
            }
        }
    }];
}


//配置蓝牙断连回调
-(void)stepBlueDisConnectBlock{
    
    __weak JRSynHeartVC* blockSelf = self;
    [self.blueTools setDisconnectPeripheralBlock:^(CBCentralManager *central, LBWatchPerModel * watch) {
        
        if (watch.type != LBWatchTypeDone) {
            
            watch.type = LBWatchTypeDisConnected;
            [blockSelf.tableView reloadData];
            
            //连接时断开
            if (watch == blockSelf.connectingWatch) {
//                NSLog(@"连接时异常导致断开%@",watch.peripheral.name);
                watch.type = LBWatchTypeDisConnected;
//                blockSelf.connectingWatch = nil;
            }
        }else{
//            NSLog(@"同步成功并断开连接%@",watch.peripheral.name);
        }
        
        if (blockSelf.isAutoSync) {
            [blockSelf syncAllWatch];
        }
        
    }];
}


//同步某一个设备
-(void)syncWatch:(LBWatchPerModel*)watch {
    
    if (watch.upDateWalkData.length > 1 && watch.isConnected) {
        NSString* base64Str = [watch.upDateWalkData base64EncodedStringWithOptions:0];
        [self netForSyncWalkWatch:watch andDataBase:base64Str];
        return;
    }
        
    if (watch.type != LBWatchTypeWait  && !watch.isConnected) {
        
        watch.type = LBWatchTypeWait;
        [self.tableView reloadData];
        
        LBLog(@"将%@加入等待连接列表",watch.peripheral.name);
        
        if (![self.waitingConnectArray containsObject:watch] && self.connectingWatch!= watch) {
            [self.waitingConnectArray addObject:watch];
        }
    }
    //当前正有设备在连接中
    if (self.connectingWatch) {
        
    }else{
        [self syncWatchInWaitingQueue];
    }
}


//同步等待队列中的手表
-(void)syncWatchInWaitingQueue {
    
    LBLog(@"准备连接等待队列中的设备");
    
    if (!self.waitingConnectArray.count) {
        LBLog(@"没有设备在等待队列中");
        return;
    }
    LBWatchPerModel* watch = self.waitingConnectArray[0];

    //进行设备的连接
    if (watch.type == LBWatchTypeDisConnected) {
        LBLog(@"准备重连%@",watch.peripheral.name);
       [self performSelector:@selector(prepareConnectWatch:) withObject:watch afterDelay:.5];
       
    }else{
       [self prepareConnectWatch:watch];
    }
}


-(void)prepareConnectWatch:(LBWatchPerModel*)watch {
    
    __weak JRSynHeartVC * weakSelf = self;
    weakSelf.connectingWatch = watch;
    [weakSelf.waitingConnectArray removeObject:watch];
    
    LBLog(@"正在连接%@",watch.peripheral.name);
    
    watch.type = LBWatchTypeConnecting;
    [self.tableView reloadData];
    
    // 延迟2秒执行：
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        if (weakSelf.clearAllData) {
             [weakSelf cleanWatch:watch];
        }else{
            [weakSelf connectWatch:watch];
        }
    });
}


-(void)connectWatch:(LBWatchPerModel*)watch{

    __weak JRSynHeartVC* blockSelf = self;
    
    [self.blueTools connectWatch:watch andSuccess:^(CBPeripheral *peripheral) {
//        NSLog(@"连接成功%@",watch.peripheral.name);
        blockSelf.connectingWatch = nil;
        watch.type = LBWatchTypeConnected;
        [blockSelf.tableView reloadData];
        
        [blockSelf syncTimeWithWatch:watch];
    } andFail:^(NSString * errorStr) {
//        NSLog(@"连接失败%@",watch.peripheral.name);
        blockSelf.connectingWatch = nil;
        watch.type = LBWatchTypeDisConnected;
        [blockSelf.tableView reloadData];
        [blockSelf.blueTools cancelPeripheralConnection:watch.peripheral];
    }];
}



//同步时间
-(void)syncTimeWithWatch:(LBWatchPerModel*)watch {
    
    __weak JRSynHeartVC* blockSelf = self;
    
    [watch syncTimeWithSuccess:^(NSObject *anyObj) {
        
        [blockSelf orderWorkTimeWithWatch:watch];
        
    } fail:^(NSString *errorStr) {
        
        watch.type = LBWatchTypeDisConnected;
        [blockSelf.tableView reloadData];
        [blockSelf.blueTools cancelPeripheralConnection:watch.peripheral];
    }];
}



//同步计步数据
-(void)syncWalkWithWathch:(LBWatchPerModel*)watch{
    
    //已同步过步数数据
    if (watch.upDateWalkData.length >1) {
        NSString* base64Str = [watch.upDateWalkData base64EncodedStringWithOptions:0];
//        NSLog(@"%@",watch.upDateWalkData);
        [self netForSyncWalkWatch:watch andDataBase:base64Str];
        return ;
    }
    
    watch.type = LBWatchTypeSyncWalk;
    [self.tableView reloadData];
    
    __weak JRSynHeartVC* blockSelf = self;
    [watch syncWalkWithProgress:^(NSObject *anyObj) {
        
        
    } Success:^(NSObject *anyObj) {
        
        watch.upDateWalkData = (NSData*)anyObj;
        watch.progressStr = @"";
        //        NSLog(@"%@",watch.upDateWalkData);
        
#warning aimi
        NSString* base64Str = [watch.upDateWalkData base64EncodedStringWithOptions:0];
        
        [blockSelf netForSyncWalkWatch:watch andDataBase:base64Str];
//                 [blockSelf syncDoneWithWatch:watch];
        
    } fail:^(NSString *errorStr){
        LBLog(@"同步步数出现错误 %@",watch.peripheral.name);
        
        watch.type = LBWatchTypeDisConnected;
        watch.progressStr = @"";
        [blockSelf.tableView reloadData];
        [blockSelf.blueTools cancelPeripheralConnection:watch.peripheral];
        
        [blockSelf syncWalkWithWathch:watch];
    }];
}


//同步连续心率
-(void)syncHearContinueWithWatch:(LBWatchPerModel*)watch{
    //已同步过连续心率
    if (watch.upDateHeartData.length >1) {
        NSString* base64Str = [watch.upDateHeartData base64EncodedStringWithOptions:0];
//        NSLog(@"%@",watch.upDateHeartData);
        [self netForSyncHeartContinueWatch:watch andDataBase:base64Str];
        return ;
    }
    
    __weak JRSynHeartVC* blockSelf = self;
    
    watch.type = LBWatchTypeSyncHeart;
    [self.tableView reloadData];
    
    [watch syncHeartContinueWithProgress:^(NSObject *anyObj) {
        
        
    } Success:^(NSObject *anyObj) {
        watch.upDateHeartData = (NSData*)anyObj;
        
//        NSLog(@"%@",watch.upDateHeartData);
        NSString* base64Str = [watch.upDateHeartData base64EncodedStringWithOptions:0];
        
        [blockSelf netForSyncHeartContinueWatch:watch andDataBase:base64Str];
        
    } fail:^(NSString *errorStr) {
        watch.type = LBWatchTypeDisConnected;
        watch.progressStr = @"";
        [blockSelf.tableView reloadData];
        [blockSelf.blueTools cancelPeripheralConnection:watch.peripheral];
    }];
}



//清除数据
-(void)orderCleanWithWatch:(LBWatchPerModel*)watch{
    watch.type = LBWatchTypeClean;
    [self.tableView reloadData];
    __weak JRSynHeartVC* blockSelf = self;
    [watch orderCleanSuccess:^(NSObject *anyObj) {
        [blockSelf syncDoneWithWatch:watch];
    } fail:^(NSString *errorStr) {
        watch.type = LBWatchTypeDisConnected;
        [blockSelf.tableView reloadData];
        [blockSelf.blueTools cancelPeripheralConnection:watch.peripheral];
    }];
}



//设置工作时间
-(void)orderWorkTimeWithWatch:(LBWatchPerModel*)watch{
    __weak JRSynHeartVC* blockSelf = self;
    [watch orderWorkTimeSuccess:^(NSObject *anyObj) {
        NSLog(@"------------\n 设置工作时间成功---------\n");
        [blockSelf syncWalkWithWathch:watch];
    } fail:^(NSString *errorStr) {
        watch.type = LBWatchTypeDisConnected;
        [blockSelf.tableView reloadData];
        [blockSelf.blueTools cancelPeripheralConnection:watch.peripheral];
    }];
}



//进入休眠
-(void)orderSleepWithWatch:(LBWatchPerModel*)watch{
    [watch orderSleep];
}



-(void)cleanWatch:(LBWatchPerModel*)watch {

    __weak JRSynHeartVC* blockSelf = self;
    
    [self.blueTools connectWatch:watch andSuccess:^(CBPeripheral *peripheral) {
//        blockSelf.connectingWatch = nil;
        watch.type = LBWatchTypeConnected;
        [blockSelf.tableView reloadData];
        [blockSelf orderCleanWithWatch:watch];
        
    } andFail:^(NSString *errorStr) {
//        blockSelf.connectingWatch = nil;
        watch.type = LBWatchTypeDisConnected;
        [blockSelf.tableView reloadData];
        [blockSelf.blueTools cancelPeripheralConnection:watch.peripheral];
        
    }];
}

//同步数据完成
-(void)syncDoneWithWatch:(LBWatchPerModel*)watch {
   
    watch.type = LBWatchTypeDone;

    [self.tableView reloadData];
    
    [self toSyncWatchCompleted:watch];
}



//同步所有手表
-(void)syncAllWatch {
    
    self.isAutoSync = YES;  // 判断当前是否全部处于等待同步中
    BOOL isAllSynced = YES; // 是否是所有的手表都同步完成
    NSInteger connectedCount = 0;
    NSInteger connectedMax   = 3;
    
    for (LBWatchPerModel * watch in self.blueTools.scanWatchArray) {
        
        if (watch.type != LBWatchTypeDone) {
            isAllSynced = NO;
        }
        
        // 等待连接的手表数量
        if (watch.isConnected || watch.type == LBWatchTypeWait) {
            connectedCount++;
        }
    }
    if (isAllSynced == YES) {
        NSLog(@"当前所有设备已全部同步完成");
        if (self.clearAllData) {
             [self showSuccessAlertAndPopVCWithTitleStr:@"清除完成"];
            return;
        }
        self.isAutoSync = NO;
        
        if (self.isUpload) {
            NSLog(@"点击了上传数据");
            if (![[HttpHelper JSONRequestManager] isNetWork]) {
                [self showErroAlertWithTitleStr:@"请在有网络的环境下，上传运动数据"];
                return ;
            }
            if (self.haveClassArr.count <= 0) {
                [self showSuccessAlertAndPopVCWithTitleStr:@"数据同步成功，没有需要上传的课程"];
                return;
            }
            [self showNetWorkAlertWithTitleStr:@"数据上传"];
            
            for (int i = 0; i < self.haveClassArr.count; i++) {
                self.successfulCount++;
                HaveClassModel * haveClassModel = self.haveClassArr[i];
                HJClassInfo * classInfo = [HJClassInfo createClassInfoWithHaveClassModel:haveClassModel];
                NSMutableArray *studentDataArr = [self getWatchAssignWithType:1 andWithClassInfo:classInfo];
                [self netForSyncHeartContinueWatch:classInfo WithStudentData:studentDataArr];
            }
            
        }else{
            if (self.synHeartSoureType != JRSynHeartSoureTypePerson) {
                
                HJUploadHeartDataVC *uploadHeartDataVc = [[HJUploadHeartDataVC alloc] init];
                uploadHeartDataVc.synHeartSoureType = self.synHeartSoureType;
                [self pushHiddenTabBar:uploadHeartDataVc];
            }
        }
        return;
    }
    
    
#warning  ---- 循环发起同步
    //循环发起同步
    for (LBWatchPerModel * watch in self.blueTools.scanWatchArray) {
        
        if (connectedCount >= connectedMax) {
            return;
        }
        NSLog(@"------------------------------------------------------------------------");
        
        if ( watch.countConnected > 2 && watch.type != LBWatchTypeDone && watch.type != LBWatchTypeConnecting && !watch.isConnected ) {
            
            watch.type = LBWatchTypeNetError;
            [self.waitingConnectArray removeObject:watch];
            [self syncWatchInWaitingQueue];
            
            continue;
        }
        
        // 去除状态为连接状态、已完成状态、等待状态
        if (!watch.isConnected && watch.type != LBWatchTypeDone  && watch.type != LBWatchTypeConnecting && watch.type != LBWatchTypeNetError) {
            [self syncWatch:watch];
            connectedCount++;
        }
    }
}



#pragma --mrak-- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {

        if (alertView.tag == 100) {
            if (self.synHeartSoureType == JRSynHeartSoureTypeClass) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}



#pragma mark  ---tableviewDelegate ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.blueTools.scanWatchArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HJSyncDataCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HJSyncDataCell"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HJSyncDataCell" owner:self options:nil]lastObject];
    }
    
    LBWatchPerModel* watch = [self.blueTools.scanWatchArray objectAtIndexWithSafety:indexPath.row];
    cell.nameLb.text = [NSString stringWithFormat:@"手表%@",[self getWatchNo:watch.peripheral]];
    [cell.activity stopAnimating];
    cell.activity.hidden = YES;
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.progressLB.text = watch.progressStr;
    
    switch (watch.type) {
        case LBWatchTypeUnConnected:
            cell.stateLB.text = @"数据待同步";
            break;
            
        case LBWatchTypeConnecting:
            cell.stateLB.text = @"连接中";
            cell.stateLB.textColor = [UIColor darkGrayColor];
            cell.activity.hidden = NO;
            [cell.activity startAnimating];
                        
            break;
            
        case LBWatchTypeConnected:
            cell.stateLB.text = @"已连接";
            cell.stateLB.textColor = [UIColor darkGrayColor];
            cell.activity.hidden = NO;
            [cell.activity startAnimating];
            break;
            
        case LBWatchTypeSyncWalk:
            cell.stateLB.text = @"计步同步中";
            cell.stateLB.textColor = [UIColor darkGrayColor];
            cell.activity.hidden = NO;
            [cell.activity startAnimating];
            break;
            
        case LBWatchTypeupDataWalk:
            cell.stateLB.text = @"计步上传中";
            cell.stateLB.textColor = [UIColor darkGrayColor];
            cell.activity.hidden = NO;
            [cell.activity startAnimating];
            break;
            
        case LBWatchTypeSyncHeart:
            cell.stateLB.text = @"心率同步中";
            cell.stateLB.textColor = [UIColor darkGrayColor];
            cell.activity.hidden = NO;
            [cell.activity startAnimating];
            break;
            
        case LBWatchTypeupDataHeart:
            cell.stateLB.text = @"心率上传中";
            cell.stateLB.textColor = [UIColor darkGrayColor];
            cell.activity.hidden = NO;
            [cell.activity startAnimating];
            break;
            
        case LBWatchTypeClean:
            cell.stateLB.text = @"数据整理中";
            cell.stateLB.textColor = [UIColor darkGrayColor];
            cell.activity.hidden = NO;
            [cell.activity startAnimating];
            break;
            
        case LBWatchTypeDisConnected:
            
            if (self.isAutoSync) {
                cell.stateLB.text = @"等待重连";
                cell.stateLB.textColor = [UIColor darkGrayColor];
                cell.activity.hidden = NO;
                [cell.activity startAnimating];
            } else {
                cell.stateLB.text = @"连接出错,点击重连";
                cell.stateLB.textColor = [UIColor redColor];
            }
            break;
            
        case LBWatchTypeNetError:
            cell.stateLB.text = @"连接失败";
            cell.stateLB.textColor = [UIColor redColor];
            break;
            
        case LBWatchTypeDone:
            cell.stateLB.text = @"同步完成";
            cell.stateLB.textColor = [UIColor blueColor];
            break;
            
        case LBWatchTypeWait:
            cell.stateLB.text = @"等待连接";
            cell.stateLB.textColor = [UIColor lightGrayColor];
            cell.activity.hidden = NO;
            [cell.activity startAnimating];
            break;
            
        default: break;
    }
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
        
    HJSyncDataCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.stateLB.text isEqualToString:@"连接出错,点击重连"]) {
        [self toSendConnectWithWatch:[self.waitingConnectArray firstObject]];
    }
    
}


#pragma mark  -------分区的灰色分割
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return self.sectionOneView.bounds.size.height;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionOneView;

}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"重置数据";
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        LBWatchPerModel* watch = self.blueTools.scanWatchArray[indexPath.row];
        [self cleanWatch:watch];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}









-(NSString *)getWatchNo:(CBPeripheral*)per{
    NSString* localName =per.name;
    NSArray* arr = [localName componentsSeparatedByString:@"-"];
    WatchModel * watchModel = [[LifeBitCoreDataManager shareInstance] efGetWatchDetailedById:[arr objectAtIndexWithSafety:1]];
    return watchModel.watchNo;
}



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

-(NSDictionary *)coverUploadDatasWithType:(NSInteger)type tudentInfo:(HJStudentInfo*)studentInfo{
    NSMutableArray *countData= nil;
    if (type == 1 ){
        countData = studentInfo.headDataArr;
        
    }else{
        countData = studentInfo.weakDataArr;
    }
    NSMutableData *typeData = [NSMutableData data];
    
    NSMutableDictionary *studentDic = [NSMutableDictionary dictionary];
    //            拼接每个学生的数据
    NSMutableString *attStr = [NSMutableString string];
    for (HJBluetoothDataInfo*bluetoothDataInfo in countData) {
        if (bluetoothDataInfo.recordData <= 0) {
            continue;
        }
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
-(NSMutableArray*)getWatchDataAndClassInfo:(HJClassInfo*)classInfo{
    if (self.exceptionWatchArr == nil) {
        self.exceptionWatchArr = [NSMutableArray array];
    }
    // 删除记录的问题数据
    [self.exceptionWatchArr removeAllObjects];
    // 获取所有的手环
    NSMutableArray* watchMACArr = [[LifeBitCoreDataManager shareInstance] efGetAllWatchModel];
    // 根据班级获取所有学生数据
    NSMutableArray *classStudentArr = [[LifeBitCoreDataManager shareInstance] efGetClassAllStudentWith:classInfo.cClassId];
    // 将所有学生的model转换成学生
    NSMutableArray *studentArr = [NSMutableArray array];
    for (StudentModel*studentModel in classStudentArr) {
        HJStudentInfo *studentInfo = [HJStudentInfo createClassInfoWithStudentModel:studentModel];
        [studentArr addObject:studentInfo];
    }
    // 利用block进行排序
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
    NSInteger recordCount = secTime/5;
    NSInteger maxRecordCount = recordCount * 1.2;
    NSInteger minRecordCount = recordCount * 0.8;
    
    for (int i = 0; i < count; i++) {
        HJStudentInfo*studentInfo = sortStudentArr[i];
        // 判断学生是否参加上课，如果未参加上课，无数据
        BOOL isNot = [self isNotClass:classInfo callOvew:studentInfo];
        if (!isNot) {
            
            // 如果未点名，说明就无数据，点名了就有数据
            continue;
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
                NSLog(@"参加上课没有记录数据");
            }else if(dataArr.count > maxRecordCount){
                // 大于正常数据，删除多余的数据
            }
        }
        // 获取指定步数数据，并判断是否有异常
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
        
        // 十进制转换成16进制字符串
        NSString *hexStr = [self ToHex:averagerHear];
        // 16进制字符串转换成NSData
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
    for (int i = 0; i < 9; i++) {
        
        ttmpig = tmpid % 16;
        tmpid  = tmpid / 16;
        
        switch (ttmpig) {
            case 10: nLetterValue = @"A"; break;
            case 11: nLetterValue = @"B"; break;
            case 12: nLetterValue = @"C"; break;
            case 13: nLetterValue = @"D"; break;
            case 14: nLetterValue = @"E"; break;
            case 15: nLetterValue = @"F"; break;
            default: nLetterValue = [[NSString alloc]initWithFormat:@"%i",ttmpig];
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
            WatchModel *watchModel = [watchMACArr objectAtIndexWithSafety:indexTag];
            // 小于正常数据，做数据补全
            studentInfo.headDataArr = [self getClassAverageHear:classInfo withStudentMac:watchModel.watchMAC];
            
            [studentDataArr addObject: [self coverUploadDatasWithType:1 tudentInfo:studentInfo]];
            // 上传异常
            [self uploadExceptionWatchWithMac:watchModel.watchMAC andExcType:0];
        }
    }    
    // 设置超时时间
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
    [parameters setValue:studentDataArr     forKey:@"headData"];
    [parameters setValue:classInfo.cClassId forKey:@"classId"];
    [parameters setValue:startDateStr       forKey:@"courseStartTime"];
    [parameters setValue:courseId           forKey:@"courseId"];
    [parameters setValue:classInfo.cLessonPlanId            forKey:@"bookId"];
    [parameters setValue:[classInfo.cClassTime stringValue] forKey:@"courseLong"];

    
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
                    NSLog(@"array is %@",self.haveClassArr );
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
        case 0: remarkStr = @"手表收集数据异常";
            break;
        default: break;
    }
    [parameters setValue:remarkStr forKey:@"REMARK"];
    [self POST:KuploadException parameters:parameters andSuccess:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        
    } Failure:nil];
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



-(void)dealloc{
    NSLog(@"JRSynHeartVC dealloc");
}


@end
