//
//  QYHTTPManager.h
//  Yueba
//
//  Created by qingyun on 16/8/23.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef void(^QYHTTPManagerCompletionHandle) (NSURLSessionTask *task, id responseObject, NSError *error);

@interface QYHTTPManager : AFHTTPSessionManager

//添加了baseURL
+(instancetype)httpManager;


//封装af的get方法
-(NSURLSessionDataTask *)GET:(NSString *)URLString
                  parameters:(id)parameters
                  Completion:(QYHTTPManagerCompletionHandle)completionHandle;

-(NSURLSessionDataTask *)POST:(NSString *)URLString
                  parameters:(id)parameters
                  Completion:(QYHTTPManagerCompletionHandle)completionHandle;

//请求短信验证码的请求
-(NSURLSessionDataTask *)sendSMSCode:(NSString *)phoneNumer Completion:(QYHTTPManagerCompletionHandle )completionHandle;

//注册账号的方法
-(NSURLSessionDataTask *)creatAccount:(NSString *)phoneNumber PWD:(NSString *)pwd SMS:(NSString *)smsCode Completion:(QYHTTPManagerCompletionHandle )completionHandle;

//登录服务器
-(NSURLSessionDataTask *)loginService:(NSString *)phone PWD:(NSString *)pwd Completion:(QYHTTPManagerCompletionHandle )completionHandle;

//上传用户信息
-(NSURLSessionDataTask *)uploadInfo:(NSDictionary *)params Completion:(QYHTTPManagerCompletionHandle )completionHandle;

//批量获取用户信息
-(NSURLSessionDataTask *)getUserInfosWith:(NSArray *)userIds Completion:(QYHTTPManagerCompletionHandle )completionHandle;

//添加好友信息
-(NSURLSessionDataTask *)addUser:(NSString *)friendID Like:(BOOL)like Completion:(QYHTTPManagerCompletionHandle )completionHandle;

@end
