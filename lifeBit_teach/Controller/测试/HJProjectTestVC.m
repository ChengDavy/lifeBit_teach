//
//  HJProjectTestVC.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/2.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJProjectTestVC.h"
#import "HJHistoryTestCell.h"
#import "HJTestStudentVC.h"
#import "HJCustomPickerView.h"
#import "AppDelegate.h"
@interface HJProjectTestVC()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *gradsBgView;
@property (weak, nonatomic) IBOutlet UITextField *gradsTF;

@property (weak, nonatomic) IBOutlet UIView *projectBgView;
@property (weak, nonatomic) IBOutlet UITextField *projectTF;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *footView;

@property (nonatomic,strong)NSMutableArray *historyTestProjectArr;


@property (nonatomic,strong)NSMutableArray *testProjectArr;
@property (nonatomic,strong)NSMutableArray *greadArr;

// 选中年级
@property (nonatomic,strong)HJClassInfo *selectClassInfo;
// 选中的项目
@property (nonatomic,strong)HJProjectInfo *selectProjectInfo;

@property (nonatomic,strong)NSMutableArray *savehistoryModelArr;

@end
@implementation HJProjectTestVC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"测试";
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    //设置navi字体颜色
    [self setNavigationBarTitleTextColor:@"测试"];
    [self initialize];
}

-(void)initialize{
    self.gradsBgView.layer.cornerRadius = 5;
    self.projectBgView.layer.cornerRadius = 5;
    self.footView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color_VCBG"]];
    self.tableView.tableFooterView = self.footView;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color_VCBG"]];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //显示naviBar
    self.navigationController.navigationBar.hidden = NO;
    //隐藏返回按钮
    self.leftNavBtn.hidden = YES;
    [self showTabBar];
    [self getLatestHistoryTest];
}

-(HJClassInfo *)selectClassInfo{
    if (_selectClassInfo == nil) {
        _selectClassInfo = [[HJClassInfo alloc] init];
    }
    return _selectClassInfo;
}

-(NSMutableArray *)historyTestProjectArr{
    if (_historyTestProjectArr == nil) {
        _historyTestProjectArr = [NSMutableArray array];
    }
    return _historyTestProjectArr;
}

-(void)getLatestHistoryTest{
    [self.historyTestProjectArr removeAllObjects];
    self.savehistoryModelArr = [[LifeBitCoreDataManager shareInstance] efGetAllHistoryTestModel];
    for (HistoryTestModel *historyTestModel  in self.savehistoryModelArr) {
        HJProjectInfo *prjectInfo = [HJProjectInfo converHistoryTestFromProject:historyTestModel];
        [self.historyTestProjectArr addObject:prjectInfo];
    }
    [self.tableView reloadData];
}

#pragma --mark-- 事件

- (IBAction)selectGradeTapClick:(UIButton *)sender {
    self.greadArr = [[HJAppObject sharedInstance] getSchoolAllGreadMsg];
    if (self.greadArr.count <= 0) {
        [self showErroAlertWithTitleStr:@"没有更新年级班级信息"];
        return;
    }
    HJLinkagePickerView *pickerView = [HJLinkagePickerView createSelectPickerWithDataSource:self.greadArr andWithTitle:@"选择班级" WithType:HJLinkagePickerTypeGread] ;
    __weak typeof(self) weakSelf = self;
    
    [pickerView setSelectPickerBlock:^(NSInteger comperOne,NSInteger comerTwo) {
        HJGreadInfo *greadInfo =  [weakSelf.greadArr objectAtIndexWithSafety:comperOne];
        HJSubClassInfo *subClassInfo = [greadInfo.gClassArr objectAtIndexWithSafety:comerTwo];
        NSLog(@"选中年级名称 ＝ %@   班级名称%@ ",greadInfo.gGreadName,subClassInfo.sClassName);
        weakSelf.selectClassInfo.cGradeId = greadInfo.gGreadID;
        weakSelf.selectClassInfo.cGradeName = greadInfo.gGreadName;
        weakSelf.selectClassInfo.cClassId = subClassInfo.sClassID;
        weakSelf.selectClassInfo.cClassName = subClassInfo.sClassName;
        weakSelf.gradsTF.text = [NSString stringWithFormat:@"%@%@",greadInfo.gGreadName,subClassInfo.sClassName];
    }];
    [UIView animateWithDuration:0.5 animations:^{
        AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [app.window addSubview:pickerView];
    }];
}

- (IBAction)selectProjectClick:(UIButton *)sender {
    self.testProjectArr = [[HJAppObject sharedInstance] getProjectList];
    NSMutableArray * projectNameArr = [NSMutableArray arrayWithCapacity:self.testProjectArr.count];
    for (HJProjectInfo *projectInfo in self.testProjectArr) {
        [projectNameArr addObject:projectInfo.pProjectName];
    }
    
    HJCustomPickerView *pickerView = [HJCustomPickerView createSelectPickerWithDataSource:projectNameArr andWithTitle:@"标准项目"] ;
    __weak typeof(self) weakSelf = self;
    
    [pickerView setSelectPickerBlock:^(NSString *sexType, NSInteger index) {
        NSLog(@"选中项目 ＝ %@   项目名称%@ ",weakSelf.testProjectArr[index],sexType);
        weakSelf.selectProjectInfo = [weakSelf.testProjectArr objectAtIndexWithSafety:index];
        weakSelf.projectTF.text = sexType;
    }];
    [UIView animateWithDuration:0.5 animations:^{
        AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [app.window addSubview:pickerView];
    }];

}


#pragma --mark-- 开始测试
- (IBAction)startTestProjectClick:(id)sender {
    if (self.selectClassInfo == nil || self.selectClassInfo.cClassId.length <= 0) {
        [self showErroAlertWithTitleStr:@"请选择测试年级"];
        return;
    }
    
    if (self.selectProjectInfo == nil || self.selectProjectInfo.pProjectID.length <= 0) {
        [self showErroAlertWithTitleStr:@"请选择测试项目"];
        return;
    }
    
//    保存历史查询数据
    
    [self saveTesthistoryClick];
    
    HJTestStudentVC *testStudentVc = [[HJTestStudentVC alloc] init];
    testStudentVc.projectInfo = self.selectProjectInfo;
    testStudentVc.classInfo = self.selectClassInfo;
    [self pushHiddenTabBar:testStudentVc];
}


#pragma --mark-- UITableViewDataSource UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.historyTestProjectArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HJHistoryTestCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"HJHistoryTestCell" owner:nil options:nil] lastObject];
    __weak typeof(self) weakSelf = self;
    [cell setAgainTestProjectBlock:^(HJProjectInfo * projectInfo) {
        HJTestStudentVC *testStudentVc = [[HJTestStudentVC alloc] init];
        HJClassInfo *classInfo = [[HJClassInfo alloc] init];
        classInfo.cClassId = projectInfo.pProjectClassId;
        classInfo.cClassName = projectInfo.pProjectClass;
        classInfo.cGradeName = projectInfo.pProjectGrade;
        classInfo.cGradeId =projectInfo.pProjectGradeId;

        testStudentVc.classInfo = classInfo;
        testStudentVc.projectInfo = projectInfo;
        [weakSelf pushHiddenTabBar:testStudentVc];
    }];
    NSDictionary *dic = self.historyTestProjectArr[indexPath.row];
    [cell updateSelfUiData:dic];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel* headLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth, 60)];
    headLb.text = @"  历史测试成绩";
    headLb.textColor = UIColorFromRGB(0x666666);
    headLb.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color_VCBG"]];
    headLb.font = [UIFont systemFontOfSize:18];
    return headLb;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma --mark-- 保存测试历史
-(void)saveTesthistoryClick{
//    NSMutableArray *historyArr = [[LifeBitCoreDataManager shareInstance] efGetAllHistoryTestModel];
    if (self.savehistoryModelArr.count >=5) {
        [[LifeBitCoreDataManager shareInstance] efDeleteHistoryTestModel:[self.savehistoryModelArr objectAtIndexWithSafety:0]];
    }
    HistoryTestModel* historyTestModel =[[LifeBitCoreDataManager shareInstance] efCraterHistoryTestModel];
    historyTestModel.classId = self.selectClassInfo.cClassId;
    historyTestModel.classname = self.selectClassInfo.cClassName;
    historyTestModel.greadId = self.selectClassInfo.cGradeId;
    historyTestModel.greadName = self.selectClassInfo.cGradeName;
    historyTestModel.projectName = self.selectProjectInfo.pProjectName;
    historyTestModel.projectId = self.selectProjectInfo.pProjectID;
    historyTestModel.projectUnit = self.selectProjectInfo.pProjectUnit;
    historyTestModel.data_type = self.selectProjectInfo.pProjectType;
    historyTestModel.remark = self.selectProjectInfo.pProjectRemark;
    historyTestModel.good = self.selectProjectInfo.pScoreGood;
    historyTestModel.pass = self.selectProjectInfo.pScorePass;
    historyTestModel.no_pass = self.selectProjectInfo.pScoreNoPass;
    historyTestModel.startDate = [NSDate date];
    historyTestModel.teacherId = [HJUserManager shareInstance].user.uTeacherId;
    [[LifeBitCoreDataManager shareInstance] efAddHistoryTestModel:historyTestModel];
    
    
}

@end
