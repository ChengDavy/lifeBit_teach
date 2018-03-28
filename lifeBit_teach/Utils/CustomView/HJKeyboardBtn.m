//
//  HJKeyboardBtn.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/10/10.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJKeyboardBtn.h"

@implementation HJKeyboardBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
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

/**
 *  有边框的按钮
 */
-(void)initialze{
    self.layer.borderWidth = 0.25;
    self.layer.borderColor = [UIColor grayColor].CGColor;
}
@end
