//
//  UIViewController+AMAutoKeyBoardVC.h
//  AMToolsDemo
//
//  Created by Aimi on 15/9/23.
//  Copyright © 2015年 Aimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (AMAutoKeyBoardVC)

@property(nonatomic,strong)UITapGestureRecognizer* amKeyboardTapGR;
@property(nonatomic,strong)NSNumber* amKeyboardOffSetY;


/**
 *  在控制器的首视图中添加一个用于隐藏键盘的点击手势
 */
-(void)addAmAutoKeyBoardTapGR;



#pragma mark  -----版本------
/**
 *  version 1.0.2 updata in 16/03/14
 *  修正了键盘弹起后 其他控件点击无效的问题
 */

/**
 *  version 1.0.1 updata in 15/9/24
 *  请使用AMAutoTextField.h
 */
@end
