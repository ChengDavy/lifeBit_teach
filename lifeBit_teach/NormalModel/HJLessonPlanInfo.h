//
//  HJLessonPlanInfo.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/4.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "BaseModel.h"
#import "HJLessonPlanPhaseInfo.h"

@interface HJLessonPlanInfo : BaseModel
/*
 *教案ID
 */
@property (nonatomic,strong)NSString *sId;
/*
 *教案名称
 */
@property (nonatomic,strong)NSString *sSportTitle;

/*
 *教案学习项目技巧ID
 */
@property (nonatomic,strong)NSString *sSportSkillID;
/*
 *教案学习项目技巧
 */
@property (nonatomic,strong)NSString *sSportSkill;

/*
 *教案适用年级
 */
@property (nonatomic,strong)NSMutableString *sSportGrade;

/*
 *教案适用年级
 */
@property (nonatomic,strong)NSMutableArray *sSportGrades;

/*
 *教案阶段
 */
@property (nonatomic,strong)NSMutableArray *sPhaseArr;

/*
 *教案总时间
 */
@property (nonatomic,strong)NSString *sTotalTime;
/*
 *教案来源(平台，我的，学校)
 */
@property (nonatomic,strong)NSString *sLessonPlanSource;

/*
 *教案是否分享
 */
@property (nonatomic,strong)NSString *sLessonPlanShare;

/*
 *教案关键词
 */
@property (nonatomic,strong)NSString *sLessonPlanCode;

-(void)setLessonPlanAttributes:(NSDictionary*)attributes;

-(void)setModelAttributes:(NSDictionary *)attributes;

+(HJLessonPlanInfo *)creatLessonPlanInfoWithModel:(LessonPlanModel*)lessonPlanModel;


// 将教案详情保存在数据中
+(LessonPlanModel *)saveConversionLessonPlanInfoWithLessonPlanModel:(HJLessonPlanInfo*)lessonPlanInfo;

// 将数据库教案对象转换成教案
+(HJLessonPlanInfo *)CreatLessonPlanInfoWithLessonPlanModel:(LessonPlanModel*)lessonPlanModel;
@end
