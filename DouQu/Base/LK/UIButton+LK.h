//
//  UIButton+LKSetting.h
//  LJH
//
//  Created by LK on 13-5-30.
//  Copyright (c) 2013年 Jianghuai Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (LKSetting)
-(void)lkTitle:(NSString*)title;

-(void)lkImage:(id)image;
-(void)lkImage:(id)img1 highl:(id)img2;
-(void)lkImage:(id)img1 highl:(id)img2 center:(BOOL)center;

-(void)lkBackgroupImage:(id)image;
-(void)lkBackgroupImage:(id)img1 highl:(id)img2;
-(void)lkBackgroupImage:(id)img1 highl:(id)img2 stretch:(BOOL)stretch;

-(void)lkTitleColor:(UIColor *)color;
-(void)lkTitleColor:(UIColor *)color1 highl:(UIColor*)color2;
@end

//点击区域扩大Button
@interface LKButtonEX : UIButton
@property(nonatomic) float extendTouchRange;
@property(nonatomic) float extendTouchRangeX;
@property(nonatomic) float extendTouchRangeY;
@end
