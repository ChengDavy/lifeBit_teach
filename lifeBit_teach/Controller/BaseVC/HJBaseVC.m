//
//  HJBaseVC.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/2.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJBaseVC.h"
#import "AppDelegate.h"
#import "RDVTabBarController.h"
#import "AppDelegate.h"

@interface HJBaseVC()<UIGestureRecognizerDelegate>

@end

@implementation HJBaseVC

@synthesize leftNavBtn;
-(void)dealloc{
    
    NSLog(@"%@释放了",NSStringFromClass([self class]));
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //取消scrollview的自动像素下移
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //取消navigationbar导致的view层自动下移
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;

    //设置状态栏字体颜色为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    //naviBar的颜色
//    self.navigationController.navigationBar.translucent = NO;
//    [self.navigationController.navigationBar setBarTintColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"brown3"]]];
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color_VCBG"]];
    [self initialize];
    [self baseInitialize];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    app.currentVc = self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void)initialize{

}

-(AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseURL]];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
//        [_manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        //        [_JSONRequestManager.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/plain",nil];
        //        _JSONRequestManager.manager.requestSerializer.timeoutInterval = 10;
        //        [_JSONRequestManager.manager.requestSerializer setValue:nil forHTTPHeaderField:@"x-auth-token"];
    }
    
    return _manager;
}


#pragma mark 在基类里创建通用的返回按钮
-(void)baseInitialize{
    
    
    if (!self.hiddenBackButton) {
        //返回按钮
        leftNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        UIImage *leftImage = [UIImage imageNamed:@"icon_1_9"];
        [leftNavBtn setImage:leftImage forState:UIControlStateNormal];
        [leftNavBtn setImageEdgeInsets:UIEdgeInsetsMake(12, -20, 12, 0)];
        [self.leftNavBtn addTarget:self action:@selector(naviBack) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:self.leftNavBtn];
    }
    
 
    

}

#pragma mark 所有返回按钮响应
-(void)naviBack{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 设置naviBarTitle字体颜色
-(void)setNavigationBarTitleTextColor:(NSString* )string{
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
    titleLabel.font = [UIFont boldSystemFontOfSize:21];  //设置文本字体与大小
    titleLabel.textColor = [UIColor whiteColor];  //设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = string;  //设置标题
    self.navigationItem.titleView = titleLabel;
    
    
}

#pragma mark 去除tableView的header的粘性
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat sectionHeaderHeight = 60;
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    }
//    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
//}



-(void)pushHiddenTabBar:(HJBaseVC*)vc{
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    RDVTabBarController *tabBar =(RDVTabBarController*) app.viewController;
    
    [tabBar setTabBarHidden:YES animated:NO];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


-(void)showTabBar{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    RDVTabBarController *tabBar =(RDVTabBarController*) app.viewController;
    [tabBar setTabBarHidden:NO animated:NO];
}

#pragma mark 指定宽度按比例缩放
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    
    
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    
    CGFloat width = imageSize.width;
    
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = defineWidth;
    
    CGFloat targetHeight = height / (width / targetWidth);
    
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    
    CGFloat scaleFactor = 0.0;
    
    CGFloat scaledWidth = targetWidth;
    
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        
        CGFloat widthFactor = targetWidth / width;
        
        CGFloat heightFactor = targetHeight / height;
        
        
        if(widthFactor > heightFactor){
            
            scaleFactor = widthFactor;
            
        }
        
        else{
            
            scaleFactor = heightFactor;
            
        }
        
        scaledWidth = width * scaleFactor;
        
        scaledHeight = height * scaleFactor;
        
        
        if(widthFactor > heightFactor){
            
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
            
        }else if(widthFactor < heightFactor){
            
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            
        }
        
    }
    
    
    UIGraphicsBeginImageContext(size);
    
    
    CGRect thumbnailRect = CGRectZero;
    
    thumbnailRect.origin = thumbnailPoint;
    
    thumbnailRect.size.width = scaledWidth;
    
    thumbnailRect.size.height = scaledHeight;
    
    
    [sourceImage drawInRect:thumbnailRect];
    
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    
    if(newImage == nil){

        NSLog(@"scale image fail");
        
    }
    
    UIGraphicsEndImageContext();
    
    NSLog(@"%lf%lf",newImage.size.width,newImage.size.height);
    return newImage;
    
}

#pragma --mark-- 获取未上传数据的数量
-(NSInteger)efGetNotUploadDataCount{
    NSMutableArray *inclassArr = [[LifeBitCoreDataManager shareInstance] efGetHaveClassModelWithSourceType:@(0) andScheduleStatus:@"4"];
    NSMutableArray *scoreArr = [[LifeBitCoreDataManager shareInstance] efGetAllTestModel];
    
    return inclassArr.count + scoreArr.count;
    
}
#pragma --mark-- 判断是否有课程在上课中
-(BOOL)efIsInClassAndHaveClassModel:(SEL)action withClass:(SEL)action1{
    BOOL isInclass = NO;
    NSMutableArray *inclassArr = [[LifeBitCoreDataManager shareInstance] efGetHaveClassModelWithSourceType:@(0) andScheduleStatus:@"2"];
    NSMutableArray *inclassArr1 = [[LifeBitCoreDataManager shareInstance] efGetHaveClassModelWithSourceType:@(0) andScheduleStatus:@"3"];
    for (HaveClassModel *haveClassModel in inclassArr1) {
        [inclassArr addObject:haveClassModel];
    }
    
    for (HaveClassModel*haveClassModel in inclassArr) {
        NSDate *startDate = haveClassModel.startDate;
        NSTimeInterval timeInterval= [startDate timeIntervalSinceReferenceDate];
        timeInterval +=[haveClassModel.classTime integerValue] * 60;
        NSDate *endDate = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
        NSComparisonResult  Comparison = [endDate compare:[NSDate date]];
        switch (Comparison) {
            case NSOrderedAscending:{
                if ([haveClassModel.scheduleType intValue] == 1) {
                    //        更新课表中数据信息
                    ScheduleModel *scheduleModel = [[LifeBitCoreDataManager shareInstance] efGetScheduleModeldWithSchedule:haveClassModel.scheduleId];
                    scheduleModel.classStatus = @"1";
                    [[LifeBitCoreDataManager shareInstance] efAddScheduleModel:scheduleModel];
                }
                haveClassModel.classStatus = @"4";
                [[LifeBitCoreDataManager shareInstance] efAddHaveClassModel:haveClassModel];
                isInclass = NO;
                HJClassInfo *classInfo = [HJClassInfo createClassInfoWithHaveClassModel:haveClassModel];
                [self efPerformSelector:action withObject:classInfo];
            }
                break;
            case NSOrderedSame:{
                if ([haveClassModel.scheduleType intValue] == 1) {
                    //        更新课表中数据信息
                    ScheduleModel *scheduleModel = [[LifeBitCoreDataManager shareInstance] efGetScheduleModeldWithSchedule:haveClassModel.scheduleId];
                    scheduleModel.classStatus = @"1";
                    [[LifeBitCoreDataManager shareInstance] efAddScheduleModel:scheduleModel];
                }
                haveClassModel.classStatus = @"4";
                [[LifeBitCoreDataManager shareInstance] efAddHaveClassModel:haveClassModel];
                isInclass = NO;
                HJClassInfo *classInfo = [HJClassInfo createClassInfoWithHaveClassModel:haveClassModel];
                [self efPerformSelector:action withObject:classInfo];
            }
                break;
            case NSOrderedDescending:{
                HJClassInfo *classInfo = [HJClassInfo createClassInfoWithHaveClassModel:haveClassModel];
                [self efPerformSelector:action1 withObject:classInfo];
                isInclass = YES;
        
            }
                break;
            default:
                break;
        }

    }
    return isInclass;
    
}


-(void)efPerformSelector:(SEL)action withObject:(id)o{
    if (action) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:action withObject:o];
#pragma clang diagnostic pop
    }
}


#pragma --mark-- 筛选出点名学生
-(NSMutableArray*)efFilterCallOverStudent:(NSString*)classId{
    NSMutableArray *callOverArr = [NSMutableArray array];
    NSMutableArray *studentArr = [[LifeBitCoreDataManager shareInstance] efGetClassAllStudentWith:classId];
    for (StudentModel *studentModel in studentArr) {
        if ([studentModel.sIsCallOver boolValue]) {
            HJStudentInfo *studentInfo = [HJStudentInfo createClassInfoWithStudentModel:studentModel];
            [callOverArr addObject:studentInfo];
        }
    }
    return callOverArr;
}

#pragma --mark-- 将所有学生的点名状态职位未点名
-(void)efResetCallOverStudent:(NSString*)classId{
    NSMutableArray *studentArr = [[LifeBitCoreDataManager shareInstance] efGetClassAllStudentWith:classId];
    for (StudentModel *studentModel in studentArr) {
        studentModel.sIsCallOver = @(0);
        [[LifeBitCoreDataManager shareInstance] efAddStudentModel:studentModel];

    }
}


#pragma --mark-- 根据班级获取所有学生
-(NSMutableArray*)efClassAllStudent:(NSString*)classId{
    NSMutableArray *allStudentArr = [NSMutableArray array];
    NSMutableArray *studentArr = [[LifeBitCoreDataManager shareInstance] efGetClassAllStudentWith:classId];
    for (StudentModel *studentModel in studentArr) {
            HJStudentInfo *studentInfo = [HJStudentInfo createClassInfoWithStudentModel:studentModel];
            [allStudentArr addObject:studentInfo];
    }
    return allStudentArr;
}


//#pragma --mark-- 获取未点名的学生
//-(NSMutableArray*)getNotClassStudent:(HJClassInfo*)classInfo{
//    NSMutableArray *notStudentModelArr =  [[LifeBitCoreDataManager shareInstance] efGetClassAllNotStudentModelWith:classInfo.cClassId withStartDate:classInfo.cStartTime];
//    NSMutableArray *notArr = [NSMutableArray array];
//    for (NotStudentModel*notSudentModel in notStudentModelArr) {
//        HJStudentInfo* studentInfo = [HJStudentInfo createStudentInfoWithNotStudentModel:notSudentModel];
//        [notArr addObject:studentInfo];
//        NSLog(@"name = %@",notSudentModel.studentName);
//        NSLog(@"studentNo = %@",notSudentModel.studentNo);
//        NSLog(@"sStartTime = %@",notSudentModel.sStartTime);
//        NSLog(@"sClassName = %@",notSudentModel.sClassName);
//    }
//    
//    return notArr;
//    
//}


#pragma --mark-- 网络请求
// 带loading
- (void)POSTAndLoading:(NSString *)post parameters:(id)parameters andSuccess:(void (^)(NSURLSessionDataTask *task, NSDictionary* responseObject))success
     Failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    //设置https的自验证书
    //    [self stepSesecurityPolicy];
    [self showNetWorkAlertWithTitleStr:@"加载中"];
    [self.manager POST:post parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //若返回的数据为data类型,则解析为Json类型
        if ([responseObject isKindOfClass:[NSData class]]) {
            id res = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"接口名:%@ \n入参项:%@\n出参项:%@",post,parameters,res);
            success(task,res);
            return;
        }
        NSLog(@"接口名:%@ \n入参项:%@\n出参项:%@",post,parameters,responseObject);
        success(task,responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self showNetWorkAlertWithTitleStr:@"加载失败"];
        NSLog(@"请求失败\n接口名:%@ \n入参项:%@\nerror:%@",post,parameters,error);
        failure(task,error);
       
    }];
}


- (void)POST:(NSString *)post parameters:(id)parameters andSuccess:(void (^)(NSURLSessionDataTask *task, NSDictionary* responseObject))success
     Failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    //设置https的自验证书
    //    [self stepSesecurityPolicy];
    
    [self.manager POST:post parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //若返回的数据为data类型,则解析为Json类型
        if ([responseObject isKindOfClass:[NSData class]]) {
            id res = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"接口名:%@ \n入参项:%@\n出参项:%@",post,parameters,res);
            success(task,res);
            return;
        }
        NSLog(@"接口名:%@ \n入参项:%@\n出参项:%@",post,parameters,responseObject);
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求失败\n接口名:%@ \n入参项:%@\nerror:%@",post,parameters,error);
        failure(task,error);
    }];
}








#pragma mark - 常用方法
-(void)quickAlertViewWithTitle:(NSString *)title Content:(NSString *)content{
    if (!title) {
        title=@"温馨提示";
    }
    
    
    if (kISIOS8AndUP) {
        NSLog(@"ios8以后");
        
    }else{
        
    }
    
    
    
    UIAlertView* alert=[[UIAlertView alloc]initWithTitle:title message:content delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
    
}


-(void)quickAlertViewWithTitle:(NSString *)title Content:(NSString *)content tag:(NSInteger)tag delegate:(id<NSObject>)delegate{
    if (!title) {
        title=@"温馨提示";
    }
    UIAlertView* alert=[[UIAlertView alloc]initWithTitle:title message:content delegate:delegate cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    alert.tag=tag;
    [alert show];
}

-(void)alertViewWithTitle:(NSString *)title Content:(NSString *)content tag:(NSInteger)tag delegate:(id<NSObject>)delegate{
    if (!title) {
        title=@"温馨提示";
    }
    UIAlertView* alert=[[UIAlertView alloc]initWithTitle:title message:content delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag=tag;
    [alert show];
}

-(void)otherAlertViewWithTitle:(NSString *)title Content:(NSString *)content tag:(NSInteger)tag delegate:(id<NSObject>)delegate{
    if (!title) {
        title=@"温馨提示";
    }
    UIAlertView* alert=[[UIAlertView alloc]initWithTitle:title message:content delegate:delegate cancelButtonTitle:@"继续同步" otherButtonTitles:@"重新搜索", nil];
    alert.tag=tag;
    [alert show];
}


#pragma --mark-- 设置当前显示的视图
-(void)efSetRootVc:(id)vc{
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    app.viewController = nil;
    app.window.rootViewController = vc;
}
@end
