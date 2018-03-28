//
//  LBPreviewNoAlertCell.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/5/13.
//  Copyright © 2016年 joyskim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJLessonPlanUnitInfo.h"

@interface HJPreviewNoAlertCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lessonPlanNumLb;
@property (weak, nonatomic) IBOutlet UILabel *unitDetailsLb;
-(void)efUpdateSelfUi:(HJLessonPlanUnitInfo*)unitInfo;
@end
