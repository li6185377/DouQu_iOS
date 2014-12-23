//
//  NSString+LK.m
//  LJHV2
//
//  Created by LK on 13-7-4.
//  Copyright (c) 2013年 LJH. All rights reserved.
//

#import "NSString+LK.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (LK)

-(NSData *)convert16ByteData
{
    int j=0;
    Byte bytes[128];  ///3ds key的Byte 数组， 128位
    for(int i=0;i<[self length];i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        
        unichar hex_char1 = [self characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
        {
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        }
        else if(hex_char1 >= 'A' && hex_char1 <='F')
        {
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        }
        else
        {
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        }
        i++;
        
        unichar hex_char2 = [self characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
        {
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        }
        else if(hex_char2 >= 'A' && hex_char2 <='F')
        {
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        }
        else
        {
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        }
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    return [NSData dataWithBytes:bytes length:j];
}


//判断邮箱是否合法的代码   拆分验证
+(BOOL)checkEmailWithComponent:(NSString*)email
{
    if((0 != [email rangeOfString:@"@"].length) &&
       (0 != [email rangeOfString:@"."].length))
    {
        
        NSCharacterSet* tmpInvalidCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        NSMutableCharacterSet* tmpInvalidMutableCharSet = [tmpInvalidCharSet mutableCopy];
        [tmpInvalidMutableCharSet removeCharactersInString:@"_-"];

        //使用compare option 来设定比较规则，如
        //NSCaseInsensitiveSearch是不区分大小写
        //NSLiteralSearch 进行完全比较,区分大小写
        //NSNumericSearch 只比较定符串的个数，而不比较字符串的字面值
        NSRange range1 = [email rangeOfString:@"@"
                                      options:NSCaseInsensitiveSearch];
        
        //取得用户名部分
        NSString* userNameString = [email substringToIndex:range1.location];
        NSArray* userNameArray   = [userNameString componentsSeparatedByString:@"."];
        
        for(NSString* string in userNameArray)
        {
            NSRange rangeOfInavlidChars = [string rangeOfCharacterFromSet: tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length != 0 || [string isEqualToString:@""])
            {
                return NO;
            }
        }
        
        NSString *domainString = [email substringFromIndex:range1.location+1];
        NSArray *domainArray   = [domainString componentsSeparatedByString:@"."];
        
        for(NSString *string in domainArray)
        {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return NO;
        }

        return YES;
    }
    else // no ''@'' or ''.'' present
        return NO;
}




//利用正则表达式验证
+(BOOL)checkEmailWithRegex:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(BOOL)checkQQNumberWithRegex:(NSString*)qq
{
    NSString *qqRegex = @"[1-9]{1}+[0-9]{4,19}";
    NSPredicate *qqPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", qqRegex];
    return [qqPredicate evaluateWithObject:qq];
}

//手机号码验证
+(BOOL)checkMobileNumble:(NSString *)mobileStr
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobileStr];
}

+(BOOL)checkMobileNumble:(NSString *)mobileStr contry:(NSUInteger)contry
{
    switch (contry) {
        case 86:
        {
            //手机号以13， 15，18开头，八个 \d 数字字符
            NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
            NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
            return [phoneTest evaluateWithObject:mobileStr];
        }
        default:
        {
            NSString *phoneRegex = @"[0-9]{6,11}";
            NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
            return [phoneTest evaluateWithObject:mobileStr];
        }
            break;
    }
}


// 判断字符串为空或只为空格
+(BOOL)isBlankString:(NSString *)string
{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if([string isKindOfClass:[NSString class]] == NO)
    {
        return YES;
    }
    if(string.length == 0)
    {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return YES;
    }
    if ([string.lowercaseString isEqualToString:@"(null)"] || [string.lowercaseString isEqualToString:@"null"] || [string.lowercaseString isEqualToString:@"<null>"])
    {
        return YES;
    }
    return NO;
}
-(NSString *)getTrimString
{
   return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
-(NSString *)md5HexDigest
{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str,(CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash uppercaseString];
}
@end

@implementation NSObject(LKString)
+(BOOL)checkIsNilOrEmptyString:(id)obj
{
    if(obj == nil || obj == [NSNull null])
        return YES;
    if([obj isKindOfClass:[NSString class]])
    {
        if ([[obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
            return YES;
        }
    }
    return NO;
}
-(BOOL)isNotEmptyString
{
    return ![NSString isBlankString:(id)self];
}
-(BOOL)isNotSpaceString
{
    if([self isKindOfClass:[NSString class]])
    {
        if([(id)self length] > 0)
        {
            return YES;
        }
    }
    return NO;
}
@end
