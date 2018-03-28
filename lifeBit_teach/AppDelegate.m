//
//  AppDelegate.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/1.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "AppDelegate.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "JRFirstVC.h"
#import "HJHaveClassVC.h"
#import "HJLessonPlanVC.h"
#import "HJProjectTestVC.h"
#import "HttpHelper.h"
#import "APPIdentificationManage.h"
#import "JRLoginVC.h"
#import "SKLeadingVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    
    [[HJUserManager shareInstance] init_singleton_from_disk];
//     开始检测网络状态
    [[HttpHelper JSONRequestManager] startNetWorkStatus];
    [HttpHelper JSONRequestManager].networkStatusChangeBlock = ^{
        NSLog(@"有网络了——————————");
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_Network object:nil];
    };

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    if ([[HJUserManager shareInstance] efIsLogin]) {
        [self setupViewControllers];
        [self.window setRootViewController:self.viewController];
    }else{
//        JRLoginVC *loginVc = [[JRLoginVC alloc] init];
//        [self.window setRootViewController:loginVc];
        NSString* str = [[NSUserDefaults standardUserDefaults]valueForKey:@"isFirstOpen"];
        if (str&&[str isEqualToString:@"isFirstOpen"]) {
            
            self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[[JRLoginVC alloc] init]];
        }
        else{
            self.window.rootViewController = [[SKLeadingVC alloc] init];
        }
    }
    
    [self.window makeKeyAndVisible];
    
    [self customizeInterface];
    
    return YES;

}



#pragma mark - Methods

- (void)setupViewControllers {
    UIViewController *firstViewController = [[JRFirstVC alloc] init];
    UIViewController *firstNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:firstViewController];
    
    UIViewController *secondViewController = [[HJHaveClassVC alloc] init];
    UIViewController *secondNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:secondViewController];
    
    UIViewController *thirdViewController = [[HJLessonPlanVC alloc] init];
    UIViewController *thirdNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:thirdViewController];
    UIViewController *fourViewController = [[HJProjectTestVC alloc] init];
    UIViewController *fourNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:fourViewController];
    
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    [tabBarController setViewControllers:@[firstNavigationController, secondNavigationController,
                                           thirdNavigationController,fourNavigationController]];
    self.viewController = tabBarController;
    
    [self customizeTabBarForController:tabBarController];
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_default"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_default"];
    NSArray *tabBarItemImages = @[@"first", @"second", @"third",@"four"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {

        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndexWithSafety:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [tabBarItemImages objectAtIndexWithSafety:index]]];
        
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        item.selectedTitleAttributes = [NSDictionary
                                        dictionaryWithObjectsAndKeys: [UIColor colorWithRed:49.0/255.0 green:142.0/255.0 blue:255.0/255.0 alpha:1.0],
                                        NSForegroundColorAttributeName, nil];
        item.unselectedTitleAttributes = [NSDictionary
                                        dictionaryWithObjectsAndKeys: UIColorFromRGB(0x999999),
                                        NSForegroundColorAttributeName, nil];
        index++;
    }
}



- (void)customizeInterface {
    [self setUpNavigationBarAppearance];
}



/**
 *  设置navigationBar样式
 */
- (void)setUpNavigationBarAppearance {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    
    UIImage *backgroundImage = nil;
    NSDictionary *textAttributes = nil;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        backgroundImage = [UIImage imageNamed:@"color_nav"];
        
        textAttributes = @{
                           NSFontAttributeName : [UIFont boldSystemFontOfSize:20],
                           NSForegroundColorAttributeName : [UIColor blackColor],
                           };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        backgroundImage = [UIImage imageNamed:@"color_nav"];
        textAttributes = @{
                           UITextAttributeFont : [UIFont boldSystemFontOfSize:20],
                           UITextAttributeTextColor : [UIColor blackColor],
                           UITextAttributeTextShadowColor : [UIColor clearColor],
                           UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetZero],
                           };
#endif
    }
    
    [navigationBarAppearance setBackgroundImage:backgroundImage
                                  forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self updateScheduleMeg];
    [[HJBluetootManager shareInstance] registerBlueToothManager];
    
}



- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}




#pragma --mark--  更新课程表状态信息
-(void)updateScheduleMeg{
    NSMutableArray *haveClassModelArr = [[LifeBitCoreDataManager shareInstance] efGetHaveClassModelWithSourceType:@(1) andScheduleStatus:@"2"];
//    NSLog(@"haveClassModelArr = %ld",haveClassModelArr.count);
    for (HaveClassModel *haveClassModel in haveClassModelArr) {
        NSDate *startDate = haveClassModel.startDate;
        NSTimeInterval timeInterval= [startDate timeIntervalSinceReferenceDate];
        timeInterval +=[haveClassModel.classTime integerValue] * 60;
        NSDate *endDate = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
        NSComparisonResult  Comparison = [endDate compare:[NSDate date]];
        switch (Comparison) {
            case NSOrderedAscending:{
//                将所有学生的点名状态职位为点名
                [self efResetCallOverStudent:haveClassModel.classId];
                //                如果时间超过  设置为准备上课
                haveClassModel.classStatus = @"4";
                [[LifeBitCoreDataManager shareInstance] efAddHaveClassModel:haveClassModel];
                if ([haveClassModel.scheduleType intValue] == 1) {
                    //        更新课表中数据信息
                    ScheduleModel *scheduleModel = [[LifeBitCoreDataManager shareInstance] efGetScheduleModeldWithSchedule:haveClassModel.scheduleId];
                    scheduleModel.classStatus = @"1";
                    [[LifeBitCoreDataManager shareInstance] efAddScheduleModel:scheduleModel];
                }
                
            }
                break;
            case NSOrderedSame:{
                //                将所有学生的点名状态职位为点名
                [self efResetCallOverStudent:haveClassModel.classId];
                haveClassModel.classStatus = @"4";
                [[LifeBitCoreDataManager shareInstance] efAddHaveClassModel:haveClassModel];
                if ([haveClassModel.scheduleType intValue] == 1) {
                    //        更新课表中数据信息
                    ScheduleModel *scheduleModel = [[LifeBitCoreDataManager shareInstance] efGetScheduleModeldWithSchedule:haveClassModel.scheduleId];
                    scheduleModel.classStatus = @"1";
                    [[LifeBitCoreDataManager shareInstance] efAddScheduleModel:scheduleModel];
                }
                
            }
                break;
            case NSOrderedDescending:{
//                haveClassModel.classStatus = @"2";
//                [[LifeBitCoreDataManager shareInstance] efAddHaveClassModel:haveClassModel];
                if ([haveClassModel.scheduleType intValue] == 1) {
                    //        更新课表中数据信息
                    ScheduleModel *scheduleModel = [[LifeBitCoreDataManager shareInstance] efGetScheduleModeldWithSchedule:haveClassModel.scheduleId];
                    scheduleModel.classStatus = @"2";
                    [[LifeBitCoreDataManager shareInstance] efAddScheduleModel:scheduleModel];
                }
            }
                break;
            default:
                break;
        }
    }
    
  
}

#pragma --mark-- 将所有学生的点名状态职位为点名
-(void)efResetCallOverStudent:(NSString*)classId{
    NSMutableArray *studentArr = [[LifeBitCoreDataManager shareInstance] efGetClassAllStudentWith:classId];
    for (StudentModel *studentModel in studentArr) {
        studentModel.sIsCallOver = @(0);
        [[LifeBitCoreDataManager shareInstance] efAddStudentModel:studentModel];
        
    }
}
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "JJ.lifeBit_teach" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"lifeBit_teach" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"lifeBit_teach.sqlite"];
    
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}




#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
