//
//  LKLanguageManager.m
//  DouQu
//
//  Created by ljh on 14/12/14.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import "LKLanguageManager.h"
#import "LKWeakArray.h"

#define LKLanguageManagerTypeKey @"LKLanguageManagerType"

@interface LKLanguageManager()
@property(strong,nonatomic)LKWeakArray* listenerArray;
@end
@implementation LKLanguageManager
+(instancetype)shareLanguageManager
{
    static LKLanguageManager* manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
    });
    return manager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.listenerArray = [LKWeakArray array];
        NSNumber* number = [[NSUserDefaults standardUserDefaults] objectForKey:LKLanguageManagerTypeKey];
        if(number)
        {
            _currentLanguageType = [number integerValue];
        }
    }
    return self;
}
-(void)addChangedListener:(NSObject *)obj
{
    if([_listenerArray containsObject:obj] == NO)
    {
        [_listenerArray addObject:obj];
    }
}

-(NSString *)localizeStringForKey:(NSString *)key
{
    ///目前先返回Key 以后扩展
    return key;
}

-(void)setCurrentLanguageType:(LKLanguageType)currentLanguageType
{
    if(_currentLanguageType == currentLanguageType)
    {
        return;
    }
    _currentLanguageType = currentLanguageType;
    
    [[NSUserDefaults standardUserDefaults] setObject:@(currentLanguageType) forKey:LKLanguageManagerTypeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_listenerArray bk_each:^(id obj) {
        if([obj respondsToSelector:@selector(appLanguageDidChanged:)])
        {
            [obj appLanguageDidChanged:currentLanguageType];
        }
    }];
}
@end
