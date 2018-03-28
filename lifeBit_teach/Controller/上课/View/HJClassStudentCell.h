//
//  HJClassStudentCell.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/11.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJStudentInfo.h"
@interface HJClassStudentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *heatBtn;

@property (weak, nonatomic) IBOutlet UILabel *macWatchLb;

-(void)updateSelfUi:(HJStudentInfo*)studentInfo;

@property (nonatomic,strong) void (^ShowHeartRateClickBlock)(HJStudentInfo *studentInfo);
-(void)setShowHeartRateClickBlock:(void (^)(HJStudentInfo *studentInfo))ShowHeartRateClickBlock;
@end
