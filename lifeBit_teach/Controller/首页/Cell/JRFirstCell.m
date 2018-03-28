//
//  JRFirstCell.m
//  手表
//
//  Created by joyskim-ios1 on 16/9/1.
//  Copyright © 2016年 joyskim. All rights reserved.
//

#import "JRFirstCell.h"


@interface JRFirstCell()
//上课班级名称
@property (weak, nonatomic) IBOutlet UILabel *classNameLb;
//查看详情按钮
@property (weak, nonatomic) IBOutlet UIButton *checkDetailBtn;

@property (weak, nonatomic) IBOutlet UILabel *btnTitleLb;

@property (nonatomic,strong)HJClassInfo *classInfo;

@end

@implementation JRFirstCell

- (void)awakeFromNib {
    [super awakeFromNib];

}
//查看详情按钮
- (IBAction)checkDetail:(UIButton *)sender {
    if (self.gotoCheckPlanBlock) {
        self.gotoCheckPlanBlock(self,self.classInfo);
    }
    
}

-(void)updateSelfUi:(HJClassInfo*)classinfo{
    self.classInfo = classinfo;
    self.classNameLb.text = [NSString stringWithFormat:@"%@%@  第%@节课",classinfo.cGradeName,classinfo.cClassName,classinfo.cperiod];
    switch ([self.classInfo.cStatus intValue]) {
        case 0:{
            self.btnTitleLb.text = @"未设置教案";
        }
        break;
        case 1:{
            self.btnTitleLb.text = @"准备上课";

        }
            break;
        case 2:
//        {
//            self.btnTitleLb.text = @"上课点名";
//
//        }
//            break;
        case 3:{
            self.btnTitleLb.text = @"上课中";

        }
            break;
            
        default:
            break;
    }
}


@end
