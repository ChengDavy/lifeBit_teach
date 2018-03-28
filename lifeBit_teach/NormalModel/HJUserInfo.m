//
//  UserInfo.m
//  BusinessFete
//
//  Created by yangxiangwei on 14/12/4.
//  Copyright (c) 2014年 yangxiangwei. All rights reserved.
//

#import "HJUserInfo.h"
#import "NSString+Category.h"
@implementation HJUserInfo

@synthesize uAccount;
@synthesize uSigner;
@synthesize uPassword;
@synthesize uSex;
@synthesize uSchoolId;
@synthesize uTeacherAge;
@synthesize uTeacherMobile;
@synthesize uTeacherJobTitle;
@synthesize uTeacherId;
@synthesize uTeacherName;
@synthesize uTeacherIco;
@synthesize uTeacher_No;
@synthesize uTeacherProfessional;
@synthesize uSchoolAreaID;
@synthesize uSchoolName;
@synthesize uId;



-(void)setAttributes:(NSDictionary *)attributes {
    
    NSDictionary *teacherDic = [attributes objectForKey:@"teacher_info"];
    self.uSchoolAreaID = [NSString stringAwayFromNSNULL:[NSString stringWithFormat:@"%@",[teacherDic objectForKey:@"AREA_ID"]]];
    self.uTeacherJobTitle = [NSString stringAwayFromNSNULL:[NSString stringWithFormat:@"%@",[teacherDic objectForKey:@"DUTY"]]];
    self.uTeacherId = [NSString stringAwayFromNSNULL:[NSString stringWithFormat:@"%@",[teacherDic objectForKey:@"TEACHER_ID"]]];
    self.uSigner =  [NSString stringAwayFromNSNULL:[NSString stringWithFormat:@"%@",[teacherDic objectForKey:@"LOGIN_PWD"]]];
    self.uTeacherMobile = [NSString stringAwayFromNSNULL:[NSString stringWithFormat:@"%@",[teacherDic objectForKey:@"MOBILE"]]];
    self.uTeacherName = [NSString stringAwayFromNSNULL:[NSString stringWithFormat:@"%@",[teacherDic objectForKey:@"NAME"]]];
    self.uTeacherProfessional =  [NSString stringAwayFromNSNULL:[NSString stringWithFormat:@"%@",[teacherDic objectForKey:@"PROFESSIONAL"]]];
    self.uSchoolId = [NSString stringAwayFromNSNULL:[NSString stringWithFormat:@"%@",[teacherDic objectForKey:@"SCHOOL_ID"]]];
    self.uSchoolName = [NSString stringAwayFromNSNULL:[NSString stringWithFormat:@"%@",[teacherDic objectForKey:@"SCHOOL_NAME"]]];
    self.uSex = [NSString stringAwayFromNSNULL:[NSString stringWithFormat:@"%@",[teacherDic objectForKey:@"SEX"]]];
    
    NSDictionary *userDic = [attributes objectForKey:@"user_info"];

    self.uId = [NSString stringAwayFromNSNULL:[NSString stringWithFormat:@"%@",[userDic objectForKey:@"id"]]];
    self.uSigner = [NSString stringAwayFromNSNULL:[NSString stringWithFormat:@"%@",[userDic objectForKey:@"signer"]]];
    self.uPassword = [NSString stringAwayFromNSNULL:[NSString stringWithFormat:@"%@",[userDic objectForKey:@"passwd"]]];
    
    

    self.uTeacherIco = [NSString stringAwayFromNSNULL:[NSString stringWithFormat:@"%@%@",Image_BASE_URL,[userDic objectForKey:@"icon"]]];

  
    
}

+(HJUserInfo*)createUserModelCoverUserInfo:(UserModel*)userModel{
    HJUserInfo *userInfo = [[HJUserInfo alloc] init];
    userInfo.uAccount = userModel.uAccount;
    userInfo.uId = userModel.uId;
    userInfo.uSex = userModel.uSex;
    userInfo.uSigner = userModel.uSigner;
    userInfo.uPassword = userModel.uPassword;
    userInfo.uSchoolId = userModel.uSchoolId;
    userInfo.uTeacherId = userModel.uTeacherId;
    userInfo.uSchoolName = userModel.uSchoolName;
    userInfo.uTeacher_No = userModel.uTeacher_No;
    userInfo.uTeacherAge = userModel.uTeacherAge;
    userInfo.uTeacherIco = userModel.uTeacherIco;
    userInfo.uTeacherName = userModel.uTeacherName;
    userInfo.uSchoolAreaID = userModel.uSchoolAreaID;
    userInfo.uTeacherMobile = userModel.uTeacherMobile;
    userInfo.uTeacherJobTitle = userModel.uTeacherJobTitle;
    userInfo.uTeacherProfessional = userModel.uTeacherProfessional;
    
    return userInfo;
}

+(UserModel*)coverUserInfoWithUserInfo:(HJUserInfo*)userInfo{
    UserModel *userModel = [[LifeBitCoreDataManager shareInstance] efCraterUserModel];
    userModel.uAccount = userInfo.uAccount;
    userModel.uId = userInfo.uId;
    userModel.uSex = userInfo.uSex;
    userModel.uSigner = userInfo.uSigner;
    userModel.uPassword = userInfo.uPassword;
    userModel.uSchoolId = userInfo.uSchoolId;
    userModel.uTeacherId = userInfo.uTeacherId;
    userModel.uSchoolName = userInfo.uSchoolName;
    userModel.uTeacher_No = userInfo.uTeacher_No;
    userModel.uTeacherAge = userInfo.uTeacherAge;
    userModel.uTeacherIco = userInfo.uTeacherIco;
    userModel.uTeacherName = userInfo.uTeacherName;
    userModel.uSchoolAreaID = userInfo.uSchoolAreaID;
    userModel.uTeacherMobile = userInfo.uTeacherMobile;
    userModel.uTeacherJobTitle = userInfo.uTeacherJobTitle;
    userModel.uTeacherProfessional = userInfo.uTeacherProfessional;

    return userModel;
}

-(id)init{
    if (self = [super init]) {
       
    }
    return self;
}

//支持是否支持加密
+ (BOOL)supportsSecureCoding
{
    return YES;
}


@end
