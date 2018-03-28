//
//  HJNumberKeyBoard.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/10/10.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJNumberKeyBoardView.h"
@interface HJNumberKeyBoardView()


@end
@implementation HJNumberKeyBoardView

+(instancetype)createNumberKeyBoardView{
    HJNumberKeyBoardView *numberKeyBoardView = [[[NSBundle mainBundle] loadNibNamed:@"HJNumberKeyBoardView" owner:nil options:nil] firstObject];
    
    
    return numberKeyBoardView;
}
- (IBAction)clickTapKeyBoardItem:(UIButton *)sender {
    if (self.tapKeyboardItemBlock) {
        self.tapKeyboardItemBlock(sender.tag,[sender titleForState:UIControlStateNormal]);
    }
}

@end
