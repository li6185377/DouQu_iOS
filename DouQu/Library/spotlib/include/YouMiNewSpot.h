//
//  YouMiNewSpot.h
//  YouMiSpotSDK
//
//  Created by yuxuhong on 14-10-26.
//  Copyright (c) 2014年 youmi. All rights reserved.
//

#import <Foundation/Foundation.h>

// 指定要使用横屏还是竖屏的广告图片.
// 竖屏应用,选这个:kSPOTSpotTypePortrait
// 横屏应用,选这个:kSPOTSpotTypeLandscape
// 应用支持横竖屏时,选这个:kSPOTSpotTypeBoth.注意选这个sdk会缓存两张图片,不支持旋转的应用不建议选这个
typedef enum {
    kSPOTSpotTypePortrait = 0,
    kSPOTSpotTypeLandscape = 1,
    kSPOTSpotTypeBoth = 2,
} SpotType;

@interface YouMiNewSpot : NSObject

// 设置开发者的appid与appSecret
+(void)initYouMiDeveloperParams:(NSString *)YM_appid YM_SecretId:(NSString*)YM_SecretId;

// We use synchronized request method for online parameters request
// Set up the online parameters in http://www.youmi.net/ Advertisement Setting -> Online Parameters Setting
// 对于在线参数的请求，我们采用的是同步请求的方式
// 设置在线参数请到http://www.youmi.net/ 网站上。广告设置->在线参数设置
+ (id)onlineYouMiValueForKey:(NSString *)key;

// 初始化插屏广告和设置使用的广告类型
+ (void)initYouMiDeveLoperSpot:(SpotType)spotType;

// 显示插屏广告，有显示返回YES且flag也为YES.没显示返回NO且flag也为NO，dismiss为广告点关闭后的回调。
+ (BOOL)showYouMiSpotAction:(void (^)(BOOL flag))dismissAction;

// 点击插屏广告的回调,点击成功,flag为YES,否则为NO
+ (BOOL)clickYouMiSpotAction:(void (^)(BOOL flag))callbackAction;



@end
