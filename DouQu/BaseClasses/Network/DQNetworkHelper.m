//
//  DQNetworkHelper.m
//  DouQu
//
//  Created by ljh on 14/12/14.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import "DQNetworkHelper.h"
#import "LKLanguageManager.h"
#import "UIDevice-Hardware.h"

@interface DQNetworkHelper()

@end
@implementation DQNetworkHelper
+(DQNetworkHelper *)shareHelper
{
    static DQNetworkHelper* helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[self alloc] init];
    });
    return helper;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://leancloud.cn/1.1/functions/"]];
        _client.parameterEncoding = AFJSONParameterEncoding;
    }
    return self;
}
-(BOOL)isWifi
{
    return (_client.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi);
}
-(BOOL)is2G3G
{
    return (_client.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN);
}
-(BOOL)networkEnable
{
    return (_client.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable);
}
-(AFHTTPRequestOperation *)method:(NSString *)method params:(NSDictionary *)params header:(NSDictionary *)header success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSMutableDictionary* pars = [NSMutableDictionary dictionaryWithDictionary:params];
    
    pars[@"app_v"] = appVersion;
    pars[@"app_channel"] = appChannelID;
    pars[@"app_platform"] = @"ios";
    
    UIDevice* device = [UIDevice currentDevice];
    pars[@"app_device"] = [device platform];
    pars[@"app_macid"] = [device macaddress];
    pars[@"app_openudid"] = [device openUDID];
    pars[@"app_idfa"] = [device idfaString];
    pars[@"app_idfv"] = [device idfvString];
    
    pars[@"app_language"] = @([LKLanguageManager shareLanguageManager].currentLanguageType);
    
    NSMutableURLRequest* request = [_client requestWithMethod:@"POST" path:method parameters:pars];
    [request setValue:AVOSID forHTTPHeaderField:@"X-AVOSCloud-Application-Id"];
    [request setValue:AVOSKey forHTTPHeaderField:@"X-AVOSCloud-Application-Key"];
    [request setValue:AVOSProduction forHTTPHeaderField:@"X-AVOSCloud-Application-Production"];
    
    [header enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    
    AFHTTPRequestOperation* op = [_client HTTPRequestOperationWithRequest:request success:success failure:failure];
    [_client enqueueHTTPRequestOperation:op];
    return op;
}
+(AFHTTPRequestOperation *)method:(NSString *)method params:(NSDictionary *)params header:(NSDictionary *)header success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    return [[self shareHelper] method:method params:params header:header success:success failure:failure];
}
+(AFHTTPRequestOperation *)method:(NSString *)method params:(NSDictionary *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
   return [self method:method params:params header:nil success:success failure:failure];
}

@end
