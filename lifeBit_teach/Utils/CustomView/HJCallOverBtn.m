//
//  HJCallOverBtn.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/8.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJCallOverBtn.h"

@interface HJCallOverBtn()



@property (nonatomic,strong)UILabel *nameLb;

@property (nonatomic,strong)UILabel *numberLb;

@property (nonatomic,strong)UILabel *sexLb;

@end

@implementation HJCallOverBtn

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
    self.layer.cornerRadius = 5;
    
    self.callOverBtnStatus = HJCallOverStatusTypeNone;
    self.backgroundColor = [UIColor whiteColor];
    
    self.nameLb = [[UILabel alloc] init];
    self.numberLb = [[UILabel alloc] initWithFrame:CGRectZero];
    self.sexLb = [[UILabel alloc] initWithFrame:CGRectZero];
    
    self.nameLb.font = [UIFont systemFontOfSize:16];
    self.numberLb.font = [UIFont systemFontOfSize:16];
    self.sexLb.font = [UIFont systemFontOfSize:16];
    
    self.nameLb.textColor = UIColorFromRGB(0x222222);
    self.numberLb.textColor = UIColorFromRGB(0x222222);
    self.sexLb.textColor = UIColorFromRGB(0x222222);
    
    self.nameLb.textAlignment = NSTextAlignmentCenter;
    self.numberLb.textAlignment = NSTextAlignmentCenter;
    self.sexLb.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.nameLb];
    [self addSubview:self.numberLb];
    [self addSubview:self.sexLb];
    
}

-(void)updateBtnUi:(HJStudentInfo*)studentInfo{
    
    self.studentInfo = studentInfo;
    
    self.numberLb.frame = CGRectMake(10, 10, self.bounds.size.width - 2 * 10, 20);
    self.numberLb.text =  [NSString stringWithFormat:@"学号：%@",studentInfo.studentNo];
    
    self.nameLb.text = [NSString stringWithFormat:@"姓名：%@",studentInfo.studentName];
    
    
    self.nameLb.frame = CGRectMake(self.numberLb.frame.origin.x, self.numberLb.frame.origin.y + self.numberLb.bounds.size.height + 10, self.numberLb.bounds.size.width, self.numberLb.bounds.size.height);
//    self.nameLb.center = CGPointMake(CGRectGetMidX(self.bounds) + 20, CGRectGetMidY(self.bounds));
    
    NSString *sexStr;
    switch ([studentInfo.sSex intValue]) {
        case 2:
            sexStr = @"女";
            break;
        case 1:
            sexStr = @"男";
            break;
            
        default:
            break;
    }
    self.sexLb.text = [NSString stringWithFormat:@"性别：%@",sexStr];
    
    
    [self.sexLb sizeToFit];
    self.sexLb.frame = CGRectMake(self.nameLb.frame.origin.x, self.nameLb.frame.origin.y + self.nameLb.bounds.size.height + 10, self.nameLb.bounds.size.width, self.nameLb.bounds.size.height);
    
}


-(void)updateSelfStatus:(HJCallOverStatusType)callOverBtnStatus{
    self.callOverBtnStatus = callOverBtnStatus;
    switch (callOverBtnStatus) {
        case HJCallOverStatusTypeNone:
        {
            self.nameLb.textColor = UIColorFromRGB(0x222222);
            self.numberLb.textColor = UIColorFromRGB(0x222222);
            self.sexLb.textColor = UIColorFromRGB(0x222222);
            [self setBackgroundColor:[UIColor whiteColor]];
        }
            break;
        case HJCallOverStatusTypeSelect:
        {
            self.nameLb.textColor = UIColorFromRGB(0xffffff);
            self.numberLb.textColor = UIColorFromRGB(0xffffff);
            self.sexLb.textColor = UIColorFromRGB(0xffffff);
            [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"color_nav"]]];
        }
            break;
            
        default:
            break;
    }
}


-(void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
