//
//  NSObject+LKTheme.m
//  DouQu
//
//  Created by ljh on 14/12/17.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import "NSObject+LKTheme.h"
#import "LKThemeManager.h"

@interface LKThemeObserverObject : NSObject
@property(strong,nonatomic)NSString* selectorString;
@property(strong,nonatomic)NSArray* params;
@end

@implementation LKThemeObserverObject
@end

static char LK_Theme_Observers;
@implementation NSObject (LKTheme)
-(NSMutableDictionary *)lk_themeObservers
{
    NSMutableDictionary *themeObserverDict = objc_getAssociatedObject(self, &LK_Theme_Observers);
    if(themeObserverDict == nil)
    {
        themeObserverDict = [[NSMutableDictionary alloc]init];
        objc_setAssociatedObject(self, &LK_Theme_Observers, themeObserverDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return themeObserverDict;
}
-(void)lk_sendThemeChangedToObservers
{
    NSMutableDictionary *themeObserverDict = objc_getAssociatedObject(self, &LK_Theme_Observers);
    if(themeObserverDict.count == 0)
    {
        return;
    }
    
    [themeObserverDict enumerateKeysAndObjectsUsingBlock:^(id key, LKThemeObserverObject* obj, BOOL *stop) {

        SEL sel = NSSelectorFromString(obj.selectorString);
        NSMethodSignature *sig = [self.class instanceMethodSignatureForSelector:sel];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
        invocation.target = self;
        invocation.selector = sel;
        
        NSUInteger argIndex = 2;
        
        for (id par in obj.params)
        {
            if([par isKindOfClass:[NSValue class]])
            {
                char argType = [sig getArgumentTypeAtIndex:argIndex][0];
                if(argType == '@')
                {
                    NSObject* arg = par;
                    [invocation setArgument:&arg atIndex:argIndex++];
                }
                else
                {
                    char arg;
                    [par getValue:&arg];
                    [invocation setArgument:&arg atIndex:argIndex++];
                }
            }
            else
            {
                NSObject* arg = par;
                [invocation setArgument:&arg atIndex:argIndex++];
            }
        }
        [invocation invoke];
    }];
}
-(void)lk_addObserverWithSEL:(SEL)sel paramsArray:(id)params
{
    NSString* selStr = NSStringFromSelector(sel);
    if(selStr.length == 0)
    {
        return;
    }
    if(params && [params isKindOfClass:[NSArray class]] == NO)
    {
        params = @[params];
    }
    NSMutableDictionary* dic = [self lk_themeObservers];
    LKThemeObserverObject* object = [dic objectForKey:selStr];
    if(object == nil)
    {
        object = [LKThemeObserverObject new];
    }
    object.selectorString = selStr;
    object.params = params;
    [dic setObject:object forKey:selStr];
    
    [[LKThemeManager shareThemeManager] addChangedListener:self];
}

@end
