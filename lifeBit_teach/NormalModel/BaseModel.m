//
//  BaseModel.m
//  YWBPurchase
//
//  Created by YXW on 14-4-3.
//  Copyright (c) 2014年 YXW. All rights reserved.
//

#import "BaseModel.h"
#import "RunTime.h"

@implementation BaseModel

- (id)mutableCopyWithZone:(NSZone*)zone
{
 
    NSData *encoderData = [RunTime NSDataFromId:self];
    typeof(self)copyObjec = [NSKeyedUnarchiver unarchiveObjectWithData:encoderData];
    
    return copyObjec;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[RunTime initWithCoder:aDecoder withInstance:self];
    return self;
}

-(id)init
{
    self=[super init];
    if (self) {
        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
   
    [RunTime encodeWithCoder:aCoder withInstance:self];
}

-(void)setAttributes:(NSDictionary *)attributes
{
    [RunTime setAttributes:attributes withInstance:self];
    return;
}

-(NSDictionary *)NSDictionaryFromSelf
{
    NSDictionary *reVal=[RunTime NSDictionaryFromAttributeWithInstance:self];
    return reVal;
}

-(NSString *)description
{
    NSDictionary *dict=[self NSDictionaryFromSelf];
    NSString *reVal=[dict description];
    return reVal;
}

@end
