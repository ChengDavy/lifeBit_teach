      //
//  AMDriftScrollPicView.m
//  AMToolsDemo
//
//  Created by Aimi on 15/10/9.
//  Copyright © 2015年 Aimi. All rights reserved.
//

#import "AMDriftScrollPicView.h"
#import "UIImageView+AFNetworking.h"
#define kdsMyWidth self.bounds.size.width
#define kdsMyHeight self.bounds.size.height

@interface AMDriftScrollPicView ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView* scrollView;
@property(nonatomic)NSInteger currentIndex;
@property(nonatomic,strong)UIView* currentView;
@property(nonatomic,strong)UIView* nextView;
@property(nonatomic,strong)UIView* awardView;

@property(nonatomic,strong)UIImageView* currentIV;
@property(nonatomic,strong)UIImageView* nextIV;
@property(nonatomic,strong)UIImageView* awardIV;

@property(nonatomic,strong)UITapGestureRecognizer* tapGR;
@property(nonatomic,strong)UILongPressGestureRecognizer* tapLongPressGR;


@property(nonatomic,strong)UIPageControl* pageControl;

@property(nonatomic,strong)NSTimer* scrollTimer;

@property(nonatomic)NSTimeInterval eachTime;

@end

@implementation AMDriftScrollPicView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
    [self initScrollView];
    [self initTapGR];
    [self initLongPressGR];
    [self initPageControlCenter];
}




#pragma mark  ---工厂方法----
+(instancetype)driftScrollPicViewWithFrame:(CGRect)frame imageNameArray:(NSMutableArray *)imageNameArray needPageControl:(BOOL)needpageControl didTapPicBlock:(void (^)(NSInteger))didTapPicBlock{
    AMDriftScrollPicView* scrollPicView = [[AMDriftScrollPicView alloc]initWithFrame:frame];
    scrollPicView.imageNameArray = imageNameArray;
    if (didTapPicBlock) {
        scrollPicView.didTapPicBlock = didTapPicBlock;
    }
    
    if (needpageControl) {
        scrollPicView.pageControlColor = [UIColor whiteColor];
    }
    
    return scrollPicView;
}


+(instancetype)driftScrollPicViewWithFrame:(CGRect)frame imageURLArray:(NSMutableArray *)imageURLArray needPageControl:(BOOL)needpageControl didTapPicBlock:(void (^)(NSInteger))didTapPicBlock{
    AMDriftScrollPicView* scrollPicView = [[AMDriftScrollPicView alloc]initWithFrame:frame];
    scrollPicView.imageURLArray = imageURLArray;
    if (didTapPicBlock) {
        scrollPicView.didTapPicBlock = didTapPicBlock;
    }
    
    if (needpageControl) {
        scrollPicView.pageControlColor = [UIColor whiteColor];
    }
    
    return scrollPicView;
}



#pragma mark  ---逻辑代码-----

-(void)setImageNameArray:(NSMutableArray *)imageNameArray{
    _imageNameArray = imageNameArray;
    
    self.currentIndex = 0;
    self.currentIV.image = [UIImage imageNamed:imageNameArray[0]];
    
    if (imageNameArray.count<=1) {
        self.nextIV.image = [UIImage imageNamed:imageNameArray[0]];
    }else{
        self.nextIV.image = [UIImage imageNamed:imageNameArray[1]];
    }
    self.awardIV.image = [UIImage imageNamed:[imageNameArray lastObject]];
    
    if (self.pageControl) {
        self.pageControl.numberOfPages = imageNameArray.count;
    }
    
}


-(void)setImageURLArray:(NSMutableArray *)imageURLArray{
    _imageURLArray = imageURLArray;
    
    self.currentIndex = 0;
    [self.currentIV setImageWithURL:imageURLArray[0]];
    
    if (imageURLArray.count<=1) {
        [self.nextIV setImageWithURL:imageURLArray[0]];
    }else{
        [self.nextIV setImageWithURL:imageURLArray[1]];
    }
    [self.awardIV setImageWithURL:imageURLArray.lastObject];
    
    if (self.pageControl) {
        self.pageControl.numberOfPages = imageURLArray.count;
    }
}

-(void)initScrollView{
    if (self.scrollView) {
        [self.scrollView removeFromSuperview];
    }
    
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kdsMyWidth, kdsMyHeight)];
    self.scrollView.contentSize = CGSizeMake(kdsMyWidth*3, 0);
    
    [self addSubview:self.scrollView];
    self.scrollView.delegate = self;
    
    
    self.currentView = [[UIView alloc]initWithFrame:CGRectMake(kdsMyWidth, 0, kdsMyWidth, kdsMyHeight)];
    self.currentView.clipsToBounds = YES;
    self.currentIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kdsMyWidth, kdsMyHeight)];
    self.currentIV.backgroundColor = [UIColor colorWithWhite:.94 alpha:1];
    self.currentIV.contentMode = UIViewContentModeScaleAspectFill;
    [self.currentView addSubview:self.currentIV];
    [self.scrollView addSubview:self.currentView];
    
    
    self.nextView = [[UIView alloc]initWithFrame:CGRectMake(kdsMyWidth*2, 0, 0, kdsMyHeight)];
    self.nextView.clipsToBounds = YES;

     self.nextIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kdsMyWidth, kdsMyHeight)];
    self.nextIV.backgroundColor = [UIColor colorWithWhite:.94 alpha:1];
    self.nextIV.contentMode = UIViewContentModeScaleAspectFill;
    self.nextIV.center = CGPointMake(self.nextView.bounds.size.width/2, self.nextView.bounds.size.height/2);
    [self.nextView addSubview:self.nextIV];
    [self.scrollView addSubview:self.nextView];
    
    self.awardView = [[UIView alloc]initWithFrame:CGRectMake(kdsMyWidth, 0, 0, kdsMyHeight)];
    self.awardView.clipsToBounds = YES;
   
    self.awardIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kdsMyWidth, kdsMyHeight)];
    self.awardIV.backgroundColor = [UIColor colorWithWhite:.94 alpha:1];
    self.awardIV.contentMode = UIViewContentModeScaleAspectFill;
    self.awardIV.center = CGPointMake(self.awardView.bounds.size.width/2, self.awardView.bounds.size.height/2);
    
    [self.awardView addSubview:self.awardIV];
    [self.scrollView addSubview:self.awardView];
    
    self.scrollView.contentOffset = CGPointMake(kdsMyWidth, 0);
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
}


-(void)addNewAward{
    self.currentIndex --;
    if (self.currentIndex <0) {
        if (self.imageNameArray) {
            self.currentIndex = self.imageNameArray.count-1;
        }else if (self.imageURLArray){
            self.currentIndex= self.imageURLArray.count - 1;
        }
    }
    
    [self.currentIV removeFromSuperview];
    [self.nextIV removeFromSuperview];
    [self.awardIV removeFromSuperview];
    
    self.nextIV = self.currentIV;
    self.nextIV.center = CGPointMake(self.nextView.bounds.size.width/2, self.nextView.bounds.size.height/2);
    [self.nextView addSubview:self.nextIV];
    
    self.currentIV = self.awardIV;
    self.currentIV.center = CGPointMake(self.currentView.bounds.size.width/2, self.currentView.bounds.size.height/2);
    [self.currentView addSubview:self.currentIV];
    
    self.awardIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kdsMyWidth, kdsMyHeight)];
    self.awardIV.backgroundColor = [UIColor colorWithWhite:.94 alpha:1];
    self.awardIV.contentMode = UIViewContentModeScaleAspectFill;
    if (self.imageNameArray) {
        if (self.currentIndex == 0) {
            self.awardIV.image =[UIImage imageNamed:self.imageNameArray.lastObject];
        }else{
            self.awardIV.image = [UIImage imageNamed:self.imageNameArray[self.currentIndex-1]];
        }
    }else if (self.imageURLArray){
        if (self.currentIndex == 0) {
            [self.awardIV setImageWithURL:self.imageURLArray.lastObject];
        }else{
            [self.awardIV setImageWithURL:self.imageURLArray[self.currentIndex-1]];
        }
    }
    
    
    self.awardIV.center = CGPointMake(self.awardView.bounds.size.width/2, self.awardView.bounds.size.height/2);
    
    [self.awardView addSubview:self.awardIV];
    self.scrollView.contentOffset = CGPointMake(kdsMyWidth, 0);
    
}

-(void)addNewNext{
    [self.currentIV removeFromSuperview];
    [self.nextIV removeFromSuperview];
    [self.awardIV removeFromSuperview];
    
    self.currentIndex ++;
    if (self.imageNameArray) {
        if (self.currentIndex > self.imageNameArray.count-1) {
            self.currentIndex = 0;
        }
    }else if (self.imageURLArray){
        if (self.currentIndex > self.imageURLArray.count-1) {
            self.currentIndex = 0;
        }
    }

    self.awardIV = self.currentIV;
    self.awardIV.center = CGPointMake(self.awardView.bounds.size.width/2, self.awardView.bounds.size.height/2);
    [self.awardView addSubview:self.awardIV];
    
    self.currentIV = self.nextIV;
    self.currentIV.center = CGPointMake(self.currentView.bounds.size.width/2, self.currentView.bounds.size.height/2);
    [self.currentView addSubview:self.currentIV];
    
    self.nextIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kdsMyWidth, kdsMyHeight)];
    self.nextIV.backgroundColor = [UIColor colorWithWhite:.94 alpha:1];
    self.nextIV.contentMode = UIViewContentModeScaleAspectFill;
    if (self.imageNameArray) {
        if (self.currentIndex == self.imageNameArray.count-1) {
            self.nextIV.image =[UIImage imageNamed:self.imageNameArray.firstObject];
        }else{
            self.nextIV.image = [UIImage imageNamed:self.imageNameArray[self.currentIndex+1]];
        }
    }else if (self.imageURLArray){
        if (self.currentIndex == self.imageURLArray.count-1) {
            [self.nextIV setImageWithURL:self.imageURLArray.firstObject];
        }else{
            [self.nextIV setImageWithURL:self.imageURLArray[self.currentIndex+1]];
        }
    }
    
    self.nextIV.center = CGPointMake(self.nextView.bounds.size.width/2, self.nextView.bounds.size.height/2);
    [self.nextView addSubview:self.nextIV];
    
    self.scrollView.contentOffset = CGPointMake(kdsMyWidth, 0);
    
}


#pragma mark  ---scrollViewDelegate------
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        CGFloat offSetX = scrollView.contentOffset.x - kdsMyWidth;
        //        NSLog(@"scrollView Did scroll %.2f",offSetX);
        //向前滑动
        if (offSetX<0) {
            offSetX = (-offSetX);
            CGRect frame = self.awardView.frame;
            frame.size.width = offSetX;
            frame.origin.x = kdsMyWidth - offSetX;
            self.awardView.frame = frame;
            self.awardIV.center = CGPointMake(self.awardView.bounds.size.width/2, self.awardView.bounds.size.height/2);
            
            frame = self.currentView.frame;
            frame.size.width =  kdsMyWidth - offSetX;
            self.currentView.frame = frame;
            self.currentIV.center = CGPointMake(self.currentView.bounds.size.width/2, self.currentView.bounds.size.height/2);
            
        }else{
            //向后滑动
            CGRect frame = self.nextView.frame;
            frame.size.width = offSetX;
            self.nextView.frame = frame;
            self.nextIV.center = CGPointMake(self.nextView.bounds.size.width/2, self.nextView.bounds.size.height/2);
            
            frame = self.currentView.frame;
            frame.size.width =  kdsMyWidth - offSetX;
            frame.origin.x = kdsMyWidth+ offSetX;
            self.currentView.frame = frame;
            self.currentIV.center = CGPointMake(self.currentView.bounds.size.width/2, self.currentView.bounds.size.height/2);
        }
    }
}

-(void)scrollViewWillBeginDecelerating: (UIScrollView *)scrollView{
    [scrollView setContentOffset:scrollView.contentOffset animated:NO];
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (scrollView.contentOffset.x < kdsMyWidth && targetContentOffset->x <= kdsMyWidth/2) {
        [self scrollViewMoveToAward];
    }else if (scrollView.contentOffset.x > kdsMyWidth && targetContentOffset->x >= kdsMyWidth*3/2){
        [self scrollViewMoveToNext];
    }else{
        [self scrollViewMoveToMiddle];
    }
}


-(void)scrollViewMoveToAward{
    [UIView animateWithDuration:.3 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }completion:^(BOOL finished) {
        [self addNewAward];
        self.pageControl.currentPage = self.currentIndex;
    } ];
    
    
    if (self.eachTime) {
        [self.scrollTimer invalidate];
        self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.eachTime target:self selector:@selector(scrollViewMoveToNext) userInfo:nil repeats:YES];
    }
}

-(void)scrollViewMoveToNext{
    [UIView animateWithDuration:.3 animations:^{
        self.scrollView.contentOffset = CGPointMake(kdsMyWidth*2, 0);
    }completion:^(BOOL finished) {
        [self addNewNext];
        self.pageControl.currentPage = self.currentIndex;
    }];
    
    if (self.eachTime) {
        [self.scrollTimer invalidate];
        self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.eachTime target:self selector:@selector(scrollViewMoveToNext) userInfo:nil repeats:YES];
    }
}

-(void)scrollViewMoveToMiddle{
    [UIView animateWithDuration:.3 animations:^{
        self.scrollView.contentOffset = CGPointMake(kdsMyWidth, 0);
    }];
    
    if (self.eachTime) {
        [self.scrollTimer invalidate];
        self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.eachTime target:self selector:@selector(scrollViewMoveToNext) userInfo:nil repeats:YES];
    }
}


#pragma mark  -----点击事件--------
-(void)initTapGR{
    self.tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGRDidTap:)];
    self.tapGR.numberOfTapsRequired = 1;
    self.tapGR.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:self.tapGR];
}

-(void)tapGRDidTap:(UITapGestureRecognizer*)tapGR{
//    NSLog(@"AMDriftScrollPicView tap %d pic",self.currentIndex);
    if (self.didTapPicBlock) {
        self.didTapPicBlock(self.currentIndex);
    }
}

#pragma mark  -----点击事件--------
-(void)initLongPressGR{
    self.tapLongPressGR = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tapLongPressGRDidTap:)];
    [self.scrollView addGestureRecognizer:self.tapLongPressGR];
}

-(void)tapLongPressGRDidTap:(UILongPressGestureRecognizer*)tapLongPressGR{
    
    if(tapLongPressGR.state == UIGestureRecognizerStateBegan)
        
    {
       [self stopAutoScrollAnimation];
    }
    
    else if(tapLongPressGR.state == UIGestureRecognizerStateEnded)
        
    {
        [self startAutoScrollAnimationWithEachTime:4];
    }
    
    else if(tapLongPressGR.state == UIGestureRecognizerStateChanged)
        
    {
        
    }
    
}

#pragma mark  -----pagecontrol------
-(void)initPageControlCenter{
    //设置pageControl
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-25, 100, 20)];
    self.pageControl.center = CGPointMake(self.bounds.size.width/2, self.pageControl.center.y);
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
//    self.pageControl.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@""]];
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.alpha = 0.0;
    [self addSubview:self.pageControl];
    
}

-(void)setPageControlCenter:(CGPoint)pageControlCenter{
    _pageControlCenter = pageControlCenter;
    _pageControl.alpha = 1.0;
    _pageControl.center = _pageControlCenter;
}

-(void)setPageControlColor:(UIColor *)pageControlColor{
    _pageControlColor = pageControlColor;
    _pageControl.alpha = 1.0;
    _pageControl.currentPageIndicatorTintColor = pageControlColor;
}


#pragma mark ------自动动画-------
-(void)startAutoScrollAnimationWithEachTime:(NSTimeInterval)eachTime{
    self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:eachTime target:self selector:@selector(scrollViewMoveToNext) userInfo:nil repeats:YES];
    self.eachTime = eachTime;
}

-(void)stopAutoScrollAnimation{
    [self.scrollTimer invalidate];
    self.eachTime = 0;
}

@end
