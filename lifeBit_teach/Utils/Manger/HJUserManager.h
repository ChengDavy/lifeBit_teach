//
//  UserManager.h
//  BusinessFete
//
//  Created by yangxiangwei on 14/12/4.
//  Copyright (c) 2014年 yangxiangwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HJUserInfo.h"

@interface HJUserManager : NSObject

@property (nonatomic,strong)HJUserInfo *user;
@property (nonatomic,strong)NSArray* transportArr;
+(instancetype)shareInstance;//共享实例
+(void)destroyInstance;//销毁实例


/*!
 *@method  efIsLogin
 *@abstract 判断是否已登录
 *@discussion 程序启动时，需调用此方法，判断是否已登录。
 */
- (BOOL)efIsLogin;
  
/*！
 *@method  init_singleton_from_disk
 *@abstract 从硬盘初始化用户信息
 *@discussion 程序启动时应该首先调用该函数。
 */
-(void)init_singleton_from_disk;



/*！
 *@method update_to_disk
 *@abstract 保存数据到硬盘
 *@discussion 每次更新成员属性，需要手工调用此函数，将更新内容持久化到磁盘。
 */
- (void) update_to_disk;

/*！
 *@method   clear_all_data
 *@abstract 清空所有内存、磁盘文件。
 *@discussion  注销时使用。
 */
- (void) clear_all_data;

/*！
 *@method      clear_all_data_not_save_to_disk
 *@abstract    清楚所有数据但是不保存在客户端
 *@discussion  清空所有内存、但是硬盘中的数据并未清除， 主意，需要手动调用一次 update_to_disk
 (注意： 注销时使用)
 */
- (void) clear_all_data_not_save_to_disk;



@end
