//
//  JRTeachPlanCell.h
//  lifeBit_teach
//
//  Created by joyskim-ios1 on 16/9/5.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JRTeachPlanCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellLabel;
@property (weak, nonatomic) IBOutlet UIButton *cellButten;

-(void)setValue:(HJLessonPlanInfo*)dic withIndex:(NSInteger)index;
@end
