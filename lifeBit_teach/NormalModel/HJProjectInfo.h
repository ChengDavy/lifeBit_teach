//
//  HJProjectInfo.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/22.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "BaseModel.h"
@interface HJSubProjectInfo : BaseModel

/*
 *子项目分类id
 */
@property (nonatomic,strong)NSString *sId;
/*
 *子项目分类名称
 */
@property (nonatomic,strong)NSString *sName;
@end


@interface HJProjectInfo : BaseModel



/*
 * 项目ID
 */
@property (nonatomic,strong)NSString *pProjectID;
/*
 * 项目名称
 */
@property (nonatomic,strong)NSString *pProjectName;
/*
 *子项目数组
 */
@property (nonatomic,strong)NSMutableArray *pSubProjectArr;
/*
 * 项目类型
 */
@property (nonatomic,strong)NSString *pProjectType;
/*
 * 成绩（优）
 */
@property (nonatomic,strong)NSString *pScoreGood;
/*
 * 成绩（中）
 */
@property (nonatomic,strong)NSString *pScorePass;
/*
 * 成绩（差）
 */
@property (nonatomic,strong)NSString *pScoreNoPass;
/*
 * 项目描述
 */
@property (nonatomic,strong)NSString *pProjectRemark;
/*
 * 测试单位
 */
@property (nonatomic,strong)NSString *pProjectUnit;
/*
 * 测试年级id
 */
@property (nonatomic,strong)NSString *pProjectGradeId;
/*
 * 测试班级id
 */
@property (nonatomic,strong)NSString *pProjectClassId;
/*
 * 测试年级
 */
@property (nonatomic,strong)NSString *pProjectGrade;
/*
 * 测试班级
 */
@property (nonatomic,strong)NSString *pProjectClass;

// 教案项目分类
-(void)setModelAttributes:(NSDictionary *)attributes;

//讲历史测试转换成测试项目Model
+(HJProjectInfo*)converHistoryTestFromProject:(HistoryTestModel*)historyTestModel;
@end
