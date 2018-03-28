//
//  HJCustomClassCell.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/19.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJCustomClassCell : UITableViewCell
-(void)updateSelfUi:(HJClassInfo*)classInfo;

@property (nonatomic,strong) void (^tapGotoInClassBlock)(UITableViewCell*cell,HJClassInfo *classInfo);
-(void (^)(UITableViewCell * cell, HJClassInfo * classInfo))tapGotoInClassBlock;
@end
