//
//  SYSSPasteboardView.m
//  LJH
//
//  Created by ljh on 14-7-21.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import "SYSSPasteboardView.h"


@implementation SYSSPasteboardView
-(void)showMenuWithView:(UIView *)view inView:(UIView *)inView
{
    CGRect point = [view convertRect:view.bounds toView:inView];
    [self showMenuWithView:view inView:inView inRect:point];
}
-(void)showMenuWithView:(UIView *)view inView:(UIView *)inView inRect:(CGRect)rect
{
    [view addSubview:self];
    [self becomeFirstResponder];
    
    NSMutableArray* menus = [NSMutableArray array];
    if (_pasteCopyBlock || _pasteCopyString) {
        UIMenuItem* menu = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(sy_copy:)];
        [menus addObject:menu];
    }
    if (_pasteDeleteBlock) {
        UIMenuItem* menu = [[UIMenuItem alloc]initWithTitle:@"删除" action:@selector(sy_delete:)];
        [menus addObject:menu];
    }
    if (_pasteCollectionBlock) {
        UIMenuItem* menu = [[UIMenuItem alloc]initWithTitle:@"收藏" action:@selector(sy_collection:)];
        [menus addObject:menu];
    }
    if (_pasteReportBlock) {
        UIMenuItem* menu = [[UIMenuItem alloc]initWithTitle:@"举报" action:@selector(sy_report:)];
        [menus addObject:menu];
    }
    
    UIMenuController * menuController = [UIMenuController sharedMenuController];
    menuController.menuItems = menus;
    [menuController setTargetRect:rect inView:inView];
    [menuController setMenuVisible:YES animated:YES];
}
+(instancetype)shareInstance
{
    static SYSSPasteboardView* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
        instance.hidden = YES;
        [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(clearPropertys) name:UIMenuControllerDidHideMenuNotification object:nil];
    });
    return instance;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)clearPropertys
{
    _pasteCopyBlock = nil;
    _pasteCopyString = nil;
    _pasteDeleteBlock = nil;
    _pasteCollectionBlock = nil;
    _pasteReportBlock = nil;
}
-(BOOL)canBecomeFirstResponder
{
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    BOOL result = NO;
    if(action == @selector(sy_copy:))
    {
        result = YES;
    }
    if(action == @selector(sy_delete:))
    {
        result = YES;
    }
    if(action == @selector(sy_collection:))
    {
        result = YES;
    }
    if(action == @selector(sy_report:))
    {
        result = YES;
    }
    return result;
}
-(void)sy_report:(id)sender
{
    if(_pasteReportBlock)
    {
        _pasteReportBlock();
        _pasteReportBlock = nil;
    }
}
-(void)sy_collection:(id)sender
{
    if(_pasteCollectionBlock)
    {
        _pasteCollectionBlock();
        _pasteCollectionBlock = nil;
    }
}
-(void)sy_copy:(id)sender{
    if(_pasteCopyBlock)
    {
        _pasteCopyBlock();
        _pasteCopyBlock = nil;
    }
    else if(_pasteCopyString)
    {
        UIPasteboard* board = [UIPasteboard generalPasteboard];
        board.string = _pasteCopyString;
        _pasteCopyString = nil;
    }
}
-(void)sy_delete:(id)sender
{
    if(_pasteDeleteBlock)
    {
        _pasteDeleteBlock();
        _pasteDeleteBlock = nil;
    }
}
@end