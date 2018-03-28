//
//  HJSyncDataCell.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/12.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJSyncDataCell.h"
@interface HJSyncDataCell()



@property (weak, nonatomic) IBOutlet UILabel *numberLb;
@end
@implementation HJSyncDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updataSelfUi:(NSDictionary*)dic{
    
}

@end
