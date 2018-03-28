//
//  JRCusClassVC.m
//  lifeBit_teach
//
//  Created by joyskim-ios1 on 16/9/7.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "JRCusClassVC.h"
#import "JRChangeTeachPlanVC.h"
#import "AppDelegate.h"
#import "HJNumberView.h"

@interface JRCusClassVC ()

@property (nonatomic,strong)HJClassInfo *classInfo;
@property (weak, nonatomic) IBOutlet UITextField *gradsTF;

@property (nonatomic,strong)NSMutableArray *greadArr;
@property (weak, nonatomic) IBOutlet UITextField *timeTF;

@end

@implementation JRCusClassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置naviTitle字体文字和颜色
    [self setNavigationBarTitleTextColor:@"自定义课程"];

    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{

}


-(void)initialize{
    self.greadArr = [[HJAppObject sharedInstance] getSchoolAllGreadMsg];
    
    HJNumberView *numberView = [HJNumberView createNumberView];
    self.timeTF.inputView = numberView;
    __weak JRCusClassVC *weakSelf = self;
    [numberView setTapKeyboardClick:^(NSInteger tap,NSString* contentStr) {
        switch (tap) {
                
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
            case 10:{
                if ([weakSelf.timeTF.text doubleValue] > 0) {
                    
                    NSString *numberStr = [NSString stringWithFormat:@"%@%@",weakSelf.timeTF.text,contentStr];
                    weakSelf.timeTF.text = [NSString stringWithFormat:@"%d",[numberStr intValue]];
                    
                }else{
                    if (tap == 10) {
                        if(weakSelf.timeTF.text.length > 0 && weakSelf.timeTF.text.intValue > 0)//_roaldSearchText
                        {
                            NSLog(@"yes");
                            NSString *timeStr = [NSString stringWithFormat:@"%@%@",weakSelf.timeTF.text,contentStr];
                            weakSelf.timeTF.text = [NSString stringWithFormat:@"%d",[timeStr intValue]];
                        }
                        else
                        {
                            NSLog(@"no");
                            weakSelf.timeTF.text = contentStr;
                        }
                    }else{
                        
                        NSString *timeStr = [NSString stringWithFormat:@"%@%@",weakSelf.timeTF.text,contentStr];
                        weakSelf.timeTF.text = [NSString stringWithFormat:@"%d",[timeStr intValue]];
                    }
                    
                }
                
            }
                break;
            case 11:{
                weakSelf.timeTF.text = @"";
            }break;
                
            default:
                break;
        }
    }];

}

-(HJClassInfo *)classInfo{
    if (_classInfo == nil) {
        _classInfo = [[HJClassInfo alloc] init];
    }
    return _classInfo;
}


- (IBAction)clickSetLessonPlanItem:(UIButton *)sender {
    NSLog(@"先创建课程");
    if (self.gradsTF.text <= 0) {
        [self showErroAlertWithTitleStr:@"请选择上课年级"];
        return;
    }
    if (self.timeTF.text.length <= 0) {
        [self showErroAlertWithTitleStr:@"请输入上课时间长"];
        return;
        
    }
    
    if ([self.timeTF.text intValue] > 256) {
        [self showErroAlertWithTitleStr:@"您输入的上课时间过长"];
        return;
    }
    
    self.classInfo.cClassTime = [NSNumber numberWithInt:[self.timeTF.text intValue]];
    JRChangeTeachPlanVC *changeTeachPlanVC = [[JRChangeTeachPlanVC alloc] init];
    changeTeachPlanVC.lessonPlanType = JRLessonPlanShowTypeNoneClass;
    changeTeachPlanVC.classInfo = self.classInfo;
    [self pushHiddenTabBar:changeTeachPlanVC];
}

- (IBAction)clickSelectGreadItem:(UIButton *)sender {
    if (self.greadArr.count <= 0) {
        [self showErroAlertWithTitleStr:@"没有更新到年级信息"];
        return;
    }
    HJLinkagePickerView *pickerView = [HJLinkagePickerView createSelectPickerWithDataSource:self.greadArr andWithTitle:@"选择班级" WithType:HJLinkagePickerTypeGread] ;
    __weak typeof(self) weakSelf = self;
    
    [pickerView setSelectPickerBlock:^(NSInteger comperOne,NSInteger comerTwo) {
        HJGreadInfo *greadInfo =  [weakSelf.greadArr objectAtIndexWithSafety:comperOne];
        HJSubClassInfo *subClassInfo = [greadInfo.gClassArr objectAtIndexWithSafety:comerTwo];
        NSLog(@"选中年级名称 ＝ %@   班级名称%@ ",greadInfo.gGreadName,subClassInfo.sClassName);
        weakSelf.classInfo.cGradeId = greadInfo.gGreadID;
        weakSelf.classInfo.cGradeName = greadInfo.gGreadName;
        weakSelf.classInfo.cClassId = subClassInfo.sClassID;
        weakSelf.classInfo.cClassName = subClassInfo.sClassName;
        weakSelf.classInfo.cMaxRate = subClassInfo.sMax_Rate;
        weakSelf.classInfo.cMinRate = subClassInfo.sMin_Rate;
        weakSelf.gradsTF.text = [NSString stringWithFormat:@"%@%@",greadInfo.gGreadName,subClassInfo.sClassName];
    }];
    
    NSLog(@"%f  %f",pickerView.frame.size.width,pickerView.frame.size.height);
    
    [UIView animateWithDuration:0.9 animations:^{
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:pickerView];
    }];
}

@end
