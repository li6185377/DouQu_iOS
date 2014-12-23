//
//  UIButton+LKSetting.m
//  LJH
//
//  Created by LK on 13-5-30.
//  Copyright (c) 2013年 Jianghuai Li. All rights reserved.
//

#import "LKTools.h"

@implementation UIButton (LKSetting)
-(void)lkTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
}
-(void)lkTitleColor:(UIColor *)color
{
    [self lkTitleColor:color highl:color];
}
-(void)lkTitleColor:(UIColor *)color1 highl:(UIColor *)color2
{
    [self setTitleColor:color1 forState:UIControlStateNormal];
    [self setTitleColor:color2 forState:UIControlStateHighlighted];
}
-(void)lkImage:(id)image
{
    [self lkImage:image highl:nil];
}
-(void)lkImage:(id)img1 highl:(id)img2
{
    [self lkImage:img1 highl:img2 center:NO];
}
-(void)lkImage:(id)img1 highl:(id)img2 center:(BOOL)center
{
    //正常
    UIImage* image = nil;
    if([img1 isKindOfClass:[NSString class]])
        image = [UIImage imageNamed:img1];
    if([img1 isKindOfClass:[UIImage class]])
        image = img1;
    if(image && center)
    {
        float edgeWidth = (self.width-image.size.width)/2;
        float edgeHeight = (self.height-image.size.height)/2;
        if(edgeWidth>0 && edgeHeight>0)
        {
            [self setImageEdgeInsets:UIEdgeInsetsMake(edgeHeight, edgeWidth, edgeHeight, edgeWidth)];
        }
    }
    
    //点击
    UIImage* highimage = nil;
    if([img2 isKindOfClass:[NSNumber class]])
    {
        float value = [img2 floatValue];
        if(value > 0 && value < 1)
        {
            highimage = [UIImage imageWithImage:image darkValue:value];
        }else{
            highimage = [UIImage imageWithImage:image grayLevelType:(int)value];
        }
    }
    else if([img2 isKindOfClass:[NSString class]])
    {
        highimage = [UIImage imageNamed:img2];
    }
    else if([img2 isKindOfClass:[UIImage class]])
    {
        highimage = img2;
    }
    
    [self setImage:image forState:UIControlStateNormal];
    
    if(!(image && IOS7 && highimage==nil))
    {
        [self setImage:highimage forState:UIControlStateHighlighted];
    }
}

-(void)lkBackgroupImage:(id)image
{
    [self lkBackgroupImage:image highl:nil];
}
-(void)lkBackgroupImage:(id)img1 highl:(id)img2
{
    [self lkBackgroupImage:img1 highl:img2 stretch:NO];
}
-(void)lkBackgroupImage:(id)img1 highl:(id)img2 stretch:(BOOL)stretch
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
        }else{
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
    
    [self setBackgroundImage:image forState:UIControlStateNormal];
    
    if(!(image && IOS7 && highimage==nil))
    {
        [self setBackgroundImage:highimage forState:UIControlStateHighlighted];
    }
}
@end

@implementation LKButtonEX
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.extendTouchRange = 15;
}
-(void)setExtendTouchRange:(float)extendTouchRange
{
    _extendTouchRange = extendTouchRange;
    _extendTouchRangeX = _extendTouchRange;
    _extendTouchRangeY = _extendTouchRange;
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect bounds = self.bounds;
    bounds.origin = CGPointMake(-_extendTouchRangeX,-_extendTouchRangeY);
    bounds.size = CGSizeMake(bounds.size.width + _extendTouchRangeX * 2, bounds.size.height+ _extendTouchRangeY * 2);
    return CGRectContainsPoint(bounds, point);
}
@end
