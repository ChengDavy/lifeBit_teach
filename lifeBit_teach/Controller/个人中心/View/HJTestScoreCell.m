//
//  HJTestScoreCell.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/18.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJTestScoreCell.h"
@interface HJTestScoreCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *sexLb;
@property (weak, nonatomic) IBOutlet UIView *scoreBgView;
// 成绩数组
@property (nonatomic,strong)NSMutableArray *scoreArr;
@end
@implementation HJTestScoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateSelfUi:(HJStudentInfo*)studentInfo{
    self.sexLb.layer.cornerRadius = 3;
    self.sexLb.layer.masksToBounds = YES;
    NSString *sexStr = studentInfo.sSex;
    if ([sexStr intValue] == 1) {
        self.sexLb.text = @"男";
        self.sexLb.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color_nav"]];
    }else{
        self.sexLb.text = @"女";
        self.sexLb.backgroundColor = UIColorFromRGB(0xF3406D);
    }
    self.nameLb.text = studentInfo.studentName;
    self.scoreArr = [studentInfo.sScoreArr mutableCopy];
}

-(void)setScoreArr:(NSMutableArray *)scoreArr{
    _scoreArr = scoreArr;
    CGFloat scoreItemWidth = 68;
    CGFloat scoreItemHeight = 22;
    CGFloat scoreItemY = self.scoreBgView.bounds.size.height/2 - scoreItemHeight/2;
    CGFloat itemSpacing = 10;
    for (int i = 0; i < _scoreArr.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*scoreItemWidth + itemSpacing*i, scoreItemY, scoreItemWidth, scoreItemHeight)];
        btn.layer.cornerRadius = 3;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"color_nav"]].CGColor;
        btn.layer.borderWidth = 1;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = i;
        
        NSString *scoreStr = self.scoreArr[i];
        [btn setTitleColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"color_nav"]] forState:UIControlStateNormal];
        [btn setTitle:scoreStr forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(tapScoreClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scoreBgView addSubview:btn];
    }
}
-(void)tapScoreClick:(UIButton*)tapBtn{
    
}


@end
