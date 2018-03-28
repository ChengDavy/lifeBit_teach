//
//  AQAppObject.m
//  AQSDK
//
//  Created by 严伟强 on 15/3/27.
//  Copyright (c) 2015年 AQiang. All rights reserved.
//

#import "HJAppObject.h"
static HJAppObject* _app;
@implementation HJAppObject
+(HJAppObject*)sharedInstance{
    if (!_app) {
        _app=[[HJAppObject alloc]init];
        
    }
    return _app;
}

+(void)cleanObject{
    if (_app) {
        _app = [[HJAppObject alloc]init];
    }
}
#pragma mark - 自定义方法
- (UIColor *)tintColor {
    return [UIColor colorWithRed:64/255.0f green:108/255.0f blue:208/255.0f alpha:1];
    
}
-(void)storeCode:(NSString *)code andValue:(NSString*)valueStr{
    NSUserDefaults*UD=[NSUserDefaults standardUserDefaults];
    if (code) {
        [UD setObject:valueStr forKey:code];
        [UD synchronize];
        
    }else{
        NSLog(@"code不存在，存入失败");
    }
    
    
}

-(void)storeCode:(NSString *)code{
    NSUserDefaults*UD=[NSUserDefaults standardUserDefaults];
    if (code) {
        [UD setObject:code forKey:@"code"];
        [UD synchronize];
        
    }else{
        NSLog(@"code不存在，存入失败");
    }
    
    
}
-(NSString *)getCode:(NSString*)key{
    NSUserDefaults* UD=[NSUserDefaults standardUserDefaults];
    NSString* code=[UD objectForKey:key];
    if (code) {
        return code;
    }else{
        NSLog(@"取出code为空");
        return @"";
    }
    
}


// 判断是否登录
-(BOOL)aQIsLogin{
    NSString *totken = [self getCode:@"token"];
    if (totken != nil && totken.length > 0) {
        return YES;
    }
    return NO;
}


// 获取自定义项目列表
-(NSMutableArray*)getProjectList{
    NSString *documentPath = [NSString GetDocumentsPath];
    NSString *namePath = [NSString stringWithFormat:@"project_v_%@.plist",[HJUserManager shareInstance].user.uId];
    NSString *path1 = [documentPath stringByAppendingPathComponent:namePath];
    NSArray *projectListArr = [NSMutableArray arrayWithContentsOfFile:path1];
    NSMutableArray *projectArr = [NSMutableArray array];
    for (NSDictionary *projectDic in projectListArr) {
        HJProjectInfo *projectInfo = [[HJProjectInfo alloc] init];
        [projectInfo setAttributes:projectDic];
        [projectArr addObject:projectInfo];
    }
    return projectArr;
}

// 获取学校年级班级信息
-(NSMutableArray*)getSchoolAllGreadMsg{
    NSString *documentPath = [NSString GetDocumentsPath];
    NSString *namePath = [NSString stringWithFormat:@"grade_v_%@.plist",[HJUserManager shareInstance].user.uId];
    NSString *path1 = [documentPath stringByAppendingPathComponent:namePath];
    NSArray *greadListArr = [NSMutableArray arrayWithContentsOfFile:path1];
    NSMutableArray *greadArr = [NSMutableArray array];
    for (NSDictionary *greadDic in greadListArr) {
        HJGreadInfo *greadInfo = [[HJGreadInfo alloc] init];
        [greadInfo setAttributes:greadDic];
        [greadArr addObject:greadInfo];
    }
    return greadArr;
}

-(NSMutableArray *)getAllLessonPlanType{
    NSString *documentPath = [NSString GetDocumentsPath];
    NSString *namePath = [NSString stringWithFormat:@"feedback_v_%@.plist",[HJUserManager shareInstance].user.uId];
    NSString *path1 = [documentPath stringByAppendingPathComponent:namePath];
    NSMutableArray *tempArr = [[NSMutableArray arrayWithContentsOfFile:path1] mutableCopy];
    NSDictionary *dic = @{
                          @"name":@"全部",
                          @"id":@"",
                          @"children":@[@{@"id":@"",@"name":@"全部"}]
                          };
    [tempArr insertObject:dic atIndex:0];
    NSMutableArray *projectArr = [NSMutableArray array];
    for (NSDictionary*projectDic in tempArr) {
        HJProjectInfo *projectSelectInfo = [[HJProjectInfo alloc] init];
        [projectSelectInfo setModelAttributes:projectDic];
        [projectArr addObject:projectSelectInfo];
    }
    return projectArr;
}
@end
