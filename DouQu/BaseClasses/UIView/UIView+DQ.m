//
//  UIView+DQ.m
//  DouQu
//
//  Created by ljh on 14/12/15.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import "UIView+DQ.h"

@implementation UIView (DQ)
-(void)showLineForRow:(NSInteger)row leftMargin:(NSInteger)margin rowCount:(NSInteger)rowCount
{
    if (rowCount == 1)
    {
        [self topLineView:YES].left = margin;
        [self bottomLineView:YES].left = margin;
    }
    else
    {
        if(row == 0)
        {
            [self topLineView:YES].left = 0;
            [self bottomLineView:YES].left = margin;
        }
        else if(row == rowCount - 1)
        {
            [[self topLineView:NO] removeFromSuperview];
            [self bottomLineView:YES].left = 0;
        }
        else
        {
            [[self topLineView:NO] removeFromSuperview];
            [self bottomLineView:YES].left = margin;
        }
    }
}
-(UIImageView *)topLineView:(BOOL)create
{
    int topViewTag = 51511;
    UIImageView *line = (UIImageView *) [self viewWithTag:topViewTag];
    if(line == nil && create)
    {
        line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1)];
        line.tag = topViewTag;
        [line lk_setImageForKey:@"all_lineone" stretch:CGPointMake(0.5, 0.5)];
        line.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
        [self addSubview:line];
    }
    if (line)
    {
        [self bringSubviewToFront:line];
    }
    return line;
}
-(UIImageView *)bottomLineView:(BOOL)create
{
    int bottomViewTag = 51513;
    UIImageView *line = (UIImageView *) [self viewWithTag:bottomViewTag];
    if(line == nil && create)
    {
        line = [[UIImageView alloc] initWithFrame:CGRectMake(0,self.height-1, self.width, 1)];
        line.tag = bottomViewTag;
        [line lk_setImageForKey:@"all_lineone" stretch:CGPointMake(0.5, 0.5)];
        line.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        [self addSubview:line];
    }
    if (line)
    {
        [self bringSubviewToFront:line];
    }
    return line;
}
@end
