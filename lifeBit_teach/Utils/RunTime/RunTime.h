//
//  RunTime.h
//  Test
//
//  Created by ZhuJianyin on 14-3-31.
//  Copyright (c) 2014年 com.zjy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface RunTime : NSObject

+(NSArray *)getIvarList:(id)instance;
+(NSArray *)getAllIvarList:(id)instance;
+(id)getIvarValue:(id)instance ivarName:(NSString *)ivarName;
+(void)setIvarValue:(id)instance ivarName:(NSString *)ivarName value:(id)value;
+(NSString *)getIvarType:(id)instance ivarName:(NSString *)ivarName;
+(NSInteger)sizeOfObject:(id)object;

+(NSData *)NSDataFromId:(id)object;

+(id)initWithCoder:(NSCoder *)aDecoder withInstance:(id)instance;
+(void)encodeWithCoder:(NSCoder *)aCoder withInstance:(id)instance;
+(void)setAttributes:(NSDictionary*)attributes withInstance:(id)instance;
+(NSDictionary *)NSDictionaryFromAttributeWithInstance:(id)instance;

@end
