//
//  HJVersionInfo.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/10/13.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "BaseModel.h"

@interface HJVersionInfo : BaseModel
/*
 * 老师id
 */
@property (nonatomic, strong) NSString *uTeacherId;
/*
 * 获取教案项目分类列表
 */
@property (nonatomic, strong) NSString *books_v;
/*
 * 获取年级列表
 */
@property (nonatomic, strong) NSString *grade_v;
/*
 * 获取教具箱列表
 */
@property (nonatomic, strong) NSString *mac_v;
/*
 * 获取标准项目
 */
@property (nonatomic, strong) NSString *project_v;
/*
 * 获取我的教案
 */
@property (nonatomic, strong) NSString *books_Classify_v;
/*
 * 获取学生列表
 */
@property (nonatomic, strong) NSString *student_v;
/*
 * 获取课程表
 */
@property (nonatomic, strong) NSString *courses_v;

+(HJVersionInfo*)createVersionInfoWithVersionModel:(VersionModel*)versionModel;
+(VersionModel*)convertVersionModelWithVersionInfo:(HJVersionInfo*)versionInfo;
@end
