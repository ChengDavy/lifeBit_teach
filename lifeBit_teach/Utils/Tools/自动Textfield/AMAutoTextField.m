//
//  AMAutoTextField.m
//  AMToolsDemo
//
//  Created by Aimi on 15/9/22.
//  Copyright (c) 2015年 Aimi. All rights reserved.
//

#import "AMAutoTextField.h"
#import "UIViewController+AMAutoKeyBoardVC.h"


@interface AMAutoTextField()
@property(nonatomic)CGRect keyboradFrame;
@end


@implementation AMAutoTextField
#pragma mark  -----------view的初始化------------
-(instancetype)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize{
//    self.delegate = self;
    [self addKeyBoardNotification];
    [self addTarget:self action:@selector(editDidEnd) forControlEvents:UIControlEventEditingDidEnd];
}



-(void)editDidEnd{
    UIViewController* currentVC = [self myViewController];
    [currentVC.view endEditing:YES];
}

-(void)upKeyboard:(NSNotification*)notification{
    
    if (self.isFirstResponder) {
        CGRect keyboardFrame = [notification.userInfo [UIKeyboardFrameEndUserInfoKey] CGRectValue];
        UIViewController* currentVC = [self myViewController];

        [self upViewWithKeyBoardFrame:keyboardFrame];
        
        if (!currentVC.amKeyboardTapGR) {
            [currentVC addAmAutoKeyBoardTapGR];
        }
//        NSLog(@"当前屏幕的布局  %d", [self myViewController].extendedLayoutIncludesOpaqueBars);
//        NSLog(@"调用了upKeyBoard方法");
    }
}

-(void)downKeyboard:(NSNotification*)notification{
    if (self.isFirstResponder) {
        [self resetView];
    }
}



-(void)upViewWithKeyBoardFrame:(CGRect)keyboardFrame{
    CGRect textFieldFrame = [self rectInWindow];
    CGFloat windowHeight = [UIScreen mainScreen].bounds.size.height;
     UIViewController* currentVC = [self myViewController];
    
    if (!currentVC.amKeyboardOffSetY) {
        currentVC.amKeyboardOffSetY = [NSNumber numberWithFloat:currentVC.view.frame.origin.y];
    }
    
    
    CGFloat offSetY = [currentVC.amKeyboardOffSetY floatValue];

    CGRect frame = currentVC.view.frame;
    CGFloat moveY = textFieldFrame.origin.y+textFieldFrame.size.height+kKeyboardEdge - (windowHeight - keyboardFrame.size.height);
    
    frame.origin.y -= moveY;
    
    if (frame.origin.y >= offSetY) {
        frame.origin.y = offSetY;
    }
    currentVC.view.frame = frame;
}


-(void)resetView{
    UIViewController* currentVC = [self myViewController];
    CGRect frame = currentVC.view.frame;
    
   CGFloat offSetY = [currentVC.amKeyboardOffSetY floatValue];
    
    frame.origin.y = offSetY;
    currentVC.view.frame = frame;
    
    [currentVC.view removeGestureRecognizer:currentVC.amKeyboardTapGR];
    currentVC.amKeyboardTapGR = nil;
}


-(CGRect)rectInWindow{
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    return [self convertRect: self.bounds toView:window];
}


- (UIViewController*)myViewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController
                                          class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


-(void)addKeyBoardNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downKeyboard:) name:UIKeyboardWillHideNotification object:nil];
}


-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


-(void)dealloc{
    [self removeNotification];
}

/*
// Only override drawRect: if you perform cust om drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
