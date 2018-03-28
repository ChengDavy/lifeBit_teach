//
//  HJCallOverView.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/8.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJCallOverView.h"
#import "HJCallOverBtn.h"

@interface HJCallOverView()
@property (nonatomic,strong)UIScrollView *scrollView;
@end
@implementation HJCallOverView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initialze];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialze];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialze];
    }
    return self;
}



-(void)initialze{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.scrollView];
}

-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}




-(void)showStudentView:(NSMutableArray *)studentArr withCallOverArr:(NSMutableArray*)callOverArr{
    self.studentArr = studentArr;
    if (self.callOverArr == nil) {
        self.callOverArr = [NSMutableArray array];
    }
    self.callOverArr = callOverArr;
}
// 根据点名学生更新ui
-(void)setCallOverArr:(NSMutableArray *)callOverArr{
    _callOverArr = callOverArr;
    if (callOverArr.count <= 0) {
        for (UIButton*btn in self.scrollView.subviews) {
            if ([btn isKindOfClass:[HJCallOverBtn class]]) {
                HJCallOverBtn *callBtn = (HJCallOverBtn*)btn;
                [callBtn updateSelfStatus:HJCallOverStatusTypeNone];
                
            }
        }
        return;
    }
    for (HJStudentInfo*stu in _callOverArr) {
        for (UIButton*btn in self.scrollView.subviews) {
            if ([btn isKindOfClass:[HJCallOverBtn class]]) {
                HJCallOverBtn *callBtn = (HJCallOverBtn*)btn;
                if ([stu.studentId isEqualToString:callBtn.studentInfo.studentId]) {
                    [callBtn updateSelfStatus:HJCallOverStatusTypeSelect];
                }
            }
        }
    }
    
}

-(void)setStudentArr:(NSMutableArray *)studentArr{
    _studentArr = studentArr;
    CGFloat widthItem = 177;
    CGFloat heightItem = 100;
    CGFloat leftTopSpac = 10;
    CGFloat spac = 13;
    for (int i = 0; i < self.studentArr.count; i++) {
        HJCallOverBtn *callOverBtn = [[HJCallOverBtn alloc] initWithFrame:CGRectMake(leftTopSpac + widthItem*(i%4) + spac*(i%4), leftTopSpac + leftTopSpac*(i/4) + heightItem*(i/4), widthItem, heightItem)];
        callOverBtn.tag = i;
        HJStudentInfo *studentInfo = self.studentArr[i];
        [callOverBtn addTarget:self action:@selector(tapCallOverItemBtn:) forControlEvents:UIControlEventTouchUpInside];
        [callOverBtn updateBtnUi:studentInfo];
        for (HJStudentInfo *s in self.callOverArr) {
            if ([s.studentId isEqualToString:studentInfo.studentId]) {
                [callOverBtn updateSelfStatus:HJCallOverStatusTypeSelect];
            }
        }
        
        [self.scrollView addSubview:callOverBtn];
        
    }
    HJCallOverBtn *callOverBtn = (HJCallOverBtn*)[self.scrollView viewWithTag:self.studentArr.count - 1];
    
    
    
    UIImage *btnImg = [UIImage imageNamed:@"btn_yinying"];
    UIButton *startClassBtn = [[UIButton alloc] initWithFrame:CGRectMake(215, callOverBtn.frame.origin.y + heightItem + 115, btnImg.size.width,  btnImg.size.height)];
    [startClassBtn setImage:btnImg forState:UIControlStateNormal];
    [startClassBtn addTarget:self action:@selector(tapStartClassClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:startClassBtn.frame];
    CGRect titleFrame = titleLb.frame;
    titleFrame.origin.y =titleFrame.origin.y-5;
    titleLb.frame = titleFrame;
    
    
    titleLb.text = @"开始上课";
    titleLb.textColor = [UIColor whiteColor];
    titleLb.textAlignment = NSTextAlignmentCenter;
    titleLb.font = [UIFont systemFontOfSize:22];
    [titleLb setTintColor:UIColorFromRGB(0xffffff)];
    [self.scrollView addSubview:startClassBtn];
    [self.scrollView addSubview:titleLb];
    
    if (startClassBtn.frame.origin.y + startClassBtn.bounds.size.height > kScreenHeitht) {
        self.scrollView.contentSize = CGSizeMake(kScreenWidth, startClassBtn.frame.origin.y + startClassBtn.bounds.size.height + 100);
    }
}


-(void)tapCallOverItemBtn:(HJCallOverBtn*)sender{
    HJStudentInfo *studentInfo = self.studentArr[sender.tag];
    if ([self.callOverArr containsObject:studentInfo]) {
        [self.callOverArr removeObject:studentInfo];
        [sender updateSelfStatus:HJCallOverStatusTypeNone];
    }else{
        [self.callOverArr addObject:studentInfo];
        [sender updateSelfStatus:HJCallOverStatusTypeSelect];

    }
}


// 点击开始上课
-(void)tapStartClassClick:(UIButton*)sender{
    if (self.startClassTapBlock) {
        self.startClassTapBlock();
    }
    
    // 更新点名状态
    for (HJStudentInfo *studentInfo in self.callOverArr) {
        StudentModel *studentModel = [[LifeBitCoreDataManager shareInstance] efGetStudentDetailedById:studentInfo.studentId];
        studentModel.sIsCallOver = [NSNumber numberWithInt:1];
        [[LifeBitCoreDataManager shareInstance] efAddStudentModel:studentModel];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
