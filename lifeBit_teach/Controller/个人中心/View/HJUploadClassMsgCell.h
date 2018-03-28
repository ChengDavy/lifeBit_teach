//
//  HJUploadClassMsgCell.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/13.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJClassInfo.h"

@interface HJUploadClassMsgCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;

@property (weak, nonatomic) IBOutlet UILabel *testProjectLb;
-(void)updateSelfUi:(HJClassInfo*)classInfo;


@property (nonatomic,strong)void (^tapUploadDataBlock)(HJClassInfo* classInfo);
-(void)setTapUploadDataBlock:(void (^)(HJClassInfo *classInfo))tapUploadDataBlock;
@end
