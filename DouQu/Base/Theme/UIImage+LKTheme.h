//
//  UIImage+LKTheme.h
//  DouQu
//
//  Created by ljh on 14/12/16.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIImage_LKTheme_Category

@interface UIImage (LKTheme)
+(instancetype)lk_imageWithName:(NSString*)name;
+(instancetype)lk_imageCenterStretchWithName:(NSString*)name;
+(instancetype)lk_imageWithName:(NSString*)name stretch:(CGPoint)stretch;
@end
