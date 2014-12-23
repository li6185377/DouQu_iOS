//
//  DragRefreshTableFooterView_ot.m
//  LoadMore
//
//  Created by openthread on 2/12/13.
//  Copyright (c) 2013 CannonInc. All rights reserved.
//

#import "DragTableFooterView_ot.h"
#import "DragTableDragState_ot.h"

#define TEXT_COLOR                          [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION             (0.18f)

@implementation DragTableFooterView_ot
{
	DragTableDragState_ot _state;
    BOOL _isLoading;
    
	UILabel *_statusLabel;
	UIActivityIndicatorView *_activityView;
    
    UIView *_backgroundView;
}
@synthesize isLoading = _isLoading;
@synthesize pullUpText = _pullUpText, releaseText = _releaseText, loadingText = _loadingText;

#pragma mark - Text
- (void)setPullUpText:(NSString *)pullUpText
{
    _pullUpText = pullUpText;
    
    //refresh status label immediately
    self.state = self.state;
}

- (void)setReleaseText:(NSString *)releaseText
{
    _releaseText = releaseText;
    
    //refresh status label immediately
    self.state = self.state;
}

- (void)setLoadingText:(NSString *)loadingText
{
    _loadingText = loadingText;
    
    //refresh status label immediately
    self.state = self.state;
}

#pragma mark - UIs
- (UILabel *)loadingStatusLabel
{
    return _statusLabel;
}

- (UIActivityIndicatorView *)loadingIndicator
{
    return _activityView;
}

- (UIView *)backgroundView
{
    return _backgroundView;
}

#pragma mark - Events

- (CGFloat)footerVisbleHeightInScrollView:(UIScrollView *)scrollView
{
    return CGRectGetHeight(scrollView.frame) - (CGRectGetMinY(self.frame) - scrollView.contentOffset.y);
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.releaseText = @"松开手开始加载";
        self.pullUpText = @"往上拉加载更多";
        self.loadingText = @"加载中。。。";
        
        _isLoading = NO;
        
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        
		_statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 12.0f, self.frame.size.width, 20.0f)];
		_statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
		_statusLabel.textColor = TEXT_COLOR;
		_statusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		_statusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		_statusLabel.backgroundColor = [UIColor clearColor];
		_statusLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:_statusLabel];
		
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_activityView.frame = CGRectMake(25.0f, 10.0f, 20.0f, 20.0f);
		[self addSubview:_activityView];
        
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        [self insertSubview:_backgroundView atIndex:0];
		
		[self setState:DragTableDragStateNormal_ot];
    }
    return self;
}

- (DragTableDragState_ot)state
{
    return _state;
}

- (void)setState:(DragTableDragState_ot)aState
{
	switch (aState)
    {
		case DragTableDragStatePulling_ot:
        {
			_statusLabel.text = self.releaseText;
        }
			break;
		case DragTableDragStateNormal_ot:
        {
			_statusLabel.text = self.pullUpText;
			[_activityView stopAnimating];
        }
			break;
		case DragTableDragStateLoading_ot:
        {
			_statusLabel.text = self.loadingText;
			[_activityView startAnimating];
        }
			break;
		default:
			break;
	}
	_state = aState;
}

- (void)dragTableDidScroll:(UIScrollView *)scrollView
{
    if (_state != DragTableDragStateLoading_ot && scrollView.isDragging)
    {
		BOOL _loading = _isLoading;
		if (_state == DragTableDragStatePulling_ot && [self footerVisbleHeightInScrollView:scrollView] < LOADMORE_TRIGGER_HEIGHT && !_loading)
        {
			[self setState:DragTableDragStateNormal_ot];
		}
        else if (_state == DragTableDragStateNormal_ot && [self footerVisbleHeightInScrollView:scrollView] > LOADMORE_TRIGGER_HEIGHT && !_loading)
        {
			[self setState:DragTableDragStatePulling_ot];
		}
	}
}

- (void)dragTableDidEndDragging:(UIScrollView *)scrollView
{
	BOOL _loading = _isLoading;
    CGFloat footerVisibleHeight = [self footerVisbleHeightInScrollView:scrollView];
	if (footerVisibleHeight >= LOADMORE_TRIGGER_HEIGHT && !_loading)
    {
		if ([_delegate respondsToSelector:@selector(dragTableFooterDidTriggerLoadMore:)])
        {
			[_delegate dragTableFooterDidTriggerLoadMore:self];
            _isLoading = YES;
		}
		[self setState:DragTableDragStateLoading_ot];
        
        CGFloat contentInsetHeightAdder = scrollView.frame.size.height - scrollView.contentSize.height;
        contentInsetHeightAdder = MAX(0, contentInsetHeightAdder);
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, LOADMORE_TRIGGER_HEIGHT + contentInsetHeightAdder, 0.0f);
		[UIView commitAnimations];
	}
}

- (void)triggerLoading:(UIScrollView *)scrollView
{
    // by ivan 大神修改 https://github.com/dcty
    //    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, LOADMORE_TRIGGER_HEIGHT)];
    //    [self dragTableDidEndDragging:scrollView];
    //原来的代码只有上面两句，第一句本身就是一个bug，第二句因为高度不满足条件并不会出发委托，所以这个方法的原来两句代码基本残废。
    //下面是自己修改后的代码
    //如果不在加载更多，则尝试触发委托，然后改变状态为正在加载更多
    if (!_isLoading)
    {
        if ([_delegate respondsToSelector:@selector(dragTableFooterDidTriggerLoadMore:)])
        {
            [_delegate dragTableFooterDidTriggerLoadMore:self];
            _isLoading = YES;
        }
        [self setState:DragTableDragStateLoading_ot];
    }
}

//Prevent animation conflict when refresh triggerd. Pass `NO` to `shouldChangeContentInset` when refresh triggered.
- (void)endLoading:(UIScrollView *)scrollView shouldChangeContentInset:(BOOL)shouldChangeContentInset
{
    if (_isLoading)
    {
        if (shouldChangeContentInset)
        {
            NSString *edgeInsetString = NSStringFromUIEdgeInsets(UIEdgeInsetsZero);
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 scrollView, @"scrollView",
                                 edgeInsetString, @"edgeInset",
                                 nil];
            [self performSelector:@selector(setScrollViewContentInset:) withObject:dic afterDelay:0];
        }
        _isLoading = NO;
    }
	[self setState:DragTableDragStateNormal_ot];
}

//For set `contentInset` with delay usage.
//Prevent call [table reloadData] and `endLoading:shouldChangeContentInset:` at the same runloop.
//If [table reloadData] and [table setContentInset"] at the same runloop, `contentOffset` behaves strangely.
- (void)setScrollViewContentInset:(NSDictionary *)dic
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    UIScrollView *scrollView = dic[@"scrollView"];
    NSString *edgeInsetString = dic[@"edgeInset"];
    UIEdgeInsets edgeInset = UIEdgeInsetsFromString(edgeInsetString);
    [scrollView setContentInset:edgeInset];
    [UIView commitAnimations];
}

@end
