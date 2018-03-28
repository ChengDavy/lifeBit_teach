//
//  HJLinkagePickerView.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/22.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJLinkagePickerView.h"
@interface HJLinkagePickerView()

@property (weak, nonatomic) IBOutlet UILabel *pickerTitleLb;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic,strong)NSMutableArray *pickerDataArr;

@property (nonatomic,assign)HJLinkagePickerType LinkagePickerType;

@property (nonatomic,strong)NSString *titleStr;

// 默认选中的对象
@property (nonatomic,strong)id selectObj;

// 默认选择的第一列的行
@property (nonatomic,assign)NSInteger selectIndex;
@property (weak, nonatomic) IBOutlet UIView *bg1View;

// 默认选中的第二列的行
@property (nonatomic,assign)NSInteger selectRow;

@property (nonatomic,strong)NSMutableArray *objArr;

@property (nonatomic,strong)NSMutableArray *subObjArr;


@end
@implementation HJLinkagePickerView
+(instancetype)createSelectPickerWithDataSource:(NSMutableArray*)dataSource  andWithTitle:(NSString*)title WithType:(HJLinkagePickerType)type{
    HJLinkagePickerView *pickerView = [[[NSBundle mainBundle] loadNibNamed:@"HJLinkagePickerView" owner:nil options:nil] firstObject];
    if (![pickerView isKindOfClass:[HJLinkagePickerView class]] ) {
        pickerView = [[[NSBundle mainBundle] loadNibNamed:@"HJLinkagePickerView" owner:nil options:nil] lastObject];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:pickerView action:@selector(tapClick:)];
    [pickerView.bg1View addGestureRecognizer:tap];
    pickerView.pickerDataArr = dataSource;
    pickerView.LinkagePickerType = type;
    pickerView.titleStr = title;
    [pickerView initialize];
    pickerView.frame = CGRectMake(0, 0, 768, 1024);
    
    return pickerView;
}

-(void)initialize{
    self.pickerTitleLb.text = self.titleStr;
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.masksToBounds = YES;
    self.selectIndex = 0;
    self.selectRow = 0;
    switch (self.LinkagePickerType) {
        case HJLinkagePickerTypeGread:
        {
            HJGreadInfo *greadInfo = [self.pickerDataArr objectAtIndexWithSafety:self.selectIndex];
            self.subObjArr = greadInfo.gClassArr;
            

        }
            break;
        case HJLinkagePickerTypeLessonType:
        {
            HJProjectInfo *projectInfo = [self.pickerDataArr objectAtIndexWithSafety:self.selectIndex];
            self.subObjArr = projectInfo.pSubProjectArr;
        }
            break;
            
        default:
            break;
    }
}

-(void)tapClick:(UITapGestureRecognizer*)tap{
    [self removeFromSuperview];
}

- (IBAction)confirmSelectClick:(UIButton *)sender {
    if (self.selectPickerBlock) {
        self.selectPickerBlock(self.selectIndex,self.selectRow);
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
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (self.LinkagePickerType) {
        case HJLinkagePickerTypeGread:
        {
            
            if (component == 0) {
                return self.pickerDataArr.count;
            }else if (component == 1){
        
                return self.subObjArr.count;
            }
        }
            break;
        case HJLinkagePickerTypeLessonType:
        {
            if (component == 0) {
                return self.pickerDataArr.count;
            }else if (component == 1){
                return self.subObjArr.count;
            }
        }
            break;
            
        default:
            break;
    }
    
    return 0;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return self.bgView.bounds.size.width/2;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (self.LinkagePickerType) {
        case HJLinkagePickerTypeGread:
        {
            
            if (component == 0) {
                HJGreadInfo *greadInfo = [self.pickerDataArr objectAtIndexWithSafety:row];
                return greadInfo.gGreadName;
            }else if (component == 1){
                HJSubClassInfo *subClassInfo = [self.subObjArr objectAtIndexWithSafety:row];
                return subClassInfo.sClassName;
            }
        }
            break;
        case HJLinkagePickerTypeLessonType:
        {
            HJProjectInfo *projectInfo = [self.pickerDataArr objectAtIndexWithSafety:row];
            if (component == 0) {
                return projectInfo.pProjectName;
            }else if (component == 1){
                HJSubProjectInfo *subProjectInfo = [self.subObjArr objectAtIndexWithSafety:row];
                return subProjectInfo.sName;
            }
        }
            break;
            
        default:
            break;
    }
    return nil;
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (self.LinkagePickerType) {
        case HJLinkagePickerTypeGread:
        {
            if (component == 0) {
                self.selectIndex = row;
                HJGreadInfo *greadInfo = [self.pickerDataArr objectAtIndexWithSafety:self.selectIndex];
                self.subObjArr = greadInfo.gClassArr;
                
                [pickerView reloadComponent:1];
            }else{
                self.selectRow = row;
                
            }
        }
            break;
        case HJLinkagePickerTypeLessonType:
        {
            if (component == 0) {
                self.selectIndex = row;
                HJProjectInfo *projectInfo = [self.pickerDataArr objectAtIndexWithSafety:self.selectIndex];
                self.subObjArr = projectInfo.pSubProjectArr;
                [pickerView reloadComponent:1];
            }else{
                self.selectRow = row;
                            }

        }
            break;
            
        default:
            break;
    }
 
}




@end
