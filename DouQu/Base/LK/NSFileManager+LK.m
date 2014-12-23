//
//  NSFileManager+LK.m
//  LJH
//
//  Created by LK on 13-7-8.
//  Copyright (c) 2013年 Jianghuai Li. All rights reserved.
//

#import "NSFileManager+LK.h"
#define LKFileErrorDefine NSError* error = nil;
#define LKFileErrorLogDefine if(error){NSLog(@"%@",error.debugDescription);error=nil;}
@implementation NSFileManager (LK)
+(NSString *)getDocumentPath
{
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
#else
    NSString* homePath = [[NSBundle mainBundle] resourcePath];
    return homePath;
#endif
}
+(NSString *)getDirectoryForDocuments:(NSString *)dir
{
    NSString* dirPath = [[self getDocumentPath] stringByAppendingPathComponent:dir];
    BOOL isDir = NO;
    BOOL isCreated = [[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDir];
    if ( isCreated == NO || isDir == NO ) {
        NSError* error = nil;
        BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
        if(success == NO)
            NSLog(@"create dir error: %@",error.debugDescription);
    }
    return dirPath;
}
+ (NSString *)getPathForDocuments:(NSString *)filename
{
    return [[self getDocumentPath] stringByAppendingPathComponent:filename];
}
+(NSString *)getPathForDocuments:(NSString *)filename inDir:(NSString *)dir
{
    return [[self getDirectoryForDocuments:dir] stringByAppendingPathComponent:filename];
}
+(BOOL)isFileExists:(NSString *)filepath
{
    return [[NSFileManager defaultManager] fileExistsAtPath:filepath];
}
+(BOOL)deleteWithFilepath:(NSString *)filepath
{
    return [[NSFileManager defaultManager] removeItemAtPath:filepath error:nil];
}
@end
