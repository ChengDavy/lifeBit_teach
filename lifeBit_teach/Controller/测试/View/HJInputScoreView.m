//
//  HJInputScoreView.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/6.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJInputScoreView.h"
#import "HJNumberKeyBoardView.h"
@interface HJInputScoreView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *bg1View;

@property (weak, nonatomic) IBOutlet UITextField *inputTF;

@property (weak, nonatomic) IBOutlet UILabel *exitBtn;


@property (weak, nonatomic) IBOutlet UILabel *queDingBtn;
@end

@implementation HJInputScoreView
-(void)dealloc{
    NSLog(@"HJInputScoreView 释放了");
}
+(instancetype)createInputScoreViewWithScore:(NSString *)score{
    HJInputScoreView * inputScoreView = [[[NSBundle mainBundle] loadNibNamed:@"HJInputScoreView" owner:nil options:nil] lastObject];
    [inputScoreView initialize];
    if (score.length > 0 && score != nil) {
        inputScoreView.inputTF.text = score;
    }
    
    HJNumberKeyBoardView *numberKeyBoardView = [HJNumberKeyBoardView createNumberKeyBoardView];
    inputScoreView.inputTF.inputView = numberKeyBoardView;
    __weak HJInputScoreView *weakSelf = inputScoreView;
    [numberKeyBoardView setTapKeyboardItemBlock:^(NSInteger tap, NSString *contentStr) {
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
                if ([weakSelf.inputTF.text doubleValue] > 0) {
                    if([weakSelf.inputTF.text rangeOfString:@"."].location !=NSNotFound)//_roaldSearchText
                    {
                        
                        NSString *numberStr = [NSString stringWithFormat:@"%@%@",weakSelf.inputTF.text,contentStr];
                        weakSelf.inputTF.text = numberStr;
                        NSLog(@"yes");
                    }
                    else
                    {
                        
                        NSString *numberStr = [NSString stringWithFormat:@"%@%@",weakSelf.inputTF.text,contentStr];
                        
//                        NSRange range = [numberStr rangeOfString:@"ccd"];
//                        if (range.location != NSNotFound) {
//                            NSLog(@"found at location = %lu, length = %lu",(unsigned long)range.location,(unsigned long)range.length);
////                            NSString *ok = [numberStr substringFromIndex:range.location];
////                            NSLog(@"%@",ok);
//                            int location = range.location;
//                            
//                        }else{
//                            NSLog(@"Not Found");  
//                        }
                        
                        weakSelf.inputTF.text = numberStr;
                        NSLog(@"no");
                    }
                    
                }else{
                    if (tap == 10) {
                        if([weakSelf.inputTF.text rangeOfString:@"."].location !=NSNotFound)//_roaldSearchText
                        {
                            NSLog(@"yes");
                            NSString *numberStr = [NSString stringWithFormat:@"%@%@",weakSelf.inputTF.text,contentStr];
                            weakSelf.inputTF.text = [NSString stringWithFormat:@"%d",[numberStr intValue]];
                        }
                        else
                        {
                            NSLog(@"no");
                            weakSelf.inputTF.text = [NSString stringWithFormat:@"%@%@",weakSelf.inputTF.text,contentStr];
                        }
                    }else{
                    
                         NSString *numberStr  = [NSString stringWithFormat:@"%@%@",weakSelf.inputTF.text,contentStr];
                        if([weakSelf.inputTF.text rangeOfString:@"."].location !=NSNotFound)//_roaldSearchText
                        {
                            weakSelf.inputTF.text = numberStr;
                        }
                        else
                        {
                            if ([weakSelf.inputTF.text floatValue] > 0.0) {
                                weakSelf.inputTF.text = numberStr;
                            }else{
                                weakSelf.inputTF.text = [NSString stringWithFormat:@"%d",[numberStr intValue]];
                            }
                        }
                        
                        
                    }
                    
                }
                
            }
                break;
            case 11:{
                if([weakSelf.inputTF.text rangeOfString:@"."].location !=NSNotFound)//_roaldSearchText
                {
                    NSLog(@"yes");
                    
                }
                else
                {
                    if (weakSelf.inputTF.text.length <= 0) {
                        
                    }else{
                        NSLog(@"no");
                        NSString *numberStr = [NSString stringWithFormat:@"%@%@",weakSelf.inputTF.text,contentStr];
                        weakSelf.inputTF.text = numberStr;
                    }
                    
                }
            }break;
            case 12:{
                   weakSelf.inputTF.text = @"";
            }break;
                
            default:
                break;
        }
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:inputScoreView action:@selector(tapClick:)];
    [inputScoreView.bg1View addGestureRecognizer:tap];
    return inputScoreView;
}



-(void)tapClick:(UITapGestureRecognizer*)tap{
    [self removeFromSuperview];
}
-(void)initialize{
    self.bgView.layer.cornerRadius = 10;
    self.bgView.layer.masksToBounds = YES;
    
    [self.inputTF becomeFirstResponder];
}

- (IBAction)exitInputClick:(UIButton *)sender {
    if (self.inputTF.isFirstResponder) {
        [self.inputTF resignFirstResponder];
    }
    [self removeFromSuperview];
    
}

- (IBAction)queRenInputClick:(UIButton *)sender {
    if (self.inputTF.text.length <= 0) {
       UIAlertView*alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入成绩" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    if (self.inputTF.isFirstResponder) {
        [self.inputTF resignFirstResponder];
    }
    
    if (self.inputScoreSureBlock) {
        self.inputScoreSureBlock(self.inputTF.text);
    }
    [self removeFromSuperview];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}



@end
