//
//  HJInputTimeScoreView.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/14.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJInputTimeScoreView.h"
@interface HJInputTimeScoreView()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *bg1View;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic,strong)NSString *selectMinuteStr;
@property (nonatomic,strong)NSString *selectSecondsStr;
@property (nonatomic,strong)NSString *selectMillisecondStr;
@end
@implementation HJInputTimeScoreView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(instancetype)createInputTimeScoreViewWithScore:(NSString*)score{
    HJInputTimeScoreView * inputScoreView = [[[NSBundle mainBundle] loadNibNamed:@"HJInputTimeScoreView" owner:nil options:nil] lastObject];
    [inputScoreView initialize];
    if (score.length > 0 && score != nil) {
        inputScoreView.selectMinuteStr = [score substringWithRange:NSMakeRange(0,2)];
        inputScoreView.selectSecondsStr = [score substringWithRange:NSMakeRange(3,2)];
        inputScoreView.selectMillisecondStr = [score substringWithRange:NSMakeRange(6,2)];
    }
    [inputScoreView.pickerView selectRow:[inputScoreView.selectMinuteStr integerValue] inComponent:0 animated:NO];
     [inputScoreView.pickerView selectRow:[inputScoreView.selectSecondsStr integerValue] inComponent:1 animated:NO];
     [inputScoreView.pickerView selectRow:[inputScoreView.selectMillisecondStr integerValue] inComponent:2 animated:NO];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:inputScoreView action:@selector(tapClick:)];
    [inputScoreView.bg1View addGestureRecognizer:tap];
    return inputScoreView;
    return inputScoreView;
}

-(void)tapClick:(UITapGestureRecognizer*)tap{
    [self removeFromSuperview];
}

-(void)initialize{
    self.bgView.layer.cornerRadius = 10;
    self.bgView.layer.masksToBounds = YES;

}

- (IBAction)exitInputClick:(UIButton *)sender{
    [self removeFromSuperview];
}
- (IBAction)queRenInputClick:(UIButton *)sender{
    [self removeFromSuperview];
    if (self.inputTimeScoreSureBlock) {
        self.inputTimeScoreSureBlock(self.selectMinuteStr,self.selectSecondsStr,self.selectMillisecondStr);
    }
    
}

#pragma mark - UIPickerViewDataSource,UIPickerViewDelegate


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 2) {
        return 100;
    }
    return 60;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return self.bgView.bounds.size.width/3;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return [NSString stringWithFormat:@"%02ld",(long)row];
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        self.selectMinuteStr = [NSString stringWithFormat:@"%02ld",(long)row];
    }else if (component == 1){
        self.selectSecondsStr = [NSString stringWithFormat:@"%02ld",(long)row];
    }else if (component == 2){
        self.selectMillisecondStr = [NSString stringWithFormat:@"%02ld",(long)row];
    }
    
}


@end
