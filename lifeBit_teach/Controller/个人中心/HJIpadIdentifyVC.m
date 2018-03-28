//
//  HJIpadIdentifyVC.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/26.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJIpadIdentifyVC.h"

@interface HJIpadIdentifyVC ()

@property (weak, nonatomic) IBOutlet UILabel *ipadLb;
@end

@implementation HJIpadIdentifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)initialize{
    [self setNavigationBarTitleTextColor:@"设备识别码"];
    NSString *ipadStr = [[APPIdentificationManage shareInstance] readUDID];
    
    NSLog(@"%@",ipadStr);
    
    self.ipadLb.text = ipadStr;
}
- (IBAction)copy:(id)sender {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.ipadLb.text;
    [self showSuccessAlertWithTitleStr:@"已复制到,粘贴板"];
    
}


-(void)naviBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
