//
//  JRNameButten.m
//  lifeBit_teach
//
//  Created by joyskim-ios1 on 16/9/8.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "JRNameButten.h"
@interface JRNameButten()
// 年级名称
@property (nonatomic,strong)UILabel *greadLb;
// 班级名称
@property (nonatomic,strong)UILabel *classLb;

// 班级状态
@property (nonatomic,strong)UILabel *statusLb;

@end

@implementation JRNameButten


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

/**
 *  有边框的按钮
 */
-(void)initialze{
    self.classStatusType = JRClsssStatusTypeNone;
    
    self.greadLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 10,( kScreenWidth - 15 * 2)/6, 16)];
    self.greadLb.font = [UIFont systemFontOfSize:16];
    self.greadLb.textAlignment = NSTextAlignmentCenter;
    self.greadLb.textColor = UIColorFromRGB(0xF3406D);
   // self.greadLb.backgroundColor = [UIColor redColor];
    [self addSubview:self.greadLb];
    
    self.classLb = [[UILabel alloc] initWithFrame:CGRectMake(0, self.greadLb.frame.origin.y + self.greadLb.bounds.size.height , ( kScreenWidth - 15 * 2)/6, 16)];
    self.classLb.font = [UIFont systemFontOfSize:16];
    self.classLb.textAlignment = NSTextAlignmentCenter;
    self.classLb.textColor = UIColorFromRGB(0xF3406D);
   // self.classLb.backgroundColor = [UIColor grayColor];
    [self addSubview:self.classLb];
    
    
    
    self.statusLb = [[UILabel alloc] initWithFrame:CGRectMake(0, self.classLb.frame.origin.y + self.classLb.bounds.size.height + 5, 70, 15)];
    self.statusLb.textAlignment = NSTextAlignmentCenter;
    self.statusLb.font = [UIFont systemFontOfSize:14];
    self.statusLb.layer.cornerRadius = 2;
    self.statusLb.layer.masksToBounds = YES;
  //  self.statusLb.backgroundColor = [UIColor blueColor];
    self.statusLb.textColor = [UIColor whiteColor];
//    self.statusLb.backgroundColor = UIColorFromRGB(0xF3406D);
    
    CGPoint pointCenter = self.statusLb.center;
    pointCenter.x = self.classLb.center.x;
    self.statusLb.center = pointCenter;
    
    [self addSubview:self.statusLb];

    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithRed:90.0/255.0 green:145.0/255.0 blue:226.0/255.0 alpha:1].CGColor;
}

-(void)alertClassMessageWithClassName:(HJClassInfo*)classInfo  andClassType:(JRClsssStatusType)type{
    self.classDataInfo = classInfo;
    self.greadStr = [NSString stringWithFormat:@"%@",classInfo.cGradeName];
    self.classStr = [NSString stringWithFormat:@"%@",classInfo.cClassName];
    self.classStatusType = type;
}

-(void)setClassStatusType:(JRClsssStatusType)classStatusType{
    _classStatusType = classStatusType;
    switch (_classStatusType) {
        case JRClsssStatusTypeUndefined:{
            self.greadLb.text = self.greadStr;
            self.greadLb.textColor = UIColorFromRGB(0xF3406D);
            self.classLb.text = self.classStr;
            self.statusLb.text = @"设置教案";
            self.classLb.textColor = UIColorFromRGB(0xF3406D);
            self.statusLb.backgroundColor = UIColorFromRGB(0xF3406D);
        }
            break;
        case JRClsssStatusTypeReady:{
            self.greadLb.text = self.greadStr;
            self.greadLb.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color_nav"]];
            self.classLb.text = self.classStr;
            self.statusLb.text = @"准备上课";
            self.classLb.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color_nav"]];
            self.statusLb.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color_nav"]];
        }
            break;
        case JRClsssStatusTypeNamedClasses:
//        {
//            self.classLb.text = self.classStr;
//            self.statusLb.text = @"上课点名";
//            self.classLb.textColor = UIColorFromRGB(0xfa932a);
//            self.statusLb.backgroundColor = UIColorFromRGB(0xfa932a);
//        }
//            break;
        case JRClsssStatusTypeInClass:{
            self.greadLb.text = self.greadStr;
            self.greadLb.textColor =  UIColorFromRGB(0xfa932a);
            self.classLb.text = self.classStr;
            self.statusLb.text = @"上课中";
            self.classLb.textColor = UIColorFromRGB(0xfa932a);
            self.statusLb.backgroundColor = UIColorFromRGB(0xfa932a);
        }
            break;
            
        default:
            break;
    }
}


@end
