//
//  UIViewController+AMAutoKeyBoardVC.m
//  AMToolsDemo
//
//  Created by Aimi on 15/9/23.
//  Copyright © 2015年 Aimi. All rights reserved.
//

#import "UIViewController+AMAutoKeyBoardVC.h"
#import <objc/runtime.h>

@implementation UIViewController (AMAutoKeyBoardVC)

static char AMKeyBoardTapGRKey;

-(void)setAmKeyboardTapGR:(UITapGestureRecognizer *)amKeyboardTapGR{
    [self willChangeValueForKey:@"AMKeyBoardTapGRKey"];
    objc_setAssociatedObject(self, &AMKeyBoardTapGRKey,
                             amKeyboardTapGR,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self didChangeValueForKey:@"AMNoticeAlertKey"];
    
}

-(UITapGestureRecognizer *)amKeyboardTapGR{
    return objc_getAssociatedObject(self, &AMKeyBoardTapGRKey);
}


static char AMKeyboardOffSetY;
-(void)setAmKeyboardOffSetY:(NSNumber *)amKeyboardOffSetY{
    [self willChangeValueForKey:@"AMKeyboardOffSetY"];
    objc_setAssociatedObject(self, &AMKeyboardOffSetY,
                             amKeyboardOffSetY,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self didChangeValueForKey:@"AMKeyboardOffSetY"];

}

-(NSNumber *)amKeyboardOffSetY{
    return objc_getAssociatedObject(self, &AMKeyboardOffSetY);
}


-(void)addAmAutoKeyBoardTapGR{
    UITapGestureRecognizer* tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGRDidTap:)];
    tapGR.numberOfTapsRequired = 1;
    tapGR.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapGR];
    self.amKeyboardTapGR = tapGR;
}

-(void)tapGRDidTap:(UITapGestureRecognizer*)tapGR{
    [self.view endEditing:YES];
}



@end
