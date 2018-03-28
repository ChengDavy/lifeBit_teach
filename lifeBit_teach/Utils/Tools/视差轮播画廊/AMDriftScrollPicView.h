//
//  AMDriftScrollPicView.h
//  AMToolsDemo
//
//  Created by Aimi on 15/10/9.
//  Copyright © 2015年 Aimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMDriftScrollPicView : UIView
//
@property(nonatomic,strong)NSMutableArray* imageNameArray;          //NSString类型数组 图片名称的字符串array
@property(nonatomic,strong)NSMutableArray* imageURLArray;           //NSURL类型数组 图片URL的url array

@property(nonatomic)CGPoint pageControlCenter;                     //pageControl的中心
@property(nonatomic,strong)UIColor* pageControlColor;               //pageControl的颜色
@property(nonatomic,copy)void(^didTapPicBlock)(NSInteger index);    //点击图片后的回调block,返回下标


/**
 *  创建一个本地图片类型的轮播画廊
 *
 *  @param frame            Frame
 *  @param imageNameArray   NSString类型数组 图片名称的字符串array
 *  @param needpageControl  是否需要页数视图
 *  @param didTapPicBlock   点击图片后的回调,返回下标
 *
 *  @return 轮播画廊
 */
+(instancetype)driftScrollPicViewWithFrame:(CGRect)frame imageNameArray:(NSMutableArray*)imageNameArray needPageControl:(BOOL)needpageControl didTapPicBlock:(void (^)(NSInteger index))didTapPicBlock;


/**
 *  创建一个URL图片类型的轮播画廊
 *
 *  @param frame           Frame
 *  @param imageURLArray   NSURL类型数组 图片URL的url array
 *  @param needpageControl 是否需要页数视图
 *  @param didTapPicBlock  点击图片后的回调,返回下标
 *
 *  @return 轮播画廊
 */
+(instancetype)driftScrollPicViewWithFrame:(CGRect)frame imageURLArray:(NSMutableArray*)imageURLArray needPageControl:(BOOL)needpageControl didTapPicBlock:(void (^)(NSInteger index))didTapPicBlock;


/**
 *  设置被当前页数点点的颜色
 *
 *  @param pageControlColor 当前页数点点的颜色
 */
-(void)setPageControlColor:(UIColor *)pageControlColor;

/**
 *  开始自动轮播
 *  一般在viewWillApper中调用
 *
 *  @param eachTime 每次切换的时间(秒)
 */
-(void)startAutoScrollAnimationWithEachTime:(NSTimeInterval)eachTime;

/**
 *  停止自动轮播
 *  对应在viewWillDisAppear中停止
 */
-(void)stopAutoScrollAnimation;


#pragma mark  -----版本------
//  version 1.0.0 updata in 15/10/21 （by Aimi）
/*
 1.视差效果的轮播画廊
 2.支持无线轮播
 3.支持自动轮播
 4.支持pagecontrol
 */



@end
