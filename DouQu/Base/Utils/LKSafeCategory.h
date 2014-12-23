//
//  LKSafeCategory.h
//  Jianghuai Li
//
//  Created by LK on 13-10-14.
//  Copyright (c) 2013年 Jianghuai Li. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @brief  解决nsarray 数据越界
 */
@interface NSObject (LKSafeCategory)
+(void)lk_callSafeCategory;
@end

///copy 了 JRSwizzle 的代码
@interface NSObject (LK_Swizzle)
+ (BOOL)jr_swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError**)error_;
+ (BOOL)jr_swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_ error:(NSError**)error_;
@end