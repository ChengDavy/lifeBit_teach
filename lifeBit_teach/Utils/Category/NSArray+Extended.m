//
//  NSArray+Extended.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/4.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "NSArray+Extended.h"

@implementation NSArray (Extended)
-(id)objectAtIndexWithSafety:(NSUInteger)index
{
    id reVal = nil;
    if ([self count]>index) {
        reVal=[self objectAtIndex:index];
    }
    return reVal;
}
@end
