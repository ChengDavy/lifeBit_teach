//
//  JRLoginVC.m
//  手表
//
//  Created by joyskim-ios1 on 16/8/25.
//  Copyright © 2016年 joyskim. All rights reserved.
//

#import "JRLoginVC.h"
#import "JRFirstVC.h"
#import "AppDelegate.h"
#import "HJIpadIdentifyVC.h"


@interface JRLoginVC ()

//姓名输入框
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
//密码输入框
@property (weak, nonatomic) IBOutlet UITextField *paswTF;
//选择协议按钮
@property (weak, nonatomic) IBOutlet UIButton *seleBtn;
//登陆按钮
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (strong, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation JRLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.versionLabel.text = [NSString stringWithFormat:@"V %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];

    
//    
//    self.nameTF.text = @"zhoujielun";
//    self.paswTF.text = @"111111";
//        self.nameTF.text = @"laoshi";
//        self.paswTF.text = @"111111";
   
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏naviBar
    self.navigationController.navigationBar.hidden = YES;
    //隐藏返回按钮
    self.leftNavBtn.hidden = YES;
    //显示tabBar
    self.tabBarController.tabBar.hidden = YES;
    
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.bgImageView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeitht);
}
-(void)initialize{
    if ([[[HJAppObject sharedInstance] getCode:@"isRecord"] boolValue]) {
        self.nameTF.text = [[HJAppObject sharedInstance] getCode:@"account"];
        self.paswTF.text = [[HJAppObject sharedInstance] getCode:@"password"];
        [self.seleBtn setImage:[UIImage imageNamed:@"noselect_kuang1"] forState:UIControlStateNormal];
    }else{
        [[HJAppObject sharedInstance] storeCode:@"isRecord" andValue:@"0"];
    }
    
    
}

#pragma mark   点击登陆
- (IBAction)login:(UIButton *)sender {
    
    if (self.nameTF.text.length <= 0) {
        [self showErroAlertWithTitleStr:@"请输入账号或用户名"];
        return;
    }
    
    if (self.paswTF.text.length <= 0) {
        [self showErroAlertWithTitleStr:@"请输入密码"];
        return;
    }
    
    if (![HttpHelper JSONRequestManager].isNetWork) {
       UserModel *userModel =  [[LifeBitCoreDataManager shareInstance] efGetUserModelMobile:self.nameTF.text andPassword:self.paswTF.text];
//        判断数据库中存在此用户
        if (userModel.uAccount.length <= 0 || userModel.uPassword.length <= 0) {
            [self showErroAlertWithTitleStr:@"用户不存在或者本地未缓存该用户的信息，请在网络环境下登陆"];
            return;
        }
        
        HJUserInfo *userInfo = [HJUserInfo createUserModelCoverUserInfo:userModel];
        [HJUserManager shareInstance].user = userInfo;
        [[HJUserManager shareInstance] update_to_disk];
        AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [app setupViewControllers];
        [app.viewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:app.viewController animated:YES completion:nil];

        return;
    }
    
    //登陆按钮跳转到首页
    NSDictionary *parameters = @{ @"NAME":self.nameTF.text,
                                  @"LOGIN_PWD":self.paswTF.text };
    
    [self showNetWorkAlertWithTitleStr:@"加载中"];
    [self POST:KLogin_Interface parameters:parameters andSuccess:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"success"] intValue] == 1) {
            [self showSuccessAlertWithTitleStr:@"登陆成功"];
            
            if ([[[HJAppObject sharedInstance] getCode:@"isRecord"] boolValue]) {
                [[HJAppObject sharedInstance] storeCode:@"account" andValue:self.nameTF.text];
                [[HJAppObject sharedInstance] storeCode:@"password" andValue:self.paswTF.text];
            }
            NSDictionary *userDic = [responseObject objectForKey:@"user"];
            HJUserInfo *userInfo = [[HJUserInfo alloc] init];
            [userInfo setAttributes:userDic];
            userInfo.uAccount = self.nameTF.text;
            userInfo.uPassword = self.paswTF.text;
            [HJUserManager shareInstance].user = userInfo;
            [[HJUserManager shareInstance] update_to_disk];
            UserModel *userModel = [HJUserInfo coverUserInfoWithUserInfo:[HJUserManager shareInstance].user];
            [[LifeBitCoreDataManager shareInstance] efAddUserModel:userModel];
            AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
            [app setupViewControllers];
            [app.viewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
            [self presentViewController:app.viewController animated:YES completion:nil];
        }else{
            [self showErroAlertWithTitleStr:[responseObject objectForKey:@"message"]];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [UIView animateWithDuration:0.5 animations:^{
            [self endNetWorkAlertWithNoMessage];
            
        } completion:^(BOOL finished) {
            
            [self showErroAlertWithTitleStr:error.localizedDescription];
        }];
        
        
    }];
 
    
}
- (IBAction)clickRememberPasswordItem:(UIButton *)sender {
    if ([[[HJAppObject sharedInstance] getCode:@"isRecord"] boolValue]) {
        [[HJAppObject sharedInstance] storeCode:@"isRecord" andValue:@"0"];
        [sender setImage:[UIImage imageNamed:@"select_kuang1"] forState:UIControlStateNormal];
        
    }else{
        [[HJAppObject sharedInstance] storeCode:@"isRecord" andValue:@"1"];
        [sender setImage:[UIImage imageNamed:@"noselect_kuang1"] forState:UIControlStateNormal];
        
    }
}
- (IBAction)clickQueryIdentifyNumberItm:(UIButton *)sender {
    HJIpadIdentifyVC *ipadIdentVc = [[HJIpadIdentifyVC alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ipadIdentVc];
    [self presentViewController:nav animated:YES completion:nil];
    
}

@end
