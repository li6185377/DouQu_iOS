//
//  LKSendDeviceInfo.m
//  DouQu
//
//  Created by ljh on 15/1/7.
//  Copyright (c) 2015年 Jianghuai Li. All rights reserved.
//

#import "DQSendDeviceInfo.h"
#import "SSKeychain.h"
#import "UIDevice-Hardware.h"

#define kService [NSString stringWithFormat:@"%@_%@",@"NeedSendDeviceInfo",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]

@implementation DQSendDeviceInfo
+(void)start
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if([self neverSend])
        {
            [self sendDeviceInfo];
        }
    });
}
+(void)sendDeviceInfo
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    UIDevice *device = [UIDevice currentDevice];
    params[@"macAddress"] = device.macaddress;
    params[@"systemVersion"] = device.systemVersion;
    params[@"platform"] = device.platform;
    params[@"carrier"] = device.carrierName;
    params[@"resolution"] = [NSString stringWithFormat:@"%.f*%.f", ScreenWidth * ScreenScale, ScreenHeight * ScreenScale];
    params[@"isWifi"] = @([DQNetworkHelper shareHelper].isWifi);
    params[@"isJB"] = @([MobClick isJailbroken]);
    
    [DQNetworkHelper method:@"i_just_is_a_method_3" params:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self sendSuccess];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
            [self start];
        });
    }];
}
+(void)sendSuccess
{
    [SSKeychain setPassword:@"1" forService:kService account:@"DouQu_Account"];
}
+(BOOL)neverSend
{
    NSString *password = [SSKeychain passwordForService:kService account:@"DouQu_Account"];
    return (password.length == 0);
}
@end
