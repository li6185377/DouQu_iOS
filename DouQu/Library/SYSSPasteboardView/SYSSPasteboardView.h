//
//  SYSSPasteboardView.h
//  LJH
//
//  Created by ljh on 14-7-21.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYSSPasteboardView : UIView
+(instancetype)shareInstance;
-(void)showMenuWithView:(UIView*)view inView:(UIView*)inView;
-(void)showMenuWithView:(UIView*)view inView:(UIView*)inView inRect:(CGRect)rect;

@property(copy,nonatomic)NSString* pasteCopyString;
///复制
@property(copy,nonatomic)void(^pasteCopyBlock)(void);
///删除
@property(copy,nonatomic)void(^pasteDeleteBlock)(void);
///收藏
@property(copy,nonatomic)void(^pasteCollectionBlock)(void);
///举报
@property(copy,nonatomic)void(^pasteReportBlock)(void);
@end