//
//  JRCornerView.m
//  lifeBit_teach
//
//  Created by joyskim-ios1 on 16/9/8.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "JRCornerView.h"

@implementation JRCornerView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initialze];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialze];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialze];
    }
    return self;
}

-(void)initialze{
    // 圆角
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 6.0;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1].CGColor;
}


@end
