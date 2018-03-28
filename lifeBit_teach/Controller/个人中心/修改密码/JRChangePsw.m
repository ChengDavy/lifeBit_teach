//
//  JRChangePsw.m
//  手表
//
//  Created by joyskim-ios1 on 16/8/26.
//  Copyright © 2016年 joyskim. All rights reserved.
//

#import "JRChangePsw.h"

@interface JRChangePsw ()
// 旧密码
@property (weak, nonatomic) IBOutlet UITextField *passwordOldTF;
//新密码
@property (weak, nonatomic) IBOutlet UITextField *passwordNewTF;
//再次输入新密码
@property (weak, nonatomic) IBOutlet UITextField *passwordNew1TF;
@end

@implementation JRChangePsw

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置navi字体颜色
    [self setNavigationBarTitleTextColor:@"修改密码"];
    
    //设置右键按钮
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(tapRightBtn)];
    rightBtn.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //显示naviBar
    self.navigationController.navigationBar.hidden = NO;
    //显示返回按钮
    self.leftNavBtn.hidden = NO;
    //隐藏tabBar
    self.tabBarController.tabBar.hidden = YES;
}
#pragma mark  点击右键按钮--保存
-(void)tapRightBtn
{
    NSLog(@"提交密码");
    if (self.passwordOldTF.text.length <= 0) {
        [self showErroAlertWithTitleStr:@"请输入旧密码"];
        return;
    }
    if (self.passwordNewTF.text.length <= 0) {
        [self showErroAlertWithTitleStr:@"请输入新密码"];
        return;
    }
    if (self.passwordNew1TF.text.length <= 0) {
        [self showErroAlertWithTitleStr:@"请输入新密码"];
        return;
    }
    if (![self.passwordNewTF.text isEqualToString:self.passwordNew1TF.text]) {
        [self showErroAlertWithTitleStr:@"输入的新密码不一致"];
        return;
    }
    NSDictionary* parameters = @{
                                 @"from":kChange_Password,
                                 @"searchVo.objectId":[HJUserManager shareInstance].user.uId,
                                 @"searchVo.newPass":self.passwordNewTF.text,
                                 @"searchVo.oldPass":self.passwordOldTF.text,
                                 @"searchVo.signer":[HJUserManager shareInstance].user.uSigner};
    NSString *oldInterface = KOld_Interface;
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self POSTAndLoading:oldInterface parameters:parameters andSuccess:^(NSURLSessionDataTask *task, NSDictionary *responseObject)  {
        if ([[responseObject objectForKey:@"result"] boolValue]) {
            [HJUserManager shareInstance].user.uPassword = self.passwordNewTF.text;
            [[HJUserManager shareInstance] update_to_disk];
            
            UserModel *userModel = [HJUserInfo coverUserInfoWithUserInfo:[HJUserManager shareInstance].user];
            [[LifeBitCoreDataManager shareInstance] efAddUserModel:userModel];
            [self showSuccessAlertAndPopVCWithTitleStr:@"修改成功"];
        }else{
            [self showErroAlertWithTitleStr:[responseObject objectForKey:@"message"]];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


@end
