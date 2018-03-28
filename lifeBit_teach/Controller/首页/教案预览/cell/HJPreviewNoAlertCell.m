//
//  LBPreviewNoAlertCell.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/5/13.
//  Copyright © 2016年 joyskim. All rights reserved.
//

#import "HJPreviewNoAlertCell.h"

@interface HJPreviewNoAlertCell()
@property (weak, nonatomic) IBOutlet UILabel *unitTitleLb;






@property (weak, nonatomic) IBOutlet UILabel *unitTimeLb;
@end

@implementation HJPreviewNoAlertCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)efUpdateSelfUi:(HJLessonPlanUnitInfo*)unitInfo{
    self.unitTitleLb.text = unitInfo.uUnitTitle;
    self.unitTimeLb.text = [NSString stringWithFormat:@"%@分钟",unitInfo.uUnitTime];
    self.unitDetailsLb.text = unitInfo.uUnitDetails;
}

@end
