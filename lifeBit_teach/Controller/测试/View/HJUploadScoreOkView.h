//
//  HJUploadStatusView.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/7.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJUploadScoreOkView : UIView

+(instancetype)createUploadScoreStatusView;


// 上传成绩成功
@property (nonatomic,strong) void (^uploadScoreOkBlock)(void);
-(void)setUploadScoreOkBlock:(void (^)(void))uploadScoreOkBlock;
@end
