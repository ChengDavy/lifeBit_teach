//
//  RunTime.m
//  Test
//
//  Created by ZhuJianyin on 14-3-31.
//  Copyright (c) 2014年 com.zjy. All rights reserved.
//

#import "RunTime.h"
#import <objc/runtime.h>
#import "BaseModel.h"
@implementation RunTime

+(NSArray *)getIvarList:(id)instance
{
    NSMutableArray *reVal;
    unsigned int numIvars = 0;
    Ivar * ivars = class_copyIvarList([instance class],&numIvars);
    if (numIvars>0) {
        reVal=[[NSMutableArray alloc] init];
        for(int i = 0; i < numIvars; i++) {
            Ivar thisIvar = ivars[i];
            const char *ivarName=ivar_getName(thisIvar);
            const char *ivarType=ivar_getTypeEncoding(thisIvar);
            [reVal addObject: @{@"name":[NSString stringWithUTF8String:ivarName],@"attribute":[NSString stringWithUTF8String:ivarType]}];
            
        }
        free(ivars);
    }
    return reVal;
}

+(NSArray *)getAllIvarList:(id)instance
{
    NSMutableArray *reVal;
    reVal=[[NSMutableArray alloc] init];
    Class cls=[instance class];
    Class endCls=NSClassFromString(@"BaseModel");
    while (YES) {
        NSArray *value=[self getIvarList:cls];
        [reVal addObjectsFromArray:value];
        if (cls==endCls) {
            break;
        }
        cls=class_getSuperclass(cls);
    }
    return reVal;
}

+(id)getIvarValue:(id)instance ivarName:(NSString *)ivarName
{
    id reVal = nil;
    // 获取Ivar
    Ivar ivar=class_getInstanceVariable([instance class],[ivarName cStringUsingEncoding:NSUTF8StringEncoding]);
    // 取得变量的类型
    const char *type = ivar_getTypeEncoding(ivar);
    if (type[0]=='@') {
        //NSObject
//        NSString *className =  [NSString stringWithCString:type encoding:NSUTF8StringEncoding] ;
//        className =  [className substringWithRange:NSMakeRange(2, [className length]-3)];
        reVal=object_getIvar(instance, ivar);
//        [self object_getInstanceVariable:instance name:[ivarName cStringUsingEncoding:NSUTF8StringEncoding] outValue:(void *)&reVal];
    }else{
        // 基本数据类型或者结构体
        // 取得变量的偏移量
        ptrdiff_t offset=ivar_getOffset(ivar);
        NSUInteger ivarSize = 0;
        NSUInteger ivarAlignment = 0;
        // 取得变量的Type
        NSGetSizeAndAlignment(type, &ivarSize, &ivarAlignment);
        // 变量指针
        Byte *ivarPointer=(Byte *)(__bridge const void *)instance+offset;
        reVal=[NSData dataWithBytes:ivarPointer length:ivarSize];
    }

    return reVal;
}

+(id)getIvarValueWithObject:(id)instance ivarName:(NSString *)ivarName
{
    id reVal = [self getIvarValue:instance ivarName:ivarName];
    // 获取Ivar
    Ivar ivar=class_getInstanceVariable([instance class],[ivarName cStringUsingEncoding:NSUTF8StringEncoding]);
    // 取得变量的类型
    const char *type = ivar_getTypeEncoding(ivar);
    switch (type[0]) {
        case '@':
        {
            // 对象
            NSString *type=[self getIvarType:instance ivarName:ivarName];

//            NIF_INFO(@"BaseModel=%@",[BaseModel class]);
//            NIF_INFO(@"reVal=%@",[reVal class]);
            if (reVal) {
                if ([self isSuperClass:[BaseModel class] class:[reVal class]]) {
                    reVal=[self NSDictionaryFromAttributeWithInstance:reVal];
                }else if ([reVal isKindOfClass:[NSArray class]] && [type rangeOfString:@"@\"NSArray" options:NSLiteralSearch].location==0) {
                    if (type.length>@"@\"NSArray\"".length) {
                        // Model Array
                        NSArray *list=(NSArray *)reVal;
                        NSMutableArray *arrayObject=[[NSMutableArray alloc] init];
                        for (NSInteger i=0; i<[list count]; i++) {
                            id object=[self NSDictionaryFromAttributeWithInstance:[list objectAtIndex:i]];
                            [arrayObject addObject:object];
                        }
                        reVal=arrayObject;
                    }
                }
            }
            break;
        }
        case 'c':
        {
            // char && BOOL
            char number;
            [reVal getBytes:&number length:((NSData *)reVal).length];
            reVal=[NSNumber numberWithChar:number];
            break;
        }
        case 'C':
        {
            // unsigned_char
            unsigned char number;
            [reVal getBytes:&number length:((NSData *)reVal).length];
            reVal=[NSNumber numberWithUnsignedChar:number];
            break;
        }
        case 's':
        {
            // short
            short number;
            [reVal getBytes:&number length:((NSData *)reVal).length];
            reVal=[NSNumber numberWithShort:number];
            break;
        }
        case 'S':
        {
            // unsigned_short
            unsigned short number;
            [reVal getBytes:&number length:((NSData *)reVal).length];
            reVal=[NSNumber numberWithUnsignedChar:number];
            break;
        }
        case 'i':
        {
            // int
            int number;
            [reVal getBytes:&number length:((NSData *)reVal).length];
            reVal=[NSNumber numberWithInt:number];
            break;
        }
        case 'I':
        {
            // unsigned_int
            unsigned int number;
            [reVal getBytes:&number length:((NSData *)reVal).length];
            reVal=[NSNumber numberWithUnsignedInt:number];
            break;
        }
        case 'l':
        {
            // long
            long number;
            [reVal getBytes:&number length:((NSData *)reVal).length];
            reVal=[NSNumber numberWithLong:number];
            break;
        }
        case 'L':
        {
            // unsigned_long
            unsigned long number;
            [reVal getBytes:&number length:((NSData *)reVal).length];
            reVal=[NSNumber numberWithUnsignedLong:number];
            break;
        }
        case 'q':
        {
            // long_long
            long long number;
            [reVal getBytes:&number length:((NSData *)reVal).length];
            reVal=[NSNumber numberWithLongLong:number];
            break;
        }
        case 'Q':
        {
            // unsigned_long_long
            unsigned long long number;
            [reVal getBytes:&number length:((NSData *)reVal).length];
            reVal=[NSNumber numberWithUnsignedLongLong:number];
            break;
        }
        case 'f':
        {
            // float
            float number;
            [reVal getBytes:&number length:((NSData *)reVal).length];
            reVal=[NSNumber numberWithFloat:number];
            break;
        }
        case 'd':
        {
            // double
            double number;
            [reVal getBytes:&number length:((NSData *)reVal).length];
            reVal=[NSNumber numberWithDouble:number];
            break;
        }
        case '{':
        {
            // struct
            break;
        }
        default:
            break;
    }
    return reVal;
}

+(NSString *)getIvarType:(id)instance ivarName:(NSString *)ivarName
{
    NSString *reVal;
    // 获取Ivar
    Ivar ivar=class_getInstanceVariable([instance class],[ivarName cStringUsingEncoding:NSUTF8StringEncoding]);
    // 取得变量的大小
    const char *type = ivar_getTypeEncoding(ivar);
    if (type!=NULL) {
        reVal=[NSString stringWithUTF8String:type];
    }else{
       // NIF_WARN(@"找不到变量%@",ivarName);
        reVal=@"";
    }
    return reVal;
}

+(void)setIvarValue:(id)instance ivarName:(NSString *)ivarName value:(id)value
{
    // 获取Ivar
    Ivar ivar=class_getInstanceVariable([instance class],[ivarName cStringUsingEncoding:NSUTF8StringEncoding]);
    // 取得变量的Type
    NSString *type=[self getIvarType:instance ivarName:ivarName];
    if (type.length>0) {
        if ([@"@" isEqualToString:[type substringToIndex:1]]) {
            // NSObject
            object_setIvar(instance, ivar, value);
//            [self object_setInstanceVariable:instance name:[ivarName cStringUsingEncoding:NSUTF8StringEncoding] value:(void *)value];
        }else{
            if ([value isKindOfClass:[NSNumber class]]) {
                const char *charAttributes=[type cStringUsingEncoding:NSUTF8StringEncoding];
                switch (charAttributes[0]) {
                    case '@':
                    {
                        // 对象
//                        NSString *nameOfSEL=[NSString stringWithFormat:@"set%@%@:",[[name substringToIndex:1] uppercaseString],[name substringFromIndex:1]];
//                        SEL sel=NSSelectorFromString(nameOfSEL);
//                        if ([self respondsToSelector:sel]) {
//                            [self performSelectorOnMainThread:sel withObject:value waitUntilDone:YES];
//                        }
                        break;
                    }
                    case 'c':
                    {
                        // char && BOOL
                        char number=[((NSNumber *)value) charValue];
                        value=[NSData dataWithBytes:&number length:sizeof(number)];
                        break;
                    }
                    case 'C':
                    {
                        // unsigned_char
                        unsigned char number=[((NSNumber *)value) unsignedCharValue];
                        value=[NSData dataWithBytes:&number length:sizeof(number)];
                        break;
                    }
                    case 's':
                    {
                        // short
                        short number=[((NSNumber *)value) shortValue];
                        value=[NSData dataWithBytes:&number length:sizeof(number)];
                        break;
                    }
                    case 'S':
                    {
                        // unsigned_short
                        unsigned short number=[((NSNumber *)value) unsignedShortValue];
                        value=[NSData dataWithBytes:&number length:sizeof(number)];
                        break;
                    }
                    case 'i':
                    {
                        // int
                        int number=[((NSNumber *)value) intValue];
                        value=[NSData dataWithBytes:&number length:sizeof(number)];
                        break;
                    }
                    case 'I':
                    {
                        // unsigned_int
                        unsigned int number=[((NSNumber *)value) unsignedIntValue];
                        value=[NSData dataWithBytes:&number length:sizeof(number)];
                        break;
                    }
                    case 'l':
                    {
                        // long
                        long number=[((NSNumber *)value) longValue];
                        value=[NSData dataWithBytes:&number length:sizeof(number)];
                        break;
                    }
                    case 'L':
                    {
                        // unsigned_long
                        unsigned long number=[((NSNumber *)value) unsignedLongValue];
                        value=[NSData dataWithBytes:&number length:sizeof(number)];
                        break;
                    }
                    case 'q':
                    {
                        // long_long
                        long long number=[((NSNumber *)value) longLongValue];
                        value=[NSData dataWithBytes:&number length:sizeof(number)];
                        break;
                    }
                    case 'Q':
                    {
                        // unsigned_long_long
                        unsigned long long number=[((NSNumber *)value) unsignedLongLongValue];
                        value=[NSData dataWithBytes:&number length:sizeof(number)];
                        break;
                    }
                    case 'f':
                    {
                        // float
                        float number=[((NSNumber *)value) floatValue];
                        value=[NSData dataWithBytes:&number length:sizeof(number)];
                        break;
                    }
                    case 'd':
                    {
                        // double
                        double number=[((NSNumber *)value) doubleValue];
                        value=[NSData dataWithBytes:&number length:sizeof(number)];
                        break;
                    }
                    case '{':
                    {
                        // struct
                        break;
                    }
                    default:
                        break;
                }
            }
            // 基本数据类型或者结构体
            // 取得变量的偏移量
            ptrdiff_t offset=ivar_getOffset(ivar);
            NSUInteger ivarSize = 0;
            NSUInteger ivarAlignment = 0;
            // 取得变量的大小
            NSGetSizeAndAlignment([type cStringUsingEncoding:NSUTF8StringEncoding], &ivarSize, &ivarAlignment);
            // 变量指针
            Byte *ivarPointer=(Byte *)((__bridge const void *)instance+offset);
            [value getBytes:ivarPointer length:((NSData *)value).length];
        }
    }
}

+(NSData *)NSDataFromId:(id)object
{
    NSData *reVal=[NSKeyedArchiver archivedDataWithRootObject:object];
    return reVal;
}

+(NSInteger)sizeOfObject:(id)object
{
    NSInteger reVal=class_getInstanceSize([object class]);
    return reVal;
}



+(id)initWithCoder:(NSCoder *)aDecoder withInstance:(id)instance
{
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    NSArray *list=[RunTime getAllIvarList:instance];
    for (NSInteger i=0; i<[list count]; i++) {
        NSString *name=[[list objectAtIndex:i] objectForKey:@"name"];
        id data=[aDecoder decodeObjectForKey:name];
        if (data) {
            if ([@"_" isEqualToString:[name substringToIndex:1]]) {
                name=[name substringFromIndex:1];
            }
            [dict setObject:data forKey:name];
        }
    }
    [self setAttributes:dict withInstance:instance];
    return instance;
}

+(void)encodeWithCoder:(NSCoder *)aCoder withInstance:(id)instance
{
    NSArray *list=[RunTime getAllIvarList:instance];
    for (NSInteger i=0; i<[list count]; i++) {
        NSString *name=[[list objectAtIndex:i] objectForKey:@"name"];
        id data=[RunTime getIvarValueWithObject:instance ivarName:name];
        [aCoder encodeObject:data forKey:name];
    }
}

+(NSDictionary *)NSDictionaryFromAttributeWithInstance:(id)instance
{
    NSMutableDictionary *reVal=[[NSMutableDictionary alloc] init];
    NSArray *list=[RunTime getAllIvarList:instance];
    for (NSInteger i=0; i<[list count]; i++) {
        NSString *name=[[list objectAtIndex:i] objectForKey:@"name"];
        id data=[self getIvarValueWithObject:instance ivarName:name];
        if ([data isKindOfClass:[BaseModel class]]) {
            data=[self NSDictionaryFromAttributeWithInstance:data];
        }
        if (data) {
            if ([@"_" isEqualToString:[name substringToIndex:1]]) {
                name=[name substringFromIndex:1];
            }
            [reVal setObject:data forKey:name];
        }
    }
    return reVal;
}



+(void)setAttributes:(NSDictionary*)attributes withInstance:(id)instance
{
    if ([attributes isKindOfClass:[NSDictionary class]]) {
        NSArray *allKeys=[attributes allKeys];
        for (NSInteger i=0; i<[allKeys count]; i++) {
            NSString *key=[allKeys objectAtIndex:i];
#warning 去掉了_
            NSString *name=[NSString stringWithFormat:@"%@",key];
            NSString *type=[self getIvarType:instance ivarName:name];
            // 能够找到变量
            if (type.length>0) {
                id value=[attributes objectForKey:key];
                if ([value isKindOfClass:[NSArray class]] && [type rangeOfString:@"@\"NSArray" options:NSLiteralSearch].location==0) {
                    if (type.length>@"@\"NSArray\"".length) {
                        NSString *modelName=[self getModelName:type];
                        // Model Array
                        NSArray *list=(NSArray *)value;
                        NSMutableArray *arrayObject=[[NSMutableArray alloc] init];
                        for (NSInteger i=0; i<[list count]; i++) {
                            id object=[[NSClassFromString(modelName) alloc] init];
                            [self setAttributes:[list objectAtIndex:i] withInstance:object];
                     
                            [arrayObject addObject:object];
                        }
                        value=arrayObject;
                    }else{
                        // 普通的 Array
                    }
                }else if ([value isKindOfClass:[NSDictionary class]] && ![@"@\"NSDictionary\"" isEqualToString:type]) {
                    // Model
                    type=[type substringWithRange:NSMakeRange(2, type.length-3)];
                    id object = [[NSClassFromString(type) alloc] init];
                    [self setAttributes:value withInstance:object]; 
                    value=object;
                }
                [self setIvarValue:instance ivarName:name value:value];
            }else{
                // 不能找到变量
            }
        }
    }else{
        NSLog(@"找不到对象%@",instance);
    }
}

+(NSString *)getModelName:(NSString *)type
{
    NSString *reVal;
    NSInteger length=type.length-@"@\"NSArray\"".length-8-2;
    reVal=[type substringWithRange:NSMakeRange(10, length)];
    return reVal;
}

+(void)save
{
    [NSKeyedArchiver archiveRootObject:self toFile:[[self class] GetArchiverPath]];
}

+(NSString*)GetArchiverPath;
{
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    documentsPath=[NSString stringWithFormat:@"%@/AppDevData.dat",documentsPath];
    return documentsPath;
}

+(BOOL)isSuperClass:(Class)superClass class:(Class)class
{
    BOOL reVal=NO;
    Class temp=[class superclass];
    while (YES) {
        if (superClass==temp) {
            reVal=YES;
            break;
        }
        if (temp==[NSObject class]) {
            break;
        }
        temp=[temp superclass];
    }
    return reVal;
}

@end
