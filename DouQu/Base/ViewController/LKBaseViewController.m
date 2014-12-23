//
//  LHBaseViewController.m
//  LaHuo
//
//  Created by ljh on 14-10-23.
//  Copyright (c) 2014年 LaHuo. All rights reserved.
//

#import "LKBaseViewController.h"
#import "LKBaseNavigationController.h"
#import "UIDevice-Hardware.h"

#ifdef kAVDefaultNetworkTimeoutInterval
#import "AVOSCloud.h"
#endif

#ifdef XcodeAppVersion
#import "MobClick.h"
#endif

@interface LKBaseViewController ()

@end

@implementation LKBaseViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (IOS7)
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.view lk_setBackgroundColorForKey:colorWithBgKey];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

#ifdef XcodeAppVersion
    [MobClick endLogPageView:NSStringFromClass(self.class)];
#endif
    
#ifdef kAVDefaultNetworkTimeoutInterval
    [AVAnalytics endLogPageView:NSStringFromClass(self.class)];
#endif
    
}


- (void)enablePopGes
{
    LKBaseNavigationController *nav =  (id)self.navigationController;
    if ([nav isKindOfClass:[LKBaseNavigationController class]])
    {
        if (nav.visibleViewController == self)
        {
            nav.canPop = YES;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
#ifdef XcodeAppVersion
    [MobClick beginLogPageView:NSStringFromClass(self.class)];
#endif
    
#ifdef kAVDefaultNetworkTimeoutInterval
    [AVAnalytics beginLogPageView:NSStringFromClass(self.class)];
#endif
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(enablePopGes) object:nil];
    [self performSelector:@selector(enablePopGes) withObject:nil afterDelay:([UIDevice currentDevice].cpuCount)?0.25:0.35];
    if (IOS7)
    {
        if (self.navigationController.viewControllers.count > 1)
        {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
        else
        {
            [self disableIOS7PopGestureRecongnizer];
        }
    }
}


- (void)disableIOS7PopGestureRecongnizer
{
    if (IOS7)
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)enableIOS7PopGestureRecongnizer
{
    if (IOS7)
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if ([self isViewLoaded])
    {
        [self deleteTableViewDelegate:self.view];
    }
    NSLog(@"dealloc vc = %@",self);
}

- (void)deleteTableViewDelegate:(UIView *)view
{
    NSArray *array = view.subviews;
    for (UIView *view in array)
    {
        if ([view isKindOfClass:[UIScrollView class]])
        {
            UITableView *tableView = (id) view;
//            [tableView setDragDelegate:nil refreshDatePermanentKey:nil];
            tableView.delegate = nil;
            
            if ([tableView respondsToSelector:@selector(setDataSource:)])
            {
                [tableView setDataSource:nil];
            }
        }
        else if ([view respondsToSelector:@selector(setDelegate:)])
        {
            [((id) view) setDelegate:nil];
        }
        
        if (view.subviews.count)
        {
            [self deleteTableViewDelegate:view];
        }
    }
}

/**
 *  处理IOS7下坐标适配
 */
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if (IOS7)
    {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        CGRect viewBounds = self.view.bounds;
        CGFloat topBarOffset = self.topLayoutGuide.length;
        viewBounds.origin.y = topBarOffset * -1;
        self.view.bounds = viewBounds;
    }
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
