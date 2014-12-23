//
//  UIView+DQ.h
//  DouQu
//
//  Created by ljh on 14/12/15.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DQ)
-(void)showLineForRow:(NSInteger)row leftMargin:(NSInteger)margin rowCount:(NSInteger)rowCount;
-(UIImageView*)topLineView:(BOOL)create;
-(UIImageView*)bottomLineView:(BOOL)create;
@end
