//
//  UIImageView+LK.h
//  LJH
//
//  Created by LK on 13-9-18.
//  Copyright (c) 2013年 Jianghuai Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (LK2)
-(void)lkImage:(id)image;
-(void)lkImage:(id)img1 highl:(id)img2;
-(void)lkImage:(id)img1 highl:(id)img2 stretch:(BOOL)stretch;
@end