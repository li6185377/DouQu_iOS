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
    
    [pars setObject:appVersion forKey:@"app_v"];
    [pars setObject:appChannelID forKey:@"app_channel"];
    [pars setObject:@"ios" forKey:@"app_platform"];
    [pars setObject:[UIDevice currentDevice].platform forKey:@"app_device"];
    [pars setObject:@([LKLanguageManager shareLanguageManager].currentLanguageType) forKey:@"app_language"];
    
    NSMutableURLRequest* request = [_client requestWithMethod:@"POST" path:method parameters:params];
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
