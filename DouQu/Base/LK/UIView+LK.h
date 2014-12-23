//
//  UIView+LKRelativeLayout.h
//  Hebao_Ipad
//
//  Created by LK on 13-3-19.
//  Copyright (c) 2013年 Jianghuai Li. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 toTopOf        将该控件的底部置于给定ID的控件之上;
    
 toBottomOf     将该控件的顶部置于给定ID的控件之下;
 
 toLeftOf       将该控件的右边缘与给定ID的控件左边缘对齐;
 
 toRightOf      将该控件的左边缘与给定ID的控件右边缘对齐;
 
 
 
 alignTop       将该控件的顶部边缘与给定ID的顶部边缘对齐;
 
 alignBottom    将该控件的底部边缘与给定ID的底部边缘对齐;
 
 alignLeft      将该控件的左边缘与给定ID的左边缘对齐;
 
 alignRight     将该控件的右边缘与给定ID的右边缘对齐;
 */

@interface UIView (LKRelativeLayout)
-(void)alignTop:(UIView*)view margin:(float)margin;
-(void)alignBottom:(UIView*)view margin:(float)margin;
-(void)alignLeft:(UIView*)view margin:(float)margin;
-(void)alignRight:(UIView*)view margin:(float)margin;

-(void)toTopOf:(UIView*)view margin:(float)margin;
-(void)toBottomOf:(UIView*)view margin:(float)margin;
-(void)toLeftOf:(UIView*)view margin:(float)margin;
-(void)toRightOf:(UIView*)view margin:(float)margin;

+(void)centerVertical:(UIView*)views,...;
+(void)centerHorizontal:(UIView*)views,...;

// 0 左到右   1 右到左  2 上到下  3 下到上
+(void)sortViewWithDirection:(int)direction space:(float)space views:(UIView*)views,...;
@end

//布局属性
@interface UIView(LKLayout)
@property (nonatomic) CGFloat left;

@property (nonatomic) CGFloat top;

@property (nonatomic) CGFloat right;

@property (nonatomic) CGFloat bottom;

@property (nonatomic) CGFloat width;

@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat centerX;

@property (nonatomic) CGFloat centerY;

@property (nonatomic) CGPoint origin;

@property (nonatomic) CGSize size;

-(void)removeAllSubviews;
-(UIViewController*)viewController;
@end


@interface UIView(LKFind)
-(id)findViewParentWithClass:(Class)clazz;
@end

@interface UIView(LKClipCircle)
@property BOOL isShowInscribedCircle;
@end

//点击区域扩大UIView
@interface LKViewEX : UIView
@property(nonatomic) float extendTouchRange;
@property(nonatomic) float extendTouchRangeX;
@property(nonatomic) float extendTouchRangeY;
@end

