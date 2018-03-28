//
//  YQTableView.h
//  P2P
//
//  Created by WilliamYan on 15/8/12.
//  Copyright (c) 2015年 WilliamYan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YQTableView : UITableView
@property (nonatomic,assign)BOOL evIsDownPull;
@property (nonatomic,assign)BOOL evIsUpwardPull;


// 下拉  调用的方法
@property (nonatomic,strong) void(^epDownPullClick)(void);
-(void)setEpDownPullClick:(void (^)(void))epDownPullClick;

// 上拉  调用的方法
@property (nonatomic,strong) void(^epUpwardPullClick)(void);
-(void)setEpUpwardPullClick:(void (^)(void))epUpwardPullClick;

-(void)removeDownPullHeader;
@end
