//
//  DQAppInfo.h
//  DouQu
//
//  Created by ljh on 14/12/14.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DQAppInfo : NSObject
+(instancetype)shareAppInfo;
@property(copy,readonly,nonatomic)NSString* channelID;

@property(nonatomic) BOOL autoLoadingImage2g;
@property(nonatomic) BOOL isNight;

-(void)sendUserInfos;
-(void)showADView;
@end
