//
//  HJCustomPickerView.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/7.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HJCustomPickerView : UIView
+(instancetype)createSelectPickerWithDataSource:(NSMutableArray*)dataSource andWithTitle:(NSString*)title;
/**
 *  选择
 */
@property (nonatomic,strong) void (^selectPickerBlock)(NSString* sexType,NSInteger index);
-(void)setSelectPickerBlock:(void (^)(NSString* sexType ,NSInteger index))selectPickerBlock;
@end
