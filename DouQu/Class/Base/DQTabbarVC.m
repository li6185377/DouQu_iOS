//
//  DQTabbarVC.m
//  DouQu
//
//  Created by ljh on 14/12/14.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import "DQTabbarVC.h"
#import "LKBaseNavigationController.h"
#import "DQTextJokesVC.h"

@interface DQTabbarVC ()<UITabBarControllerDelegate>
@property NSUInteger oldSelectedIndex;
@end

@implementation DQTabbarVC
+(instancetype)shareTabbarVC
{
    static DQTabbarVC* tabbar;
    if(tabbar)
    {
        return tabbar;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tabbar = [self alloc];
        tabbar = [tabbar init];
    });
    return tabbar;
}
- (UIViewController *)navigationWithVCClass:(Class)clazz
{
    UIViewController *viewController = [[clazz alloc] init];
    return [self navigationWithVC:viewController];
}
- (UIViewController *)navigationWithVC:(UIViewController*)viewController
{
    UINavigationController *navigation = [[LKBaseNavigationController alloc] initWithRootViewController:viewController];
    return navigation;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    
    NSMutableArray* array = [NSMutableArray array];
    DQTextJokesVC* textvc = [DQTextJokesVC new];
    textvc.requestType = 1;
    textvc.title = @"段子";
    [textvc.tabBarItem lk_setFinishedSelectedImage:@"tabbar_text_up" withFinishedUnselectedImage:@"tabbar_text"];


    DQTextJokesVC* picvc = [DQTextJokesVC new];
    picvc.requestType = 2;
    picvc.title = @"图片";
    [picvc.tabBarItem lk_setFinishedSelectedImage:@"tabbar_picture_up" withFinishedUnselectedImage:@"tabbar_picture"];

    
    [array addObject:[self navigationWithVC:picvc]];
    [array addObject:[self navigationWithVC:textvc]];
    [array addObject:[self navigationWithVCClass:NSClassFromString(@"DQSettingVC")]];
    
    self.viewControllers = array;
    
    [self removeSelectionIndicatorImage];
    [self removeTabbarTopLine];
 
    [self appThemeDidChanged];
    [[LKThemeManager shareThemeManager] addChangedListener:self];
}
-(void)appThemeDidChanged
{
    UIImage* img = [UIImage lk_imageCenterStretchWithName:@"all_bottom_bg"];
    self.tabBar.backgroundImage = img;
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
        [vc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:colorWithGray, UITextAttributeTextColor, nil]
                                     forState:UIControlStateNormal];
        [vc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:colorWithRed__, UITextAttributeTextColor, nil]
                                     forState:UIControlStateSelected];
    }];
}


/**
 *  去除系统自带的Tabbar上面那条线
 */
- (void)removeTabbarTopLine
{
    if(!IOS7)
    {
        for (UIView* barLine in self.tabBar.subviews)
        {
            if([barLine isKindOfClass:[UIImageView class]])
            {
                [barLine removeFromSuperview];
            }
        }
    }
}
/**
 *  去除系统自带的SelectionIndicatorImage
 */
- (void)removeSelectionIndicatorImage
{
    if (!IOS7)
    {
        for (UIView *barButton in  self.tabBar.subviews)
        {
            if ([barButton isKindOfClass:NSClassFromString(@"UITabBarButton")])
            {
                for (UIView *view in barButton.subviews)
                {
                    if ([view isKindOfClass:NSClassFromString(@"UITabBarSelectionIndicatorView")])
                    {
                        view.hidden = YES;
                        view.tag = 1;
                        [view removeFromSuperview];
                        break;
                    }
                }
            }
        }
    }
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSInteger currentIndex = tabBarController.selectedIndex;
    //点击菜单再次刷新功能
    if (_oldSelectedIndex == currentIndex)
    {
        UIViewController* showViewController = viewController;
        if([showViewController isKindOfClass:[UINavigationController class]])
        {
            showViewController = [((id)showViewController) visibleViewController];
        }
        
        if([showViewController respondsToSelector:@selector(dq_tabbarClickEvent)])
        {
            [showViewController dq_tabbarClickEvent];
        }
    }
    _oldSelectedIndex = currentIndex;
}

#pragma mark - InterfaceOrientation

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}


@end
