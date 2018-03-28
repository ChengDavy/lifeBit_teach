//
//  HJInputScoreView.h
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/6.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJInputScoreView : UIView

+(instancetype)createInputScoreViewWithScore:(NSString*)score;



@property (nonatomic,copy)void (^inputScoreSureBlock)(NSString *score);
-(void)setInputScoreSureBlock:(void (^)(NSString *score))inputScoreSureBlock;
@end


