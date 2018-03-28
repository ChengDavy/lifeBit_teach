//
//  LBBlueSyncCell.h
//  lifeBit_teach
//
//  Created by Aimi on 16/5/11.
//  Copyright © 2016年 joyskim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBBlueSyncCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLB;
@property (strong, nonatomic) IBOutlet UILabel *stateLB;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (strong, nonatomic) IBOutlet UILabel *progressLB;

@end
