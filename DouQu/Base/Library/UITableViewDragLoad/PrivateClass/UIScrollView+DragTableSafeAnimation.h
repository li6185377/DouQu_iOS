//
//  UITableView+DragTableSafeAnimation.h
//  LoadMore
//
//  Created by openthread on 2/14/13.
//  Copyright (c) 2013 CannonInc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (DragTableSafeAnimation)

- (void)dragTableSafeAnimationForSetContentInsets:(UIEdgeInsets)contentInsets;

@end
