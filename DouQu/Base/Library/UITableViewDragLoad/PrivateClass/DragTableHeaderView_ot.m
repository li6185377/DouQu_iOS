//
//  DragTableHeaderView_ot.m
//
//  Created by openthread on 02/13/13
//

#import "DragTableHeaderView_ot.h"
#import "DragTableDragState_ot.h"

#define TEXT_COLOR                          [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION             (0.18f)
#define DATE_PERMANENT_STORAGE_KEY_PREFIX   @"DragRefreshTableHeaderView_ot_LastRefresh"

@implementation DragTableHeaderView_ot
{
	DragTableDragState_ot _state;
    BOOL _isLoading;
    NSString *_datePermanentStorageKey;
    NSDate *_lastUpdateDate;
    
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
    
    UIView *_backgroundView;
    
    NSDateFormatter *_dateFormatter;
}
@synthesize isLoading = _isLoading;
@synthesize pullDownText = _pullDownText, releaseText = _releaseText, loadingText = _loadingText;
@synthesize dateFormatterText = _dateFormatterText, refreshDateFormatText = _refreshDateFormatText;

#pragma mark - Text
- (void)setPullDownText:(NSString *)pullDownText
{
    _pullDownText = pullDownText;
    
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

- (void)setRefreshDateFormatText:(NSString *)refreshDateFormatText
{
    _refreshDateFormatText = refreshDateFormatText;
    
    //refresh updated date label immediately
    _lastUpdatedLabel.text = [self stringFromDate:_lastUpdateDate];
}

#pragma mark - UIs
- (UILabel *)loadingStatusLabel
{
    return _statusLabel;
}

- (UILabel *)refreshDateLabel
{
    return _lastUpdatedLabel;
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

- (id)initWithFrame:(CGRect)frame datePermanentStoreKey:(NSString *)datePermanentStoreKey
{
    if (self = [super initWithFrame:frame])
    {
        self.releaseText = @"松开手开始刷新";
        self.pullDownText = @"往下拉刷新数据";
        self.loadingText = @"加载中。。。";
        self.dateFormatterText = @"yyyy年MM月dd日 HH:mm:ss";
        self.refreshDateFormatText = @"最后更新时间: %@";
        
        _isLoading = NO;
        _datePermanentStorageKey = [DATE_PERMANENT_STORAGE_KEY_PREFIX stringByAppendingString:datePermanentStoreKey];
        _lastUpdateDate = [self getStoredRefreshDate];
        self.shouldShowDate = YES;
        
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        
        _lastUpdatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		_lastUpdatedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_lastUpdatedLabel.font = [UIFont systemFontOfSize:12.0f];
		_lastUpdatedLabel.textColor = TEXT_COLOR;
		_lastUpdatedLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		_lastUpdatedLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		_lastUpdatedLabel.backgroundColor = [UIColor clearColor];
        _lastUpdatedLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lastUpdatedLabel];
		
		_statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
		_statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
		_statusLabel.textColor = TEXT_COLOR;
		_statusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		_statusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		_statusLabel.backgroundColor = [UIColor clearColor];
		_statusLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:_statusLabel];
				
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_activityView.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
		[self addSubview:_activityView];
        
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        [self insertSubview:_backgroundView atIndex:0];
		
		[self setState:DragTableDragStateNormal_ot];
        
        [self adjustSubviewsFrame];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self adjustSubviewsFrame];
}

- (void)adjustSubviewsFrame
{
    CGRect frame = self.frame;
    _lastUpdatedLabel.frame = CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f);
    _statusLabel.frame = CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f);
    _arrowImage.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
    _activityView.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate
{
	if (self.shouldShowDate)
    {
        if (_lastUpdateDate)
        {
            _lastUpdatedLabel.text = [self stringFromDate:_lastUpdateDate];
            [self storeRefreshDate:_lastUpdateDate];
        }
	}
    else
    {
		_lastUpdatedLabel.text = nil;
	}
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
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
        }
			break;
		case DragTableDragStateNormal_ot:
        {
			if (_state == DragTableDragStatePulling_ot)
            {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			_statusLabel.text = self.pullDownText;
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			[self refreshLastUpdatedDate];
        }
			break;
		case DragTableDragStateLoading_ot:
        {
			_statusLabel.text = self.loadingText;
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = YES;
			[CATransaction commit];
        }
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)dragTableDidScroll:(UIScrollView *)scrollView
{
    if (_state != DragTableDragStateLoading_ot && scrollView.isDragging)
    {
		BOOL _loading = _isLoading;
		if (_state == DragTableDragStatePulling_ot && scrollView.contentOffset.y > REFRESH_TRIGGER_HEIGHT && scrollView.contentOffset.y < 0.0f && !_loading)
        {
			[self setState:DragTableDragStateNormal_ot];
		}
        else if (_state == DragTableDragStateNormal_ot && scrollView.contentOffset.y < REFRESH_TRIGGER_HEIGHT && !_loading)
        {
			[self setState:DragTableDragStatePulling_ot];
		}
	}
}

- (void)dragTableDidEndDragging:(UIScrollView *)scrollView
{
	BOOL _loading = _isLoading;
	if (scrollView.contentOffset.y <= REFRESH_TRIGGER_HEIGHT && !_loading)
    {
		if ([_delegate respondsToSelector:@selector(dragTableHeaderDidTriggerRefresh:)])
        {
			[_delegate dragTableHeaderDidTriggerRefresh:self];
            _isLoading = YES;
		}
		[self setState:DragTableDragStateLoading_ot];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		scrollView.contentInset = UIEdgeInsetsMake(-REFRESH_TRIGGER_HEIGHT, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
	}
}

- (void)triggerLoading:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, REFRESH_TRIGGER_HEIGHT)];
    [self dragTableDidEndDragging:scrollView];
}

//Prevent animation conflict when loadmore triggerd. Pass `NO` to `shouldChangeContentInset` when loadmore triggered.
- (void)endLoading:(UIScrollView *)scrollView shouldUpdateRefreshDate:(BOOL)shouldUpdate shouldChangeContentInset:(BOOL)shouldChangeContentInset
{
    if (_isLoading)
    {
        if (shouldChangeContentInset)
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
            [UIView commitAnimations];
        }
        
        _isLoading = NO;
    }
    
    if (shouldUpdate)
    {
        _lastUpdateDate = [NSDate date];
    }
	[self setState:DragTableDragStateNormal_ot];
}

- (NSString *)stringFromDate:(NSDate *)date
{
    if (!date)
    {
        return @"";
    }
    
    if (!_dateFormatter)
    {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:self.dateFormatterText];
    }
    
    return [NSString stringWithFormat:self.refreshDateFormatText, [_dateFormatter stringFromDate:date]];
}

- (void)setDateFormatterText:(NSString *)dateFormatterText
{
    _dateFormatterText = dateFormatterText;
    if (_dateFormatter)
    {
        [_dateFormatter setDateFormat:dateFormatterText];
    }
    
    //refresh updated date label immediately
    _lastUpdatedLabel.text = [self stringFromDate:_lastUpdateDate];
}

- (NSDate *)getStoredRefreshDate
{
    if (!_datePermanentStorageKey)
    {
        return nil;
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:_datePermanentStorageKey];
}

- (BOOL)storeRefreshDate:(NSDate *)date
{
    if (!_datePermanentStorageKey)
    {
        return NO;
    }
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:_datePermanentStorageKey];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
