//
//  HJUploadStatusView.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/7.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJUploadScoreOkView.h"
@interface HJUploadScoreOkView()
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
@implementation HJUploadScoreOkView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(instancetype)createUploadScoreStatusView{
    HJUploadScoreOkView *statusOkView = [[[NSBundle mainBundle] loadNibNamed:@"HJUploadScoreOkView" owner:nil options:nil] firstObject];
    if (![statusOkView isKindOfClass:[HJUploadScoreOkView class]] ) {
        statusOkView = [[[NSBundle mainBundle] loadNibNamed:@"HJUploadScoreOkView" owner:nil options:nil] lastObject];
    }
    

    
    return statusOkView;
}



- (IBAction)uploadOkClick:(UIButton *)sender {
    if (self.uploadScoreOkBlock) {
        self.uploadScoreOkBlock();
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self removeFromSuperview];
    }];
}


@end
