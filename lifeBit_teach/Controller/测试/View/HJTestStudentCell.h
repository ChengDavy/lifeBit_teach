//
//  HJTestStudentCell.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/6.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJStudentInfo.h"

@interface HJTestStudentCell : UITableViewCell

// 点击选择学生Block回调
@property (nonatomic,strong)void (^selectOrExitStudentBlock)(HJTestStudentCell* testStudentCell,HJStudentInfo* selectStudent,UIButton* sender);
-(void)setSelectOrExitStudentBlock:(void (^)(HJTestStudentCell *testStudentCell, HJStudentInfo *selectStudent,UIButton* sender))selectOrExitStudentBlock;

// 点击选择输入成绩
@property (nonatomic,strong)void (^inputStudentScoreBlock)(HJTestStudentCell* testStudentCell,HJStudentInfo*inputStudent);
-(void)setInputStudentScoreBlock:(void (^)(HJTestStudentCell *testStudentCell,HJStudentInfo*inputStudent))inputStudentScoreBlock;

// 添加成绩
-(void)addStudentScoreWithScore:(NSString*)score;

// 修改成绩
-(void)alertStudentScoreWithScore:(NSString*)score andIndex:(NSInteger)index;

// 将按钮设置为选中状态
-(void)setSelectStudentClick;

// 点击修改分数
@property (nonatomic,strong)void (^tapAlertScoreBlock)(NSString *score,HJStudentInfo *scoreStudent,NSInteger tapTag);
-(void)setTapAlertScoreBlock:(void (^)(NSString *score, HJStudentInfo *scoreStudent,NSInteger tapTag))tapAlertScoreBlock;

-(void)updateSelfUi:(HJStudentInfo*)student;
@end
