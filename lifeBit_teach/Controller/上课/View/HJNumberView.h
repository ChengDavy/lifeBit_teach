//
//  HJNumberView.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/10/18.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJNumberView : UIView
+(HJNumberView*)createNumberView;

@property (nonatomic,strong)void (^tapKeyboardClick)(NSInteger tag,NSString *contentStr);
-(void)setTapKeyboardClick:(void (^)(NSInteger tag,NSString *contentStr))tapKeyboardClick;
@end
