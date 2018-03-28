  //
//  JRAddPlanVC.m
//  lifeBit_teach
//
//  Created by joyskim-ios1 on 16/9/7.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "JRAddPlanVC.h"
#import "JRAddPlanCell.h"
#import "HJCustomPickerView.h"
#import "AppDelegate.h"
#import "YQTableView.h"

@interface JRAddPlanVC ()<UITableViewDelegate,UITableViewDataSource>

//tableView的headerView
@property (strong, nonatomic) IBOutlet UIView *headerView;
//tableView
@property (weak, nonatomic) IBOutlet YQTableView *tableView;
//年级显示Label
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
//来源显示Label
@property (weak, nonatomic) IBOutlet UILabel *comeLabel;
//分类显示Label
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (strong ,nonatomic) NSMutableArray * gradeArr;
@property (strong ,nonatomic) NSMutableArray * categoryArr;
@property (strong ,nonatomic) NSMutableArray * comeArr;


@property (strong ,nonatomic) NSMutableArray * listArr;

@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) BOOL isPage;

@end

@implementation JRAddPlanVC
-(NSMutableArray *)categoryArr{
    if (!_categoryArr) {
        self.categoryArr =[ @[@"分类0",@"分类1",@"分类2",@"分类3",@"分类4",@"分类5",@"分类6",@"分类7",@"分类8",@"分类9"] mutableCopy];
    }
    return _categoryArr;
}
-(NSMutableArray *)gradeArr{
    if (!_gradeArr) {
        _gradeArr = [[NSMutableArray array] mutableCopy];
    }
    return _gradeArr;
}
-(NSMutableArray *)comeArr{
    if (!_comeArr) {
        _comeArr = [[NSMutableArray array] mutableCopy];
    }
    return _comeArr;
}

-(NSMutableArray *)listArr{
    if (!_listArr) {
        _listArr = [[NSMutableArray array] mutableCopy];
        
//        for (int i = 0 ; i < 10; i++) {
//            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//            [dic setValue:[NSString stringWithFormat:@"要领%d",i] forKey:@"yaoling"];
//            [dic setValue:[NSString stringWithFormat:@"分类%d",i] forKey:@"category"];
//            [dic setValue:[NSString stringWithFormat:@"%d",i] forKey:@"time"];
//            [_listArr addObject:dic];
//        }
 
    }
    return _listArr;
}
-(NSMutableArray *)selectYaoLingArr{
    if (!_selectYaoLingArr) {
        _selectYaoLingArr = [[NSMutableArray array]mutableCopy];
    }
    return _selectYaoLingArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置navi字体颜色
    [self setNavigationBarTitleTextColor:@"添加单元"];
    
    //设置右键按钮
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(tapRightBtn)];
    rightBtn.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;    
    [self refresh];
    
    
}
-(void)refresh{
    self.isPage = YES;
    __weak JRAddPlanVC* jrAddPlanVc = self;
    __weak NSMutableArray* listArr = self.listArr;
    // 下拉  调用的方法
    [self.tableView setEpDownPullClick:^{
        [listArr removeAllObjects];
        self.page = 1;
        jrAddPlanVc.isPage = YES;
        [jrAddPlanVc getAddPlanList];
    }];
    // 上拉拉  调用的方法
    [self.tableView setEpUpwardPullClick:^{
        ++self.page;
        jrAddPlanVc.isPage = NO;
        [jrAddPlanVc getAddPlanList];
    }];
    [self.tableView.header beginRefreshing];
    
}


#pragma mark  点击右键按钮 -- 进入个人中心
-(void)tapRightBtn
{
    if (self.arrWitnArrSelectBlock) {
        self.arrWitnArrSelectBlock(self.selectYaoLingArr);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark   选择年级弹框
- (IBAction)chooceGrate:(UIButton *)sender {
    self.gradeArr =[ @[@"一年级",@"二年级",@"三年级",@"四年级",@"五年级",@"六年级"] mutableCopy];
    HJCustomPickerView* picerView = [HJCustomPickerView createSelectPickerWithDataSource:self.gradeArr andWithTitle:@"分类选择"];
    [picerView setSelectPickerBlock:^(NSString *sexType, NSInteger index) {
        self.gradeLabel.text = sexType;
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        [app.window addSubview:picerView];
    }];
    
    
    
}
#pragma mark   选择来源弹框
- (IBAction)chooseCome:(UIButton *)sender {
    self.comeArr =[ @[@"平台教案库",@"学校教案库",@"我的教案库"] mutableCopy];
    HJCustomPickerView* picerView = [HJCustomPickerView createSelectPickerWithDataSource:self.comeArr andWithTitle:@"来源选择"];
    [picerView setSelectPickerBlock:^(NSString *sexType, NSInteger index) {
        self.comeLabel.text = sexType;
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        [app.window addSubview:picerView];
    }];
    
}
#pragma mark   选择分类弹框
- (IBAction)chooseCategory:(UIButton *)sender {
    
    HJCustomPickerView* picerView = [HJCustomPickerView createSelectPickerWithDataSource:self.categoryArr andWithTitle:@"分类选择"];
    [picerView setSelectPickerBlock:^(NSString *sexType, NSInteger index) {
        self.categoryLabel.text = sexType;

    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        [app.window addSubview:picerView];
    }];
    
}

#pragma mark   获取单元列表接口
-(void)getAddPlanList{
   
    NSDictionary *parameters = @{
                                 @"type":@"1",
                                 @"referId":[[HJUserManager shareInstance].user uTeacherId],
                                 @"grade":@"1",
                                 @"typeId":@"1",
                                 @"pharse":@"0",
                                 @"currentPage":[NSString stringWithFormat:@"%ld",(long)self.page],
                                 @"pageSize":@"10"
                                 
                                 };
    
    [self POST:KLessonPlanUnit_list parameters:parameters andSuccess:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] intValue] == 1) {
//             [self.listArr removeAllObjects];
            //添加到本地
            [self.listArr addObject:responseObject[@"feedback"]];
            [self.tableView.header endRefreshing];
        }else{
            [self.tableView.header endRefreshing];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.header endRefreshing];
    }];
    
    
}



#pragma mark   UITableViewDelegate方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JRAddPlanCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JRAddPlanCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JRAddPlanCell" owner:nil options:nil] lastObject];
    }
    [self.selectYaoLingArr removeAllObjects];
    [cell setArrWitnButtenSelectBlock:^(NSMutableDictionary* dic) {
        if (cell.selctButten.selected == YES) {
            for (NSMutableDictionary*selectedDic in self.selectYaoLingArr) {
                if ([selectedDic[@"title"] isEqualToString:dic[@"title"]]) {
                    return;
                }
            }
            [self.selectYaoLingArr addObject:dic];
            NSLog(@"!!!%lu",(unsigned long)self.selectYaoLingArr.count);

        }else{
            for (NSMutableDictionary*selectedDic in self.selectYaoLingArr) {
                if ([selectedDic[@"title"] isEqualToString:dic[@"title"]]) {
                    [self.selectYaoLingArr removeObject:selectedDic];
                    return;
                }
            }
            NSLog(@"!!!%lu",(unsigned long)self.selectYaoLingArr.count);


        }
  
    }];

    NSMutableDictionary* dic = self.listArr[indexPath.row];
    [cell setValue:dic];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 60);
    self.headerView.backgroundColor = UIColorFromRGB(0XEDEDED);
    return self.headerView;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}


@end
