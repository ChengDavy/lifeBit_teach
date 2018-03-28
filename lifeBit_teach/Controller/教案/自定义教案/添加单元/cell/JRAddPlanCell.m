//
//  LBLessonPlanUnitCell.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/5/12.
//  Copyright © 2016年 joyskim. All rights reserved.
//

#import "JRAddPlanCell.h"


@interface JRAddPlanCell()

@property (weak, nonatomic) IBOutlet UILabel *projectLb;

@property (weak, nonatomic) IBOutlet UILabel *skillLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *classLb;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@end

@implementation JRAddPlanCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clickSelectUnitItem:(UIButton *)sender {
    if (self.selectUnitBlock) {
        self.selectUnitBlock(self);
    }
}

-(void)efUpdateSelfUi:(HJLessonPlanUnitInfo*)unitInfo{
    self.projectLb.text = unitInfo.uUnitTitle;
    self.skillLb.text = unitInfo.uUnitDetails;
    self.timeLb.text = [NSString stringWithFormat:@"%@分钟",unitInfo.uUnitTime];
    self.classLb.text = unitInfo.uUnitClass;
}

-(void)selectUniClick{
    [self.selectBtn setImage:[UIImage imageNamed:@"testSelect_kuang"] forState:UIControlStateNormal];
}

-(void)exitSelectUnitClick{
    [self.selectBtn setImage:[UIImage imageNamed:@"select_kuang"] forState:UIControlStateNormal];
}

@end
