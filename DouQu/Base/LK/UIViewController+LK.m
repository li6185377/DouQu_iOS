//
//  UIViewController+LK.m
//  LJH
//
//  Created by LK on 13-8-16.
//  Copyright (c) 2013年 Jianghuai Li. All rights reserved.
//

#import "UIViewController+LK.h"
#import "LKBaseNavigationController.h"

#define topLeftButtonTag  11113
#define topRightButtonTag  11114

@implementation UIViewController (LK)
-(UIButton *)lk_topLeftButton
{
    return [self lk_barButtonWithLeft:YES];
}

-(UIButton *)lk_topRightButton
{
    return [self lk_barButtonWithLeft:NO];
}
-(UIButton*)lk_barButtonWithLeft:(BOOL)isLeft
{
    UIView *btBox = nil;
    if (IOS7)
    {
        btBox = (isLeft ? (UIBarButtonItem *) self.navigationItem.leftBarButtonItems.lastObject : (UIBarButtonItem *) self.navigationItem.rightBarButtonItems.lastObject).customView;
    }
    else
    {
        btBox = (isLeft ? self.navigationItem.leftBarButtonItem : self.navigationItem.rightBarButtonItem).customView;
    }
    
    if (btBox.tag == (isLeft ? topLeftButtonTag : topRightButtonTag))
    {
        if (btBox.subviews.count > 0)
        {
            return [btBox.subviews objectAtIndex:0];
        }
    }
    btBox = [[LKViewEX alloc] initWithFrame:CGRectMake(0, 0, 65, 44)];
    btBox.tag = isLeft ? topLeftButtonTag : topRightButtonTag;

    LKButtonEX *bt = [[LKButtonEX alloc] initWithFrame:btBox.bounds];
    [bt lkTitleColor:[UIColor whiteColor] highl:[UIColor grayColor]];
    
    bt.titleLabel.font = [UIFont systemFontOfSize:16];
    if (!IOS7)
    {
        if (isLeft)
        {
            bt.titleEdgeInsets = UIEdgeInsetsMake(0, 3.5, 0, 0);
            bt.imageEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
        }
        else
        {
            bt.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 2.5);
            bt.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 2.5);
        }
    }
    if (isLeft)
    {
        bt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        if (IOS7)
        {
            bt.left+=0.5;
        }
        [bt addTarget:self action:@selector(lk_topLeftButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        bt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [bt addTarget:self action:@selector(lk_topLeftButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    }
    
    bt.exclusiveTouch = YES;
    [btBox addSubview:bt];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btBox];
    
    if (isLeft)
        self.navigationItem.leftBarButtonItem = item;
    else
        self.navigationItem.rightBarButtonItem = item;
    
    return bt;
}
-(void)lk_topLeftButtonIsBack
{
    
}
-(void)lk_topLeftButtonTouchUpInside
{
    
}
-(void)lk_topRightButtonTouchUpInside
{
    
}


- (void)lk_push:(UIViewController *)viewController
{
    [self lk_push:viewController animated:YES];
}

- (void)lk_push:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nav = (UINavigationController *) self;
        [nav pushViewController:viewController animated:YES];
    }
    else
    {
        /**
         *   避免多次点击进入
         */
        if ([self.navigationController.viewControllers lastObject] == self || self.navigationController.viewControllers.lastObject == self.parentViewController)
        {
            [self.navigationController pushViewController:viewController animated:animated];
        }
    }
}

- (void)lk_present:(UIViewController *)viewController
{
    [self lk_present:viewController animated:YES];
}

- (void)lk_present:(UIViewController *)viewController animated:(BOOL)animated
{
    if (![viewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nav = [[LKBaseNavigationController alloc] initWithRootViewController:viewController];
        [self lk_present:nav animated:animated];
    }
    else
    {
        [self presentViewController:viewController animated:animated completion:nil];
    }
}

@end
