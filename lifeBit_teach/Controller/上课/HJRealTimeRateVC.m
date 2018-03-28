//
//  HJRealTimeRateVC.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/14.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJRealTimeRateVC.h"
#import "IBLineChartView.h"
#import "IBLineChart.h"
#import "AudioPlayerManager.h"
#import "NSTimer+Expand.h"


@interface HJRealTimeRateVC ()<HJDetectionPeripheralRSSI,UIAlertViewDelegate>
{
    
    NSLock *theLock;
    NSThread *ticketsThreadone;
 
    
}
@property (weak, nonatomic) IBOutlet UILabel *RSSILB;

@property (weak, nonatomic) IBOutlet UILabel *curretnLb;
@property (nonatomic,strong)IBLineChartView * lineChartView;
@property (nonatomic,strong) IBLineChart * lineChart;


// 存储报警心率
@property (nonatomic,strong)NSMutableArray *savePoliceArr;


@end

@implementation HJRealTimeRateVC
-(void)dealloc{
    [[HJBluetootManager shareInstance].blueTools cancelAllBluePeripheral];;
    self.watchPerModel.delegate = nil;
    self.watchPerModel = nil;
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[HJBluetootManager shareInstance].blueTools cancelAllBluePeripheral];
    [[AudioPlayerManager shareInstance] stop];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    
}

-(void)initialize{
    
    
    NSString *str = [NSString stringWithFormat:@"%@同学(%@号实时心率)",self.studentInfo.studentName, self.studentInfo.studentNo];
    [self setNavigationBarTitleTextColor:str];


    /*
    self.lineChartView = [[IBLineChartView alloc] initWithFrame:(CGRect){20, 164, [UIScreen mainScreen].bounds.size.width - 2 *20, 400}];
     self.lineChartView.calibrationValues = [@[@40,@60, @80, @100, @120, @160, @180,@200] mutableCopy];
    [self.view addSubview:self.lineChartView];
    self.lineChartView.backgroundColor = [UIColor redColor];
    */
    
    self.lineChart = [[IBLineChart alloc] initWithFrame:(CGRect){20, 164, [UIScreen mainScreen].bounds.size.width - 2 *20, 400}];
    self.lineChart.horizontalScaleLineCount = 10;

//    self.lineChartView.calibrationValues = [@[@40,@60, @80, @100, @120, @160, @180,@200] mutableCopy];
    [self.view addSubview:self.lineChart];
//    self.lineChartView.backgroundColor = [UIColor redColor];
    

    __weak typeof(self) weakSelf = self;
    self.watchPerModel.type = LBWatchTypeConnecting;
    self.watchPerModel.delegate = self;
    
    
    [[HJBluetootManager shareInstance].blueTools connectWatch:self.watchPerModel andSuccess:^(CBPeripheral *peripheral) {
        
        [HJBluetootManager shareInstance].connectingWatch = nil;
        weakSelf.watchPerModel.type = LBWatchTypeConnected;
        NSLog(@"连接成功  %@",weakSelf.watchPerModel.peripheral.name);
        [weakSelf syncRealTimeWithWatch:weakSelf.watchPerModel];
        
    } andFail:^(NSString *errorStr) {
        
        NSLog(@"连接失败%@",weakSelf.watchPerModel.peripheral.name);
        [HJBluetootManager shareInstance].connectingWatch = nil;
        weakSelf.watchPerModel.type = LBWatchTypeDisConnected;
        [[HJBluetootManager shareInstance].blueTools cancelPeripheralConnection:weakSelf.watchPerModel.peripheral];
        
    }];
    
    
    __block int seconds = 0;
    [self.watchPerModel setGetReadTimeSyncHeartBlock:^(NSInteger heart) {
//        NSLog(@"实时心率 %ld",(long)heart);
        if (heart <= 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未开启连续心率模式，请检查手表" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alertView.tag = 9999;
            [alertView show];
            return;
        }
        
        [weakSelf checkAlarmRateWithRate:heart];
        
        if (seconds == 10) {
            weakSelf.curretnLb.text = [NSString stringWithFormat:@"当前心率：%ldbpm",(long)heart];
            [weakSelf.lineChart addData:@(heart)];
            seconds = 0;
        }
        seconds++;
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ((alertView.tag == 9999)) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

static BOOL isPlay = NO;
-(void)checkAlarmRateWithRate:(NSInteger)rate{
    if (self.savePoliceArr == nil) {
        self.savePoliceArr = [NSMutableArray array];
    }
    
    if (rate >= self.police_Hear || rate <= self.min_Hear) {
        [self.savePoliceArr addObject:[NSNumber numberWithInteger:rate]];
    }

    
    if (self.savePoliceArr.count <= 0) {
        return;
    }
    
    if (!isPlay) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[AudioPlayerManager shareInstance] player:@"msg.WAV"];
            isPlay = YES;
            sleep(3);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.savePoliceArr removeAllObjects];
                isPlay = NO;
            });
            
        });
    }
    
    
    
}
//同步时间
-(void)syncRealTimeWithWatch:(LBWatchPerModel*)watch{
    [watch syncRealTimeWithSuccess:^(NSObject *anyObj) {
        
        
    } fail:^(NSString *errorStr) {
        watch.type = LBWatchTypeDisConnected;
        
        [[HJBluetootManager shareInstance].blueTools cancelPeripheralConnection:watch.peripheral];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma --mark-- HJDetectionPeripheralRSSI

-(void)didReadRSSI:(NSNumber*)RSSI withPeripher:(CBPeripheral*)peripheral{
//    NSLog(@"信号：%@",RSSI);
    self.RSSILB.text = [NSString stringWithFormat:@"信号：%f",[self getDistance:RSSI]];
}


-(void)naviBack{
    [super naviBack];
//    取消所有连接
    [[HJBluetootManager shareInstance].blueTools cancelAllBluePeripheral];
    [[AudioPlayerManager shareInstance] stop];
}

#pragma --mark-- tools
-(CGFloat)getDistance:(NSNumber*)RSSI{
    float power = (abs([RSSI intValue]) - 59)/(10 * 2.0);
    return powf(10.0f, power);
}

@end
