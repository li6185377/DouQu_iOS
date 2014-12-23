//
//  DQNetworkHelper.h
//  DouQu
//
//  Created by ljh on 14/12/14.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

@interface DQNetworkHelper : NSObject
+(DQNetworkHelper*)shareHelper;
@property(strong,nonatomic) AFHTTPClient* client;
@property(readonly) BOOL isWifi;
@property(readonly) BOOL is2G3G;
@property(readonly) BOOL networkEnable;

+(AFHTTPRequestOperation*)method:(NSString*)method
                          params:(NSDictionary*)params
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+(AFHTTPRequestOperation*)method:(NSString*)method
                          params:(NSDictionary*)params
                          header:(NSDictionary*)header
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
