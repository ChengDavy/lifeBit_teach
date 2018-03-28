//
//  HJUploadTestScoreVC.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/18.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJUploadTestScoreVC.h"
#import "HJUploadClassMsgCell.h"
#import "HJTestScoreClassVC.h"
@interface HJUploadTestScoreVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray *testClassArr;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation HJUploadTestScoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)initialize{
    [self setNavigationBarTitleTextColor:@"测试班级列表"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
-(NSMutableArray *)testClassArr{
    return [[LifeBitCoreDataManager shareInstance] efGetAllTestModel];
}


#pragma --mark-- UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.testClassArr.count <= 0) {
        return 1;
    }
    return self.testClassArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.testClassArr.count <= 0) {
        HJEmptyCell *emptyCell = [[[NSBundle mainBundle] loadNibNamed:@"HJEmptyCell" owner:nil options:nil] lastObject];
        return emptyCell;
    }
    
    
    HJUploadClassMsgCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"HJUploadClassMsgCell" owner:nil options:nil] lastObject];
    [cell.uploadBtn setTitle:@"上传测试成绩" forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;
    [cell setTapUploadDataBlock:^(HJClassInfo *classInfo) {
        NSLog(@"上传成绩");
        if (![[HttpHelper JSONRequestManager] isNetWork]) {
            [weakSelf showErroAlertWithTitleStr:@"请在有网络的环境下，上传成绩数据"];
            return ;
        }
        [weakSelf netWorkUploadTestScore:classInfo];
    }];
    TestModel *testModel = self.testClassArr[indexPath.row];
    HJClassInfo *classInfo = [HJClassInfo createClassInfoWithTestModel:testModel];
    cell.testProjectLb.text = [NSString stringWithFormat:@"测试项目：%@",classInfo.cProjectName];
    [cell updateSelfUi:classInfo];
    cell.uploadBtn.backgroundColor = UIColorFromRGB(0x2876FE);
    cell.uploadBtn.enabled = YES;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.testClassArr.count <= 0) {
        return self.tableView.bounds.size.height;
    }
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击了上传数据");
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[HJEmptyCell class]]) {
        return;
    }
    TestModel *testModel = self.testClassArr[indexPath.row];
    HJClassInfo *classInfo = [HJClassInfo createClassInfoWithTestModel:testModel];
    HJTestScoreClassVC *classStudentVC = [[HJTestScoreClassVC alloc] init];
    classStudentVC.classInfo = classInfo;
    [self pushHiddenTabBar:classStudentVC];
}

-(NSMutableArray*)getStudentScoreList:(HJClassInfo*)classInfo{
    NSMutableArray *scoreModelArr = [[LifeBitCoreDataManager shareInstance] efGetClassAllStudentSecoreWith:classInfo.cClassId withRecordDate:classInfo.cStartTime];
    NSMutableArray *scoreInfoArr = [NSMutableArray array];
    for (ScoreModel*scoreModel in scoreModelArr) {
        HJStudentInfo *stu = [HJStudentInfo createScoreInfoWithScoreModel:scoreModel];
        [scoreInfoArr addObject:stu];
    }
    return scoreInfoArr;
}

#pragma --mark-- 构建数据上传数据类型

// 成绩数据
-(NSMutableArray*)structureUploadScoreDataType:(HJClassInfo*)classInfo{
    NSMutableArray *scoreInfoArr =[self getStudentScoreList:classInfo];
    NSMutableArray *studentScoreArr = [NSMutableArray array];
    for (HJStudentInfo *studentInfo in scoreInfoArr) {
        NSMutableDictionary *stuDic = [NSMutableDictionary dictionary];
        [stuDic setValue:studentInfo.studentId forKey:@"studentId"];
        [stuDic setValue:studentInfo.sScoreArr forKey:@"scores"];
        [studentScoreArr addObject:stuDic];
    }
    for (HJStudentInfo *studentInfo in scoreInfoArr) {
        NSLog(@"项目类型＝ %@",studentInfo.sProjectType);
        NSLog(@"项目单位＝ %@",studentInfo.sProjectUnit);
        NSLog(@"成绩数据＝ %@",studentInfo.sScoreArr);
        NSLog(@"开始记录时间＝ %@",studentInfo.sStartDate);
    }
    
    return studentScoreArr;
}


-(void)netWorkUploadTestScore:(HJClassInfo*)classInfo{
   
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[self structureUploadScoreDataType:classInfo] forKey:@"scoresList"];
    [parameters setValue:classInfo.cProjectUnit forKey:@"UNIT"];
    [parameters setValue:classInfo.cProjectType forKey:@"TYPE"];
    [parameters setValue:classInfo.cProjectId forKey:@"PROJECT_ID"];
    [parameters setValue:classInfo.cClassId forKey:@"CLASS_ID"];
    
    [self POSTAndLoading:KuploadScore parameters:parameters andSuccess:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] intValue] == 1) {
            [self.testClassArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TestModel *testModel =(TestModel *)obj;
                if ([testModel.classId isEqualToString:classInfo.cClassId] && [testModel.startTime compare:classInfo.cStartTime] == NSOrderedSame) {
                    [[LifeBitCoreDataManager shareInstance] efDeleteTestModel:testModel];
                    *stop = YES;
                    
                    if (*stop == YES) {
                        
                        [self.testClassArr removeObject:testModel];
                        
                    }
                    
                }
                if (*stop) {
                    
//                    NSLog(@"array is %@",self.testClassArr );
                    
                }
            }];
            
            [self showSuccessAlertAndPopVCWithTitleStr:@"上传成功"];
        }else{
            [self showErroAlertWithTitleStr:@"数据错误"];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

@end
