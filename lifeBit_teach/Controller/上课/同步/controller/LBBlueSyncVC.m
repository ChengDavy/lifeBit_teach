//
//  LBBlueSyncVC.m
//  lifeBit_teach
//
//  Created by Aimi on 16/5/11.
//  Copyright © 2016年 joyskim. All rights reserved.
//

#import "LBBlueSyncVC.h"
#import "LBBlueSyncCell.h"
#import "AMLifeBitBlueTools.h"
#import "LBWatchPerModel.h"

@interface LBBlueSyncVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)AMLifeBitBlueTools* blueTools;
@property(nonatomic)LBWatchPerModel* connectingWatch;
@property(nonatomic,strong)NSMutableArray* waitingConnectArray;
@property(nonatomic)BOOL isAutoSync;

@end

@implementation LBBlueSyncVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillDisappear:(BOOL)animated{
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

- (IBAction)goBack:(id)sender{
    if (self.isAutoSync) {
        UIAlertView* alert =  [[UIAlertView alloc]initWithTitle:nil message:@"自动同步未完成,无法退出" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)initialize{
//    让app不息屏
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    self.title = @"数据同步";
    self.tableView.tableFooterView = [[UIView alloc]init];


    self.waitingConnectArray = [NSMutableArray array];
    self.isAutoSync = NO;
    self.blueTools = [AMLifeBitBlueTools instance];
    //配置蓝牙状态更改回调
    [self stepBlueStateChangeBlock];
    
    //配置蓝牙设备断连回调
    [self stepBlueDisConnectBlock];
    
}


#pragma mark  ----按钮点击相关----
- (IBAction)tapAllSyncBtn:(id)sender {
    if (self.isAutoSync) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"当前正在自动同步中" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
    }else{
        [self syncAllWatch];
    }
}





#pragma mark  ----蓝牙操作相关-----
//当前没有连接中的设备时,自动检测等待队列
-(void)setConnectingWatch:(LBWatchPerModel *)connectingWatch{
    if (connectingWatch) {
        _connectingWatch = connectingWatch;
    }else{
        
        _connectingWatch = nil;
        [self performSelector:@selector(syncWatchInWaitingQueue) withObject:nil afterDelay:0];
//        [self syncWatchInWaitingQueue];
    }
}


//配置蓝牙状态更变的回调
-(void)stepBlueStateChangeBlock{
    __weak LBBlueSyncVC* blockSelf = self;
    [self.blueTools setDidUpdateStateBlock:^(CBCentralManager *centralManager) {
        NSLog(@"状态改变回调了");
        
        switch (centralManager.state) {
            case CBCentralManagerStateUnknown:
                blockSelf.stateLB.text = @"蓝牙初始化中...";
                
                break;
                
            case CBCentralManagerStateResetting:
                blockSelf.stateLB.text = @"Resetting...";
                break;
                
            case CBCentralManagerStateUnsupported:
                blockSelf.stateLB.text = @"您的设备不支持蓝牙";
                break;
                
                
            case CBCentralManagerStateUnauthorized:
                blockSelf.stateLB.text = @"您的设备蓝牙未授权";
                break;
                
                
            case CBCentralManagerStatePoweredOff:
                blockSelf.stateLB.text = @"您的设备未打开蓝牙,请打开蓝牙";
//                [blockSelf.blueTools.scanWatchArray removeAllObjects];
//                [blockSelf.tableView reloadData];
                break;
                
                
            case CBCentralManagerStatePoweredOn:{
                blockSelf.stateLB.text = @"正在搜索附近的手表";
                if (blockSelf.blueTools.scanWatchArray.count) {
                    blockSelf.isAutoSync = NO;
                    NSLog(@"蓝牙瞬断了");
                    
                    UIAlertView* alert =  [[UIAlertView alloc]initWithTitle:nil message:@"设备蓝牙刚才断开了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    
                    for (LBWatchPerModel* watch in blockSelf.blueTools.scanWatchArray) {
                        if (watch.type != LBWatchTypeDone && watch.type !=LBWatchTypeUnConnected) {
                            watch.type = LBWatchTypeDisConnected;
                            blockSelf.waitingConnectArray = nil;
                            blockSelf.connectingWatch = nil;
                            [blockSelf.tableView reloadData];
                        }
                    }
                    
//                    if (blockSelf.isAutoSync) {
//                        [blockSelf syncAllWatch];
//                    }
                    
                    return ;
                }
                
                //开始扫描
                [blockSelf.blueTools startScanWithResultBlock:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
                    
                    NSString* localName =advertisementData[@"kCBAdvDataLocalName"];
                    NSArray* arr = [localName componentsSeparatedByString:@"-"];
                    
                    //判断是否为lifeBit手表
                    if (arr && [arr[0] isEqualToString:@"SmartAM"]) {
                        
                        LBWatchPerModel* watch =[LBWatchPerModel watchPerWithPeripheral:peripheral];
                        if (![blockSelf.blueTools.scanWatchArray containsObject:watch]) {
                            [blockSelf.blueTools.scanWatchArray addObject:watch];
                            [blockSelf.tableView reloadData];
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
    
    __weak LBBlueSyncVC* blockSelf = self;
    [self.blueTools setDisconnectPeripheralBlock:^(CBCentralManager *central, LBWatchPerModel * watch) {

        if (watch.type != LBWatchTypeDone) {
            
            NSLog(@"异常断开连接%@",watch.peripheral.name);
            watch.type = LBWatchTypeDisConnected;
            [blockSelf.tableView reloadData];
            
            //连接时断开
            if (watch == blockSelf.connectingWatch) {
                NSLog(@"连接时异常导致断开%@",watch.peripheral.name);
                watch.type = LBWatchTypeDisConnected;
                blockSelf.connectingWatch = nil;
            }
        }else{
            NSLog(@"同步成功并断开连接%@",watch.peripheral.name);
            
        }
        
        
        if (blockSelf.isAutoSync) {
            [blockSelf syncAllWatch];
        }
        
    }];
}


//同步某一个设备
-(void)syncWatch:(LBWatchPerModel*)watch{
    
    if (watch.upDateHeartData.length>1) {
        NSString* base64Str = [watch.upDateWalkData base64EncodedStringWithOptions:0];
//        [self netForSyncWalkWatch:watch andDataBase:base64Str];
    }

    
    
    if (watch.type!= LBWatchTypeWait && !watch.isConnected) {
        
        watch.type = LBWatchTypeWait;
        [self.tableView reloadData];
        
        NSLog(@"将%@加入等待连接列表",watch.peripheral.name);
        
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
-(void)syncWatchInWaitingQueue{
    NSLog(@"准备连接等待队列中的设备");
    
    if (!self.waitingConnectArray.count) {
        NSLog(@"没有设备在等待队列中");
        return;
    }
    
    
    
    LBWatchPerModel* watch = self.waitingConnectArray[0];
//    if (watch.upDateWalkData.length>1) {
//        NSLog(@"%@已经同步过数据了",watch.peripheral.name);
//        [self.waitingConnectArray removeObject:watch];
//        [self syncDoneWithWatch:watch];
//        return;
//    }
    //进行设备的连接
    if (watch.type == LBWatchTypeDisConnected) {
        NSLog(@"准备重连%@",watch.peripheral.name);
        [self performSelector:@selector(connectWatch:) withObject:watch afterDelay:.5];
    }else{
        [self connectWatch:watch];
    }
}

-(void)connectWatch:(LBWatchPerModel*)watch{
    self.connectingWatch = watch;
    [self.waitingConnectArray removeObject:watch];
    
    NSLog(@"正在连接%@",watch.peripheral.name);
    
    watch.type = LBWatchTypeConnecting;
    [self.tableView reloadData];
    
    __weak LBBlueSyncVC* blockSelf = self;
    [self.blueTools connectWatch:watch andSuccess:^(CBPeripheral *peripheral) {
        NSLog(@"连接成功%@",watch.peripheral.name);
        blockSelf.connectingWatch = nil;
        watch.type = LBWatchTypeConnected;
        [blockSelf.tableView reloadData];
        
        [blockSelf syncTimeWithWatch:watch];
    } andFail:^(NSString * errorStr) {
        NSLog(@"连接失败%@",watch.peripheral.name);
        blockSelf.connectingWatch = nil;
        watch.type = LBWatchTypeDisConnected;
        [blockSelf.tableView reloadData];
        [blockSelf.blueTools cancelPeripheralConnection:watch.peripheral];
    }];
}

//同步时间
-(void)syncTimeWithWatch:(LBWatchPerModel*)watch{
    __weak LBBlueSyncVC* blockSelf = self;
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
#warning aimi
    if (watch.upDateWalkData.length >1) {
        NSString* base64Str = [watch.upDateWalkData base64EncodedStringWithOptions:0];
        NSLog(@"%@",watch.upDateWalkData);
//        [self netForSyncWalkWatch:watch andDataBase:base64Str];
        return ;
    }
    
    
    
    watch.type = LBWatchTypeSyncWalk;
    [self.tableView reloadData];
    
    __weak LBBlueSyncVC* blockSelf = self;
    [watch syncWalkWithProgress:^(NSObject *anyObj) {
        
    } Success:^(NSObject *anyObj) {
       
        watch.upDateWalkData = (NSData*)anyObj;
        watch.progressStr = @"";
//        NSLog(@"%@",watch.upDateWalkData);
        
#warning aimi
        NSString* base64Str = [watch.upDateWalkData base64EncodedStringWithOptions:0];
//        [blockSelf netForSyncWalkWatch:watch andDataBase:base64Str];
//         [blockSelf syncDoneWithWatch:watch];
        
    } fail:^(NSString *errorStr){
        NSLog(@"同步步数出现错误 %@",watch.peripheral.name);
        
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
        NSLog(@"%@",watch.upDateHeartData);
//        [self netForSyncHeartContinueWatch:watch andDataBase:base64Str];
        return ;
    }
    
     __weak LBBlueSyncVC* blockSelf = self;
    
    watch.type = LBWatchTypeSyncHeart;
    [self.tableView reloadData];
    
    [watch syncHeartContinueWithProgress:^(NSObject *anyObj) {

    } Success:^(NSObject *anyObj) {
        watch.upDateHeartData = (NSData*)anyObj;

        NSLog(@"%@",watch.upDateHeartData);
        NSString* base64Str = [watch.upDateHeartData base64EncodedStringWithOptions:0];
//        [blockSelf netForSyncHeartContinueWatch:watch andDataBase:base64Str];
        
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
    __weak LBBlueSyncVC* blockSelf = self;
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
    __weak LBBlueSyncVC* blockSelf = self;
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



-(void)cleanWatch:(LBWatchPerModel*)watch{
    watch.type = LBWatchTypeConnecting;
    [self.tableView reloadData];
    
    __weak LBBlueSyncVC* blockSelf = self;
    
    
    [self.blueTools connectWatch:watch andSuccess:^(CBPeripheral *peripheral) {
        watch.type = LBWatchTypeConnected;
        [blockSelf.tableView reloadData];
        [blockSelf orderCleanWithWatch:watch];

    } andFail:^(NSString *errorStr) {
        watch.type = LBWatchTypeDisConnected;
        [blockSelf.tableView reloadData];
        [blockSelf.blueTools cancelPeripheralConnection:watch.peripheral];

    }];
}

//同步数据完成
-(void)syncDoneWithWatch:(LBWatchPerModel*)watch{
    watch.type = LBWatchTypeDone;
    
#warning aimi
//    [self.blueTools cancelPeripheralConnection:watch.peripheral];
    [self orderSleepWithWatch:watch];
    
    [self.tableView reloadData];
}

//同步所有手表
-(void)syncAllWatch{
    //判断当前是否全部处于等待同步中
    self.isAutoSync = YES;
    BOOL isAllSynced = YES;
    NSInteger connectedCount = 0;
    NSInteger connectedMax   = 10;
    for (LBWatchPerModel* watch in self.blueTools.scanWatchArray) {
        
        if (watch.type != LBWatchTypeDone) {
            isAllSynced = NO;
        }
        
//        if (watch.type != LBWatchTypeDone && watch.type !=LBWatchTypeDisConnected) {
//            isAllSynced = NO;
//        }

        if (watch.isConnected || watch.type == LBWatchTypeWait) {
            connectedCount++;
        }
    }
    
    if (isAllSynced == YES) {
        NSLog(@"当前所有设备已全部同步完成");
        self.isAutoSync = NO;
        return;
    }
    
    
    for (LBWatchPerModel* watch in self.blueTools.scanWatchArray) {
        if (connectedCount>= connectedMax) {
            return;
        }
        
        if (!watch.isConnected && watch.type != LBWatchTypeDone &&watch.type!=LBWatchTypeWait && watch.type!=LBWatchTypeConnecting) {
            [self syncWatch:watch];
            connectedCount++;
        }
        
//        if (!watch.isConnected && watch.type != LBWatchTypeDone &&watch.type!=LBWatchTypeWait && watch.type!=LBWatchTypeConnecting && watch.type !=LBWatchTypeDisConnected) {
//            [self syncWatch:watch];
//            connectedCount++;
//        }
    }
}



#pragma mark  ---tableviewDelegate ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.blueTools.scanWatchArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LBBlueSyncCell* cell = [tableView dequeueReusableCellWithIdentifier:@"LBBlueSyncCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"LBBlueSyncCell" owner:self options:nil]lastObject];
        }
        LBWatchPerModel* watch = self.blueTools.scanWatchArray[indexPath.row];
        cell.nameLB.text = watch.peripheral.name;
        [cell.activity stopAnimating];
        cell.activity.hidden = YES;
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.progressLB.text = watch.progressStr;
        
        switch (watch.type) {
            case LBWatchTypeUnConnected:
                cell.stateLB.text = @"点击同步";
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
                cell.stateLB.text = @"清楚数据中";
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
                }else{
                cell.stateLB.text = @"连接出错,点击重连";
                cell.stateLB.textColor = [UIColor redColor];
                }
                break;
                
            case LBWatchTypeNetError:
                cell.stateLB.text = @"上传失败";
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
                
                
            
                
            default:
                break;
        }
        return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    LBWatchPerModel* watch = self.blueTools.scanWatchArray[indexPath.row];
    
    [self syncWatch:watch];

    
}


#pragma mark  -------分区的灰色分割
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

        return self.sectionOneView.bounds.size.height;

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section == 1) {
        return self.sectionOneView;
//    }else{
//    
//        UIView* v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WINDOW_WIDTH, 10)];
//        v.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        return v;
//    }
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
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {

    }
}


#pragma mark  ---接口相关----
/*
-(void)netForSyncWalkWatch:(LBWatchPerModel*)watch andDataBase:(NSString*)dataBase{
    
    if ([dataBase isEqualToString:@""]) {
        [self syncHearContinueWithWatch:watch];
        UIAlertView* alert =  [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@ 没有步数数据",watch.peripheral.name] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    watch.type = LBWatchTypeupDataWalk;
    [self.tableView reloadData];
    
    NSArray* arr = [watch.peripheral.name componentsSeparatedByString:@"-"];
    
    NSDictionary* dic = @{
                          @"from":KUpdata_walk,
                          @"watchSport.data":dataBase,
                          @"watchSport.mac":arr[1]
                          };
    
    [self creatUnActivityPostBlock:KOld_Interface andDictionary:dic andSuccessBlock:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        NSLog(@"responseDic %@",responseDic);
        if ([responseDic[@"result"] integerValue]== 1) {
//            [self changeNetToSuccessWithTitleStr:@"已上传运动数据"];
            [self syncHearContinueWithWatch:watch];
        }else{
//            [self changeNetToErrorWithTitleStr:@"网络出错"];
            watch.type = LBWatchTypeNetError;
            [self.blueTools cancelPeripheralConnection:watch.peripheral];
            self.isAutoSync = NO;
            [self.tableView reloadData];
            
        }
        
    } andFailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self changeNetToErrorWithTitleStr:@"网络出错"];
        watch.type = LBWatchTypeNetError;
        self.isAutoSync = NO;
        [self.blueTools cancelPeripheralConnection:watch.peripheral];
        [self.tableView reloadData];
        
    }];
}


-(void)netForSyncHeartContinueWatch:(LBWatchPerModel*)watch andDataBase:(NSString*)dataBase{
    
    if ([dataBase isEqualToString:@""]) {
        watch.type = LBWatchTypeDone;
        [self.tableView reloadData];
//       UIAlertView* alert =  [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@ 没有心率数据",watch.peripheral.name] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
        [self syncDoneWithWatch:watch];
        return;
    }
    
    watch.type = LBWatchTypeupDataHeart;
    [self.tableView reloadData];
    
    NSArray* arr = [watch.peripheral.name componentsSeparatedByString:@"-"];
    
    NSDictionary* dic = @{
                          @"from":KUpdata_heart,
                          @"heartRate.data":dataBase,
                          @"heartRate.mac":arr[1]
                          };
    
    [self creatUnActivityPostBlock:KOld_Interface andDictionary:dic andSuccessBlock:^(AFHTTPRequestOperation *operation, NSDictionary *responseDic) {
        NSLog(@"responseDic %@",responseDic);
        if ([responseDic[@"result"] integerValue]== 1) {
            [self syncDoneWithWatch:watch];
            
        }else{
            watch.type = LBWatchTypeNetError;
            self.isAutoSync = NO;
            [self.blueTools cancelPeripheralConnection:watch.peripheral];
            [self.tableView reloadData];
        }
        
    } andFailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self changeNetToErrorWithTitleStr:@"网络出错"];
        watch.type = LBWatchTypeNetError;
        self.isAutoSync = NO;
        [self.blueTools cancelPeripheralConnection:watch.peripheral];
        [self.tableView reloadData];
    }];
}

*/
-(void)dealloc{
    NSLog(@"LBBLueSyncVC dealloc");
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
