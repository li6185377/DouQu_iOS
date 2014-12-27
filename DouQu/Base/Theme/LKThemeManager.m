//
//  LKThemeManager.m
//  DouQu
//
//  Created by ljh on 14/12/14.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import "LKThemeManager.h"
#import "LKWeakArray.h"
#import "NSObject+LKTheme.h"

#define LKThemeManagerPathKey @"LKLanguageManagerType"

@interface LKThemeManager()
@property(strong,nonatomic)LKWeakArray* listenerArray;
@property(strong,nonatomic)NSString* resourcePath;
@property(strong,nonatomic)NSCache* themeCache;
@end

@implementation LKThemeManager
@synthesize mainPath = _mainPath;
@synthesize themeInfo = _themeInfo;
@synthesize mainInfo = _mainInfo;

+(instancetype)shareThemeManager
{
    static LKThemeManager* manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
    });
    return manager;
}
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.listenerArray = [LKWeakArray array];
        NSString* themePath = [[NSUserDefaults standardUserDefaults] objectForKey:LKThemeManagerPathKey];
        if(themePath.length > 0)
        {
            self.themePath = themePath;
        }
        NSData* mainInfoData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LKThemeInfo" ofType:@"json"]];
        _mainInfo = [NSData dictionaryWithJSONData:mainInfoData];
    }
    return self;
}

#pragma mark- set keyboard style
-(void)setKeyboardAppearanceDark:(BOOL)keyboardAppearanceDark
{
    _keyboardAppearanceDark = keyboardAppearanceDark;
    if(IOS7)
    {
        if(_keyboardAppearanceDark)
        {
            [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];
            
            Class<UIAppearance> clazz = NSClassFromString(@"UISearchBarTextField");
            if([(Class)clazz conformsToProtocol:@protocol(UIAppearance)])
            {
                [[clazz appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];
            }
        }
        else
        {
            [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDefault];
            
            Class<UIAppearance> clazz = NSClassFromString(@"UISearchBarTextField");
            if([(Class)clazz conformsToProtocol:@protocol(UIAppearance)])
            {
                [[clazz appearance] setKeyboardAppearance:UIKeyboardAppearanceDefault];
            }
        }
    }
}
#pragma mark- get resource
-(UIColor *)colorForKey:(NSString *)key
{
    UIColor* color = [self cacheObjectForKey:key];
    if (!color)
    {
        NSString* hexColor = _themeInfo[@"color"][key];
        if (hexColor.length == 0)
        {
            hexColor = _mainInfo[@"color"][key];
        }
        color = [UIColor colorWithHexString:hexColor];
        [self setCacheObject:color forKey:key];
    }
    return color;
}

-(NSString *)resourcePathForName:(NSString *)fileName
{
    if(fileName.length == 0)
    {
        return nil;
    }
    
    NSString* resourcePath = nil;
    if(_resourcePath.length > 0)
    {
        resourcePath = [_resourcePath stringByAppendingPathComponent:fileName];
        if([NSFileManager isFileExists:resourcePath] == NO)
        {
            resourcePath = nil;
        }
    }
    if(resourcePath.length == 0)
    {
        resourcePath = [self.mainPath stringByAppendingPathComponent:fileName];
        if([NSFileManager isFileExists:resourcePath] == NO)
        {
            resourcePath = nil;
        }
    }
    if(resourcePath.length == 0)
    {
        resourcePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:fileName];
        if([NSFileManager isFileExists:resourcePath] == NO)
        {
            resourcePath = nil;
        }
    }
    return resourcePath;
}

#pragma mark- cache
-(void)setCacheObject:(id)obj forKey:(NSString *)key
{
    if(key.length)
    {
        if(obj)
        {
            [_themeCache setObject:obj forKey:key];
        }
        else
        {
            [_themeCache removeObjectForKey:key];
        }
    }
}
-(id)cacheObjectForKey:(NSString *)key
{
    if(key.length == 0)
    {
        return nil;
    }
    return [_themeCache objectForKey:key];
}

#pragma theme manage
-(void)addChangedListener:(NSObject *)obj
{
    if([_listenerArray containsObject:obj] == NO)
    {
        [_listenerArray addObject:obj];
    }
}
-(NSString *)mainPath
{
    if(_mainPath == nil)
    {
        _mainPath = [NSBundle mainBundle].resourcePath;
    }
    return _mainPath;
}

-(void)setThemePath:(NSString *)themePath
{
    NSString* documentPath = [NSFileManager getPathForDocuments:themePath];
    BOOL isExists = [NSFileManager isFileExists:documentPath];
    if(isExists == NO)
    {
        documentPath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:themePath];
        isExists = [NSFileManager isFileExists:documentPath];
    }
    if(isExists)
    {
        _themePath = themePath;
        self.resourcePath = documentPath;
        
        NSData* themeInfoData = [NSData dataWithContentsOfFile:[_resourcePath stringByAppendingPathComponent:@"LKThemeInfo.json"]];
        _themeInfo = [NSData dictionaryWithJSONData:themeInfoData];
        self.keyboardAppearanceDark = [_themeInfo[@"keyboarDrak"] boolValue];
        [self sendThemeChangedEvent];
    }
    else
    {
        _themePath = nil;
        if(_resourcePath != nil)
        {
            _themeInfo = nil;
            self.resourcePath = nil;
            self.keyboardAppearanceDark = NO;
            
            [self sendThemeChangedEvent];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:_themePath forKey:LKThemeManagerPathKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)sendThemeChangedEvent
{
    [_themeCache removeAllObjects];
    [_listenerArray bk_each:^(id obj) {
        
        if([obj respondsToSelector:@selector(lk_sendThemeChangedToObservers)])
        {
            [obj lk_sendThemeChangedToObservers];
        }
        if([obj respondsToSelector:@selector(appThemeDidChanged)])
        {
            [obj appThemeDidChanged];
        }
    }];
}
@end
