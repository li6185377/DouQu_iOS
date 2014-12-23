//
//  UIViewController+LK.h
//  LJH
//
//  Created by LK on 13-8-16.
//  Copyright (c) 2013年 Jianghuai Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LK)

-(UIButton*)lk_topLeftButton;
-(UIButton*)lk_topRightButton;

-(void)lk_topLeftButtonIsBack;

-(void)lk_topLeftButtonTouchUpInside;
-(void)lk_topRightButtonTouchUpInside;

- (void)lk_push:(UIViewController *)viewController;
- (void)lk_push:(UIViewController *)viewController animated:(BOOL)animated;

- (void)lk_present:(UIViewController *)viewController;
- (void)lk_present:(UIViewController *)viewController animated:(BOOL)animated;
@end
