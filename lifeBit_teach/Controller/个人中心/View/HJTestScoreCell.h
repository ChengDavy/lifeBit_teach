//
//  HJTestScoreCell.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/18.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJStudentInfo.h"

@interface HJTestScoreCell : UITableViewCell
-(void)updateSelfUi:(HJStudentInfo*)studentInfo;
@end
