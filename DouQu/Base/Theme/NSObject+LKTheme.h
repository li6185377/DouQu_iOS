//
//  NSObject+LKTheme.h
//  DouQu
//
//  Created by ljh on 14/12/17.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LKTheme)

///当皮肤变更的时候  自动去执行保存的 sel
-(void)lk_sendThemeChangedToObservers;

/**
 *  @brief  给object 添加皮肤切换时 自动执行的方法
 *
 *  @param sel    方法
 *  @param params 参数集合
 */
-(void)lk_addObserverWithSEL:(SEL)sel paramsArray:(id)params;

///可以给sel 加上不同的 缓存名
-(void)lk_addObserverWithSEL:(SEL)sel paramsArray:(id)params appendKey:(id)key;
@end
