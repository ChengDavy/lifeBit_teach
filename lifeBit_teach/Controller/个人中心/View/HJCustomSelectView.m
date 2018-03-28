//
//  HJCustomSelectView.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/27.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJCustomSelectView.h"
@interface HJCustomSelectView()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@end

@implementation HJCustomSelectView
+(instancetype)createSelectCustomSelectView{
    HJCustomSelectView *customSelectView = [[[NSBundle mainBundle] loadNibNamed:@"HJCustomSelectView" owner:nil options:nil] firstObject];
    if (![customSelectView isKindOfClass:[HJCustomSelectView class]] ) {
        customSelectView = [[[NSBundle mainBundle] loadNibNamed:@"HJCustomSelectView" owner:nil options:nil] lastObject];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:customSelectView action:@selector(tapClick:)];
    [customSelectView.bgView addGestureRecognizer:tap];
    return customSelectView;
}

-(void)tapClick:(UITapGestureRecognizer*)tap{
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)clickPhotoItemBtn:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
            
            NSLog(@"拍照");
            break;
        case 2:
            NSLog(@"从手机相册选择");
            break;
        case 3:
            NSLog(@"取消");
            break;
            
        default:
            break;
    }
    [self removeFromSuperview];
    if (self.selectPhotoTypeBlock) {
        self.selectPhotoTypeBlock(sender.tag);
    }
}

@end
