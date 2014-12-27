//
//  LHBaseNavigationController.m
//  LaHuo
//
//  Created by ljh on 14-10-23.
//  Copyright (c) 2014年 LaHuo. All rights reserved.
//

#import "LKBaseNavigationController.h"
#import "LKTools.h"
#import "LKThemeManager.h"

@interface LKBaseNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation LKBaseNavigationController


- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self)
    {
        self.canPop = YES;
        
        if (IOS7)
        {
            self.interactivePopGestureRecognizer.delegate = (id <UIGestureRecognizerDelegate>) self;
            self.delegate = (id <UINavigationControllerDelegate>) self;
        }
        [self appThemeDidChanged];
        [[LKThemeManager shareThemeManager] addChangedListener:self];
    }
    return self;
}
-(void)appThemeDidChanged
{
    NSMutableDictionary *titleTextAttributes = [[NSMutableDictionary alloc] init];
    titleTextAttributes[UITextAttributeFont] = [UIFont boldSystemFontOfSize:20];
    titleTextAttributes[UITextAttributeTextColor] = colorWithBrown;
    titleTextAttributes[UITextAttributeTextShadowColor] = [UIColor clearColor];
    titleTextAttributes[UITextAttributeTextShadowOffset] = [NSValue valueWithCGSize:CGSizeMake(0, 0)];
    self.navigationBar.titleTextAttributes = titleTextAttributes;
    
    if(IOS6)
    {
        [self.navigationBar setShadowImage:[UIImage new]];
    }
    
    [self.navigationBar setBackgroundImage:[UIImage lk_imageCenterStretchWithName:@"all_top_bg"] forBarMetrics:UIBarMetricsDefault];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0)
    {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [self.visibleViewController.view endEditing:YES];
    [super pushViewController:viewController animated:animated];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    self.canPop = YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    self.canPop = NO;
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:NSClassFromString(@"UIScreenEdgePanGestureRecognizer")])
    {
        BOOL flag = (self.canPop && self.viewControllers.count > 1);
        if (self.retryCount >= 2)
        {
            flag = YES;
            self.canPop = YES;
            self.retryCount = 0;
        }
        if (!flag)
        {
            self.retryCount++;
        }
        return flag;
    }
    return YES;
}


@end
