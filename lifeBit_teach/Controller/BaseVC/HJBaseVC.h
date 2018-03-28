//
//  HJBaseVC.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/2.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "HJClassInfo.h"

@interface HJBaseVC : UIViewController



typedef NS_ENUM(NSInteger,JRLessonPlanShowType){
    JRLessonPlanShowTypeNone,   // 
    JRLessonPlanShowTypeHome,   // 首页预览（设置）教案
    JRLessonPlanShowTypeClass,   // 上课预览（设置）教案（有课程id情况）
    JRLessonPlanShowTypeNoneClass,   // 上课预览（设置）教案（无课程id情况）
    JRLessonPlanShowTypeLessonPlan,   // 教案预览教案
};

@property(nonatomic,strong)UIButton *leftNavBtn;
@property (nonatomic,assign)BOOL hiddenBackButton;
@property(nonatomic,strong)AFHTTPSessionManager * manager;
// 带loading
- (void)POSTAndLoading:(NSString *)post parameters:(id)parameters andSuccess:(void (^)(NSURLSessionDataTask *task, NSDictionary* responseObject))success
               Failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
- (void)POST:(NSString *)post parameters:(id)parameters andSuccess:(void (^)(NSURLSessionDataTask *task, NSDictionary* responseObject))success
     Failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


-(void)initialize;
//设置naviBarTitle字体颜色
-(void)setNavigationBarTitleTextColor:(NSString* )string;
-(void)showTabBar;

-(void)pushHiddenTabBar:(HJBaseVC*)vc;

-(void)naviBack;
//指定宽度按比例缩放
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
#pragma --mark-- 获取未上传数据的数量
-(NSInteger)efGetNotUploadDataCount;
#pragma --mark-- 判断是否有课程在上课中
-(BOOL)efIsInClassAndHaveClassModel:(SEL)action withClass:(SEL)action1;
#pragma --mark-- 将所有学生的点名状态职位为点名
-(void)efResetCallOverStudent:(NSString*)classId;
#pragma --mark-- 筛选出点名学生
-(NSMutableArray*)efFilterCallOverStudent:(NSString*)classId;

#pragma --mark-- 根据班级获取所有学生
-(NSMutableArray*)efClassAllStudent:(NSString*)classId;



/**
 *  快速弹框 只有确定按钮 不带按钮事件
 *
 *  @param title   标题 nil时为“温馨提示”
 *  @param content 内容
 */
-(void)quickAlertViewWithTitle:(NSString*)title
                       Content:(NSString*)content;
/**
 *  快速弹框 只有确定按钮 带按钮事件
 *
 *  @param title    标题 nil时为“温馨提示”
 *  @param content  内容
 *  @param tag      tag
 *  @param delegate delegate
 */
-(void)quickAlertViewWithTitle:(NSString *)title
                       Content:(NSString *)content
                           tag:(NSInteger)tag
                      delegate:(id<NSObject>)delegate;
/**
 *  快速弹框 带确定、取消按钮 带按钮事件
 *
 *  @param title    标题 nil时为“温馨提示”
 *  @param content  内容
 *  @param tag      tag
 *  @param delegate delegate
 */

-(void)alertViewWithTitle:(NSString*)title
                  Content:(NSString*)content
                      tag:(NSInteger)tag
                 delegate:(id<NSObject>)delegate;

/**
 *  手表同步提醒框
 *  快速弹框 带确定、取消按钮 带按钮事件
 *
 *  @param title    标题 nil时为“温馨提示”
 *  @param content  内容
 *  @param tag      tag
 *  @param delegate delegate
 */
-(void)otherAlertViewWithTitle:(NSString *)title Content:(NSString *)content tag:(NSInteger)tag delegate:(id<NSObject>)delegate;

#pragma --mark-- 设置当前显示的视图
-(void)efSetRootVc:(id)vc;
@end
