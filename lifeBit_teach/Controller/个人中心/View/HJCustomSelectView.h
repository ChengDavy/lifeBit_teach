//
//  HJCustomSelectView.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/27.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJCustomSelectView : UIView

+(instancetype)createSelectCustomSelectView;

@property (nonatomic,strong)void (^selectPhotoTypeBlock)(NSInteger type);
-(void)setSelectPhotoTypeBlock:(void (^)(NSInteger type))selectPhotoTypeBlock;
@end
