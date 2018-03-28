//
//  HJUploadStatusView.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/7.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJUploadScoreErrorView : UIView

+(instancetype)createUploadScoreStatusView;
// 保存成绩到本地
@property (nonatomic,strong)void (^saveScoreLocalBlock)(void);
-(void)setSaveScoreLocalBlock:(void (^)(void))saveScoreLocalBlock;

// 重新上传成绩
@property (nonatomic,strong) void (^afreshUploadScoreBlock)(void);
-(void)setAfreshUploadScoreBlock:(void (^)(void))afreshUploadScoreBlock;
@end
