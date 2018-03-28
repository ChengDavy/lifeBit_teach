//
//  HJPageView.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/6.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJPageView.h"



@implementation HJPageView

-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

-(void)setUp{
    CGFloat widthItem = kScreenWidth/self.pageItemArr.count;
    CGFloat heightItem = self.bounds.size.height;
    for (int i = 0; i < self.pageItemArr.count; i++) {
        NSString *titleStr = self.pageItemArr[i];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*widthItem, 0, widthItem, heightItem)];
        [btn setBackgroundImage:[UIImage imageNamed:@"color_VCBG"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"color_blue"] forState:UIControlStateDisabled];
        [btn setBackgroundImage:[UIImage imageNamed:@"color_VCBG"] forState:UIControlStateHighlighted];
        [btn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateDisabled];
        [btn setTitleColor:UIColorFromRGB(0x1a75e3) forState:UIControlStateNormal];
        [btn setTitle:titleStr forState:UIControlStateNormal];
        [btn setTitle:titleStr forState:UIControlStateDisabled];
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color_blue"]].CGColor;
        btn.titleLabel.font = [UIFont systemFontOfSize:20];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.tag = i+1;
        [btn addTarget:self action:@selector(tapPageClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    self.defaultSelectIndex = 1;
}

-(void)setPageItemArr:(NSArray *)pageItemArr{
    _pageItemArr = pageItemArr;
    [self setUp];
}

-(void)setDefaultSelectIndex:(NSUInteger)defaultSelectIndex{
    if (defaultSelectIndex > self.pageItemArr.count || defaultSelectIndex <= 0) {
        defaultSelectIndex = 1;
    }
    _defaultSelectIndex = defaultSelectIndex;
    for (UIButton *btn in self.subviews) {
        if (btn.tag == _defaultSelectIndex) {
            [self tapPageClick:btn];
        }
    }
}
static int count = 0;
-(void)tapPageClick:(UIButton*)sender{
    count++;
    NSLog(@"count======%d",count);
    for (UIButton*btn in self.subviews) {
        btn.enabled = YES;
    }
    sender.enabled = NO;
    if (self.tapPageClickBlock) {
        self.tapPageClickBlock(sender.tag,sender);
    }
}
@end
