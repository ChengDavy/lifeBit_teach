//
//  HJSetVC.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/18.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJSetVC.h"
#import "HJAboutUsVC.h"
#import "JRLoginVC.h"
#import "HJIpadIdentifyVC.h"
#import "AppDelegate.h"
#import "HJRemoveDataVC.h"
@interface HJSetVC()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSArray *titleArr;

@end
@implementation HJSetVC

-(void)viewDidLoad{
    [super viewDidLoad];
}
-(void)initialize{
    [self setNavigationBarTitleTextColor:@"设置"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(NSArray *)titleArr{
    if (_titleArr == nil) {
        _titleArr = @[@"清除缓存",@"关于我们",@"退出登陆"];
    }
    return _titleArr;
}

#pragma --mark-- UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        cell.textLabel.textColor = UIColorFromRGB(0x222222);
    }
    cell.textLabel.text = self.titleArr[indexPath.section];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {

        case 0:{
            if ([self efIsInClassAndHaveClassModel:nil withClass:nil]) {
                [self showErroAlertWithTitleStr:@"正在上课中，请完成上课再执行改操作。"];
                return;
            }
            HJRemoveDataVC *removeDataVC = [[HJRemoveDataVC alloc] init];
            [self pushHiddenTabBar:removeDataVC];
        }
            break;
        case 1:{
            HJAboutUsVC *aboutVc = [[HJAboutUsVC alloc] init];
            [self pushHiddenTabBar:aboutVc];
        }
            break;
        case 2:{
            [[HJAppObject sharedInstance] storeCode:@"callOver" andValue:@"0"];
            [HJUserManager shareInstance].user = nil;
            [[HJUserManager shareInstance] update_to_disk];
            if (self.presentingViewController != nil) {
                [self dismissViewControllerAnimated:YES completion:^{
                    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
                    app.viewController = nil;
                }];
            }else{
                
                JRLoginVC *loginVc = [[JRLoginVC alloc] init];
                [self efSetRootVc:loginVc];
            }
        }
            break;
            
        default:
            break;
    }
}



@end
