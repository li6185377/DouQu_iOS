//
//  LKThemeManager.h
//  DouQu
//
//  Created by ljh on 14/12/14.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(LKThemeManagerDelegate)
-(void)appThemeDidChanged;
@end

#define LK_ThemePath(o) [[LKThemeManager shareThemeManager] resourcePathForName:o]
#define LK_ThemeColor(o) [[LKThemeManager shareThemeManager] colorForKey:o]

@interface LKThemeManager : NSObject

+(instancetype)shareThemeManager;

///皮肤配置
@property(readonly,strong,nonatomic)NSDictionary* themeInfo;
///默认配置
@property(readonly,strong,nonatomic)NSDictionary* mainInfo;

///是否使用深色键盘
@property(nonatomic) BOOL keyboardAppearanceDark;

///从themeInfo 里面获取颜色
-(UIColor*)colorForKey:(NSString*)key;

///主皮肤的地址 在 document/xxxx/ 或者 .app/xxxx/ 下面的地址   xxxx就是你要传进来的值
@property(strong,nonatomic)NSString* themePath;

///主皮肤的地址 默认是 .app/
@property(strong,nonatomic)NSString* mainPath;

///根据文件名去获取皮肤里面的资源路径
-(NSString*)resourcePathForName:(NSString*)fileName;

///如果有皮肤切换 自动发回调给监听者
-(void)addChangedListener:(NSObject*)obj;

-(void)setCacheObject:(id)obj forKey:(NSString*)key;
-(id)cacheObjectForKey:(NSString*)key;
@end