//
//  JRCusTeaPlanBtnCell.m
//  lifeBit_teach
//
//  Created by joyskim-ios1 on 16/9/7.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "JRCusTeaPlanBtnCell.h"
@interface JRCusTeaPlanBtnCell()
//cell的nLabel
@property (weak, nonatomic) IBOutlet UILabel *buttenCellLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttenCellBtn;
@end

@implementation JRCusTeaPlanBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (IBAction)gotoAddPlan:(UIButton *)sender {
    
    if (self.blockClickLessonPlanUnit) {
        self.blockClickLessonPlanUnit(self);
    }
}
-(void)efUpdateSelfUi:(HJLessonPlanPhaseInfo*)phaseInfo{
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color_VCBG"]];
    self.buttenCellLabel.text = phaseInfo.pTitle;

}
@end
