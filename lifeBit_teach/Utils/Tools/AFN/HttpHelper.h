//
//  HttpHelper.h
//  testCocoaPods
//
//  Created by Aimi on 16/8/15.
//  Copyright © 2016年 joyskim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@class AFHTTPRequestOperation;

//定义http请求成功block
typedef void (^HTTPSuccessBlock)(NSURLSessionDataTask *operation,id obj);
//定义http请求失败block
typedef void (^HTTPFailureBlock)(NSURLSessionDataTask *operation,NSError *error);

//网络状态变成有网
typedef void (^HttpNetWorkStatusChangeBlock)(void);

@interface HttpHelper : NSObject

@property(nonatomic,strong)AFHTTPSessionManager * manager;

@property (nonatomic,strong)AFNetworkReachabilityManager *netWorkStatusManager;

@property (nonatomic,copy)HttpNetWorkStatusChangeBlock networkStatusChangeBlock;


@property (nonatomic,assign)BOOL isNetWork;
//单例创建一个json请求的网络管理器
+(HttpHelper *)JSONRequestManager;

//单例创建一个text/html请求的网络管理器
+(HttpHelper *)HTTPRequestManager;

// 判断是否由网络
-(void)startNetWorkStatus;
/**
 *  创建post请求
 *
 *  @param post       接口名
 *  @param parameters 入参
 *  @param success    成功返回
 *  @param failure    失败返回
 */
- (void)POST:(NSString *)post parameters:(id)parameters success:(HTTPSuccessBlock)success failure:(HTTPFailureBlock)failure;


#pragma mark  -----版本------
/**
 *  version 1.0.0 updata in 16/08/17
 *  使用新版afn AFHTTPSessionManager的网球请求类
 *  json格式的Post请求 使用 [HttpHelper JSONRequestManager] 进行post
 *  form-urlencoded格式的Post请求 使用 [HttpHelper HTTPRequestManager] 进行Post
 *  需要自己定义kBaseUrl宏
 */

@end
