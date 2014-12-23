//
//  UIImage+LKTheme.m
//  DouQu
//
//  Created by ljh on 14/12/16.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import "UIImage+LKTheme.h"
#import "UIDevice-Hardware.h"
#import "LKThemeManager.h"

@implementation UIImage (LKTheme)
+ (int)lk_imageScale
{
    static int scale = 1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        scale = (int)[UIScreen mainScreen].scale;
        if(scale == 1 && [[UIDevice currentDevice].platform.lowercaseString containsString:@"ipad"])
        {
            scale = 2;
        }
    });
    return scale;
}


+(instancetype)lk_imageWithName:(NSString *)name
{
   return [self lk_imageWithName:name stretch:CGPointZero];
}
+(instancetype)lk_imageCenterStretchWithName:(NSString *)name
{
    return [self lk_imageWithName:name stretch:CGPointMake(0.5, 0.5)];
}
+(instancetype)lk_imageWithName:(NSString *)name stretch:(CGPoint)stretch
{
    NSString* filePath = [self lk_imageFilePathWithName:name];
    if(!filePath)
    {
        return nil;
    }
    
    UIImage* image = [[LKThemeManager shareThemeManager] cacheObjectForKey:filePath];
    if(!image)
    {
        image = [self imageWithContentsOfFile:filePath];
        [[LKThemeManager shareThemeManager] setCacheObject:image forKey:filePath];
    }
    
    stretch.x = MAX(0, MIN(1, stretch.x));
    stretch.y = MAX(0,MIN(1, stretch.y));
    if(stretch.x > 0 || stretch.y > 0)
    {
        NSInteger leftCap = (image.size.width * stretch.x);
        NSInteger topCap = (image.size.height * stretch.y);
        return [image stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap];
    }
    return image;
}
+(NSString*)lk_imageFilePathWithName:(NSString*)imageName
{
    if(imageName.length == 0)
    {
        return nil;
    }
    
    NSString* fileName = nil;
    NSString* fileExt = nil;
    
    NSRange dotRange = [imageName rangeOfString:@"." options:NSBackwardsSearch range:NSMakeRange(0, imageName.length)];
    if(dotRange.length == 0 || dotRange.location >= imageName.length)
    {
        fileName = imageName;
    }
    else
    {
        fileName = [imageName substringToIndex:dotRange.location];
        fileExt = [imageName substringFromIndex:dotRange.location + dotRange.length];
    }
    
    if(fileExt.length == 0)
    {
        fileExt = @"png";
    }
    
    if(fileName.length > 3)
    {
        ///路径中有带有 @2x 这种  要先剔除掉
        unichar isAt = [fileName characterAtIndex:fileName.length-3];
        if(isAt == '@')
        {
            fileName = [fileName substringToIndex:fileName.length-3];
        }
    }
    
    NSString* fullName = nil;
    NSString* imagePath = nil;
    if([UIImage lk_imageScale] > 1)
    {
        fullName = [NSString stringWithFormat:@"%@@%dx.%@",fileName,[UIImage lk_imageScale],fileExt];
        imagePath = LK_ThemePath(fullName);
        if(imagePath == nil)
        {
            if ([UIImage lk_imageScale] == 3)
            {
                fullName = [NSString stringWithFormat:@"%@@%dx.%@",fileName,2,fileExt];
                imagePath = LK_ThemePath(fullName);
            }
        }
    }
    
    if (imagePath.length == 0)
    {
        fullName = [NSString stringWithFormat:@"%@.%@",fileName,fileExt];
        imagePath = LK_ThemePath(fullName);
    }
    
    if (imagePath)
    {
        return imagePath;
    }
    else
    {
        return LK_ThemePath(imageName);
    }
}
@end
