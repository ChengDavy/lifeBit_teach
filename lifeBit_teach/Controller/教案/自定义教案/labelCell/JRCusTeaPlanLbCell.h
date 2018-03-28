//
//  JRCusTeaPlanLbCell.h
//  lifeBit_teach
//
//  Created by joyskim-ios1 on 16/9/7.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JRCusTeaPlanLbCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numberLb;
@property (weak, nonatomic) IBOutlet UILabel *timeCellLb;
-(void)efUpdateSelfUi:(HJLessonPlanUnitInfo*)unitInfo;

@property (nonatomic, strong) void (^changeTimeBlock)(JRCusTeaPlanLbCell*tempSelf);

-(void)setChangeTimeBlock:(void (^)(JRCusTeaPlanLbCell *tempSelf))changeTimeBlock;

@end
