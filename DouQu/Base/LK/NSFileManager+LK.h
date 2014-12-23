//
//  NSFileManager+LK.h
//  LJH
//
//  Created by LK on 13-7-8.
//  Copyright (c) 2013年 Jianghuai Li. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSFileManager (LK)
///返回根目录路径 "document"
+(NSString*) getDocumentPath;
///返回 "document/dir/" 文件夹路径
+(NSString*) getDirectoryForDocuments:(NSString*) dir;
///返回 "document/filename" 路径
+(NSString*) getPathForDocuments:(NSString*)filename;
///返回 "document/dir/filename" 路径
+(NSString*) getPathForDocuments:(NSString *)filename inDir:(NSString*)dir;
///文件是否存在
+(BOOL) isFileExists:(NSString*)filepath;
///删除文件
+(BOOL)deleteWithFilepath:(NSString*)filepath;
@end
