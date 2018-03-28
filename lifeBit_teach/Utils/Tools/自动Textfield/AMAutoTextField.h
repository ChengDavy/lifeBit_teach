//
//  AMAutoTextField.h
//  AMToolsDemo
//
//  Created by Aimi on 15/9/22.
//  Copyright (c) 2015年 Aimi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kKeyboardEdge 60    //textfield在键盘上方所保持的报读

@interface AMAutoTextField : UITextField <UITextFieldDelegate>

@end

#pragma mark  -----版本------
/**
 *  version 1.0.2 updata in 16/03/14
 *  修正了键盘弹起后 其他控件点击无效的问题
 */


/**
 *  version 1.0.0 updata in 15/9/24
 *  替换textfield使用即可
 *
 *  自动根据用户所点击的textfield 弹出键盘 并使界面向上移动
 *  textfield 始终会在保持在键盘上方 “kKeyboardEdge” 的高度
 *  当用户点击键盘returnKey时 自动隐藏键盘恢复界面
 */

/**
 *  version 1.0.1 updata in 15/9/24
 *  修正了未设置 extendedLayoutIncludesOpaqueBars 属性时的错位问题
 */