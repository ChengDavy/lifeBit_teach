//
//  AMNoticeAlertView.m
//  AMToolsDemo
//
//  Created by Aimi on 15/8/31.
//  Copyright (c) 2015年 Aimi. All rights reserved.
//

#import "AMNoticeAlertView.h"

@interface AMNoticeAlertView () 
@property(nonatomic,strong)UILabel* titleLB;
@property(nonatomic,strong)UIImageView* noticeIV;
@property(nonatomic,strong)CAShapeLayer*arcLayer;
@property(nonatomic)AMNoticeAlertType type;
@property(nonatomic,strong)NSString* titleStr;
@property(nonatomic,strong)CALayer*pointLayer;


@end

@implementation AMNoticeAlertView

-(instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}




+(instancetype)noticeAlertWithType:(AMNoticeAlertType)type andTitleStr:(NSString *)str{
    AMNoticeAlertView* noticeAlertView = [[AMNoticeAlertView alloc]initWithFrame:CGRectMake(0, 0, 150, 90)];
    noticeAlertView.type = type;
    noticeAlertView.titleStr = str;
    [noticeAlertView initialize];
    switch (type) {
        case AMNoticeAlertTypeSuccess:
            [noticeAlertView initSuccessUI];
            break;
            
        case AMNoticeAlertTypeError:
            [noticeAlertView initErroUI];
            break;
            
        case AMNoticeAlertTypeNetWork:
            [noticeAlertView initNetWorkUI];
            
        default:
            break;
    }
    
    return noticeAlertView;
}



-(void)initialize{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActiveNotif:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    //设置背景颜色

    self.backgroundColor = [UIColor colorWithWhite:.0 alpha:.7];


    self.layer.cornerRadius = 10.0;
    self.layer.masksToBounds = YES;
    
    //添加title label
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(10, self.bounds.size.height-kTitleLableHeight-5, self.bounds.size.width-20, kTitleLableHeight)];
    self.titleLB.font = [UIFont boldSystemFontOfSize:14];
    self.titleLB.textColor = [UIColor whiteColor];
    self.titleLB.textAlignment = NSTextAlignmentCenter;
    self.titleLB.text = self.titleStr;
    self.titleLB.numberOfLines = 2;
    [self addSubview:self.titleLB];
    
    self.noticeIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    self.noticeIV.center = CGPointMake(self.center.x, self.center.y-18);
    [self addSubview:self.noticeIV];
    
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(2, 2);               //阴影的偏移量
    self.layer.shadowRadius = 3.0;                           //阴影的圆角
    self.layer.shadowOpacity = .6;                          //阴影的透明度
    self.layer.masksToBounds = NO;
}



#pragma mark -----成功type配置------
-(void)initSuccessUI{
    
    UIBezierPath *path=[UIBezierPath bezierPath];
    
    CGSize size=self.bounds.size;
    
    [path addArcWithCenter:CGPointMake(size.width/2,(size.height - kTitleLableHeight)/2+2) radius:17 startAngle:-M_PI/3 endAngle:M_PI*2-M_PI/3+0.00001 clockwise:NO];
    CAShapeLayer* arcLayer=[CAShapeLayer layer];
    arcLayer.path=path.CGPath;
    arcLayer.fillColor=[UIColor clearColor].CGColor;
    arcLayer.strokeColor=[UIColor colorWithWhite:1 alpha:1].CGColor;
    arcLayer.lineWidth=2.5;
    arcLayer.frame=CGRectMake(0, 0, 50, 50);
    self.arcLayer = arcLayer;
    [self.layer addSublayer:arcLayer];
    
    [self startSuccessAnimation];
    
}

-(void)startSuccessAnimation{
    
    self.titleLB.alpha = 0;
    self.noticeIV.alpha = 0;
    self.titleLB.text = self.titleStr;
    self.noticeIV.image = [UIImage imageNamed:@"notice_alert_gou"];
    
    [self drawLineAnimation:self.arcLayer];

    [UIView animateWithDuration:.3 delay:.3 options:0 animations:^{
        self.noticeIV.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:.3 delay:.4 options:0 animations:^{
        self.titleLB.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}


-(void)drawLineAnimation:(CALayer*)layer
{
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration=.4;
    bas.delegate=self;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue=[NSNumber numberWithInteger:1];
//    bas.repeatCount = 1;
    
    [layer addAnimation:bas forKey:@"key"];
}


#pragma mark -----出错type配置------
-(void)initErroUI{
    
    [self startErrorAnimation];
}


-(void)startErrorAnimation{
    self.noticeIV.image = [UIImage imageNamed:@"notice_alert_error"];
    self.titleLB.text = self.titleStr;
    self.titleLB.alpha = 0;
    self.noticeIV.alpha = 0;
    
    if (self.arcLayer) {
        [self.arcLayer removeFromSuperlayer];
    }
    UIBezierPath *path=[UIBezierPath bezierPath];
    CGSize size=self.bounds.size;
    [path addArcWithCenter:CGPointMake(size.width/2,(size.height - kTitleLableHeight)/2+2) radius:17 startAngle:-M_PI/3 endAngle:M_PI*2-M_PI/50 clockwise:NO];
    CAShapeLayer* arcLayer=[CAShapeLayer layer];
    arcLayer.path=path.CGPath;
    arcLayer.fillColor=[UIColor clearColor].CGColor;
    arcLayer.strokeColor=[UIColor colorWithWhite:1 alpha:1].CGColor;
    arcLayer.lineWidth=2.5;
    arcLayer.frame=CGRectMake(0, 0, 50, 50);
    self.arcLayer = arcLayer;
    [self.layer addSublayer:arcLayer];
    
    [self drawErrorLineAnimation:self.arcLayer];
    
    [UIView animateWithDuration:.1 delay:.3 options:0 animations:^{
        self.noticeIV.alpha = 1;
    } completion:^(BOOL finished) {
        [self shakeViewWithLayer:self.arcLayer];
        [self shakeViewWithLayer:self.noticeIV.layer];

    }];
    
    [UIView animateWithDuration:.2 delay:.3 options:0 animations:^{
        self.titleLB.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)drawErrorLineAnimation:(CALayer*)layer
{
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration=.3;
    bas.delegate=self;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue=[NSNumber numberWithInteger:1];
    [layer addAnimation:bas forKey:@"key"];
}

-(void)shakeViewWithLayer:(CALayer*)layer{
    CGPoint posLbl = [layer position];
    CGPoint y = CGPointMake(posLbl.x-5, posLbl.y);
    CGPoint x = CGPointMake(posLbl.x+5, posLbl.y);
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.04];
    [animation setRepeatCount:3];
    [layer addAnimation:animation forKey:nil];
    
}





#pragma mark  ------网络--------
-(void)initNetWorkUI{
    
    self.layer.masksToBounds = YES;
    
    UIBezierPath *path=[UIBezierPath bezierPath];
    
    CGSize size=self.bounds.size;
    
    [path addArcWithCenter:CGPointMake(size.width/2,(size.height - kTitleLableHeight)/2+2) radius:17 startAngle:-M_PI/3 endAngle:M_PI*2-M_PI/3+0.00001 clockwise:NO];
    CAShapeLayer* arcLayer=[CAShapeLayer layer];
    arcLayer.path=path.CGPath;
    arcLayer.fillColor=[UIColor clearColor].CGColor;
    arcLayer.strokeColor=[UIColor colorWithWhite:1 alpha:1].CGColor;
    arcLayer.lineWidth=2.5;
    arcLayer.frame=CGRectMake(0, 0, 50, 50);
    self.arcLayer = arcLayer;
    [self.layer addSublayer:arcLayer];
    
    
    CALayer* pointLayer = [[CALayer alloc]init];
    pointLayer.frame = CGRectMake(-5, -5,3.5,3.5);
    pointLayer.cornerRadius = 1.7;
    pointLayer.backgroundColor = [UIColor whiteColor].CGColor;
    self.pointLayer = pointLayer;
    
    [self.layer addSublayer:pointLayer];
    
//    self.titleLB.alpha = 0;
    self.noticeIV.alpha = 0;
    self.noticeIV.image = [UIImage imageNamed:@"notice_alert_gou"];
    
    [self startNetWorkAnimation];
    
}


-(void)startNetWorkAnimation{
    self.titleLB.alpha = 1.0;
    self.titleLB.text = self.titleStr;
    self.isNeting = YES;
    self.animationTime = 0.0f;
    self.alertTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(netWorkRunTimer) userInfo:nil repeats:YES];
    
    [self startNetWorkWithLayer:self.arcLayer];
    [self startNetWorkPointAnimationWithLayer:self.pointLayer];
}

-(void)netWorkRunTimer{
    self.animationTime += 0.05;
//    NSLog(@"netWorkRunTimer");
}

-(void)startNetWorkWithLayer:(CALayer*)layer
{
    CAKeyframeAnimation *bas1=[CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    bas1.delegate=self;
    bas1.values = @[@(0),@(.9),@(1.0)];
    bas1.keyTimes = @[@(.0),@(.3),@(.6)];

    
    CAKeyframeAnimation *bas2=[CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
    bas2.beginTime = .4;
    bas2.delegate=self;
    bas2.values = @[@(0),@(.7),@(1.0)];
    bas2.keyTimes = @[@(.0),@(.3),@(.6)];
//
//    CABasicAnimation *bas3=[CABasicAnimation animationWithKeyPath:@"opacity"];
//    bas3.beginTime = bas2.beginTime + bas2.duration;
//    bas3.duration = .2;
//    bas3.repeatCount = MAXFLOAT;
//    bas3.delegate=self;
//    bas3.fromValue=[NSNumber numberWithInteger:.1];
//    bas3.toValue=[NSNumber numberWithInteger:0.0];

    
    CAAnimationGroup *animation=[CAAnimationGroup animation];
    
    animation.animations=@[bas1,bas2];
    
    animation.duration=1.3;
    
    animation.repeatCount=FLT_MAX;
    
    animation.fillMode=kCAFillModeRemoved;
    
    animation.delegate = self;
    
    [layer addAnimation:animation forKey:@"netArcKey"];
}


-(void)startNetWorkPointAnimationWithLayer:(CALayer*)layer{
    
    
    CAKeyframeAnimation* moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGSize size=self.bounds.size;
    UIBezierPath *path=[UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(size.width/2,(size.height - kTitleLableHeight)/2+2) radius:17 startAngle:-M_PI/3 endAngle:M_PI*2-M_PI/3+.6 clockwise:NO];
    
    
    moveAnimation.path = path.CGPath;
    
    moveAnimation.duration = .7;
    moveAnimation.beginTime = .4;
    moveAnimation.removedOnCompletion = YES;
    
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"opacity"];
    bas.beginTime=1.25;
    bas.duration = .1;
    bas.delegate=self;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue=[NSNumber numberWithInteger:1];
    
    
    CAAnimationGroup *animation=[CAAnimationGroup animation];
    
    animation.animations=@[moveAnimation];
    
    animation.duration=1.3;
    
    animation.repeatCount=FLT_MAX;
    
    animation.fillMode=kCAFillModeRemoved;
    
    animation.delegate = self;
    
    [layer addAnimation:animation forKey:@"netPointKey"];
}

-(void)changeNetAnimationToSuccessAnimationWithTitleStr:(NSString*)titleStr WithDelayTime:(NSTimeInterval)delayTime{
    self.isNeting = NO;
    if (self.alertTimer) {
        [self.alertTimer invalidate];
    }
    [self performSelector:@selector(changeToSuccessWithStr:) withObject:titleStr afterDelay:delayTime];
}

-(void)changeNetAnimationToErrorAnimationWithTitleStr:(NSString*)titleStr WithDelayTime:(NSTimeInterval)delayTime{
    self.isNeting = NO;
    if (self.alertTimer) {
        [self.alertTimer invalidate];
    }
     [self performSelector:@selector(changeToErrorWithStr:) withObject:titleStr afterDelay:delayTime];
}

-(void)changeToSuccessWithStr:(NSString*)titleStr{
    [self.arcLayer removeAllAnimations];
    [self.pointLayer removeAllAnimations];
    self.titleStr = titleStr;
    self.isNeting = NO;
    [self startSuccessAnimation];

}

-(void)changeToErrorWithStr:(NSString*)titleStr{
    [self.arcLayer removeAllAnimations];
    [self.pointLayer removeAllAnimations];
    self.titleStr = titleStr;
    self.isNeting = NO;
    [self startErrorAnimation];
}

-(void)endNetAnimationWithNoMessage{
    if (self.alertTimer) {
        [self.alertTimer invalidate];
    }
    self.isNeting = NO;
    [self.arcLayer removeAllAnimations];
    [self.pointLayer removeAllAnimations];
}

- (void)appDidBecomeActiveNotif:(NSNotification*)notif
{
    if (self.isNeting) {
        [self startNetWorkWithLayer:self.arcLayer];
        [self startNetWorkPointAnimationWithLayer:self.pointLayer];
    }else{
//        NSLog(@"notNeting");
    }
}

-(void)dealloc{
//    NSLog(@"%@ 销毁了",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}


-(void)willMoveToWindow:(UIWindow *)newWindow{
    if (self.isNeting) {
        [self startNetWorkWithLayer:self.arcLayer];
        [self startNetWorkPointAnimationWithLayer:self.pointLayer];
    }else{
        //        NSLog(@"notNeting");
    }
}


@end
