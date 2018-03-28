//
//  HJLinkagePickerView.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/22.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,HJLinkagePickerType) {
    HJLinkagePickerTypeGread,   // 年级选择
    HJLinkagePickerTypeLessonType, // 教案选择
};

@interface HJLinkagePickerView : UIView
+(instancetype)createSelectPickerWithDataSource:(NSMutableArray*)dataSource  andWithTitle:(NSString*)title WithType:(HJLinkagePickerType)type;


/**
 *  选择
 */
@property (nonatomic,strong) void (^selectPickerBlock)(NSInteger comperOne,NSInteger comerTwo);
-(void)setSelectPickerBlock:(void (^)(NSInteger comperOne,NSInteger comerTwo))selectPickerBlock;
@end
