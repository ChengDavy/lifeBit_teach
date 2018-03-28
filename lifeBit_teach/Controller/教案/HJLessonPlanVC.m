//
//  HJLessonPlanVC.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/2.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJLessonPlanVC.h"
#import "JRTeachPlanCell.h"
#import "JRCustomTeachPlanVC.h"
#import "AppDelegate.h"
#import "RDVTabBarController.h"
#import "HJCustomPickerView.h"
#import "JRCheckTeatchPlanVC.h"
#import "YQTableView.h"
#import "HJEmptyCell.h"

@interface HJLessonPlanVC ()<UITableViewDelegate,UITableViewDataSource>

//设置三个按钮
@property (weak, nonatomic) IBOutlet HJPageView *pageView;

//tableView的headerView
@property (strong, nonatomic) IBOutlet UIView *headerView;
//tableView的headerView里面的label
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;


@property (weak, nonatomic) IBOutlet YQTableView *tableView;
//年级显示Label
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
//分类显示Label
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (nonatomic,strong)NSMutableArray *lessonPlanTypeArr;

@property (strong ,nonatomic) NSMutableArray * gradeArr;
@property (strong ,nonatomic) NSMutableArray * categoryArr;
@property (strong ,nonatomic) NSMutableArray * teachPlanArr;
@property (strong ,nonatomic) NSMutableArray * teachSelectPlanArr;

@property (nonatomic,strong)NSString *scanGradeStr;
@property (nonatomic,strong)NSString *scanCategoryStr;

@property (assign ,nonatomic) NSInteger index;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) BOOL isPage;

@end
@implementation HJLessonPlanVC

-(NSMutableArray *)categoryArr{
    if (!_categoryArr) {
        _categoryArr = [[NSMutableArray array] mutableCopy];
    }
    return _categoryArr;
}
-(NSMutableArray *)gradeArr{
    if (!_gradeArr) {
        _gradeArr = [[NSMutableArray array]mutableCopy];
    }
    return _gradeArr;
}

-(NSMutableArray *)teachPlanArr{
    if (!_teachPlanArr) {
        
        _teachPlanArr = [[NSMutableArray array]mutableCopy];
        self.teachSelectPlanArr = [_teachPlanArr mutableCopy];
    }
    return _teachPlanArr;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"教案";
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    //设置navi字体颜色
    [self setNavigationBarTitleTextColor:@"教案"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCell:) name:@"addCellNotice" object:nil];
}


-(void)refresh:(NSInteger)type{
    self.isPage = YES;
    __weak HJLessonPlanVC* weakSelf = self;
    // 下拉  调用的方法
    [self.tableView setEpDownPullClick:^{
        [weakSelf.teachPlanArr removeAllObjects];
        weakSelf.page = 1;
        weakSelf.isPage = YES;
        if (![[HttpHelper JSONRequestManager] isNetWork]) {
            if (weakSelf.index == 1) {
                [weakSelf.teachPlanArr removeAllObjects];
                [weakSelf.teachSelectPlanArr removeAllObjects];
                NSMutableArray *lessonPlanModelArr = [[LifeBitCoreDataManager shareInstance] efGetAllLessonPlanModelWithTearchId];
                for (LessonPlanModel *lessonPlanModel in lessonPlanModelArr) {
                    HJLessonPlanInfo *lessonPlanInfo = [HJLessonPlanInfo creatLessonPlanInfoWithModel:lessonPlanModel];
                    [weakSelf.teachPlanArr addObject:lessonPlanInfo];
                    [weakSelf.teachSelectPlanArr addObject:lessonPlanInfo ];
                }
                [weakSelf.tableView.header endRefreshing];
                [weakSelf.tableView.footer endRefreshing];
                [weakSelf.tableView reloadData];
                return;
            }else{
                [weakSelf.tableView.header endRefreshing];
                [weakSelf.tableView.footer endRefreshing];
                [weakSelf showErroAlertWithTitleStr:@"暂无网络"];
            }
        }else{
            [weakSelf getTeachList:type];
        }
        
    }];
    // 上拉拉  调用的方法
    [self.tableView setEpUpwardPullClick:^{
        ++weakSelf.page;
        weakSelf.isPage = NO;
        if (![[HttpHelper JSONRequestManager] isNetWork]) {
            if (weakSelf.index == 1) {
                [self.teachPlanArr removeAllObjects];
                [self.teachSelectPlanArr removeAllObjects];
                NSMutableArray *lessonPlanModelArr = [[LifeBitCoreDataManager shareInstance] efGetAllLessonPlanModelWithTearchId];
                for (LessonPlanModel *lessonPlanModel in lessonPlanModelArr) {
                    HJLessonPlanInfo *lessonPlanInfo = [HJLessonPlanInfo creatLessonPlanInfoWithModel:lessonPlanModel];
                    [weakSelf.teachPlanArr addObject:lessonPlanInfo];
                    [weakSelf.teachSelectPlanArr addObject:lessonPlanInfo ];
                }
                [weakSelf.tableView.header endRefreshing];
                [weakSelf.tableView.footer endRefreshing];
                [weakSelf.tableView reloadData];

                return;
            }else{
                [weakSelf.tableView.header endRefreshing];
                [weakSelf.tableView.footer endRefreshing];
                [weakSelf showErroAlertWithTitleStr:@"暂无网络"];
            }
        }else{
            [weakSelf getTeachList:type];
        }
        
    }];
    [self.tableView.header beginRefreshing];
    
}
#pragma mark 通知有消息
-(void)addCell:(NSNotification* )notification{
   
    [self.teachPlanArr addObject:notification.userInfo[@"dic"]];
    if (self.pageView.defaultSelectIndex == 1) {
        [self.teachSelectPlanArr addObject:notification.userInfo[@"dic"]];
    }
     [self.tableView reloadData];
    
}
-(void)initialize{
    self.scanGradeStr = @"";
    self.scanCategoryStr = @"";
    //设置右键按钮
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"制作教案" style:UIBarButtonItemStyleDone target:self action:@selector(gotoCustomTeachPlan)];
    rightBtn.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    __weak typeof(self) weakSelf = self;
    [self.pageView setTapPageClickBlock:^(NSInteger selectIndex, UIButton *selectBtn) {
        [weakSelf refreshPlanWitnType:selectIndex];
    }];
    self.pageView.pageItemArr = @[@"我的教案库",@"学校教案库",@"平台教案库"];
    
    self.lessonPlanTypeArr = [[HJAppObject sharedInstance] getAllLessonPlanType];
}
-(void)refreshPlanWitnType:(NSInteger)index{
    
    [self.teachSelectPlanArr removeAllObjects];
    
    
    
    
    if (index == 1) {
        self.index = 1;
        [self refresh:2];
        
        
    }else if (index == 2) {
        self.index = 2;
        [self refresh:1];
        
        
 
    }else if (index ==3){
        self.index = 3;
        [self refresh:0];
        
    }
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //显示naviBar
    self.navigationController.navigationBar.hidden = NO;
    //隐藏返回按钮
    self.leftNavBtn.hidden = YES;
    
    //显示tabBar
    [self showTabBar];
}
-(void)showTabBar{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    RDVTabBarController *tabBar =(RDVTabBarController*) app.viewController;
    [tabBar setTabBarHidden:NO animated:NO];
}
#pragma mark   选择年级弹框
- (IBAction)chooceGrate:(UIButton *)sender {
    self.gradeArr =[ @[@"全部",@"一年级",@"二年级",@"三年级",@"四年级",@"五年级",@"六年级",@"七年级",@"八年级",@"九年级",@"十年级",@"十一年级",@"十二年级"] mutableCopy];
    HJCustomPickerView* picerView = [HJCustomPickerView createSelectPickerWithDataSource:self.gradeArr andWithTitle:@"年级选择"];
    __weak typeof(self) weakSelf = self;
    [picerView setSelectPickerBlock:^(NSString *sexType, NSInteger index) {
        weakSelf.gradeLabel.text = sexType;
        if (index == 0) {
            weakSelf.scanGradeStr = @"";
        }else{
            weakSelf.scanGradeStr = [NSString stringWithFormat:@"%ld",(long)index];
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
        [self showErroAlertWithTitleStr:@"没有更新到项目分类信息"];
        return;
    }
    HJLinkagePickerView *pickerView = [HJLinkagePickerView createSelectPickerWithDataSource:self.lessonPlanTypeArr andWithTitle:@"选择分类" WithType:HJLinkagePickerTypeLessonType] ;
    __weak typeof(self) weakSelf = self;
    
    [pickerView setSelectPickerBlock:^(NSInteger comperOne,NSInteger comerTwo) {
        HJProjectInfo *projectInfo =  [weakSelf.lessonPlanTypeArr objectAtIndexWithSafety:comperOne];
        HJSubProjectInfo *subClassInfo = [projectInfo.pSubProjectArr objectAtIndexWithSafety:comerTwo];
        if (comperOne == 0 && comerTwo == 0) {
            weakSelf.categoryLabel.text = @"全部";
            weakSelf.scanCategoryStr = [NSString stringWithFormat:@"%@",subClassInfo.sId];
        }else{
            weakSelf.categoryLabel.text = [NSString stringWithFormat:@"%@-%@",projectInfo.pProjectName,subClassInfo.sName];
            weakSelf.scanCategoryStr = [NSString stringWithFormat:@"%@",subClassInfo.sId];
        }
        
        [weakSelf.tableView.header beginRefreshing];
    }];
    [UIView animateWithDuration:0.5 animations:^{
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:pickerView];
    }];

}
#pragma mark   去自定义教案弹框
- (void)gotoCustomTeachPlan {
    if (![[HttpHelper JSONRequestManager] isNetWork]) {
        [self showErroAlertWithTitleStr:@"请在有网环境下，制作教案"];
        return;
    }
    JRCustomTeachPlanVC * jrcustomTeachPlanVc = [[JRCustomTeachPlanVC alloc]init];
//    jrcustomTeachPlanVc.index = self.index;
    [self pushHiddenTabBar:jrcustomTeachPlanVc];
}

#pragma mark   获取教案列表库
-(void)getTeachList:(NSInteger)type{

    NSMutableDictionary *parameters = [@{
                                 @"type":[NSString stringWithFormat:@"%ld",(long)type],
                                 @"grade":self.scanGradeStr,
                                 @"typeId":self.scanCategoryStr,
                                 @"currentPage":[NSString stringWithFormat:@"%ld",(long)self.page],
                                 @"pageSize":@"10",
                                 } mutableCopy];
    if (type == 2) {
        [parameters setValue:[HJUserManager shareInstance].user.uId forKey:@"referId"];
    }else if (type == 1){
        [parameters setValue:[HJUserManager shareInstance].user.uSchoolId forKey:@"referId"];
    }
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self POST:KPlatform_LessonPlanList parameters:parameters andSuccess:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 0) {
            if (self.isPage) {
                [self.teachSelectPlanArr removeAllObjects];
            }
            NSArray *feedbackArr = [responseObject objectForKey:@"feedback"];
            for (NSDictionary *lessonPlanDic in feedbackArr) {
                HJLessonPlanInfo *lessonPlanInfo = [[HJLessonPlanInfo alloc] init];
                [lessonPlanInfo setModelAttributes:lessonPlanDic];
                [self.teachSelectPlanArr addObject:lessonPlanInfo];
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

#pragma mark   UITableViewDelegate方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.teachSelectPlanArr.count > 0) {
        return self.teachSelectPlanArr.count;
    }
    return 1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.teachSelectPlanArr.count > 0) {
        JRTeachPlanCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JRTeachPlanCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JRTeachPlanCell" owner:nil options:nil] lastObject];
        }
        
        HJLessonPlanInfo*lessonPlanInfo = self.teachSelectPlanArr[indexPath.row];
        [cell setValue:lessonPlanInfo withIndex:self.index];
        
        return cell;

    }else{
        HJEmptyCell *emptyCell = [[[NSBundle mainBundle] loadNibNamed:@"HJEmptyCell" owner:nil options:nil] lastObject];
        if (![[HttpHelper JSONRequestManager] isNetWork] && self.index != 1) {
            emptyCell.emptyImageView.image = [UIImage imageNamed:@"noNetwork"];
            emptyCell.contraintWithd.constant = 281;
            emptyCell.constriintHeiht.constant = 281;
        }
        
        return emptyCell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.teachSelectPlanArr.count > 0) {
        return 60;
    }else{
        return self.tableView.bounds.size.height;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 60);
    self.headerView.backgroundColor = UIColorFromRGB(0XEDEDED);
    self.headerLabel.text = @"  教案列表";
    return self.headerView;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[HJEmptyCell class]]) {
        return;
    }
    JRCheckTeatchPlanVC* jrCheckTeachPlanVc = [[JRCheckTeatchPlanVC alloc]init];
     HJLessonPlanInfo *lessonPlanInfo = self.teachSelectPlanArr[indexPath.row];
    if (self.index == 1) {
        jrCheckTeachPlanVc.lessonPlanShowType = JRLessonPlanShowTypeNone;
        jrCheckTeachPlanVc.isPlatform = NO;
    }else if(self.index == 2){
        jrCheckTeachPlanVc.lessonPlanShowType = JRLessonPlanShowTypeLessonPlan;
        jrCheckTeachPlanVc.isPlatform = NO;
    }else if(self.index == 3){
        jrCheckTeachPlanVc.lessonPlanShowType = JRLessonPlanShowTypeLessonPlan;
        jrCheckTeachPlanVc.isPlatform = YES;
    }
    jrCheckTeachPlanVc.lessonPlanInfo = lessonPlanInfo;
    [self pushHiddenTabBar:jrCheckTeachPlanVc];
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[HJEmptyCell class]]) {
        return NO;
    }
    if (self.index == 1) {
        return YES;
    }
    return NO;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//改变删除按钮的title
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        HJLessonPlanInfo*lessonPlanInfo = self.teachSelectPlanArr[indexPath.row];
        if (![HttpHelper JSONRequestManager].isNetWork) {
            [self showErroAlertWithTitleStr:@"请在网络环境下，删除教案"];
            return;
            [self showNetWorkAlertWithTitleStr:@"删除中"];
            LessonPlanModel *lessonPlanMode = [[LifeBitCoreDataManager shareInstance] efGetLessonPlanModelWithLessonPlan:lessonPlanInfo.sId];
            lessonPlanInfo = [HJLessonPlanInfo CreatLessonPlanInfoWithLessonPlanModel:lessonPlanMode];
            for (int i = 0; i < lessonPlanInfo.sPhaseArr.count ;i++ ) {
                HJLessonPlanPhaseInfo*phase = lessonPlanInfo.sPhaseArr[i];
                NSMutableArray * unitArr = [[LifeBitCoreDataManager shareInstance] efGetLessonPlanModelWithLessonPlan:lessonPlanInfo.sId withLessonPlanPhase:phase.pId];
                
                for (int j = 0;j < unitArr.count;j++ ) {
                    LessonPlanIdUnitModel*unitModel = unitArr[j];
                    [[LifeBitCoreDataManager shareInstance] efDeleteLessonPlanIdUnitModel:unitModel];
                    if (i == lessonPlanInfo.sPhaseArr.count - 1  && j == unitArr.count - 1) {
                        [self.teachSelectPlanArr removeObjectAtIndex:indexPath.row];
                        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                        [self performSelector:@selector(showSuccessAlertWithTitleStr:) withObject:@"删除成功" afterDelay:1.5];
                    }
                }
            }
            
            [[LifeBitCoreDataManager shareInstance] efDeleteLessonPlanModel:lessonPlanMode];
            
        }else{
            [self delectLessonPlanId:lessonPlanInfo.sId andIndexPath:indexPath];
        }
        
    }
}



#pragma --mark-- 网络
/*
 *删除
 */
-(void)delectLessonPlanId:(NSString*)lessonPlanId andIndexPath:(NSIndexPath*)indexPath{
    NSDictionary* parameters = @{
                                 @"bookId":lessonPlanId,
                                 
                                 } ;
    NSString *newInterface = KDelectLessonPlan_delete;
    [self POSTAndLoading:newInterface parameters:parameters andSuccess:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
            if ([[responseObject objectForKey:@"status"] intValue] == 0) {
                [self.teachSelectPlanArr removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                
                
                LessonPlanModel *lessonPlanMode = [[LifeBitCoreDataManager shareInstance] efGetLessonPlanModelWithLessonPlan:lessonPlanId];
                 HJLessonPlanInfo *lessonPlanInfo = [HJLessonPlanInfo CreatLessonPlanInfoWithLessonPlanModel:lessonPlanMode];
                for (int i = 0; i < lessonPlanInfo.sPhaseArr.count ;i++ ) {
                    HJLessonPlanPhaseInfo*phase = lessonPlanInfo.sPhaseArr[i];
                    NSMutableArray * unitArr = [[LifeBitCoreDataManager shareInstance] efGetLessonPlanModelWithLessonPlan:lessonPlanInfo.sId withLessonPlanPhase:phase.pId];
                    
                    for (int j = 0;j < unitArr.count;j++ ) {
                        LessonPlanIdUnitModel*unitModel = unitArr[j];
                        [[LifeBitCoreDataManager shareInstance] efDeleteLessonPlanIdUnitModel:unitModel];
                    }
                }
                 [[LifeBitCoreDataManager shareInstance] efDeleteLessonPlanModel:lessonPlanMode];
                [self showSuccessAlertWithTitleStr:@"教案删除成功"];
            }else{
                [self showSuccessAlertWithTitleStr:[NSString stringAwayFromNSNULL:[responseObject objectForKey:@"details"]]];
            }

    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

//释放消息中心
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addCellNotice"  object:nil];
    
}
@end
