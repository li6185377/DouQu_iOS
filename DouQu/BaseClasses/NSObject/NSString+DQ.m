//
//  NSString+DQ.m
//  DouQu
//
//  Created by ljh on 14/12/17.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import "NSString+DQ.h"

inline CGSize dq_sizeWithImageSize(CGSize imageSize,CGSize maxSize)
{
    maxSize.width = maxSize.width?:ScreenWidth;
    maxSize.height = maxSize.height?:ScreenWidth;
    
    NSInteger newWidth = 0;
    NSInteger newHeight = 0;
    //如果图片的长宽都小于默认值 则不压缩了
    if (imageSize.width <= maxSize.width && imageSize.height <= maxSize.height)
    {
        newWidth = imageSize.width;
        newHeight = imageSize.height;
    }
    else
    {
        float radio = maxSize.width/imageSize.width;
        
        newWidth = maxSize.width;
        newHeight = imageSize.height*radio;
    }
    newWidth = ceil(MIN(maxSize.width,MAX(80, newWidth)));
    newHeight = ceil(MIN(maxSize.height,MAX(50,newHeight)));
    
    return CGSizeMake(newWidth, newHeight);
}

@interface NSObject(DQString_Containg)
@end
@implementation NSObject(DQString_Containg)
-(BOOL)containsString:(NSString*)aString
{
    if([self isKindOfClass:[NSString class]])
    {
        if(aString.length > 0)
        {
            return ([(NSString*)self rangeOfString:aString options:NSBackwardsSearch].length > 0);
        }
    }
    return NO;
}
@end

@implementation NSString (DQ)
-(CGSize)lastComponentOriginalImageSize
{
    NSArray* targetArray = [self componentsSeparatedByString:@"_"];
    if(targetArray.count >= 2)
    {
        NSArray *tmpArray = [targetArray subarrayWithRange:NSMakeRange(targetArray.count - 2, 2)];
        int width = 0;
        int height = 0;
        NSString *string1 = [tmpArray lastObject];
        if([string1 containsString:@"x"])
        {
            NSArray* taobaoArray = [string1 componentsSeparatedByString:@"x"];
            width = [taobaoArray[0] intValue];
            height = [taobaoArray[1] intValue];
        }
        else
        {
            NSString *string2 = [tmpArray firstObject];
            height = string1.intValue;
            width = string2.intValue;
        }
        
        if (isnan(width) || isnan(height))
        {
            width = 0;
            height = 0;
        }
        return CGSizeMake(width, height);

    }
    return CGSizeZero;
}
-(CGSize)lastComponentImageSize
{
    int newSizeWidth = ScreenWidth - 20;
    CGSize size = self.lastComponentOriginalImageSize;
    if (size.height == 0 || size.width == 0)
    {
        size = CGSizeMake(newSizeWidth, 150);
    }
    else
    {
        if(size.width > newSizeWidth)
        size = [self size:size changeWidth:ScreenWidth - 20];
        if (size.height > 5000)
        {
            size.height = 150;
        }
        if (size.height == 0 || size.width == 0)
        {
            size = CGSizeMake(ScreenWidth - 20, 150);
        }
    }
    return size;
}
- (CGSize)size:(CGSize)size changeWidth:(CGFloat)width
{
    CGSize newSize = CGSizeMake(ceilf(width), ceilf(size.height * (width / size.width)));
    if (isnan(newSize.height))
    {
        newSize.height = 0;
    }
    return newSize;
}
@end
