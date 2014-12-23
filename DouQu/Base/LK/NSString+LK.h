//
//  NSString+LK.h
//  LJHV2
//
//  Created by LK on 13-7-4.
//  Copyright (c) 2013年 LJH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LK)
//16进制byty字符串 转成  NSData
-(NSData *)convert16ByteData;

// 判断字符串为空或只为空格
+(BOOL)isBlankString:(NSString *)string;

+(BOOL)checkEmailWithComponent:(NSString*)email; //判断邮箱是否合法的代码   拆分验证
+(BOOL)checkEmailWithRegex:(NSString *)email;    //正则表达式检测邮箱
+(BOOL)checkQQNumberWithRegex:(NSString*)qq;     //正则表达式检测QQ 
//+(BOOL)checkMobileNumble:(NSString *)mobileStr;//手机号码验证
+(BOOL)checkMobileNumble:(NSString *)mobileStr contry:(NSUInteger)contry;

//获取去除空格后的字符串
-(NSString*)getTrimString;
//md5
-(NSString*)md5HexDigest;

@end

@interface NSObject(LKString)
+(BOOL)checkIsNilOrEmptyString:(id)obj;
//不是 @"" or null or (null) or <null>
-(BOOL)isNotEmptyString;
//不是 @""
-(BOOL)isNotSpaceString;
@end