//
//  AppDelegate.m
//  DouQu
//
//  Created by ljh on 14/12/11.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import "AppDelegate.h"
#import "DQTabbarVC.h"
#import "NSObject+LKTheme.h"
#import "UMFeedback.h"
#import "ConfigHeader.h"
#import "LKSafeCategory.h"
#import "DQSendDeviceInfo.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self startAnalytics:launchOptions];
    });
    [NSObject lk_callSafeCategory];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_window startLaunchForRootController:[DQTabbarVC shareTabbarVC]];
    
    return YES;
}
-(void)startAnalytics:(NSDictionary *)launchOptions
{
    [AVOSCloud setApplicationId:AVOSID
                      clientKey:AVOSKey];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [AVAnalytics setChannel:appChannelID];
    
    [MobClick startWithAppkey:UmengKey reportPolicy:SEND_INTERVAL channelId:appChannelID];
    [MobClick setCrashReportEnabled:NO];
    
    [UMFeedback setAppkey:UmengKey];
    [UMFeedback setLogEnabled:NO];
    NSDictionary *notificationDict = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if ([notificationDict valueForKey:@"aps"]) // 点击推送进入
    {
        [UMFeedback didReceiveRemoteNotification:notificationDict];
    }
    
    [YouMiNewSpot initLs1G:@"baae47bbdf29c13c" l3v:@"dd1545de2076f5c0"];
    [YouMiNewSpot initLj4Z:kSPOTSpotTypePortrait];
    
    [DQSendDeviceInfo start];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [UMFeedback didReceiveRemoteNotification:userInfo];
}
@end
