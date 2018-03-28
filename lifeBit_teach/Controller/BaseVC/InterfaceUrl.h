//
//  InterfaceUrl.h
//  lifeBit_teach
//l
//  Created by WilliamYan on 16/9/2.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#ifndef InterfaceUrl_h
#define InterfaceUrl_h


//#define kBaseURL @"http://192.168.1.88:8088/lifebit_interface"
//#define kCommonBaseURL @"http://192.168.1.88:8088/lifebit_interface/"
//#define Image_BASE_URL  @"http://192.168.1.88:8088/lifebit_interface/upload/"


//#define kBaseURL        @"http://118.178.16.180/lifebit_interface"   //公司后台
//#define kCommonBaseURL  @"http://118.178.16.180/lifebit_interface/"
//#define Image_BASE_URL  @"http://118.178.16.180/lifebit_interface/upload/"


#define kBaseURL        @"http://www.jktiyu.com/lifebit_interface"   //公司后台
#define kCommonBaseURL  @"http://www.jktiyu.com/lifebit_interface/"
#define Image_BASE_URL  @"http://www.jktiyu.com/lifebit_interface/upload/"


/*
#define kBaseURL        @"http://10.42.46.155:8080/lifebit_interface"  //科技学校
#define kCommonBaseURL  @"http://10.42.46.155:8080/lifebit_interface/"
#define Image_BASE_URL  @"http://10.42.46.155:8080/lifebit_interface/upload/" 
*/
 
// 登陆接口
#define KLogin_Interface @"ipe2_001/login.action"
#pragma --mark-- 版本控制接口
//获取版本好接口
#define KGet_Version  @"ipe2_001/versionList.action"
//获取全校学生列表
#define KGet_SchoolAllStudent  @"ipe2_001/studentList.action"
//获取ipad对应教具箱列表
#define KGet_IpadCases  @"ipe2_001/deviceList.action"
//获取课程表接口
#define KGet_ScheduleList  @"ipe2_002/courseList.action"
//获取标准测试项目接口
#define KGet_TestProject  @"ipe2_001/projectList.action"
//获取学校年级
#define KGet_SchoolGread  @"ipe2_001/gradeList.action"
//自定义课程
#define KCustomCourse  @"pe2_003/customCourse.action"
//上传心率
#define KaddHeartRate  @"ipe2_003/addHeartRate.action"
//上传步数
#define KaddWatchSport  @"ipe2_003/addWatchSport.action"
//上传成绩
#define KuploadScore  @"ipe2_004/uploadScore.action"
//上传异常
#define KuploadException  @"ipe2_002/uploadException.action"



//修改密码
#define KOld_Interface @"interface/index.action"
#define kChange_Password @"IPE0810"
//消息
#define KMessage_Consulting @"IPE0100"



#pragma --mark-- 教案接口
//引用教案
#define KCollect_LessonPlanList  @"teaching_books/collect.action"
//获取版本教案
#define KCope_LessonPlan  @"teaching_books/detailAll.action"
//教案库列表
#define KPlatform_LessonPlanList  @"teaching_books/list.action"
// 教案单元列表
#define KLessonPlanUnit_list  @"teaching_books/unit_list.action"
// 教案单元详情
#define KLessonPlanUnit_Deatils  @"teaching_books/unit_detail.action"
// 给课程设置教案
#define KCourse_LessonPlanSet  @"teaching_books/set.action"
// 教案详情
#define KLessonPlan_LessonPlanDeatils  @"teaching_books/detail.action"
// 教案分类列表
#define KProject_Type  @"teaching_books/type_list.action"
// 自定义教案
#define KCustomLessonPlan_Save  @"teaching_books/save_book.action"
// 修改过教案
#define KAlertLessonPlan_update  @"teaching_books/update.action"
// 更换过教案
#define KreplaceLessonPlan_update  @"teaching_books/update_curriculum.action"
// 保存教案
#define KCopeLessonPlan_update  @"teaching_books/cope.action"
// 教案分享
#define KShareLessonPlan_share  @"teaching_books/share.action"
// 教案删除
#define KDelectLessonPlan_delete  @"teaching_books/delete.action"
// 更换头像
#define KReplace_headImageView  @"teacher/favicon/save.action"

#endif /* InterfaceUrl_h */
