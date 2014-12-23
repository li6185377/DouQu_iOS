//
//  NSObject+DragLoadSetup.h
//  DouQu
//
//  Created by ljh on 14/12/14.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UITableView+DragLoad.h"

@interface NSObject (DragLoadSetup)
- (void)setupRefreshAndLoadMore:(UITableView *)tableView;
- (void)setupLoadMore:(UITableView *)tableView;
- (void)setupRefresh:(UITableView *)tableView;

- (void)dragTableDidTriggerRefresh:(UITableView *)tableView;
- (void)dragTableDidTriggerLoadMore:(UITableView *)tableView;
@end
