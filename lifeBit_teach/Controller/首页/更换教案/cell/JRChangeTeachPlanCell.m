//
//  JRChangeTeachPlanCell.m
//  lifeBit_teach
//
//  Created by joyskim-ios1 on 16/9/5.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "JRChangeTeachPlanCell.h"

@interface JRChangeTeachPlanCell()

@property (nonatomic,strong) HJLessonPlanInfo*lessonPlanInfo;

@end

@implementation JRChangeTeachPlanCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
//按钮选择
- (IBAction)selectButten:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        if (self.changeButtenSelectedBlock) {
            self.changeButtenSelectedBlock(sender,self.lessonPlanInfo);
        }
    }
   
}

-(void)updateSelfUi:(HJLessonPlanInfo*)lessonPlanInfo{
    self.lessonPlanInfo = lessonPlanInfo;
    NSString *titleStr = nil;
//    if (lessonPlanInfo.sLessonPlanSource != nil && lessonPlanInfo.sLessonPlanSource.length > 0) {
//        switch ([lessonPlanInfo.sLessonPlanSource intValue]) {
//            case 0:
//            {
//                titleStr = lessonPlanInfo.sSportTitle;
//            }
//                break;
//            case 1:
//            {
//                titleStr = [NSString stringWithFormat:@"学校教案-%@",lessonPlanInfo.sSportTitle];
//            }
//                break;
//            case 2:
//            {
//                titleStr = [NSString stringWithFormat:@"平台教案-%@",lessonPlanInfo.sSportTitle];
//            }
//                break;
//                
//            default:
//                break;
//        }
//    }else{
        titleStr = lessonPlanInfo.sSportTitle;
//    }
    self.lessonPlanNameLb.text = titleStr;
}

@end
