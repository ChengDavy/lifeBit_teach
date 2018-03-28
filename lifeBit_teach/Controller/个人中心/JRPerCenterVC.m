//
//  JRPerCenterVC.m
//  手表
//
//  Created by joyskim-ios1 on 16/8/31.
//  Copyright © 2016年 joyskim. All rights reserved.
//

#import "JRPerCenterVC.h"
#import "JRLoginVC.h"
#import "JRChangePsw.h"
#import "JRChangeTele.h"
#import "JRSynHeartVC.h"
#import "HJAboutUsVC.h"
#import "HJUploadHeartDataVC.h"
#import "HJSetVC.h"
#import "HJUploadTestScoreVC.h"
#import "HJCustomSelectView.h"
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@interface JRPerCenterVC ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *showCellArr;



//头像的背景View
@property (weak, nonatomic) IBOutlet UIView *iconBackView;
//个人中心背景图片
@property (weak, nonatomic) IBOutlet UIImageView *backImg;
//头像图片
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
//名字电话的背景View
@property (weak, nonatomic) IBOutlet UIView *nameBackView;
//用户姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
//用户电话号码
@property (weak, nonatomic) IBOutlet UILabel *teleLb;
//头像像下面的view，用来适配
@property (weak, nonatomic) IBOutlet UIView *nextBackView;
//所教班级
@property (weak, nonatomic) IBOutlet UILabel *classLb;
//教学身份
@property (weak, nonatomic) IBOutlet UILabel *identityLb;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;



//去修改密码的按钮
@property (weak, nonatomic) IBOutlet UIButton *gotoChangePswBtn;
//去修改电话号码的按钮
@property (weak, nonatomic) IBOutlet UIButton *gotoChangeteleBtn;

@property (weak, nonatomic) IBOutlet UILabel *bluetoothNumLb;
@property (weak, nonatomic) IBOutlet UILabel *scoreNumLb;


@property (nonatomic,strong)UIImagePickerController *picker;
@end

@implementation JRPerCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self updateSelfUi];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //显示naviBar
    self.navigationController.navigationBar.hidden = NO;
    //显示返回按钮
    self.leftNavBtn.hidden = NO;
    //隐藏tabBar
    self.tabBarController.tabBar.hidden = YES;
    
    NSMutableArray *inclassArr = [[LifeBitCoreDataManager shareInstance] efGetHaveClassModelWithSourceType:@(0) andScheduleStatus:@"4"];
    if (inclassArr.count > 0) {
        self.bluetoothNumLb.hidden = NO;
        self.bluetoothNumLb.text = [NSString stringWithFormat:@"%ld", inclassArr.count];
    }else{
        self.bluetoothNumLb.hidden = YES;
    }
    NSMutableArray *scoreArr = [[LifeBitCoreDataManager shareInstance] efGetAllTestModel];
    if (scoreArr.count > 0) {
        self.scoreNumLb.hidden = NO;
        self.scoreNumLb.text = [NSString stringWithFormat:@"%ld", scoreArr.count];
    }else{
        self.scoreNumLb.hidden = YES;
    }
}


-(void)initialize{
    //设置navi字体颜色
    [self setNavigationBarTitleTextColor:@"个人中心"];
    
    //设置右键按钮
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(tapRightBtn)];
    rightBtn.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    //适配头像下面的View
    CGRect frame = self.nextBackView.frame;
    frame.origin.y = CGRectGetMaxY(self.iconBackView.frame)+1;
    self.nextBackView.frame = frame;
    
   NSMutableArray *arr =  [[LifeBitCoreDataManager shareInstance] efGetAllBluetoothDataModel];
//    NSLog(@"max = %ld ,%ld",NSIntegerMax,(unsigned long)arr.count);
    
    self.tableView.tableHeaderView = self.headView;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


-(void)updateSelfUi{
    self.scoreNumLb.layer.cornerRadius = 3;
    self.scoreNumLb.layer.masksToBounds = YES;
    self.bluetoothNumLb.layer.cornerRadius = 3;
    self.bluetoothNumLb.layer.masksToBounds = YES;

    self.nameLb.text = [HJUserManager shareInstance].user.uTeacherName;
    self.teleLb.text = [HJUserManager shareInstance].user.uTeacherMobile;
    self.classLb.text = [HJUserManager shareInstance].user.uTeacherProfessional;
    self.identityLb.text = [HJUserManager shareInstance].user.uTeacherJobTitle;
    
    self.headImageView.layer.cornerRadius = self.headImageView.bounds.size.width/2;
    self.headImageView.layer.masksToBounds = YES;
    NSURL *url = [NSURL URLWithString:[HJUserManager shareInstance].user.uTeacherIco];
    [self.headImageView setImageWithURL:url];
}

- (IBAction)tapHeadImageClick:(UIButton *)sender {
    NSLog(@"111");
    __weak typeof(self) weakSelf = self;
    HJCustomSelectView *customSelectView = [HJCustomSelectView createSelectCustomSelectView];
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [customSelectView setSelectPhotoTypeBlock:^(NSInteger type) {
        switch (type) {
            case 1:{
                if ([weakSelf validatePhoto]) {
                    weakSelf.picker.editing = NO;
                    weakSelf.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [weakSelf presentViewController:weakSelf.picker animated:YES completion:nil];
                }
            }
            break;
            case 2:{
                if ([weakSelf validatePhoto]) {
                    weakSelf.picker.editing = NO;
                    weakSelf.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    [weakSelf presentViewController:weakSelf.picker animated:YES completion:nil];
                    
                }
            }
                break;
            case 3:{
                
            }
                break;
                
            default:
                break;
        }
    }];
    customSelectView.frame = app.window.bounds;
    [UIView animateWithDuration:0.5 animations:^{
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:customSelectView];
    }];
}



#pragma  --mark-- 相册

-(UIImagePickerController *)picker{
    if (_picker == nil) {
        _picker = [[UIImagePickerController alloc] init];
        // 设置UIImagePickerController可以编辑
        _picker.allowsEditing = YES;
        // 设置跳转到系统的那个页面
        _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _picker.delegate = self;
    }
    return _picker;
}

#pragma mark - UIImagePickerController 代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    
    [self uploadHeadImageNetworkFavicon:image];
    // 退出图片选择控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


-(BOOL)validatePhoto{
    BOOL hasAuthorized = YES;
    NSString *mediaType = AVMediaTypeVideo;// Or AVMediaTypeAudio
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    // This status is normally not visible—the AVCaptureDevice class methods for discovering devices do not return devices the user is restricted from accessing.
    
    if(authStatus ==AVAuthorizationStatusRestricted){
        
    }else if(authStatus == AVAuthorizationStatusDenied){
        // The user has explicitly denied permission for media capture.
        
        //应该是这个，如果不允许的话
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                              
                                                        message:@"请在iphone的“设置-隐私-相机”选项中，允许商宴通访问你的相机"
                              
                                                       delegate:self
                              
                                              cancelButtonTitle:@"确定"
                              
                                              otherButtonTitles:nil];
        
        [alert show];
        hasAuthorized = NO;
    }else if(authStatus == AVAuthorizationStatusAuthorized){//允许访问
        
        // The user has explicitly granted permission for media capture, or explicit user permission is not necessary for the media type in question.
        
        
    }else if(authStatus == AVAuthorizationStatusNotDetermined){
        
        // Explicit user permission is required for media capture, but the user has not yet granted or denied such permission.
        
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if(granted){//点击允许访问时调用
                
                //用户明确许可与否，媒体需要捕获，但用户尚未授予或拒绝许可。
                
                NSLog(@"Granted access to %@", mediaType);
            }else {
                NSLog(@"Not granted access to %@", mediaType);
            }
        }];
    }else {
        NSLog(@"Unknown authorization status");
    }
    
    return hasAuthorized;
}

#pragma --mark-- 网络  上传照片
#pragma --mark-- 网络
// 修改过教师头像
-(void)uploadHeadImageNetworkFavicon:(UIImage*)faviconImage{
    NSData *imageData = UIImageJPEGRepresentation(faviconImage, .5);
    NSString* favicon=[imageData base64EncodedStringWithOptions:0];
    NSDictionary* parameters = @{
                                 @"favicon":favicon,
                                 @"teacherId":[HJUserManager shareInstance].user.uId
                                 };
    
    
    NSString *newInterface = KReplace_headImageView;
    [self POSTAndLoading:newInterface parameters:parameters andSuccess:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"status"] intValue] == 0) {
            self.headImageView.image = faviconImage;
            NSDictionary *feedbackDic  = [responseObject objectForKey:@"feedback"];
            [HJUserManager shareInstance].user.uTeacherIco = [NSString stringWithFormat:@"%@%@",Image_BASE_URL,[NSString stringAwayFromNSNULL:[feedbackDic objectForKey:@"icon"]]];
            [[HJUserManager shareInstance] update_to_disk];
            
            UserModel *userModel = [HJUserInfo coverUserInfoWithUserInfo:[HJUserManager shareInstance].user];
            [[LifeBitCoreDataManager shareInstance] efAddUserModel:userModel];
            
            [self showSuccessAlertWithTitleStr:@"上传成功"];
        }
    } Failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}


#pragma -mark-- UITableViewDelegate UITableDatasouse

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.showCellArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.showCellArr[indexPath.row];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            return 56;
            break;
        case 1:
            return 142;
            break;
        case 2:
            return 142;
            break;
        case 3:
            return 81;
            break;
            
        default:
            break;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark  点击右键按钮--退出登陆
-(void)tapRightBtn
{
    HJSetVC *setVc = [[HJSetVC alloc] init];
    [self pushHiddenTabBar:setVc];
}
#pragma mark  去修改密码
- (IBAction)gotoChangePsw:(UIButton *)sender {
    JRChangePsw* jrChangePswVc = [[JRChangePsw alloc]init];
    [self pushHiddenTabBar:jrChangePswVc];
}
#pragma mark  去修改手机号码
- (IBAction)gotoChangeTele:(UIButton *)sender {
    JRChangeTele* jrChangeTeleVc = [[JRChangeTele alloc]init];
    [self pushHiddenTabBar:jrChangeTeleVc];
}


#pragma mark  去同步心率
- (IBAction)gotoSynHeart:(UIButton *)sender {

    JRSynHeartVC* jrSynHeartVc = [[JRSynHeartVC alloc]init];
    jrSynHeartVc.synHeartSoureType = JRSynHeartSoureTypePerson;
    [self pushHiddenTabBar:jrSynHeartVc];
}



- (IBAction)uploadHeartDataClick:(id)sender {

    HJUploadHeartDataVC *uploadHeartDataVc = [[HJUploadHeartDataVC alloc] init];
    [self pushHiddenTabBar:uploadHeartDataVc];
}



- (IBAction)uploadTestScoreClick:(UIButton *)sender {
    NSLog(@"上传测试成绩");

    HJUploadTestScoreVC* uploadTestScoreVc = [[HJUploadTestScoreVC alloc] init];
    [self pushHiddenTabBar:uploadTestScoreVc];
}



@end
