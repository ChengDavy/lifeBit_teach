//
//  HJPageView.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/6.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJPageView : UIView

// 添加的元素
@property (nonatomic,strong)NSArray *pageItemArr;

@property (nonatomic,assign)NSUInteger defaultSelectIndex;

// 点击的按钮的回调
@property (nonatomic,copy)void (^tapPageClickBlock)(NSInteger selectIndex,UIButton *selectBtn);

-(void)setTapPageClickBlock:(void (^)(NSInteger selectIndex, UIButton * selectBtn))tapPageClickBlock;
@end
