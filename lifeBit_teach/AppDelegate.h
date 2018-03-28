//
//  AppDelegate.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/1.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIViewController *viewController;

@property (strong, nonatomic) UIViewController *currentVc;

// 记录上课中页面
@property (nonatomic,strong) HJBaseVC * inClassVC;



- (void)setupViewControllers;


// 上下文对象
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
// 数据模型对象
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
// 持久性存储区
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
// 初始化CoreData使用的数据库
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;

//managedObjectContext的初始化赋值函数
- (NSManagedObjectContext *)managedObjectContext;

//managedObjectModel初始化赋值函数
- (NSManagedObjectModel *)managedObjectModel;
@end

