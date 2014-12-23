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

///...
-(void)lk_addObserverWithSEL:(SEL)sel paramsArray:(id)params;
@end
