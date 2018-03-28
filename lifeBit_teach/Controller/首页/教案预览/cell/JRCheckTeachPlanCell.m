//
//  JRCheckTeachPlanCell.m
//  lifeBit_teach
//
//  Created by joyskim-ios1 on 16/9/5.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "JRCheckTeachPlanCell.h"

@interface JRCheckTeachPlanCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation JRCheckTeachPlanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //设置Cell的高度
     NSString* str = @"胯下运球的前提是摆好姿势，两腿要一前一后的分开，差不多和半蹲的一样。上身要挺直不要低头。胯下运球的前提是摆好姿势，两腿要一前一后的分开，差不多和半蹲的一样。上身要挺直不要低头。胯下运球的前提是摆好姿势，两腿要一前一后的分开，差不多和半蹲的一样。上身要挺直不要低头。";
    CGSize maxSize = CGSizeMake(kScreenWidth-30, MAXFLOAT);
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:18]};
    CGSize size = [str boundingRectWithSize:maxSize
                                    options:
                   NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                 attributes:attribute
                                    context:nil].size;
    
    CGRect frame =  self.contentLabel.frame;
    frame.size.height = size.height;
    frame.origin.y = CGRectGetMaxY(self.titleLabel.frame)+ 5;
    self.contentLabel.frame = frame;
    self.contentLabel.text = str;

}



@end
