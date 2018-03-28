//
//  UserManager.m
//  BusinessFete
//
//  Created by yangxiangwei on 14/12/4.
//  Copyright (c) 2014年 yangxiangwei. All rights reserved.
//

#import "HJUserManager.h"
#import "NSString+Category.h"

const NSString* c_my_account_archive_file_name = @"User.archive";

@implementation HJUserManager
 
@synthesize user = _user;

static HJUserManager*  userManager = nil;

 
+(HJUserManager*)shareInstance
{
    @synchronized(self){
        
        if (userManager == nil) {
            userManager =  [[self alloc] init];
            
        }
    }
    return userManager;
}




+(void)destroyInstance
{
    if (nil != userManager) {
        userManager = nil;
    }
}

#pragma mark - getter
- (HJUserInfo*)user{
    if(nil == _user){
        _user = [[HJUserInfo alloc] init];
    }
    return _user;
}

 /*
 *@method  efIsLogin
 *@abstract 判断是否已登录
 *@discussion 程序启动时，需调用此方法，判断是否已登录。
 */
-(BOOL)efIsLogin{
    return self.user.uSigner != nil;
//    return self.user.uMemberId!=nil&&self.user.uToken!=nil&&self.user.uSecret!=nil;
//    return self.user.uToken!=nil&&self.user.uSecret!=nil;
}

/*！
 *@method update_to_disk
 *@abstract 保存数据到硬盘
 *@discussion 每次更新成员属性，需要手工调用此函数，将更新内容持久化到磁盘。
 */
- (void) update_to_disk
{
    NSString *path = [[NSString GetDocumentsPath] stringByAppendingPathComponent:(NSString*)c_my_account_archive_file_name];
    if ([NSKeyedArchiver archiveRootObject:self.user toFile:path]) {
        NSLog(@"保存用户信息到磁盘成功");
    }else{
        NSLog(@"保存用户信息到磁盘失败");
    }
}

/*！
 *@method  init_singleton_from_disk
 *@abstract 从硬盘初始化用户信息
 *@discussion 程序启动时应该首先调用该函数。
 */
- (void) init_singleton_from_disk
{
    NSString *path = [[NSString GetDocumentsPath] stringByAppendingPathComponent:(NSString*)c_my_account_archive_file_name];
    HJUserInfo *tmpUser =  (HJUserInfo *)[NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSLog(@"%@",tmpUser);
    self.user = tmpUser;
}

/*！
 *@method   clear_all_data
 *@abstract 清空所有内存、磁盘文件。
 *@discussion  注销时使用。
 */
- (void) clear_all_data
{
    [self clear_all_data_not_save_to_disk];
    //清空磁盘
    [self update_to_disk];
}



/*！
 *@method      clear_all_data_not_save_to_disk
 *@abstract    清楚所有数据但是不保存在客户端
 *@discussion  清空所有内存、但是硬盘中的数据并未清除， 主意，需要手动调用一次 update_to_disk
 (注意： 注销时使用)
 */
- (void) clear_all_data_not_save_to_disk
{
    
    //清空用户所有保存数据
    self.user = nil;
    
}



@end
