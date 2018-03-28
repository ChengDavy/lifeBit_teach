//
//  BaseModel.h
//  YWBPurchase
//
//  Created by YXW on 14-4-3.
//  Copyright (c) 2014年 YXW. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol BaseModelDelegate <NSObject>
@end

@interface BaseModel : NSObject
-(id)init;
-(id)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;
-(void)setAttributes:(NSDictionary *)attributes;
-(NSDictionary *)NSDictionaryFromSelf;

@end
