//
//  CoreDataManager.h
//  BusinessSYT
//
//  Created by yangxiangwei on 15/3/5.
//  Copyright (c) 2015年 yangxiangwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+(instancetype)shareInstance;
//这个方法需要手动在服务端程序退出是调用
+(void)destroyInstance;


 
#pragma mark -  新对象
/*！
 @method CreateObjectWithTable
 @abstract 创建一个表对应的一个对象，用于生成一条新记录
 @param Table  需要创建的对象，所有对应的表
 @result 新记录对应的对象
 */
-(NSManagedObject*)CreateObjectWithTable:(NSString*)table_name;
/*！
 @method insertObject
 @abstract  需要存储/插入/新添一条新记录
 @param Object 需要添加的记录
 @result  操作是否成功
 */
-(BOOL)insertObject:(NSManagedObject*)object;


/*！
 *@method         QueryObjectsWithTable:condition:sortByKey:limit
 *@abstract       查询多条记录
 *@param table    需要查询的表
 *@param condition  查询条件，  eg   a == b  and  c != d
 *@param sortByKey  排序准则，  相当于SQL 中的  order by key
 *@param limit      限制查询的结果条数，  类似SQL语句中的limit
 *@param ascending  是否使用升序，默认值为 NO
 *@result NSManagedObject记录数组，如果不存在，则为nil
 */
-(NSMutableArray*)QueryObjectsWithTable:(NSString*)table_name sortByKey:(NSString*)key;
-(NSMutableArray*)QueryObjectsWithTable:(NSString*)table_name condition:(NSString*)condition sortByKey:(NSString*)key;
-(NSMutableArray*)QueryObjectsWithTable:(NSString*)table_name condition:(NSString*)condition sortByKey:(NSString*)key limit:(NSInteger)limit ascending:(BOOL)isAscending;

/*！
 *@method         QueryObjectsWithTable:index:indexName:OtherCondition:
 *@abstract       查询指定索引的记录
 *@param table    需要查询的表
 *@param index      索引值，   eg 查询key为20的这条记录，这是 index 为 '20'
 *@param indexName  索引名称，eg 查询key为20的这条记录，这是 indexName 为 'key'
 *@param OtherCondition  查询条件，  eg   a == b  and  c != d
 *@result 查询对象的值，如果不存在，则为nil
 */
-(NSManagedObject*)QueryObjectsWithTable:(NSString*)table_name index:(id)index indexName:(NSString*)indexName;
-(NSManagedObject*)QueryObjectsWithTable:(NSString*)table_name index:(id)index indexName:(NSString*)indexName OtherCondition:(NSString*)otherCondition;

/*!
 *@method  deleteWithObject:
 *@abstract 删除一条记录
 *@discussion 注意：默认保存
 *@param object 需要删除的记录对应的对象
 *@result 操作是否成功
 */
-(BOOL)deleteWithObject:(NSManagedObject*)object;


/*!
 *@method  deleteWithObject:
 *@abstract 删除一条记录，调用这个方法必须收到调用一次  savaContext 方法
 *@discussion 注意：默认不保存保存，需要调用一次 SavaContent方法
 *@param object 需要删除的记录对应的对象
 */
-(void)deleteNotSaveWithObject:(NSManagedObject *)object;

/*!
 *@method  saveContext
 *@abstract 持久化所有记录的变更，包括插入、更新等
 */
-(BOOL)saveContext;
//- (NSMutableArray *)getObjectsWithPredicate:(NSString *)predicate;


-(NSMutableArray*)QueryObjectsWithTable:(NSString*)table_name
                     PredicateCondition:(NSPredicate*)predicateCondition
                              sortByKey:(NSString*)key
                                  limit:(NSInteger)limit
                              ascending:(BOOL)isAscending;
@end
