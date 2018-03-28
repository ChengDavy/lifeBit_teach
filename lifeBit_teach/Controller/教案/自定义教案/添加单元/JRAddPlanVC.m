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

@property (nonatomic,strong)NSMutableArray *selectUnitArr;

@property (strong ,nonatomic) NSMutableArray * gradeArr;
@property (strong ,nonatomic) NSMutableArray * categoryArr;
@property (strong ,nonatomic) NSMutableArray * comeArr;

@property (nonatomic,strong)NSMutableArray *lessonPlanTypeArr;
//搜索年级
@property (nonatomic,strong)NSString* searchGradeTypeStr;
// 搜索项目
@property (nonatomic,strong)NSString* searchProjectTypeStr;
// 搜索来源
@property (nonatomic,strong)NSString* searchSourceTypeStr;


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
    
    self.lessonPlanTypeArr = [[HJAppObject sharedInstance] getAllLessonPlanType];
}
-(NSMutableArray *)selectUnitArr{
    if (_selectUnitArr == nil) {
        _selectUnitArr = [NSMutableArray array];
    }
    return _selectUnitArr;
}

-(void)refresh{
    self.isPage = YES;
    __weak JRAddPlanVC* jrAddPlanVc = self;
    __weak NSMutableArray* listArr = self.listArr;
    // 下拉  调用的方法
    [self.tableView setEpDownPullClick:^{
        [listArr removeAllObjects];
        jrAddPlanVc.page = 1;
        jrAddPlanVc.isPage = YES;
        [jrAddPlanVc getAddPlanList];
    }];
    // 上拉拉  调用的方法
    [self.tableView setEpUpwardPullClick:^{
        ++jrAddPlanVc.page;
        jrAddPlanVc.isPage = NO;
        [jrAddPlanVc getAddPlanList];
    }];
    [self.tableView.header beginRefreshing];
    
}


#pragma mark  点击右键按钮 -- 进入个人中心
-(void)tapRightBtn
{
//    if (self.arrWitnArrSelectBlock) {
//        self.arrWitnArrSelectBlock(self.selectYaoLingArr);
//    }
//    [self.navigationController popViewControllerAnimated:YES];
    if (self.selectUnitArr.count > 0) {
        if (self.arrWitnArrSelectBlock) {
            self.arrWitnArrSelectBlock([self.selectUnitArr copy]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self showErroAlertWithTitleStr:@"请选择单元"];
    }
}

#pragma mark   选择年级弹框
- (IBAction)chooceGrate:(UIButton *)sender {
    self.gradeArr =[ @[@"全部",@"一年级",@"二年级",@"三年级",@"四年级",@"五年级",@"六年级",@"七年级",@"八年级",@"九年级",@"十年级",@"十一年级",@"十二年级"] mutableCopy];
    HJCustomPickerView* picerView = [HJCustomPickerView createSelectPickerWithDataSource:self.gradeArr andWithTitle:@"分类选择"];
    __weak typeof(self) weakSelf = self;
    [picerView setSelectPickerBlock:^(NSString *sexType, NSInteger index) {
        weakSelf.gradeLabel.text = sexType;
        if (index == 0) {
            weakSelf.searchGradeTypeStr = @"";
        }else{
            weakSelf.searchGradeTypeStr = [NSString stringWithFormat:@"%ld",index];
        }

        [weakSelf.tableView.header beginRefreshing];
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:picerView];
    }];
    
    
    
}
#pragma mark   选择来源弹框
- (IBAction)chooseCome:(UIButton *)sender {
    self.comeArr =[ @[@"全部",@"我的单元",@"学校",@"平台"] mutableCopy];
    HJCustomPickerView* picerView = [HJCustomPickerView createSelectPickerWithDataSource:self.comeArr andWithTitle:@"来源选择"];
    __weak typeof(self) weakSelf = self;
    [picerView setSelectPickerBlock:^(NSString *sexType, NSInteger index) {
        self.comeLabel.text = sexType;
        if (index == 0) {
            weakSelf.searchSourceTypeStr = @"";
        }else{
            weakSelf.searchSourceTypeStr = [NSString stringWithFormat:@"%ld",index];
        }
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
        weakSelf.searchProjectTypeStr = subClassInfo.sId;
        [weakSelf.tableView.header beginRefreshing];
    }];
    [UIView animateWithDuration:0.5 animations:^{
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:pickerView];
    }];

}

#pragma mark   获取单元列表接口
-(void)getAddPlanList{
    
    NSMutableDictionary* parameters = [@{
                                         @"currentPage":[NSNumber numberWithInteger:self.page],
                                         @"pageSize":@"5",
                                         @"pharse":[NSNumber numberWithInteger:[self.phares intValue]]
                                         } mutableCopy];
    if (self.searchGradeTypeStr.length > 0 && [self.searchGradeTypeStr integerValue] > 0) {
        [parameters setValue:self.searchGradeTypeStr forKey:@"grade"];
    }
    
    if (self.searchSourceTypeStr.length > 0 && [self.searchGradeTypeStr integerValue] > 0) {
        [parameters setValue:self.searchSourceTypeStr forKey:@"type"];
    }
    
    if (self.searchProjectTypeStr.length > 0) {
        [parameters setValue:self.searchProjectTypeStr forKey:@"typeId"];
    }
    
    if ([self.searchSourceTypeStr intValue] == 1) {
        [parameters setValue:[HJUserManager shareInstance].user.uId forKey:@"referId"];
    }
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    [self POST:KLessonPlanUnit_list parameters:parameters andSuccess:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 0) {
            NSArray *feebackArr = [responseObject objectForKey:@"feedback"];
            if (self.isPage) {
                [self.listArr removeAllObjects];
            }
            for (NSDictionary *unitDic in feebackArr) {
                HJLessonPlanUnitInfo *lessonPlanUnitInfo = [[HJLessonPlanUnitInfo alloc] init];
                [lessonPlanUnitInfo setAttributes:unitDic];
                [self.listArr addObject:lessonPlanUnitInfo];
            }
            [self.tableView reloadData];
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
        }else{
            [self showErroAlertWithTitleStr:[NSString stringAwayFromNSNULL:[responseObject objectForKey:@"details"]]];
        }
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
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
    
    JRAddPlanCell *unitCell = [[[NSBundle mainBundle] loadNibNamed:@"JRAddPlanCell" owner:nil options:nil] lastObject];
    HJLessonPlanUnitInfo *unitInfo = self.listArr[indexPath.row];
    __weak HJLessonPlanUnitInfo *weakUnitInfo = unitInfo;
    __weak NSMutableArray *weakSelectArr = self.selectUnitArr;
    [unitCell setSelectUnitBlock:^(JRAddPlanCell *selfCell) {
        if ([weakSelectArr containsObject:weakUnitInfo]) {
            [selfCell exitSelectUnitClick];
            [weakSelectArr removeObject:weakUnitInfo];
        }else{
            [selfCell selectUniClick];
            [weakSelectArr addObject:weakUnitInfo];
        }
    }];
    [unitCell efUpdateSelfUi:unitInfo];
    return unitCell;
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
