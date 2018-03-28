//
//  MeterTimeCell.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/7.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJMeterTimeCell.h"
@interface HJMeterTimeCell()
@property (weak, nonatomic) IBOutlet UILabel *minutesLb;
@property (weak, nonatomic) IBOutlet UILabel *secondsLb;
@property (weak, nonatomic) IBOutlet UILabel *msLb;


@property (weak, nonatomic) IBOutlet UILabel *numberLb;

@property (nonatomic,strong)NSDictionary *scoreDic;
@end
@implementation HJMeterTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateSelfUi:(NSDictionary*)dic{
    self.scoreDic = dic;
    self.minutesLb.text = [dic objectForKey:@"minutes"];
    self.secondsLb.text = [dic objectForKey:@"seconds"];
    self.msLb.text = [dic objectForKey:@"ms"];
    self.numberLb.text = [dic objectForKey:@"number"];
}

- (IBAction)tapSelectStudentClick:(UIButton *)sender {
    if (self.selectStudentBlock) {
        self.selectStudentBlock(self,self.scoreDic);
    }
}

-(void)selectUpdateStudentNameClick:(NSString*)nameStr{
    self.nameLb.text = nameStr;
}

@end
