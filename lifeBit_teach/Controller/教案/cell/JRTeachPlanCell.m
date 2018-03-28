//
//  JRTeachPlanCell.m
//  lifeBit_teach
//
//  Created by joyskim-ios1 on 16/9/5.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "JRTeachPlanCell.h"

@implementation JRTeachPlanCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

-(void)setValue:(HJLessonPlanInfo*)lessonPlanInfo withIndex:(NSInteger)index{
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color_VCBG"]];
    NSString *titleStr = nil;
    
        
        switch (index) {
            case 1:
            {
                titleStr = lessonPlanInfo.sSportTitle;
            }
                break;
            case 2:
            {
                if (lessonPlanInfo.sLessonPlanSource != nil && lessonPlanInfo.sLessonPlanSource.length > 0) {
                    titleStr = [NSString stringWithFormat:@"学校老师教案-%@",lessonPlanInfo.sSportTitle];
                }else{
                    titleStr = [NSString stringWithFormat:@"学校教案-%@",lessonPlanInfo.sSportTitle];
                }
               
            }
                break;
            case 3:
            {
                titleStr = [NSString stringWithFormat:@"平台教案-%@",lessonPlanInfo.sSportTitle];
            }
                break;
                
            default:
                break;
        }
    self.cellLabel.text = titleStr;
}



@end
