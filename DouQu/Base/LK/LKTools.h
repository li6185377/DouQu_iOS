//
//  LKTools.h
//  LJH
//
//  Created by LK on 13-7-8.
//  Copyright (c) 2013年 Jianghuai Li. All rights reserved.
//

#ifndef LJH_LKTools_h
#define LJH_LKTools_h

#import "NSData+LK.h"
#import "NSString+LK.h"
#import "UIView+LK.h"
#import "NSFileManager+LK.h"
#import "UIWindow+LK.h"
#import "UIImage+LK.h"
#import "UIButton+LK.h"
#import "UIViewController+LK.h"
#import "UIImageView+LK.h"
#import "NSObject+LK.h"
#import "UIColor+LK.h"
#import "NSURL+LK.h"

#define IOS5 ([UIDevice currentDevice].systemVersion.floatValue >= 5)
#define IOS6 ([UIDevice currentDevice].systemVersion.floatValue >= 6)
#define IOS7 ([UIDevice currentDevice].systemVersion.floatValue >= 7)
#define IOS8 ([UIDevice currentDevice].systemVersion.floatValue >= 8)

#define iPhone5 ([UIScreen mainScreen].bounds.size.height == 568)
#define iPhone6 ([UIScreen mainScreen].bounds.size.width == 375)
#define iPhone6p ([UIScreen mainScreen].bounds.size.width == 414)

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RGBHexString(s) [UIColor colorWithHexString:s]

#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define ScreenScale ([UIScreen mainScreen].scale)

///-----------------------皮肤相关的
#import "UIImage+LKTheme.h"
#ifdef UIImage_LKTheme_Category
#define imageNamed lk_imageWithName
#endif
///-----------------------

#endif



#ifndef weakify

#define weakify(o) __typeof__(o) __weak o##__weak_ = o;
#define strongify(o) __typeof__(o##__weak_) __strong o = o##__weak_;

#endif