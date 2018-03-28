//
//  MeterTimeCell.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/7.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJMeterTimeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
-(void)updateSelfUi:(NSDictionary*)dic;
// 选择对应的学生
@property (nonatomic,strong)void (^selectStudentBlock)(HJMeterTimeCell *timeCell,NSDictionary*timeDic);
-(void)setSelectStudentBlock:(void (^)(HJMeterTimeCell *timeCell, NSDictionary*timeDic))selectStudentBlock;


-(void)selectUpdateStudentNameClick:(NSString*)nameStr;
@end
