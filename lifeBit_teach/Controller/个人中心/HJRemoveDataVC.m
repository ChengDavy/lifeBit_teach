//
//  HJRemoveDataVC.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/10/17.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJRemoveDataVC.h"

@interface HJRemoveDataVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic,strong)NSArray *dataTypeArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation HJRemoveDataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(NSArray *)dataTypeArr{
    
    return @[@"学生数据",@"清除版本信息",@"班级课表",@"清除所有上课信息",@"清除成绩数据"];
}

-(void)initialize{
    [self setNavigationBarTitleTextColor:@"清除数据"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma --mark-- tableViewDelegate tableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataTypeArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.textLabel.text = self.dataTypeArr[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
//           验证密码
            [self validationPasswordClick];
          
        }
            break;
        case 1:
        {
//            删除版本信息
            [self showNetWorkAlertWithTitleStr:@"删除中..."];
            NSMutableArray *versionArr = [[LifeBitCoreDataManager shareInstance] efGetAllVersionModel];
            if (versionArr.count > 0) {
                for (int i = 0; i < versionArr.count; i++) {
                    VersionModel *versionModel = versionArr[i];
                    [[LifeBitCoreDataManager shareInstance] efDeleteVersionModel:versionModel];
                    if (i == versionArr.count - 1) {
                        [self performSelector:@selector(showSuccessAlertWithTitleStr:) withObject:@"删除完成" afterDelay:1.0];
                    }
                }
            }else{
                [self performSelector:@selector(showSuccessAlertWithTitleStr:) withObject:@"删除完成" afterDelay:1.0];
            }
            
        }
            break;
        case 2:
        {
            
            //            删除班级课表数据  首先删除回执版本信息
            [self showNetWorkAlertWithTitleStr:@"删除中..."];
            NSMutableArray *versionArr = [[LifeBitCoreDataManager shareInstance] efGetAllVersionModel];
            for (int i = 0; i < versionArr.count; i++) {
                VersionModel *versionModel = versionArr[i];
                versionModel.courses_v = @"0";
                [[LifeBitCoreDataManager shareInstance] efAddVersionModel:versionModel];
            }
            NSMutableArray *scheduleArr = [[LifeBitCoreDataManager shareInstance] efGetClassAllScheduleModelWith:[HJUserManager shareInstance].user.uTeacherId];
            
            if (scheduleArr.count > 0) {
                for (int i = 0; i < scheduleArr.count;i++) {
                    ScheduleModel * scheduleModel = scheduleArr[i];
                    [[LifeBitCoreDataManager shareInstance] efDeleteScheduleModel:scheduleModel];
                    if (i == scheduleArr.count - 1) {
                        [self performSelector:@selector(showSuccessAlertWithTitleStr:) withObject:@"删除完成" afterDelay:1.0];
                    }
                }
            }else{
                [self performSelector:@selector(showSuccessAlertWithTitleStr:) withObject:@"删除完成" afterDelay:1.0];
            }
            
            
        }
            break;
        case 3:
        {
            //            删除已上课信息,删除已经同步的数据
            [self showNetWorkAlertWithTitleStr:@"删除中..."];
            NSMutableArray *haveClassArr = [[LifeBitCoreDataManager shareInstance] efGetAllHaveClassModel];
            for (int i = 0; i < haveClassArr.count; i++) {
                HaveClassModel *haveClassModel = haveClassArr[i];
                [[LifeBitCoreDataManager shareInstance] efDeleteHaveClassModel:haveClassModel];
                
            }
            
            NSMutableArray *bluetoothDataArr = [[LifeBitCoreDataManager shareInstance] efGetTearcherAllBluetoothDataModel];
            if (bluetoothDataArr.count > 0) {
                for (int i = 0; i < bluetoothDataArr.count;i++) {
                    BluetoothDataModel *bluetoothDataModel = bluetoothDataArr[i];
                    [[LifeBitCoreDataManager shareInstance] efDeleteBluetoothDataModel:bluetoothDataModel];
                    if (i == bluetoothDataArr.count - 1) {
                        [self performSelector:@selector(showSuccessAlertWithTitleStr:) withObject:@"删除完成" afterDelay:1.0];
                    }
                }
            }else{
                [self performSelector:@selector(showSuccessAlertWithTitleStr:) withObject:@"删除完成" afterDelay:1.0];
            }
            
            
        }
            break;
        case 4:
        {
//            先删除测试的班级 在删除成绩数据
            [self showNetWorkAlertWithTitleStr:@"删除中..."];
            NSMutableArray *testModelArr = [[LifeBitCoreDataManager shareInstance] efGetAllTestModel];
            for (int i = 0 ; i < testModelArr.count; i++) {
                TestModel *testModel = testModelArr[i];
                [[LifeBitCoreDataManager shareInstance] efDeleteTestModel:testModel];
            }
            
            NSMutableArray *scoreModelArr = [[LifeBitCoreDataManager shareInstance] efGetAllScoreModel];
            if (scoreModelArr.count > 0) {
                for (int i = 0; i < scoreModelArr.count; i++) {
                    ScoreModel *scoreModel = scoreModelArr[i];
                    [[LifeBitCoreDataManager shareInstance] efDeleteStudentScore:scoreModel];
                    if (i == scoreModelArr.count - 1) {
                        [self performSelector:@selector(showSuccessAlertWithTitleStr:) withObject:@"删除完成" afterDelay:1.0];
                    }
                }
            }else{
                 [self performSelector:@selector(showSuccessAlertWithTitleStr:) withObject:@"删除完成" afterDelay:1.0];
            }
            
        }
            break;
            
        default:
            break;
    }
    
}


-(void)validationPasswordClick{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alertView.tag  = 999;
    [alertView setAlertViewStyle:UIAlertViewStyleSecureTextInput];
    UITextField *nameField = [alertView textFieldAtIndex:0];
    nameField.placeholder = @"请输入删除数据的密码！";
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 999) {
        if (buttonIndex == 1) {
            UITextField *nameField = [alertView textFieldAtIndex:0];
            if ([nameField.text isEqualToString:KDefaultPassword]) {
                [self deleteIpadAllStudentClick];
            }else{
                [self showErroAlertWithTitleStr:@"密码错误"];
            }
        }
    }
}

// 删除ipad中所有学生
-(void)deleteIpadAllStudentClick{
    //            删除学生数据  首先删除回执版本信息
    [self showNetWorkAlertWithTitleStr:@"删除中..."];
    NSMutableArray *versionArr = [[LifeBitCoreDataManager shareInstance] efGetAllVersionModel];
    for (int i = 0; i < versionArr.count; i++) {
        VersionModel *versionModel = versionArr[i];
        versionModel.student_v = @"0";
        [[LifeBitCoreDataManager shareInstance] efAddVersionModel:versionModel];
    }
    NSMutableArray *studentArr = [[LifeBitCoreDataManager shareInstance] efGetAllStudentModel];
    if (studentArr.count > 0) {
        for (int i = 0; i < studentArr.count; i++) {
            StudentModel *studentModel = studentArr[i];
            [[LifeBitCoreDataManager shareInstance] efDeleteStudentModel:studentModel];
            if (i == studentArr.count - 1) {
                [self performSelector:@selector(showSuccessAlertWithTitleStr:) withObject:@"删除完成" afterDelay:1.0];
            }
        }
    }else{
        [self performSelector:@selector(showSuccessAlertWithTitleStr:) withObject:@"删除完成" afterDelay:1.0];
    }
}

@end
