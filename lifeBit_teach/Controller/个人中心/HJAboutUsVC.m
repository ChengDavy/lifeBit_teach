//
//  HJAboutUsVC.m
//  lifeBit_teach
//
//  Created by WilliamYan on 16/9/11.
//  Copyright © 2016年 WilliamYan. All rights reserved.
//

#import "HJAboutUsVC.h"
#import "APPIdentificationManage.h"

@interface HJAboutUsVC ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation HJAboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)initialize{
    //设置navi字体颜色
    [self setNavigationBarTitleTextColor:@"关于我们"];
    self.webView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor grayColor];
    
    NSString *urlStr = @"http://118.178.16.180/jk/index.html";  //悦点反台
    
//    NSString *urlStr = @"http://10.42.46.155:8080/jk/index.html";  //科技学校

    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
