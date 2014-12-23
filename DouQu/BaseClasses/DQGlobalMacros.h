//
//  DQGlobalMacros.h
//  DouQu
//
//  Created by ljh on 14/12/14.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//


#ifndef DouQu_DQGlobalMacros_h
#define DouQu_DQGlobalMacros_h



#ifdef DEBUG
#define UmengKey @"548a900bfd98c564e4000368"
#define AVOSID @"mp57l4wlo53n2wyfes44n0q18micqt94y1dku7acs8pvq8m3"
#define AVOSKey @"uy24pngn8iv5q3qy26ciktwmp5rw45d1e6hnm7w95f98uja7"
#define AVOSProduction @"0"
#else
#define UmengKey @"548a900bfd98c564e4000368"
#define AVOSID @"mp57l4wlo53n2wyfes44n0q18micqt94y1dku7acs8pvq8m3"
#define AVOSKey @"uy24pngn8iv5q3qy26ciktwmp5rw45d1e6hnm7w95f98uja7"
#define AVOSProduction @"1"
#endif

#define appChannelID [[DQAppInfo shareAppInfo] channelID]
#define appVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#import "DQColorMacros.h"

#endif
