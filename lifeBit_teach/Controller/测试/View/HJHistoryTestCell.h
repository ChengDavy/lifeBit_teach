//
//  HJHistoryTestCell.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/6.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HJHistoryTestCell : UITableViewCell

-(void)updateSelfUiData:(NSDictionary*)dic;

@property (nonatomic,strong)void (^againTestProjectBlock)(HJProjectInfo *projectInfo);
-(void)setAgainTestProjectBlock:(void (^)(HJProjectInfo *))againTestProjectBlock;

@end
