//
//  JRChangeTeachPlanCell.h
//  lifeBit_teach
//
//  Created by joyskim-ios1 on 16/9/5.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJLessonPlanInfo.h"
@interface JRChangeTeachPlanCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lessonPlanNameLb;

@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (nonatomic,strong)void (^changeButtenSelectedBlock)(UIButton* butten,HJLessonPlanInfo *lessonPlanInfo);
-(void)setChangeButtenSelectedBlock:(void (^)(UIButton* button,HJLessonPlanInfo *lessonPlanInfo))changeButtenSelectedBlock;
-(void)updateSelfUi:(HJLessonPlanInfo*)lessonPlanInfo;
@end
