//
//  UIView+LKTheme.h
//  DouQu
//
//  Created by ljh on 14/12/17.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LKTheme)
-(void)lk_setBackgroundColorForKey:(NSString*)key;
-(void)lk_setTextColorForKey:(NSString*)key;
@end

@interface UIImageView(LKTheme)
-(void)lk_setImageForKey:(NSString*)key;
-(void)lk_setHighlightedImageForKey:(NSString*)key;

-(void)lk_setImageForKey:(NSString*)key stretch:(CGPoint)stretch;
-(void)lk_setHighlightedImageForKey:(NSString*)key stretch:(CGPoint)stretch;
@end

@interface UIButton(LKTheme)
-(void)lk_setImageForKey:(NSString*)key forState:(UIControlState)state;
-(void)lk_setBackgroundImageForKey:(NSString*)key forState:(UIControlState)state;

-(void)lk_setTitleColorForKey:(NSString*)key forState:(UIControlState)state;

-(void)lk_setBackgroundImageForKey:(NSString*)key forState:(UIControlState)state stretch:(CGPoint)stretch;
@end

@interface UITabBarItem (LKTheme)
-(void)lk_setFinishedSelectedImage:(NSString *)selectedImageKey withFinishedUnselectedImage:(NSString *)unselectedImageKey;
@end

@interface UINavigationBar (LKTheme)
-(void)lk_setBackgroundImageForKey:(NSString *)key forBarMetrics:(UIBarMetrics)barMetrics;
@end

@interface UITabBar(LKTheme)
-(void)lk_setBackgroundImageForKey:(NSString*)key;
@end

@interface UITextView(LKTheme)
@end
