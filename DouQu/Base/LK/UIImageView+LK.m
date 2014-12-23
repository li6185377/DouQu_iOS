//
//  UIImageView+LK.m
//  LJH
//
//  Created by LK on 13-9-18.
//  Copyright (c) 2013年 Jianghuai Li. All rights reserved.
//

#import "UIImageView+LK.h"
#import "UIImage+LK.h"

@implementation UIImageView (LK2)
-(void)lkImage:(id)image
{
    [self lkImage:image highl:image];
}
-(void)lkImage:(id)img1 highl:(id)img2
{
    [self lkImage:img1 highl:img2 stretch:NO];
}
-(void)lkImage:(id)img1 highl:(id)img2 stretch:(BOOL)stretch
{
    //正常
    UIImage* image = nil;
    if([img1 isKindOfClass:[NSString class]])
        image = [UIImage imageNamed:img1];
    if([img1 isKindOfClass:[UIImage class]])
        image = img1;
    
    //点击
    UIImage* highimage = nil;
    if([img2 isKindOfClass:[NSNumber class]])
    {
        float value = [img2 floatValue];
        if(value > 0 && value < 1)
        {
            highimage = [UIImage imageWithImage:image darkValue:value];
        }
        else
        {
            highimage = [UIImage imageWithImage:image grayLevelType:(int)value];
        }
    }
    else if([img2 isKindOfClass:[NSString class]])
        highimage = [UIImage imageNamed:img2];
    else if([img2 isKindOfClass:[UIImage class]])
        highimage = img2;
    
    if(stretch)
    {
        image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
        highimage = [highimage stretchableImageWithLeftCapWidth:highimage.size.width/2 topCapHeight:highimage.size.height/2];
    }
    
    self.image =image;
    self.highlightedImage = highimage;
}
@end
