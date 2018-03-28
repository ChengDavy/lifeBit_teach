//
//  HJTestStudentCell.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/6.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJTestStudentCell.h"


@interface HJTestStudentCell()
@property (weak, nonatomic) IBOutlet UIButton *selectStudentBtn;

@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *sexLb;

@property (weak, nonatomic) IBOutlet UIButton *addScoreBtn;

@property (weak, nonatomic) IBOutlet UIView *scoreBgView;

// 成绩数组
@property (nonatomic,strong)NSMutableArray *scoreArr;


@property (nonatomic,strong)HJStudentInfo *student;
@end

@implementation HJTestStudentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)updateSelfUi:(HJStudentInfo*)studentInfo{
    self.student = studentInfo;
    self.addScoreBtn.layer.cornerRadius = 5;
    self.addScoreBtn.layer.masksToBounds = YES;
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
// 选择学生
- (IBAction)selectStudentClick:(id)sender {
    if (self.selectOrExitStudentBlock) {
        self.selectOrExitStudentBlock(self,self.student,sender);
    }
}
// 添加成绩
- (IBAction)addScoreClick:(id)sender {
    if (self.scoreArr.count >= 5) {
        NSString *msgStr = [NSString stringWithFormat:@"%@同学不能添加新成绩",self.student.studentName];
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"温馨提示" message:msgStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    if (self.inputStudentScoreBlock) {
        self.inputStudentScoreBlock(self,self.student);
    }
}
// 将按钮设置为选中状态
-(void)setSelectStudentClick{
    [self.selectStudentBtn setImage:[UIImage imageNamed:@"testSelect_kuang"] forState:UIControlStateNormal];
}

// 添加成绩
-(void)addStudentScoreWithScore:(NSString*)score{
    if (self.scoreArr == nil) {
        self.scoreArr = [NSMutableArray array];
    }
    [self.scoreArr addObject:score];
    [self.student.sScoreArr addObject:score];
    for (UIButton *btn in self.scoreBgView.subviews) {
        [btn removeFromSuperview];
    }
    
    CGFloat scoreItemWidth = 68;
    CGFloat scoreItemHeight = 22;
    CGFloat scoreItemY = self.scoreBgView.bounds.size.height/2 - scoreItemHeight/2;
    CGFloat itemSpacing = 10;
    for (int i = 0; i < self.scoreArr.count; i++) {
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

// 修改成绩
-(void)alertStudentScoreWithScore:(NSString*)score andIndex:(NSInteger)index{
    if (self.scoreArr == nil) {
        self.scoreArr = [NSMutableArray array];
    }
    [self.scoreArr replaceObjectAtIndex:index withObject:score];
    [self.student.sScoreArr replaceObjectAtIndex:index withObject:score];
    for (UIButton *btn in self.scoreBgView.subviews) {
        [btn removeFromSuperview];
    }
    
    CGFloat scoreItemWidth = 68;
    CGFloat scoreItemHeight = 22;
    CGFloat scoreItemY = self.scoreBgView.bounds.size.height/2 - scoreItemHeight/2;
    CGFloat itemSpacing = 10;
    for (int i = 0; i < self.scoreArr.count; i++) {
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

-(void)tapScoreClick:(UIButton*)sender{
    NSLog(@"点击了第几个分数%ld",sender.tag);
    NSString *scoreStr = self.scoreArr[sender.tag];
    if (self.tapAlertScoreBlock) {
        self.tapAlertScoreBlock(scoreStr,self.student,sender.tag);
    }
}


@end
