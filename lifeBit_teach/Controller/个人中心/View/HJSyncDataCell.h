//
//  HJSyncDataCell.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/12.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJSyncDataCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (strong, nonatomic) IBOutlet UILabel *stateLB;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (strong, nonatomic) IBOutlet UILabel *progressLB;
@end
