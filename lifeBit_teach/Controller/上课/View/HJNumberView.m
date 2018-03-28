//
//  HJNumberView.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/10/18.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJNumberView.h"

@implementation HJNumberView
+(HJNumberView*)createNumberView{
    HJNumberView *numberView = [[[NSBundle mainBundle] loadNibNamed:@"HJNumberView" owner:nil options:nil] firstObject];
    
    
    return numberView;

}
- (IBAction)clickNumberBtnItem:(UIButton *)sender {
    if (self.tapKeyboardClick) {
        self.tapKeyboardClick(sender.tag,[sender titleForState:UIControlStateNormal]);
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
