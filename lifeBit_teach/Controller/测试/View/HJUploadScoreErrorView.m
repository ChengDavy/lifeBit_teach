//
//  HJUploadStatusView.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/7.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJUploadScoreErrorView.h"
@interface HJUploadScoreErrorView()

@end
@implementation HJUploadScoreErrorView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(instancetype)createUploadScoreStatusView{
    HJUploadScoreErrorView *statusErrorView = [[[NSBundle mainBundle] loadNibNamed:@"HJUploadScoreErrorView" owner:nil options:nil] firstObject];
    if (![statusErrorView isKindOfClass:[HJUploadScoreErrorView class]] ) {
        statusErrorView = [[[NSBundle mainBundle] loadNibNamed:@"HJUploadScoreErrorView" owner:nil options:nil] lastObject];
    }
 
    return statusErrorView;
}

- (IBAction)afreshUploadClick:(UIButton *)sender {
    if (self.afreshUploadScoreBlock) {
        self.afreshUploadScoreBlock();
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self removeFromSuperview];
    }];
}
- (IBAction)saveLoaclClock:(UIButton *)sender {
    if (self.saveScoreLocalBlock) {
        self.saveScoreLocalBlock();
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self removeFromSuperview];
    }];
}

@end
