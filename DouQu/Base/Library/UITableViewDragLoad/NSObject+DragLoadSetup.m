//
//  NSObject+DragLoadSetup.m
//  DouQu
//
//  Created by ljh on 14/12/14.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import "NSObject+DragLoadSetup.h"
#import "LKLanguageManager.h"

@implementation NSObject (DragLoadSetup)

-(void)dragTableDidTriggerRefresh:(UITableView *)tableView{}
-(void)dragTableDidTriggerLoadMore:(UITableView *)tableView{}

- (void)setupRefreshAndLoadMore:(UITableView *)tableView
{
    tableView.backgroundColor = [UIColor clearColor];
    [tableView setDragDelegate:(id <UITableViewDragLoadDelegate>) self refreshDatePermanentKey:NSStringFromClass(self.class)];
    [self setupRefresh:tableView];
    [self setupLoadMore:tableView];
}

- (void)setupLoadMore:(UITableView *)tableView
{
    [tableView setDragDelegate:(id <UITableViewDragLoadDelegate>) self refreshDatePermanentKey:NSStringFromClass(self.class)];
    tableView.footerPullUpText = LK_STR(@"上拉可以加载更多");
    tableView.footerLoadingText = LK_STR(@"正在加载更多");
    tableView.footerReleaseText = LK_STR(@"松开手指，立即加载更多");
    tableView.footerLoadingStatusLabel.font = [UIFont systemFontOfSize:11];
    [tableView.footerLoadingStatusLabel lk_setTextColorForKey:colorWithTextGrayKey];
    tableView.footerLoadingStatusLabel.shadowColor = [UIColor clearColor];
    
    UIView *footerView = [tableView.footerLoadingStatusLabel findViewParentWithClass:NSClassFromString(@"DragTableFooterView_ot")];
    if (footerView)
    {
        footerView.backgroundColor = [UIColor clearColor];
    }
    tableView.showLoadMoreView = YES;
}

- (void)setupRefresh:(UITableView *)tableView
{
    [tableView setDragDelegate:(id <UITableViewDragLoadDelegate>) self refreshDatePermanentKey:NSStringFromClass(self.class)];
    
    UIView *headerView = [tableView.headerLoadingStatusLabel findViewParentWithClass:NSClassFromString(@"DragTableHeaderView_ot")];
    if (headerView)
    {
        headerView.backgroundColor = [UIColor clearColor];
    }
    tableView.headerPullDownText = LK_STR(@"下拉可以刷新哦");
    tableView.headerReleaseText = LK_STR(@"松开手指，开始刷新");
    tableView.headerLoadingText = LK_STR(@"正在刷新，稍后哦");
    tableView.headerLoadingStatusLabel.font = [UIFont systemFontOfSize:11];
    tableView.headerRefreshDateLabel.font = [UIFont systemFontOfSize:11];
    
    [tableView.headerLoadingStatusLabel lk_setTextColorForKey:colorWithTextGrayKey];
    tableView.headerLoadingStatusLabel.shadowColor = [UIColor clearColor];
    [tableView.headerRefreshDateLabel lk_setTextColorForKey:colorWithTextGrayKey];
    tableView.headerRefreshDateLabel.shadowColor = [UIColor clearColor];
    
    tableView.showLoadMoreView = NO;
}
@end
