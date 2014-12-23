//
//  UITableView+DragRefreshAndLoad.m
//  LoadMore
//
//  Created by openthread on 2/11/13.
//  Copyright (c) 2013 CannonInc. All rights reserved.
//

#import "UITableView+DragLoad.h"
#import <objc/runtime.h>
#import "DragTableHeaderView_ot.h"
#import "DragTableFooterView_ot.h"
#import "DragTableGestureObserver_ot.h"
#import "ComOpenThreadOTScreenshotHelperSwizzleHelper.h"

#define DRAG_DELEGATE_KEY               @"ot_kUITableViewDragDelegate"
#define DRAG_SHOULD_SHOW_REFRESH_KEY    @"ot_kUITableViewShouldShowRefresh"
#define DRAG_SHOULD_SHOW_LOAD_MORE_KEY  @"ot_kUITableViewShouldShowLoadMore"

#define DRAG_HEADER_KEY                 @"ot_kUITableViewDragHeader"
#define DRAG_FOOTER_KEY                 @"ot_kUITableViewDragFooter"
#define DRAG_GESTURE_OBSERVER_KEY       @"ot_kUITableViewDragGestureObserver"

@interface UITableView(DragRefreshAndLoadPrivate)

@property (nonatomic, retain) DragTableHeaderView_ot *dragHeaderView;
@property (nonatomic, retain) DragTableFooterView_ot *dragFooterView;
@property (nonatomic, retain) DragTableGestureObserver_ot *gestureObserver;

- (void)callDelegateDidTriggerRefresh;
- (void)callDelegateDidTriggerLoadMode;

@end

@interface UITableView(DragRefreshAndLoadCallback)<DragTableHeaderDelegate_ot, DragTableFooterDelegate_ot, DragTableGestureObserverDelegate_ot>
@end

@implementation UITableView(DragRefreshAndLoadCallback)

- (void)dragTableHeaderDidTriggerRefresh:(DragTableHeaderView_ot*)view
{
    if (self.dragFooterView.isLoading)
    {
        [self.dragFooterView endLoading:self shouldChangeContentInset:NO];
        if ([self.dragDelegate respondsToSelector:@selector(dragTableLoadMoreCanceled:)])
        {
            [self.dragDelegate dragTableLoadMoreCanceled:self];
        }
    }
    [self callDelegateDidTriggerRefresh];
}

- (void)dragTableFooterDidTriggerLoadMore:(DragTableFooterView_ot *)view
{
    if (self.dragHeaderView.isLoading)
    {
        [self.dragHeaderView endLoading:self shouldUpdateRefreshDate:NO shouldChangeContentInset:NO];
        if ([self.dragDelegate respondsToSelector:@selector(dragTableRefreshCanceled:)])
        {
            [self.dragDelegate dragTableRefreshCanceled:self];
        }
    }
    [self callDelegateDidTriggerLoadMode];
}

- (void)dragTableGestureStateWillChangeTo:(UIGestureRecognizerState)state observer:(DragTableGestureObserver_ot *)observer
{
    if (state == UIGestureRecognizerStateEnded)
    {
        if (self.showRefreshView)
        {
            [self.dragHeaderView dragTableDidEndDragging:self];
        }
        if (self.showLoadMoreView)
        {
            [self.dragFooterView dragTableDidEndDragging:self];
        }
    }
}

- (void)dragTableContentOffsetWillChangeTo:(CGPoint)contentOffset observer:(DragTableGestureObserver_ot *)observer
{
    if (self.showRefreshView)
    {
        [self.dragHeaderView dragTableDidScroll:self];
    }
    if (self.showLoadMoreView)
    {
        [self.dragFooterView dragTableDidScroll:self];
    }
}

- (void)dragTableContentSizeWillChangeTo:(CGSize)contentSize observer:(DragTableGestureObserver_ot *)observer
{
    CGFloat dragFooterMinY = MAX(contentSize.height, self.frame.size.height);
    self.dragFooterView.frame = CGRectMake(0, dragFooterMinY, self.frame.size.width, self.bounds.size.height);
}

- (void)dragTableFrameWillChangeTo:(CGRect)contentOffset observer:(DragTableGestureObserver_ot *)observer
{
    if (self.dragFooterView.isLoading)
    {
        CGFloat contentInsetHeightAdder = self.frame.size.height - self.contentSize.height;
        contentInsetHeightAdder = MAX(0, contentInsetHeightAdder);
        self.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, LOADMORE_TRIGGER_HEIGHT + contentInsetHeightAdder, 0.0f);
    }
    
    self.dragHeaderView.frame = CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.frame.size.width, self.bounds.size.height);
    CGFloat dragFooterMinY = MAX(self.contentSize.height, self.frame.size.height);
    self.dragFooterView.frame = CGRectMake(0, dragFooterMinY, self.frame.size.width, self.bounds.size.height);
}

@end

@implementation UITableView (DragLoad)

#pragma mark - Delegate

@dynamic dragDelegate;

- (id<UITableViewDragLoadDelegate>)dragDelegate
{
    return objc_getAssociatedObject(self, DRAG_DELEGATE_KEY);
}

- (void)deallocSwizz
{
    [self destroySubViews];
    [self deallocSwizz];
}

- (void)setDragDelegate:(id<UITableViewDragLoadDelegate>)dragDelegate refreshDatePermanentKey:(NSString *)refreshDatePermanentKey
{
    objc_setAssociatedObject(self, DRAG_DELEGATE_KEY, dragDelegate, OBJC_ASSOCIATION_ASSIGN);
    if (dragDelegate)
    {
        [self initSubViewsWithRefreshDatePermanentKey:refreshDatePermanentKey];
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [ComOpenThreadOTScreenshotHelperSwizzleHelper swizzClass:[self class]
                                                            selector:NSSelectorFromString(@"dealloc")
                                                            selector:@selector(deallocSwizz)];
        });
    }
    if (!dragDelegate)
    {
        [self destroySubViews];
    }
}

- (BOOL)showRefreshView
{
    NSNumber *boolNumber = objc_getAssociatedObject(self, DRAG_SHOULD_SHOW_REFRESH_KEY);
    return [boolNumber boolValue];
}

- (void)setShowRefreshView:(BOOL)shouldShowRefreshView
{
    NSNumber *boolNumber = [NSNumber numberWithBool:shouldShowRefreshView];
    objc_setAssociatedObject(self, DRAG_SHOULD_SHOW_REFRESH_KEY, boolNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.dragHeaderView.hidden = !shouldShowRefreshView;
}

- (BOOL)showLoadMoreView
{
    NSNumber *boolNumber = objc_getAssociatedObject(self, DRAG_SHOULD_SHOW_LOAD_MORE_KEY);
    return [boolNumber boolValue];
}

- (void)setShowLoadMoreView:(BOOL)shouldShowLoadMoreView
{
    NSNumber *boolNumber = [NSNumber numberWithBool:shouldShowLoadMoreView];
    objc_setAssociatedObject(self, DRAG_SHOULD_SHOW_LOAD_MORE_KEY, boolNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.dragFooterView.hidden = !shouldShowLoadMoreView;
}

#pragma mark - SubViews Init and Destroy

- (void)initSubViewsWithRefreshDatePermanentKey:(NSString *)refreshDatePermanentKey
{
    if (!self.dragHeaderView)
    {
        CGRect frame = CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.frame.size.width, self.bounds.size.height);
        self.dragHeaderView = [[DragTableHeaderView_ot alloc] initWithFrame:frame datePermanentStoreKey:refreshDatePermanentKey];
        self.dragHeaderView.delegate = self;
        [self addSubview:self.dragHeaderView];
    }
    if (!self.dragFooterView)
    {
        CGRect frame = CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.frame.size.width, self.bounds.size.height);
        self.dragFooterView = [[DragTableFooterView_ot alloc] initWithFrame:frame];
        self.dragFooterView.delegate = self;
        [self addSubview:self.dragFooterView];
    }
    if (!self.gestureObserver)
    {
        self.gestureObserver = [[DragTableGestureObserver_ot alloc] initWithObservingTableView:self delegate:self];
    }

    self.showRefreshView = YES;
    self.showLoadMoreView = YES;
}

- (void)destroySubViews
{
    [self.dragHeaderView removeFromSuperview];
    self.dragHeaderView = nil;
    
    [self.dragFooterView removeFromSuperview];
    self.dragFooterView = nil;
    
    self.gestureObserver = nil;
}

#pragma mark - Control

- (void)stopRefresh
{
    [self.dragHeaderView endLoading:self shouldUpdateRefreshDate:NO shouldChangeContentInset:YES];
}

- (void)finishRefresh
{
    [self.dragHeaderView endLoading:self shouldUpdateRefreshDate:YES shouldChangeContentInset:YES];
}

- (void)stopLoadMore
{
    [self.dragFooterView endLoading:self shouldChangeContentInset:YES];
}

- (void)finishLoadMore
{
    [self.dragFooterView endLoading:self shouldChangeContentInset:YES];
}

#pragma mark - Trigger

- (void)triggerRefresh
{
    [self.dragHeaderView triggerLoading:self];
}

- (void)triggerLoadMore
{
    [self.dragFooterView triggerLoading:self];
}

@end

#pragma mark - Private Category

@implementation UITableView(DragRefreshAndLoadPrivate)

#pragma mark Property

@dynamic dragHeaderView;
@dynamic dragFooterView;
@dynamic gestureObserver;

- (DragTableHeaderView_ot *)dragHeaderView
{
    return objc_getAssociatedObject(self, DRAG_HEADER_KEY);
}

- (void)setDragHeaderView:(DragTableHeaderView_ot *)dragHeaderView
{
    objc_setAssociatedObject(self, DRAG_HEADER_KEY, dragHeaderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DragTableFooterView_ot *)dragFooterView
{
    return objc_getAssociatedObject(self, DRAG_FOOTER_KEY);
}

- (void)setDragFooterView:(DragTableFooterView_ot *)dragFooterView
{
    objc_setAssociatedObject(self, DRAG_FOOTER_KEY, dragFooterView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DragTableGestureObserver_ot *)gestureObserver
{
    return objc_getAssociatedObject(self, DRAG_GESTURE_OBSERVER_KEY);
}

- (void)setGestureObserver:(DragTableGestureObserver_ot *)gestureObserver
{
    objc_setAssociatedObject(self, DRAG_GESTURE_OBSERVER_KEY, gestureObserver, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark Call Delegate

- (void)callDelegateDidTriggerRefresh
{
    if ([self.dragDelegate respondsToSelector:@selector(dragTableDidTriggerRefresh:)])
    {
        [self.dragDelegate dragTableDidTriggerRefresh:self];
    }
}

- (void)callDelegateDidTriggerLoadMode
{
    if ([self.dragDelegate respondsToSelector:@selector(dragTableDidTriggerLoadMore:)])
    {
        [self.dragDelegate dragTableDidTriggerLoadMore:self];
    }
}

@end

@implementation UITableView (DragLoadUI)

//Sub controls
- (UIActivityIndicatorView *)headerLoadingIndicator
{
    if (self.dragDelegate)
    {
        return self.dragHeaderView.loadingIndicator;
    }
    return nil;
}

- (UIActivityIndicatorView *)footerLoadingIndicator
{
    if (self.dragDelegate)
    {
        return self.dragFooterView.loadingIndicator;
    }
    return nil;
}

- (UILabel *)headerLoadingStatusLabel
{
    if (self.dragDelegate)
    {
        return self.dragHeaderView.loadingStatusLabel;
    }
    return nil;
}

- (UILabel *)headerRefreshDateLabel
{
    if (self.dragDelegate)
    {
        return self.dragHeaderView.refreshDateLabel;
    }
    return nil;
}

- (UILabel *)footerLoadingStatusLabel
{
    if (self.dragDelegate)
    {
        return self.dragFooterView.loadingStatusLabel;
    }
    return nil;
}

- (UIView *)headerBackgroundView
{
    if (self.dragDelegate)
    {
        return self.dragHeaderView.backgroundView;
    }
    return nil;
}

- (UIView *)footerBackgroundView
{
    if (self.dragDelegate)
    {
        return self.dragFooterView.backgroundView;
    }
    return nil;
}

//Texts
- (NSString *)headerPullDownText
{
    return self.dragHeaderView.pullDownText;
}

- (void)setHeaderPullDownText:(NSString *)headerPullDownText
{
    self.dragHeaderView.pullDownText = headerPullDownText;
}

- (NSString *)headerReleaseText
{
    return self.dragHeaderView.releaseText;
}

- (void)setHeaderReleaseText:(NSString *)headerReleaseText
{
    self.dragHeaderView.releaseText = headerReleaseText;
}

- (NSString *)headerLoadingText
{
    return self.dragHeaderView.loadingText;
}

- (void)setHeaderLoadingText:(NSString *)headerLoadingText
{
    self.dragHeaderView.loadingText = headerLoadingText;
}

- (NSString *)footerPullUpText
{
    return self.dragFooterView.pullUpText;
}

- (void)setFooterPullUpText:(NSString *)footerPullUpText
{
    self.dragFooterView.pullUpText = footerPullUpText;
}

- (NSString *)footerReleaseText
{
    return self.dragFooterView.releaseText;
}

- (void)setFooterReleaseText:(NSString *)footerReleaseText
{
    self.dragFooterView.releaseText = footerReleaseText;
}

- (NSString *)footerLoadingText
{
    return self.dragFooterView.loadingText;
}

- (void)setFooterLoadingText:(NSString *)footerLoadingText
{
    self.dragFooterView.loadingText = footerLoadingText;
}

- (NSString *)headerDateFormatText
{
    return self.dragHeaderView.dateFormatterText;
}

- (void)setHeaderDateFormatText:(NSString *)headerDateFormatText
{
    self.dragHeaderView.dateFormatterText = headerDateFormatText;
}

- (NSString *)headerRefreshDateFormatText
{
    return self.dragHeaderView.refreshDateFormatText;
}

- (void)setHeaderRefreshDateFormatText:(NSString *)headerRefreshDateFormatText
{
    self.dragHeaderView.refreshDateFormatText = headerRefreshDateFormatText;
}

@end

