//
//  JRCusTeaPlanLbCell.m
//  lifeBit_teach
//
//  Created by joyskim-ios1 on 16/9/7.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "JRCusTeaPlanLbCell.h"
@interface JRCusTeaPlanLbCell()



@property (weak, nonatomic) IBOutlet UILabel *lbCellLabel;
@property (weak, nonatomic) IBOutlet UIButton *lbCellBtn;
@end
@implementation JRCusTeaPlanLbCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)changeTime:(UIButton *)sender {
    if (self.changeTimeBlock) {
        self.changeTimeBlock(self);
    }
}
-(void)efUpdateSelfUi:(HJLessonPlanUnitInfo*)unitInfo{
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color_VCBG"]];
    self.lbCellLabel.text = unitInfo.uUnitTitle;
    self.timeCellLb.text = [NSString stringWithFormat:@"%@分钟",unitInfo.uUnitTime];
}
@end
