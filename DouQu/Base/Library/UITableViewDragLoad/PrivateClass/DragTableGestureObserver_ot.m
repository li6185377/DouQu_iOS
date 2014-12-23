//
//  DragRefreshTableGestureObserver_ot.m
//  LoadMore
//
//  Created by openthread on 2/12/13.
//  Copyright (c) 2013 CannonInc. All rights reserved.
//

#import "DragTableGestureObserver_ot.h"

@implementation DragTableGestureObserver_ot
{
    __unsafe_unretained id<DragTableGestureObserverDelegate_ot> _delegate;
    __unsafe_unretained UITableView *_tableView;
}

- (id)initWithObservingTableView:(UITableView *)tableView delegate:(id<DragTableGestureObserverDelegate_ot>)delegate
{
    self = [super init];
    if (self)
    {
        _tableView = tableView;
        _delegate = delegate;
        
        [_tableView addObserver:self forKeyPath:@"pan.state" options:NSKeyValueObservingOptionNew context:nil];
        [_tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [_tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        [_tableView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"pan.state"])
    {
        UIGestureRecognizerState newState = [change[@"new"] intValue];
        if ([_delegate respondsToSelector:@selector(dragTableGestureStateWillChangeTo:observer:)])
        {
            [_delegate dragTableGestureStateWillChangeTo:newState observer:self];
        }
    }
    else if ([keyPath isEqualToString:@"contentOffset"])
    {
        NSValue *pointValue = change[@"new"];
        NSValue *oldPointValue = change[@"old"];
        if (![pointValue isEqualToValue:oldPointValue])
        {
            CGPoint point = [pointValue CGPointValue];
            if ([_delegate respondsToSelector:@selector(dragTableContentOffsetWillChangeTo:observer:)])
            {
                [_delegate dragTableContentOffsetWillChangeTo:point observer:self];
            }
        }
    }
    else if ([keyPath isEqualToString:@"contentSize"])
    {
        NSValue *pointValue = change[@"new"];
        CGSize contentSize = [pointValue CGSizeValue];
        if ([_delegate respondsToSelector:@selector(dragTableContentSizeWillChangeTo:observer:)])
        {
            [_delegate dragTableContentSizeWillChangeTo:contentSize observer:self];
        }
    }
    else if ([keyPath isEqualToString:@"frame"])
    {
        NSValue *rectValue = change[@"new"];
        CGRect rect = [rectValue CGRectValue];
        if ([_delegate respondsToSelector:@selector(dragTableFrameWillChangeTo:observer:)])
        {
            [_delegate dragTableFrameWillChangeTo:rect observer:self];
        }
    }
}

- (void)dealloc
{
    [_tableView removeObserver:self forKeyPath:@"pan.state"];
    [_tableView removeObserver:self forKeyPath:@"contentOffset"];
    [_tableView removeObserver:self forKeyPath:@"contentSize"];
    [_tableView removeObserver:self forKeyPath:@"frame"];
}

@end
