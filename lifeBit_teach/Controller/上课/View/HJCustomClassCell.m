//
//  HJCustomClassCell.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/19.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJCustomClassCell.h"
@interface HJCustomClassCell()
@property (weak, nonatomic) IBOutlet UILabel *classNameLb;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;

@property (nonatomic,strong)HJClassInfo *classInfo;
@end
@implementation HJCustomClassCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateSelfUi:(HJClassInfo*)classInfo{
    
    self.classNameLb.text = [NSString stringWithFormat:@"%@%@",classInfo.cGradeName,classInfo.cClassName];
    NSString *statusStr = nil;
    switch ([classInfo.cStatus intValue]) {
        case 2:
//            statusStr = @"上课点名";
//            break;
        case 3:
            statusStr = @"上课中";
            break;
            
        default:
            break;
    }
    self.statusLb.text = statusStr;
    self.timeLb.text = [NSString stringWithFormat:@"课时长：%@分钟",classInfo.cClassTime];
    self.statusLb.layer.cornerRadius = 5;
    self.statusLb.layer.masksToBounds = YES;
    self.statusLb.backgroundColor = UIColorFromRGB(0xfa932a);
    self.classInfo = classInfo;
}

- (IBAction)clickGotoInClassItem:(UIButton *)sender {
    
    if (self.tapGotoInClassBlock) {
        self.tapGotoInClassBlock(self,self.classInfo);
        
    }
}

@end
