//
//  HJMeterTimeVC.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/7.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJMeterTimeVC.h"
#import "HJMeterTimeCell.h"
#import "HJCustomPickerView.h"
#import "AppDelegate.h"

@interface HJMeterTimeVC ()<UIAlertViewDelegate>

@property (nonatomic,strong)NSMutableArray *scoreArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (weak, nonatomic) IBOutlet UILabel *minuteLb;
@property (weak, nonatomic) IBOutlet UILabel *secondLb;

@property (weak, nonatomic) IBOutlet UILabel *msLb;


@property (weak, nonatomic) IBOutlet UIButton *jiCountBtn;
@property (weak, nonatomic) IBOutlet UILabel *jiCountLb;

@property (weak, nonatomic) IBOutlet UILabel *startLb;

@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (nonatomic,strong)NSTimer *timer;

@property (nonatomic,assign)BOOL isTime;

@property (nonatomic,assign)BOOL isReset;


@property (nonatomic,assign) int persent;
@property (nonatomic,assign) int seconds;
@property (nonatomic,assign)int minutes;

@property (nonatomic,strong) NSMutableArray *scoreNameArr;
@end

@implementation HJMeterTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initialize{
    [self setNavigationBarTitleTextColor:@"计时器"];
    //设置右键按钮
    
//     状态为1时为计时
    if ([self.projectInfo.pProjectType  intValue] == 1) {
        UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(tapRightBtn)];
        rightBtn.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = rightBtn;
        
    }else{
        //        为计数时隐藏tableView
        self.tableView.hidden = YES;
    }
    
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.isReset = NO;
}


-(NSMutableArray *)scoreNameArr{
    if (_scoreNameArr == nil) {
        _scoreNameArr = [NSMutableArray array];
    }
    return _scoreNameArr;
}

-(NSMutableArray *)scoreArr{
    if (_scoreArr == nil) {
        _scoreArr = [NSMutableArray array];
    }
    return _scoreArr;
}
#pragma --mark-- 启动
static  int percens = 0;
- (IBAction)clickStartTimeItem:(UIButton *)sender{

    
    if (!self.isTime) {
        self.startLb.text = @"停止";
        [self.startBtn setImage:[UIImage imageNamed:@"stop_btn"] forState:UIControlStateNormal];
        
        
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerClick:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }else{
        
        
        self.isReset = YES;
        [self.jiCountBtn setImage:[UIImage imageNamed:@"TestBtn_yinying"] forState:UIControlStateNormal];
        self.jiCountLb.text = @"复位";
        [self.jiCountLb setTextColor:[UIColor whiteColor]];
        
        self.startLb.text = @"启动";
        [self.startBtn setImage:[UIImage imageNamed:@"TestBtn_yinying"] forState:UIControlStateNormal];
        [self.timer invalidate];
        
    }
    self.isTime = !self.isTime;
}


-(void)timerClick:(NSTimer*)timer{
    
    
    percens++;
    //    没过１００毫秒，就让秒＋１，然后让毫秒在归零
    if(percens==100){
        _seconds++;
        percens = 0;
    }
    if (_seconds == 60) {
        _minutes++;
        _seconds = 0;
    }
    
    NSString* minutesStr=@"";
    if (_minutes<10) {
        minutesStr=[NSString stringWithFormat:@"0%d",_minutes];
    }else{
        minutesStr=[NSString stringWithFormat:@"%d",_minutes];
    }
    self.minuteLb.text = minutesStr;
    
    NSString* secondsStr = @"";
    if (_seconds<10) {
        secondsStr = [NSString stringWithFormat:@"0%d",_seconds];
    }else{
        secondsStr = [NSString stringWithFormat:@"%d",_seconds];
    }
    self.secondLb.text = secondsStr;
    
    
    NSString* percensStr = @"";
    if (percens<10) {
        percensStr = [NSString stringWithFormat:@"0%d",percens];
    }else{
        percensStr = [NSString stringWithFormat:@"%d",percens];
    }
    self.msLb.text = percensStr;
    
    
}

-(void)tapRightBtn{
    //            HJStudentInfo *studentInfo = weakSelf.studentArr[index];
    NSMutableString *nameStr = [NSMutableString string];
    for (HJStudentInfo *stu in self.studentArr) {
        BOOL isScore = NO;
        for (NSDictionary *dic in self.scoreArr) {
            if ([[dic objectForKey:@"name"] isEqualToString:stu.studentName]) {
                isScore = YES;
            }
        }
        if (!isScore) {
            if (nameStr.length > 0) {
                [nameStr appendString:@","];
            }
            [nameStr appendString:stu.studentName];
            
        }
    }
    
    if (nameStr.length > 0) {
        NSString *msgStr =[NSString stringWithFormat:@"%@等同学，未设置成绩，继续保存吗？",nameStr];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msgStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 2000;
        [alertView show];
        return;
    }
    
    NSMutableString *tishiStr = [NSMutableString string];
    for (HJStudentInfo *stu in self.studentArr) {
        BOOL isAdd = NO;
        for (NSDictionary *dic in self.scoreArr) {
            if (stu.sScoreArr.count >= 5 && !isAdd) {
                if (tishiStr.length > 0) {
                    [tishiStr appendString:@","];
                }
                isAdd = YES;
                [tishiStr appendString:stu.studentName];
                continue;
            }
            if ([[dic objectForKey:@"name"] isEqualToString:stu.studentName]) {
                NSString *minStr = [dic objectForKey:@"minutes"];
                NSString *secStr = [dic objectForKey:@"seconds"];
                NSString *msecStr = [dic objectForKey:@"ms"];
                NSString *scoreStr = [NSString stringWithFormat:@"%02d′%02d″%02d",[minStr intValue] <= 0 ?0:[minStr intValue],[secStr intValue] <= 0 ?0:[secStr intValue],[msecStr intValue] <= 0 ?0:[msecStr intValue] ];
                    [stu.sScoreArr addObject:scoreStr];
    
                
            }
        }
        
    }
    
    if (tishiStr.length > 0) {
        NSString *msgStr = [NSString stringWithFormat:@"%@等同学不能添加新成绩",tishiStr];
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"温馨提示" message:msgStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }

   
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2000) {
        if (buttonIndex == 1) {
            NSMutableString *tishiStr = [NSMutableString string];
            for (HJStudentInfo *stu in self.studentArr) {
                BOOL isAdd = NO;
                for (NSDictionary *dic in self.scoreArr) {
                    if (stu.sScoreArr.count >= 5 && !isAdd) {
                        if (tishiStr.length > 0) {
                            [tishiStr appendString:@","];
                        }
                        [tishiStr appendString:stu.studentName];
                        isAdd = YES;
                        continue;
                    }
                    if ([[dic objectForKey:@"name"] isEqualToString:stu.studentName]) {
                        NSString *minStr = [dic objectForKey:@"minutes"];
                        NSString *secStr = [dic objectForKey:@"seconds"];
                        NSString *msecStr = [dic objectForKey:@"ms"];
                        NSString *scoreStr = [NSString stringWithFormat:@"%02d′%02d″%02d",[minStr intValue] <= 0 ?0:[minStr intValue],[secStr intValue] <= 0 ?0:[secStr intValue],[msecStr intValue] <= 0 ?0:[msecStr intValue] ];
                            [stu.sScoreArr addObject:scoreStr];
                        
                        
                    }
                }
                
            }
            
            if (tishiStr.length > 0) {
                NSString *msgStr = [NSString stringWithFormat:@"%@等同学不能添加新成绩",tishiStr];
                UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"温馨提示" message:msgStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                return;
            }
            
            [self.navigationController popViewControllerAnimated:YES];

        }
    }
}


- (IBAction)clickTimeCountItem:(UIButton *)sender{
    if (self.isReset) {
        percens = 0;
        _seconds = 0;
        _minutes = 0;
        self.minuteLb.text = @"00";
        self.secondLb.text = @"00";
        self.msLb.text = @"00";
        [self.scoreArr removeAllObjects];
        [self.tableView reloadData];
        self.isReset = !self.isReset;
        [self.jiCountBtn setImage:[UIImage imageNamed:@"kuang_yinying"] forState:UIControlStateNormal];
        self.jiCountLb.text = @"计次";
        [self.jiCountLb setTextColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"color_nav"]]];
        
        
    }else{
        if (!self.timer.isValid) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请开启计时器" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            return;
        }
        NSString *numberStr = [NSString stringWithFormat:@"%ld",(self.scoreArr.count + 1)];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.minuteLb.text,@"minutes", self.secondLb.text,@"seconds",self.msLb.text,@"ms",numberStr,@"number",nil];
        [self.scoreArr addObject:dic];
        [self.tableView reloadData];
    }
    
    
    
}


#pragma --mark-- UITableViewDataSource UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.scoreArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJMeterTimeCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"HJMeterTimeCell" owner:nil options:nil] lastObject];
    
    __weak typeof(cell) weakCell = cell;
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = self.scoreArr[indexPath.row];
    __weak NSDictionary *weakDic = dic;
    [cell setSelectStudentBlock:^(HJMeterTimeCell *timeCell, NSDictionary *timeDic) {
        if (weakSelf.studentArr.count <= 0) {
            [weakSelf showErroAlertWithTitleStr:@"请先选择测试学生！"];
            return;
        }
        NSMutableArray * studentNameArr = [NSMutableArray arrayWithCapacity:weakSelf.studentArr.count];
        for (HJStudentInfo *studentInfo in weakSelf.studentArr) {
            [studentNameArr addObject:studentInfo.studentName];
        }
        
        HJCustomPickerView *pickerView = [HJCustomPickerView createSelectPickerWithDataSource:studentNameArr andWithTitle:@"学生列表"] ;
        [pickerView setSelectPickerBlock:^(NSString *name, NSInteger index) {
            [weakCell selectUpdateStudentNameClick:name];
//            NSMutableDictionary *scoreNameDic = [weakDic mutableCopy];
//            [scoreNameDic setValue:name forKey:@"name"];
            for (NSMutableDictionary *dic in weakSelf.scoreArr) {
                if ([[dic objectForKey:@"number"]  integerValue] == index + 1) {
                    [dic setValue:name forKey:@"name"];
                }
            }

        }];
        [UIView animateWithDuration:0.5 animations:^{
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app.window addSubview:pickerView];
        }];
    }];
    
    [cell updateSelfUi:dic];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


@end
