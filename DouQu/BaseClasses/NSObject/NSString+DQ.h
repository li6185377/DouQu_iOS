//
//  NSString+DQ.h
//  DouQu
//
//  Created by ljh on 14/12/17.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import <Foundation/Foundation.h>

extern CGSize dq_sizeWithImageSize(CGSize imageSize,CGSize maxSize);

@interface NSString (DQ)
-(CGSize)lastComponentImageSize;
-(CGSize)lastComponentOriginalImageSize;
@end
