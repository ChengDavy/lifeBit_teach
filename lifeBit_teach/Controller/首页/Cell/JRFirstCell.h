//
//  JRFirstCell.h
//  手表
//
//  Created by joyskim-ios1 on 16/9/1.
//  Copyright © 2016年 joyskim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JRFirstCell : UITableViewCell
@property (nonatomic,strong)void (^gotoCheckPlanBlock)(UITableViewCell *cell,HJClassInfo *classInfo);
-(void)setGotoCheckPlanBlock:(void (^)(UITableViewCell *cell,HJClassInfo *classInfo))gotoCheckPlanBlock;

-(void)updateSelfUi:(HJClassInfo*)classinfo;
@end
