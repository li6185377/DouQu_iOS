//
//  LKLanguageManager.h
//  DouQu
//
//  Created by ljh on 14/12/14.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LKLanguageType) {
    LKLanguageTypeSimple,           ///简体
    LKLanguageTypeTraditional       ///繁体
};

#define LK_STR(key) [[LKLanguageManager shareLanguageManager] localizeStringForKey:key]


@interface NSObject(LKLanguageManagerDelegate)
-(void)appLanguageDidChanged:(LKLanguageType)languageType;
@end

@interface LKLanguageManager : NSObject

+(instancetype)shareLanguageManager;

///当前的语言类型
@property(nonatomic) LKLanguageType currentLanguageType;

///返回本地化字符串
-(NSString*)localizeStringForKey:(NSString*)key;
///如果有语言切换 自动发回调给监听者
-(void)addChangedListener:(NSObject*)obj;
@end
