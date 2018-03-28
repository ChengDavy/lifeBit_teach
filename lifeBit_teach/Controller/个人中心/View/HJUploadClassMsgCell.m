//
//  HJUploadClassMsgCell.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/13.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJUploadClassMsgCell.h"
#import "NSDate+Categories.h"

@interface HJUploadClassMsgCell()
@property (weak, nonatomic) IBOutlet UILabel *classNameLb;
@property (weak, nonatomic) IBOutlet UILabel *startClassTimeLb;



@property (strong,nonatomic)HJClassInfo *classInfo;
@end
@implementation HJUploadClassMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateSelfUi:(HJClassInfo*)classInfo{
    self.uploadBtn.layer.cornerRadius = 3;
    self.uploadBtn.layer.masksToBounds = YES;
    self.classNameLb.text = [NSString stringWithFormat:@"%@%@",classInfo.cGradeName,classInfo.cClassName];
    self.startClassTimeLb.text = [NSString stringWithFormat:@"上课时间：%@",[NSDate stringFromDate:classInfo.cStartTime format:@"yyyy-MM-dd HH:mm:ss"]];
   
    self.classInfo = classInfo;
}

- (IBAction)startUploadDataClick:(UIButton *)sender {
    if (self.tapUploadDataBlock) {
        self.tapUploadDataBlock(self.classInfo);
    }
}

@end
