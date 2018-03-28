//
//  HJHistoryTestCell.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/6.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJHistoryTestCell.h"
@interface HJHistoryTestCell()
@property (weak, nonatomic) IBOutlet UILabel *projectNameLb;

@property (weak, nonatomic) IBOutlet UIButton *againTestBtn;

@property (nonatomic,strong)HJProjectInfo *projectInfo;
@end

@implementation HJHistoryTestCell


-(void)updateSelfUiData:(HJProjectInfo*)projectInfo{
    self.againTestBtn.layer.cornerRadius = 5;
    self.againTestBtn.layer.masksToBounds = YES;
    self.projectNameLb.text = [NSString stringWithFormat:@"%@%@-%@",projectInfo.pProjectGrade,projectInfo.pProjectClass,projectInfo.pProjectName];
    self.projectInfo = projectInfo;
}
- (IBAction)againTestProjectClick:(UIButton *)sender {
    if (self.againTestProjectBlock) {
        self.againTestProjectBlock(self.projectInfo);
    }
}


@end
