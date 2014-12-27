//
//  UIView+LKTheme.m
//  DouQu
//
//  Created by ljh on 14/12/17.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import "UIView+LKTheme.h"
#import "NSObject+LKTheme.h"
#import "UIImage+LKTheme.h"

#pragma mark- UIView
@implementation UIView (LKTheme)
-(void)lk_setBackgroundColorForKey:(NSString *)key
{
    UIColor* color = LK_ThemeColor(key);
    self.backgroundColor = color;
    
    [self lk_addObserverWithSEL:_cmd paramsArray:key];
}
-(void)lk_setTextColorForKey:(NSString *)key
{
    if([self respondsToSelector:@selector(setTextColor:)])
    {
        UIColor* color = LK_ThemeColor(key);
        [((id)self) setTextColor:color];
        
        [self lk_addObserverWithSEL:_cmd paramsArray:key];
    }
}
@end

#pragma mark- UIImageView
@implementation UIImageView(LKTheme)

-(void)lk_setImageForKey:(NSString *)key
{
    [self lk_setImageForKey:key stretch:CGPointZero];
}
-(void)lk_setImageForKey:(NSString *)key stretch:(CGPoint)stretch
{
    UIImage* img = [UIImage lk_imageWithName:key stretch:stretch];
    self.image = img;
    
    [self lk_addObserverWithSEL:_cmd paramsArray:@[key,[NSValue valueWithCGPoint:stretch]]];
}

-(void)lk_setHighlightedImageForKey:(NSString *)key
{
    [self lk_setHighlightedImageForKey:key stretch:CGPointZero];
}
-(void)lk_setHighlightedImageForKey:(NSString *)key stretch:(CGPoint)stretch
{
    UIImage* img = [UIImage lk_imageWithName:key stretch:stretch];
    self.highlightedImage = img;
    
    [self lk_addObserverWithSEL:_cmd paramsArray:@[key,[NSValue valueWithCGPoint:stretch]]];
}
@end


#pragma mark- UIButton
@implementation UIButton(LKTheme)
-(void)lk_setImageForKey:(NSString*)key forState:(UIControlState)state
{
    UIImage* img = [UIImage lk_imageWithName:key];
    [self setImage:img forState:state];
    
    [self lk_addObserverWithSEL:_cmd paramsArray:@[key,@(state)] appendKey:@(state)];
}
-(void)lk_setBackgroundImageForKey:(NSString*)key forState:(UIControlState)state
{
    [self lk_setBackgroundImageForKey:key forState:state stretch:CGPointZero];
}

-(void)lk_setTitleColorForKey:(NSString *)key forState:(UIControlState)state
{
    UIColor* color = LK_ThemeColor(key);
    [self setTitleColor:color forState:state];
    
    [self lk_addObserverWithSEL:_cmd paramsArray:@[key,@(state)] appendKey:@(state)];
}

-(void)lk_setBackgroundImageForKey:(NSString*)key forState:(UIControlState)state stretch:(CGPoint)stretch
{
    UIImage* img = [UIImage lk_imageWithName:key stretch:stretch];
    [self setBackgroundImage:img forState:state];
    
    [self lk_addObserverWithSEL:_cmd paramsArray:@[key,@(state),[NSValue valueWithCGPoint:stretch]] appendKey:@(state)];
}
@end

#pragma mark- UITabbarItem
@implementation UITabBarItem (LKTheme)
-(void)lk_setFinishedSelectedImage:(NSString *)selectedImageKey withFinishedUnselectedImage:(NSString *)unselectedImageKey
{
    UIImage *selectedImage = [UIImage lk_imageWithName:selectedImageKey];
    UIImage *unSelectedImage = [UIImage lk_imageWithName:unselectedImageKey];
    if ([selectedImage respondsToSelector:@selector(imageWithRenderingMode:)])
    {
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        unSelectedImage = [unSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    [self setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:unSelectedImage];

    [self lk_addObserverWithSEL:_cmd paramsArray:@[selectedImageKey,unselectedImageKey]];
}
@end

#pragma mark- UINavigationBar
@implementation UINavigationBar (LKTheme)
-(void)lk_setBackgroundImageForKey:(NSString *)key forBarMetrics:(UIBarMetrics)barMetrics
{
    UIImage* img = [UIImage lk_imageWithName:key stretch:CGPointMake(0.5, 0.5)];
    [self setBackgroundImage:img forBarMetrics:barMetrics];
    
    [self lk_addObserverWithSEL:_cmd paramsArray:@[key,@(barMetrics)] appendKey:@(barMetrics)];
}
@end

#pragma mark- UITabBar
@implementation UITabBar(LKTheme)
-(void)lk_setBackgroundImageForKey:(NSString *)key
{
    UIImage* img = [UIImage lk_imageCenterStretchWithName:key];
    self.backgroundImage = img;
    
    [self lk_addObserverWithSEL:_cmd paramsArray:key];
}

@end

#pragma mark- UITextView
@implementation UITextView(LKTheme)
-(void)didMoveToSuperview
{
    if(self.superview)
    {
        [self themeChangeEvent];
    }
    if(IOS7)
    {
        [self lk_addObserverWithSEL:@selector(themeChangeEvent) paramsArray:nil];
    }
}
-(void)themeChangeEvent
{
    if(IOS7)
    {
        if([LKThemeManager shareThemeManager].keyboardAppearanceDark)
        {
            self.keyboardAppearance = UIKeyboardAppearanceDark;
        }
        else
        {
            self.keyboardAppearance = UIKeyboardAppearanceDefault;
        }
    }
}
@end