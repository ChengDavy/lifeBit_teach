//
//  YQTableView.m
//  P2P
//
//  Created by WilliamYan on 15/8/12.
//  Copyright (c) 2015年 WilliamYan. All rights reserved.
//

#import "YQTableView.h"
#import "MJRefresh.h"

@implementation YQTableView
-(instancetype)init{
    self = [super init];
    if (self) {
        [self initData];
        [self initialize];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initData];
        [self initialize];
    }
    return self;
}
-(void)initData{
    self.evIsUpwardPull = YES;
    self.evIsDownPull = YES;
}
-(void)initialize{
    __weak YQTableView* tempTableView = self;
    if (self.evIsDownPull) {
        [self addLegendHeaderWithRefreshingBlock:^{
            if (tempTableView.epDownPullClick) {
                tempTableView.epDownPullClick();
            }
        }];
    }
    if (self.evIsUpwardPull) {
        [self addLegendFooterWithRefreshingBlock:^{
            if (tempTableView.epUpwardPullClick) {
                tempTableView.epUpwardPullClick();
            }
        }];
    }
    
}

-(void)removeDownPullHeader{
    [self  removeHeader];
}





@end
