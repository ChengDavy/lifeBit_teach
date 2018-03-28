//
//  Singleton.m
//  lifeBit_teach
//
//  Created by 介岳西 on 2017/5/23.
//  Copyright © 2017年 WilliamYan. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton


+ (Singleton *)sharedInstance {
    
    static Singleton * singleton = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[Singleton alloc] init];
    });
    return singleton;
}


@end
