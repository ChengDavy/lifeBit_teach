//
//  Header.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/2.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#ifndef Header_h
#define Header_h

// 自定义View
#import "HJPageView.h"
#import "HJLinkagePickerView.h"

#import "HJEmptyCell.h"

//Cell
#import "HJProjectTestVC.h"

//==============================================================================

/*CoreData*/

//==============================================================================
/**
 *  CoreDataModel头文件
 *
 *  @return
 */
#import "StudentModel.h"
#import "WatchModel.h"
#import "LessonPlanModel.h"
#import "LessonPlanIdUnitModel.h"
#import "ScoreModel.h"
#import "ScheduleModel.h"
#import "BluetoothDataModel.h"
#import "HaveClassModel.h"
#import "TestModel.h"
#import "HistoryTestModel.h"
#import "NotStudentModel.h"
#import "UserModel.h"
#import "VersionModel.h"
/*NormalData*/

//==============================================================================
/**
 *  NormalData头文件
 *
 *  @return
 */

#import "HJUserInfo.h"
#import "HJStudentInfo.h"
#import "HJProjectInfo.h"
#import "HJGreadInfo.h"
#import "HJLessonPlanInfo.h"
#import "HJLessonPlanPhaseInfo.h"
#import "HJLessonPlanUnitInfo.h"
#import "HJVersionInfo.h"

//==============================================================================

/*控制器*/

//==============================================================================
/**
 *  VC头文件
 *
 *  @return
 */

#import "HJUserManager.h"
#import "HJBaseVC.h"
#import "HJTestStudentVC.h"





//==============================================================================

/*帮助类*/

//==============================================================================
/**
 *  帮助类头文件
 *
 *  @return
 */

#import "HJAppObject.h"
#import "HttpHelper.h"
#import "NSArray+Extended.h"
#import "UIViewController+AMNoticeAlertView.h"
#import "UIViewController+AMAutoKeyBoardVC.h"
#import "HJBluetootManager.h"
#import "LifeBitCoreDataManager.h"
#import "APPIdentificationManage.h"
#import "MJRefresh.h"

#endif /* Header_h */
