//
//  UserModel+CoreDataProperties.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/10/12.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *uAccount;
@property (nullable, nonatomic, retain) NSString *uSigner;
@property (nullable, nonatomic, retain) NSString *uPassword;
@property (nullable, nonatomic, retain) NSString *uId;
@property (nullable, nonatomic, retain) NSString *uTeacherId;
@property (nullable, nonatomic, retain) NSString *uTeacherName;
@property (nullable, nonatomic, retain) NSString *uSex;
@property (nullable, nonatomic, retain) NSString *uSchoolId;
@property (nullable, nonatomic, retain) NSString *uSchoolName;
@property (nullable, nonatomic, retain) NSString *uTeacher_No;
@property (nullable, nonatomic, retain) NSString *uTeacherAge;
@property (nullable, nonatomic, retain) NSString *uTeacherMobile;
@property (nullable, nonatomic, retain) NSString *uTeacherProfessional;
@property (nullable, nonatomic, retain) NSString *uTeacherJobTitle;
@property (nullable, nonatomic, retain) NSString *uTeacherIco;
@property (nullable, nonatomic, retain) NSString *uSchoolAreaID;


@end

NS_ASSUME_NONNULL_END
