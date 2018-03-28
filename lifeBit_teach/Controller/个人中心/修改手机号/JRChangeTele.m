//
//  JRChangeTele.m
//  手表
//
//  Created by joyskim-ios1 on 16/8/26.
//  Copyright © 2016年 joyskim. All rights reserved.
//

#import "JRChangeTele.h"
#import "NSString+Category.h"

@interface JRChangeTele ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@end

@implementation JRChangeTele

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置navi字体颜色
    [self setNavigationBarTitleTextColor:@"修改手机号"];
    
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
    [self commitChangePhoneClick];
}


#pragma mark - 网络
-(void)commitChangePhoneClick{
    NSLog(@"修改号码");
    if (self.phoneTF.text.length <= 0) {
        [self showErroAlertWithTitleStr:@"请输入手机号码"];
        return;
    }
    
    if (![NSString isMobile:self.phoneTF.text]) {
        [self showErroAlertWithTitleStr:@"请输入正确的手机号码"];
        return;
    }
    
    NSDictionary* parameters = @{
                                 @"from":kChange_Password,
                                 @"searchVo.objectId":[HJUserManager shareInstance].user.uId,
                                 @"searchVo.phone":self.phoneTF.text,
                                 @"searchVo.signer":[HJUserManager shareInstance].user.uSigner};
    NSString *oldInterface = KOld_Interface;
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self POSTAndLoading:oldInterface parameters:parameters andSuccess:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"result"] boolValue]) {
            [self showSuccessAlertAndPopVCWithTitleStr:@"修改成功"];
            [HJUserManager shareInstance].user.uTeacherMobile = self.phoneTF.text;
            [[HJUserManager shareInstance] update_to_disk];
            
            UserModel *userModel = [HJUserInfo coverUserInfoWithUserInfo:[HJUserManager shareInstance].user];
            [[LifeBitCoreDataManager shareInstance] efAddUserModel:userModel];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showErroAlertWithTitleStr:[responseObject objectForKey:@"message"]];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
@end
