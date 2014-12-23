//
//  UIView+LKRelativeLayout.m
//  Hebao_Ipad
//
//  Created by LK on 13-3-19.
//  Copyright (c) 2013年 Jianghuai Li. All rights reserved.
//
#import "UIView+LK.h"

@implementation UIView (LKRelativeLayout)
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
- (void)toTopOf:(UIView *)view margin:(float)margin
{
    self.bottom = view.top - margin;
}

- (void)toBottomOf:(UIView *)view margin:(float)margin
{
    self.top = view.bottom + margin;
}

- (void)toLeftOf:(UIView *)view margin:(float)margin
{
    self.right = view.left - margin;
}

- (void)toRightOf:(UIView *)view margin:(float)margin
{
    self.left = view.right + margin;
}

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
- (void)alignTop:(UIView *)view margin:(float)margin
{
    self.top = view.top - margin;
}

- (void)alignBottom:(UIView *)view margin:(float)margin
{
    self.bottom = view.bottom + margin;
}

- (void)alignLeft:(UIView *)view margin:(float)margin
{
    self.left = view.left - margin;
}

- (void)alignRight:(UIView *)view margin:(float)margin
{
    self.right = view.right + margin;
}

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
+ (void)centerHorizontal:(UIView *)views, ...
{
    if (views == nil)
        return;
    va_list list;
    va_start(list, views);

    UIView *first = views;
    UIView *view;
    while ((view = va_arg(list, UIButton*)))
    {
        view.centerX = first.centerX;
    }
    va_end(list);
}

+ (void)centerVertical:(UIView *)views, ...
{
    if (views == nil)
        return;

    va_list list;
    va_start(list, views);

    UIView *first = views;
    UIView *view;
    while ((view = va_arg(list, UIButton*)))
    {
        view.centerY = first.centerY;
    }
    va_end(list);
}

// 0 左到右   1 右到左  2 上到下  3 下到上
+ (void)sortViewWithDirection:(int)direction space:(float)space views:(UIView *)views, ...
{
    if (views == nil)
        return;
    
    float lastPosition = 0;
    va_list list;
    va_start(list, views);

    UIView *first = views;
    UIView *view;
    while ((view = va_arg(list, UIButton*)))
    {
        if (lastPosition != 0)
        {
            [view sizeToFit];
            switch (direction)
            {
                case 0:
                {
                    view.centerY = first.centerY;
                    view.left = lastPosition + space;
                    lastPosition = view.right;
                }
                    break;
                case 1:
                {
                    view.centerY = first.centerY;
                    view.right = lastPosition - space;
                    lastPosition = view.left;
                }
                    break;
                case 2:
                {
                    view.centerX = first.centerX;
                    view.top = lastPosition + space;
                    lastPosition = view.bottom;
                }
                    break;
                case 3:
                {
                    view.centerX = first.centerX;
                    view.bottom = lastPosition - space;
                    lastPosition = view.top;
                }
                    break;
            }
        }
        else
        {
            switch (direction)
            {
                case 0:
                {
                    lastPosition = view.right;
                }
                    break;
                case 1:
                {
                    lastPosition = view.left;
                }
                    break;
                case 2:
                {
                    lastPosition = view.bottom;
                }
                    break;
                case 3:
                {
                    lastPosition = view.top;
                }
                    break;
            }
        }
    }
    va_end(list);
}
@end


@implementation UIView (LKLayout)
/*--------------------------------------------------------------------*/
- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x
{
    CGRect frame = self.frame;
    if(frame.origin.x != x)
    {
        frame.origin.x = x;
        self.frame = frame;
    }
}

/*--------------------------------------------------------------------*/
- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y
{
    CGRect frame = self.frame;
    if(frame.origin.y != y)
    {
        frame.origin.y = y;
        self.frame = frame;
    }
}

/*--------------------------------------------------------------------*/
- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    CGFloat newRight = right - frame.size.width;
    if(frame.origin.x != newRight)
    {
        frame.origin.x = newRight;
        self.frame = frame;
    }
}

/*--------------------------------------------------------------------*/
- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    CGFloat newBottom = bottom - frame.size.height;
    if(frame.origin.y != newBottom)
    {
        frame.origin.y = newBottom;
        self.frame = frame;
    }
}

/*--------------------------------------------------------------------*/
- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    if(center.x != centerX)
    {
        center.x = centerX;
        self.center = center;
    }
}

/*--------------------------------------------------------------------*/
- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    if(center.y != centerY)
    {
        center.y = centerY;
        self.center = center;
    }
}

/*--------------------------------------------------------------------*/
- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    if (isnan(width))
    {
        width = 0;
    }
    CGRect frame = self.frame;
    if(frame.size.width != width)
    {
        frame.size.width = width;
        self.frame = frame;
    }
}

/*--------------------------------------------------------------------*/

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    if (isnan(height))
    {
        height = 0;
    }
    CGRect frame = self.frame;
    if(frame.size.height != height)
    {
        frame.size.height = height;
        self.frame = frame;
    }
}

/*--------------------------------------------------------------------*/
- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    if(CGSizeEqualToSize(frame.size, size) == NO)
    {
        frame.size = size;
        self.frame = frame;
    }
}

/*--------------------------------------------------------------------*/

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    if(CGPointEqualToPoint(frame.origin, origin) == NO)
    {
        frame.origin = origin;
        self.frame = frame;
    }
}

/*--------------------------------------------------------------------*/
- (void)removeAllSubviews
{
    NSArray *array = self.subviews;
    for (UIView *subview in array)
    {
        [subview removeFromSuperview];
    }
}

- (UIViewController *)viewController
{
    for (UIView *next = [self superview]; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *) nextResponder;
        }
    }
    return nil;
}
@end

@implementation UIView (LKFind)
- (id)findViewParentWithClass:(Class)clazz
{
    if ([self isKindOfClass:clazz])
    {
        return self;
    }
    UIView *view = self.superview;
    while (view && ![view isKindOfClass:clazz])
    {
        view = view.superview;
    }
    return view;
}
@end

@implementation UIView(LKClipCircle)
-(void)setIsShowInscribedCircle:(BOOL)isShowInscribedCircle
{
#ifdef __IPHONE_8_1
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.width/2;
#else
    CAShapeLayer *maskLayer = (id)self.layer.mask;
    if(isShowInscribedCircle)
    {
        if(maskLayer==nil)
        {
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.fillColor = [UIColor blackColor].CGColor;
            
            CGMutablePathRef pathRef = CGPathCreateMutable();
            CGPathAddEllipseInRect(pathRef, NULL, self.bounds);
            maskLayer.path = pathRef;
            CGPathRelease(pathRef);
            
            maskLayer.frame = self.bounds;
            self.layer.mask = maskLayer;
        }
    }
    else
    {
        [maskLayer removeFromSuperlayer];
    }
#endif
}
-(BOOL)isShowInscribedCircle
{
#ifdef __IPHONE_8_1
    if(self.layer.cornerRadius > 0)
    {
        return YES;
    }
#else
    if([self.layer.mask isKindOfClass:nil])
    {
        return YES;
    }
#endif
    return NO;
}

@end

@implementation LKViewEX
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.extendTouchRange = 15;
}
-(void)setExtendTouchRange:(float)extendTouchRange
{
    _extendTouchRange = extendTouchRange;
    _extendTouchRangeX = _extendTouchRange;
    _extendTouchRangeY = _extendTouchRange;
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect bounds = self.bounds;
    bounds.origin = CGPointMake(-_extendTouchRangeX,-_extendTouchRangeY);
    bounds.size = CGSizeMake(bounds.size.width + _extendTouchRangeX * 2, bounds.size.height+ _extendTouchRangeY * 2);
    return CGRectContainsPoint(bounds, point);
}
@end