//
//  HJEmptyCell.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/10/12.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJEmptyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constriintHeiht;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contraintWithd;

@property (weak, nonatomic) IBOutlet UIImageView *emptyImageView;
@end
