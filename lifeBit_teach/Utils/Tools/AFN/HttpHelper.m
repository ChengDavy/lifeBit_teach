//
//  HttpHelper.m
//  testCocoaPods
//
//  Created by Aimi on 16/8/15.
//  Copyright © 2016年 joyskim. All rights reserved.
//

#import "HttpHelper.h"

#define HHLog(fmt, ...) NSLog((@"[HttpHelper Log]  "fmt), ##__VA_ARGS__);
//#define HHLog(...);

@implementation HttpHelper

static HttpHelper *_JSONRequestManager;
static HttpHelper *_HTTPRequestManager;

+(HttpHelper *)JSONRequestManager{
    if (!_JSONRequestManager) {
        _JSONRequestManager = [[HttpHelper alloc]init];
        _JSONRequestManager.isNetWork = NO;
        _JSONRequestManager.manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseURL]];
        _JSONRequestManager.manager.requestSerializer = [AFJSONRequestSerializer serializer];
//        [_JSONRequestManager.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        _JSONRequestManager.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/plain",nil];
//        _JSONRequestManager.manager.requestSerializer.timeoutInterval = 10;
//        [_JSONRequestManager.manager.requestSerializer setValue:nil forHTTPHeaderField:@"x-auth-token"];
    }

    return _JSONRequestManager;
}

+(HttpHelper *)HTTPRequestManager{
    if (!_HTTPRequestManager) {
        _HTTPRequestManager = [[HttpHelper alloc]init];
        _JSONRequestManager.isNetWork = NO;
        _HTTPRequestManager.manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kCommonBaseURL]];
        
        _HTTPRequestManager.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _HTTPRequestManager.manager.requestSerializer.timeoutInterval = 10;
        
    }
    
    return _HTTPRequestManager;
}

-(AFNetworkReachabilityManager *)netWorkStatusManager{
    if (_netWorkStatusManager == nil) {
        _netWorkStatusManager = [AFNetworkReachabilityManager sharedManager];
    }
    return _netWorkStatusManager;
}

-(void)startNetWorkStatus{
//    __block typeof(BOOL) isNetWork = self.isNetWork;
    __weak typeof(self) weakSelf = self;
    [self.netWorkStatusManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        // 当网络状态发生改变的时候调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                weakSelf.isNetWork = YES;
                
                if (weakSelf.networkStatusChangeBlock) {
                    weakSelf.networkStatusChangeBlock();
                }
                
                NSLog(@"WIFI");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                weakSelf.isNetWork = YES;
                NSLog(@"自带网络");
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                weakSelf.isNetWork = NO;
                NSLog(@"没有网络");
                break;
                
            case AFNetworkReachabilityStatusUnknown:
                weakSelf.isNetWork = NO;
                NSLog(@"未知网络");
                break;
            default:
                break;
        }
    }];
    // 开始监控
    [self.netWorkStatusManager startMonitoring];
    
}

- (void)POST:(NSString *)post parameters:(id)parameters success:(HTTPSuccessBlock)success failure:(HTTPFailureBlock)failure{

    //设置https的自验证书
//    [self stepSesecurityPolicy];
    
    [self.manager POST:post parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!success) return;
        
        //若返回的数据为data类型,则解析为Json类型
        if ([responseObject isKindOfClass:[NSData class]]) {
             id res = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            HHLog(@"接口名:%@ \n入参项:%@\n出参项:%@",post,parameters,res);
            success(task,res);
            return;
        }
        HHLog(@"接口名:%@ \n入参项:%@\n出参项:%@",post,parameters,responseObject);
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (!failure) return;
        
         HHLog(@"请求失败\n接口名:%@ \n入参项:%@\nerror:%@",post,parameters,error);
        failure(task,error);
    }];
}


//设置https的自验证书
-(void)stepSesecurityPolicy{
    AFSecurityPolicy * securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    //如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO
    //主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    securityPolicy.validatesDomainName = NO;
    //validatesCertificateChain 是否验证整个证书链，默认为YES
    //设置为YES，会将服务器返回的Trust Object上的证书链与本地导入的证书进行对比，这就意味着，假如你的证书链是这样的：
    //GeoTrust Global CA
    //    Google Internet Authority G2
    //        *.google.com
    //那么，除了导入*.google.com之外，还需要导入证书链上所有的CA证书（GeoTrust Global CA, Google Internet Authority G2）；
    //如是自建证书的时候，可以设置为YES，增强安全性；假如是信任的CA所签发的证书，则建议关闭该验证；
    self.manager.securityPolicy = securityPolicy;
}




@end
