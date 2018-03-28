//
//  HJInputTimeScoreView.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/14.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJInputTimeScoreView : UIView
+(instancetype)createInputTimeScoreViewWithScore:(NSString*)score;



@property (nonatomic,copy)void (^inputTimeScoreSureBlock)(NSString *minStr,NSString *secStr,NSString *msecStr);
-(void)setInputTimeScoreSureBlock:(void (^)(NSString *minStr,NSString*secStr,NSString*msecStr))inputTimeScoreSureBlock;
@end
