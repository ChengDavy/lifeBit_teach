//
//  HJNumberKeyBoard.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/10/10.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJNumberKeyBoardView : UIView
@property (nonatomic,strong)void (^tapKeyboardItemBlock)(NSInteger tap,NSString* contentStr);
-(void)setTapKeyboardItemBlock:(void (^)(NSInteger tap,NSString* contentStr))tapKeyboardItemBlock;
+(instancetype)createNumberKeyBoardView;
@end
