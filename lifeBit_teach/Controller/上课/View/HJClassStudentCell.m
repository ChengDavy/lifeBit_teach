//
//  HJClassStudentCell.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/11.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJClassStudentCell.h"
@interface HJClassStudentCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *sexLb;
@property (weak, nonatomic) IBOutlet UILabel *numberLb;


@property (nonatomic,strong)HJStudentInfo *studentInfo;

@end
@implementation HJClassStudentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateSelfUi:(HJStudentInfo*)studentInfo{
    self.heatBtn.layer.cornerRadius = 5;
    self.heatBtn.layer.masksToBounds = YES;
    self.sexLb.layer.cornerRadius = 3;
    self.sexLb.layer.masksToBounds = YES;
    NSString *sexStr = studentInfo.sSex;
    if ([sexStr intValue] == 1) {
        self.sexLb.text = @"男";
        self.sexLb.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color_nav"]];
    }else{
        self.sexLb.text = @"女";
        self.sexLb.backgroundColor = UIColorFromRGB(0xF3406D);
    }
    self.nameLb.text = [NSString stringWithFormat:@"姓名：%@",studentInfo.studentName];
    self.studentInfo = studentInfo;
    self.numberLb.text = [NSString stringWithFormat:@"学号：%@",studentInfo.studentNo];
}

- (IBAction)tapShowHeartRateClick:(UIButton *)sender {
    if (self.ShowHeartRateClickBlock) {
        self.ShowHeartRateClickBlock(self.studentInfo);
    }
}


@end
