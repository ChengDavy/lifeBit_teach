//
//  SKLeadingVC.m
//  SKAttendanceRecords
//
//  Created by youngxiansen on 15/8/29.
//  Copyright (c) 2015年 youngxiansen. All rights reserved.
//
#define kCount 3
#define IPhone4Height 480
#define IPhone5Height 568
#define IPhone6Height 667
#define IPhone6PlusHeight 736

#import "SKLeadingVC.h"
#import "JRLoginVC.h"
@interface SKLeadingVC ()<UIScrollViewDelegate>
{
    UIPageControl* _page;
    UIScrollView* _scroll;
    UIImageView* _imagView;
    CGFloat _btnW;
    CGFloat _btnH;
    CGFloat _bottomMargin;
    CGFloat _cornerRadius;
    CGFloat _fontSize;
}
@end

@implementation SKLeadingVC

#pragma mark --自定义View


- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    //1添加scrollView
    [self addScrollView];
    
    //2添加图片
    [self addScrollImage];
    
    //3添加pageControll
//    [self addPageControll];
}

#pragma mark --addSrollview
-(void)addScrollView
{
    _scroll = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scroll];
    
    _scroll.contentSize = CGSizeMake(kCount*[UIScreen mainScreen].bounds.size.width, 0);
    _scroll.pagingEnabled = YES;
    _scroll.delegate = self;
    _scroll.bounces = NO;
}

#pragma mark --addScrollImage
-(void)addScrollImage
{

    for (int i = 0; i < kCount; i++)
    {
        _btnW = 200;
        _btnH = 50;
        _bottomMargin = 62;
        _cornerRadius = 24;
        _fontSize = 20;
        _imagView = [[UIImageView alloc]initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, kScreenHeitht)];
        NSString* name = [NSString stringWithFormat:@"huanying_%d",i+1];
        _imagView.image = [UIImage imageNamed:name];
        [_scroll addSubview:_imagView];
        //添加立即体验
        if (i == kCount-1)
        {
            UIButton* finish = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenHeitht - 100 - 53, 210, 53)];
            CGPoint point1 = finish.center;
            point1.x = kScreenWidth*0.5;//设置中心位置
            finish.center = point1;
            [finish setImage:[UIImage imageNamed:@"start_tiyan"] forState:UIControlStateNormal];
            //要想让btn可以响应，必须让他的父视图可以用户交互
            _imagView.userInteractionEnabled = YES;
            [finish addTarget:self action:@selector(startExperience) forControlEvents:UIControlEventTouchUpInside];
            [_imagView addSubview:finish];
        }
    }
}

#pragma mark --点击事件
-(void)startExperience
{
    //    NSLog(@"fw");
    //控制器的VIEW是懒加载，用到的时候才加载
    [[NSUserDefaults standardUserDefaults]setValue:@"isFirstOpen" forKey:@"isFirstOpen"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    JRLoginVC* loginVC = [[JRLoginVC alloc]init];
//     UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    self.view.window.rootViewController = loginVC;
}

#pragma mark --addPageControll
-(void)addPageControll
{
    _page = [[UIPageControl alloc]init];
    _page.center = CGPointMake(kScreenWidth*0.5, kScreenHeitht*0.94);
    _page.numberOfPages = kCount;
    _page.pageIndicatorTintColor = UIColorFromRGB(0xF2F2F2);
    _page.currentPageIndicatorTintColor = UIColorFromRGB(0xCCCCCC);
    _page.bounds = CGRectMake(0, 0, 150, 0);
    [self.view addSubview:_page];
}
#pragma mark --scroll代理

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _page.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    
}

@end
