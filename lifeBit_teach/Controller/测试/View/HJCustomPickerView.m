//
//  HJCustomPickerView.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/7.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJCustomPickerView.h"
@interface HJCustomPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>{
    
}
@property (weak, nonatomic) IBOutlet UILabel *pickerTitleLb;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *bg1View;
@property (nonatomic,strong)NSMutableArray *pickerDataArr;

@property (nonatomic,strong)NSString *titleStr;

@property (nonatomic,strong)NSString *selectStr;

@property (nonatomic,assign)NSInteger selectIndex;
@end
@implementation HJCustomPickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(instancetype)createSelectPickerWithDataSource:(NSMutableArray*)dataSource andWithTitle:(NSString*)title{
    HJCustomPickerView *pickerView = [[[NSBundle mainBundle] loadNibNamed:@"HJCustomPickerView" owner:nil options:nil] firstObject];
    if (![pickerView isKindOfClass:[HJCustomPickerView class]] ) {
        pickerView = [[[NSBundle mainBundle] loadNibNamed:@"HJCustomPickerView" owner:nil options:nil] lastObject];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:pickerView action:@selector(tapClick:)];
    [pickerView.bg1View addGestureRecognizer:tap];
    pickerView.pickerDataArr = dataSource;
    pickerView.titleStr = title;
    [pickerView initialize];
    return pickerView;
}
-(void)tapClick:(UITapGestureRecognizer*)tap{
    [self removeFromSuperview];
}

-(void)initialize{
    self.pickerTitleLb.text = self.titleStr;
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.masksToBounds = YES;
    self.selectIndex = 0;
    self.selectStr = [self.pickerDataArr objectAtIndexWithSafety:self.selectIndex];
}

- (IBAction)confirmSelectClick:(UIButton *)sender {
    if (self.selectPickerBlock) {
        self.selectPickerBlock(self.selectStr,self.selectIndex);
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self removeFromSuperview];
    }];
}

- (IBAction)canceSelectClick:(UIButton *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        [self removeFromSuperview];
    }];

}


#pragma mark - UIPickerViewDataSource,UIPickerViewDelegate


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.pickerDataArr.count;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 300;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.pickerDataArr objectAtIndexWithSafety:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.selectStr = [self.pickerDataArr objectAtIndexWithSafety:row];
    self.selectIndex = row;
}

@end
