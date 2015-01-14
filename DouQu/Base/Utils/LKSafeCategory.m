//
//  LKSafeCategory.m
//  LJH
//
//  Created by LK on 13-10-14.
//  Copyright (c) 2013年 Jianghuai Li. All rights reserved.
//

#import "LKSafeCategory.h"
#import "UIDevice-Hardware.h"
#import <execinfo.h>

@implementation NSObject (LK_Swizzle)

+ (BOOL)jr_swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError**)error_
{
    Method origMethod = class_getInstanceMethod(self, origSel_);
    if (!origMethod) {
        return NO;
    }
    Method altMethod = class_getInstanceMethod(self, altSel_);
    if (!altMethod) {
        return NO;
    }
    
    class_addMethod(self,
                    origSel_,
                    class_getMethodImplementation(self, origSel_),
                    method_getTypeEncoding(origMethod));
    class_addMethod(self,
                    altSel_,
                    class_getMethodImplementation(self, altSel_),
                    method_getTypeEncoding(altMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, origSel_), class_getInstanceMethod(self, altSel_));
    
    return YES;
}

+ (BOOL)jr_swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_ error:(NSError**)error_
{
    return [object_getClass((id)self) jr_swizzleMethod:origSel_ withMethod:altSel_ error:error_];
}

@end


#define showErrorLog printErrorMethodStack(_cmd);
static void printErrorMethodStack(SEL seletor) {
#ifdef DEBUG
    void *callstack[10];
    int frames = backtrace(callstack, 10);
    char **strs = backtrace_symbols(callstack, frames);
    
    NSMutableArray *logArray = [NSMutableArray array];
    for (int i = 1; i < frames; i++)
    {
        if (strs[i])
            [logArray addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    
    NSLog(@"\n\n出错拉\n\n %@ \n %@ \n\n出错拉\n\n", NSStringFromSelector(seletor), logArray);
    free(strs);
#endif
}



@implementation NSArray (LKSafeCategory)
- (id)LK_safeObjectAtIndex:(int)index
{
    if (index >= 0 && index < (int) self.count)
    {
        return [self LK_safeObjectAtIndex:index];
    }
    else
    {
        showErrorLog
    }
    return nil;
}

- (id)LK_safeInitWithObjects:(const id[])objects count:(NSUInteger)cnt
{
    for (int i = 0; i < cnt; i++)
    {
        if (objects[i] == nil)
        {
            showErrorLog;
            return nil;
        }
    }
    
    return [self LK_safeInitWithObjects:objects count:cnt];
}


- (id)objectAtIndexedSubscript:(NSUInteger)index
{
    if(index < self.count)
    {
        return [self objectAtIndex:index];
    }
    else
    {
        showErrorLog;
    }
    return nil;
}
@end

@implementation NSMutableArray (LKSafeCategory)
- (void)LK_safeAddObject:(id)anObject
{
    if (anObject != nil)
    {
        [self LK_safeAddObject:anObject];
    }
    else
    {
        showErrorLog;
    }
}

- (void)LK_safeInsertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (anObject != nil)
    {
        if (index > self.count)
        {
            index = self.count;
        }
        [self LK_safeInsertObject:anObject atIndex:index];
    }
    else
    {
        showErrorLog;
    }
}

- (void)LK_safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (!anObject)
    {
        showErrorLog;
        return;
    }
    
    if (self.count > index)
    {
        [self LK_safeReplaceObjectAtIndex:index withObject:anObject];
    }
    else
    {
        [self addObject:anObject];
        showErrorLog;
    }
}

- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)index
{
    if(object == nil)
    {
        showErrorLog;
        return;
    }
    if(index < self.count)
    {
        [self replaceObjectAtIndex:index withObject:object];
    }
    else
    {
        [self addObject:object];
    }
}
@end

@implementation NSDictionary (LKSafeCategory)

- (instancetype)LK_safeInitWithObjects:(const id[])objects forKeys:(const id <NSCopying>[])keys count:(NSUInteger)cnt
{
    for (int i = 0; i < cnt; i++)
    {
        if (objects[i] == nil || keys[i] == nil)
        {
            showErrorLog
            return nil;
        }
    }
    return [self LK_safeInitWithObjects:objects forKeys:keys count:cnt];
}
@end

@implementation NSMutableDictionary (LKSafeCategory)
- (void)LK_safeSetObject:(id)anObject forKey:(id <NSCopying>)aKey
{
    if (aKey == nil)
    {
        showErrorLog
        return;
    }
    
    [self LK_safeSetObject:anObject forKey:aKey];
}
- (void)setObject:(id)object forKeyedSubscript:(id)key
{
    if(key == nil)
    {
        showErrorLog;
        return;
    }
    
    if (object)
    {
         [self setObject:object forKey:key];
    }
    else
    {
        [self setValue:object forKey:key];
    }
}
@end

@implementation UIView (LKSafeCategory)
- (void)LK_safeAddSubview:(UIView *)view
{
    if ([view isEqual:self])
    {
        showErrorLog
        return;
    }
    
    [self LK_safeAddSubview:view];
}
@end

@implementation NSURL (LKSafeCategory)
+ (id)LK_safeFileURLWithPath:(NSString *)path isDirectory:(BOOL)isDir
{
    if (path == nil)
    {
        showErrorLog
        return nil;
    }
    
    return [self LK_safeFileURLWithPath:path isDirectory:isDir];
}
@end

@implementation NSFileManager (LKSafeCategory)
- (NSDirectoryEnumerator *)LK_safeEnumeratorAtURL:(NSURL *)url includingPropertiesForKeys:(NSArray *)keys options:(NSDirectoryEnumerationOptions)mask errorHandler:(BOOL (^)(NSURL *, NSError *))handler
{
    if (url == nil)
    {
        showErrorLog
        return nil;
    }
    
    return [self LK_safeEnumeratorAtURL:url includingPropertiesForKeys:keys options:mask errorHandler:handler];
}
@end


@implementation UIViewController (LKSafeCategory)
- (void)LK_dismissModalViewControllerAnimated:(BOOL)flag
{
    UIViewController *vc = [self.navigationController popViewControllerAnimated:YES];
    if (!vc)
    {
        [self LK_dismissModalViewControllerAnimated:flag];
    }
}

@end

@implementation NSCache (LKSafeCategory)
- (void)LK_safeSetObject:(id)obj forKey:(id)key cost:(NSUInteger)g
{
    if (obj && key)
    {
        [self LK_safeSetObject:obj forKey:key cost:g];
    }
    else
    {
        showErrorLog
    }
}
@end

@implementation NSString (LKSafeCategory)
- (NSRange)LK_safeRangeOfCharacterFromSet:(NSCharacterSet *)aSet options:(NSStringCompareOptions)mask range:(NSRange)searchRange
{
    if (searchRange.location + searchRange.length > self.length)
    {
        return NSMakeRange(NSNotFound, 0);
    }
    return [self LK_safeRangeOfCharacterFromSet:aSet options:mask range:searchRange];
}

- (NSRange)LK_safeRangeOfString:(NSString *)aString options:(NSStringCompareOptions)mask range:(NSRange)searchRange locale:(NSLocale *)locale
{
    if (searchRange.location + searchRange.length > self.length)
    {
        return NSMakeRange(NSNotFound, 0);
    }
    return [self LK_safeRangeOfString:aString options:mask range:searchRange locale:locale];
}
@end

@implementation UITableView(DisableAnimation)

- (id)LK_createPreparedCellForGlobalRow:(NSInteger)arg1 withIndexPath:(NSIndexPath *)arg2
{
    //创建cell的时候 不启用动画
    [UIView setAnimationsEnabled:NO];
    id returnMe = [self LK_createPreparedCellForGlobalRow:arg1 withIndexPath:arg2];
    [UIView setAnimationsEnabled:YES];
    return returnMe;
}

@end

@implementation UIScrollView(DisableAnimation)
///ios8
- (id)sy_createPreparedCellForItemAtIndexPath:(id)arg1 withLayoutAttributes:(id)arg2 applyAttributes:(_Bool)arg3
{
    [UIView setAnimationsEnabled:NO];
    id returnMe = [self sy_createPreparedCellForItemAtIndexPath:arg1 withLayoutAttributes:arg2 applyAttributes:arg3];
    [UIView setAnimationsEnabled:YES];
    return returnMe;
}
///ios6
- (id)sy_createPreparedCellForItemAtIndexPath:(id)arg1 withLayoutAttributes:(id)arg2
{
    [UIView setAnimationsEnabled:NO];
    id returnMe = [self sy_createPreparedCellForItemAtIndexPath:arg1 withLayoutAttributes:arg2];
    [UIView setAnimationsEnabled:YES];
    return returnMe;
}
@end


#pragma mark- 添加观察者时 判断是否添加过
static __strong NSMutableArray *observerStore;
static __strong NSRecursiveLock* observerStoreLock;

@interface LKSafeObserverObject : NSObject
@property(copy, nonatomic) NSString *name;
@property(copy, nonatomic) NSString *selector;
@property(weak, nonatomic) id observer;
@end

@implementation LKSafeObserverObject
+(void)initialize
{
    observerStore = [[NSMutableArray alloc] init];
    observerStoreLock = [[NSRecursiveLock alloc]init];
}
+ (BOOL)hasContainObject:(id)observer name:(NSString *)aName selName:(NSString *)selName
{
    [observerStoreLock lock];
    for (int i = 0; i < observerStore.count;)
    {
        LKSafeObserverObject *obj = observerStore[i];
        if (obj.observer == nil)
        {
            //已经被释放了  就移除掉
            [observerStore removeObjectAtIndex:i];
            continue;
        }
        
        if (obj.observer == observer && [obj.name isEqualToString:aName] && [obj.selector isEqualToString:selName])
        {
            //重复的通知就不添加了
            [observerStoreLock unlock];
            return YES;
        }
        i++;
    }
    LKSafeObserverObject *obj = [LKSafeObserverObject new];
    obj.name = aName;
    obj.selector = selName;
    obj.observer = observer;
    
    [observerStore addObject:obj];
    [observerStoreLock unlock];
    return NO;
}

@end

@implementation NSNotificationCenter (LKSafeCategory)
- (void)LK_safeAddObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject
{
    NSString* className = [NSStringFromClass([observer class]) uppercaseString];
    if (!observer || [className hasPrefix:@"NS"] || [className hasPrefix:@"UI"])
    {
        [self LK_safeAddObserver:observer selector:aSelector name:aName object:anObject];
        return;
    }
    
    if ([LKSafeObserverObject hasContainObject:observer name:aName selName:NSStringFromSelector(aSelector)] == NO)
    {
        [self LK_safeAddObserver:observer selector:aSelector name:aName object:anObject];
    }
}
@end

@implementation NSObject (LKSafeCategory)
- (void)LK_safeAddObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    NSString* className = [NSStringFromClass([observer class]) uppercaseString];
    if (!observer || [className hasPrefix:@"NS"] || [className hasPrefix:@"UI"])
    {
        [self LK_safeAddObserver:observer forKeyPath:keyPath options:options context:context];
        return;
    }
    if ([LKSafeObserverObject hasContainObject:observer name:keyPath selName:[NSString stringWithFormat:@"%p",self]] == NO)
    {
        [self LK_safeAddObserver:observer forKeyPath:keyPath options:options context:context];
    }
}

+ (void)lk_callSafeCategory
{
    [objc_getClass("__NSPlaceholderArray") jr_swizzleMethod:@selector(initWithObjects:count:) withMethod:@selector(LK_safeInitWithObjects:count:) error:nil];
    
    [objc_getClass("__NSPlaceholderDictionary") jr_swizzleMethod:@selector(initWithObjects:forKeys:count:) withMethod:@selector(LK_safeInitWithObjects:forKeys:count:) error:nil];
    
    
    [NSURL jr_swizzleClassMethod:@selector(fileURLWithPath:isDirectory:) withClassMethod:@selector(LK_safeFileURLWithPath:isDirectory:) error:nil];
    
    
    [NSFileManager jr_swizzleMethod:@selector(enumeratorAtURL:includingPropertiesForKeys:options:errorHandler:) withMethod:@selector(LK_safeEnumeratorAtURL:includingPropertiesForKeys:options:errorHandler:) error:nil];
    
    
    [objc_getClass("SSModalAuthViewController") jr_swizzleMethod:@selector(dismissModalViewControllerAnimated:) withMethod:@selector(LK_dismissModalViewControllerAnimated:) error:nil];
    
    
    [NSCache jr_swizzleMethod:@selector(setObject:forKey:cost:) withMethod:@selector(LK_safeSetObject:forKey:cost:) error:nil];
    
    
    [UIView jr_swizzleMethod:@selector(addSubview:) withMethod:@selector(LK_safeAddSubview:) error:nil];
    
    [NSString jr_swizzleMethod:@selector(rangeOfString:options:range:locale:) withMethod:@selector(LK_safeRangeOfString:options:range:locale:) error:nil];
    [NSString jr_swizzleMethod:@selector(rangeOfCharacterFromSet:options:range:) withMethod:@selector(LK_safeRangeOfCharacterFromSet:options:range:) error:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [NSObject jr_swizzleMethod:@selector(addObserver:forKeyPath:options:context:) withMethod:@selector(LK_safeAddObserver:forKeyPath:options:context:) error:nil];
        [NSNotificationCenter jr_swizzleMethod:@selector(addObserver:selector:name:object:) withMethod:@selector(LK_safeAddObserver:selector:name:object:) error:nil];
    });
    
    SEL sel = NSSelectorFromString(@"_createPreparedCellForGlobalRow:withIndexPath:");
    [UITableView jr_swizzleMethod:sel withMethod:@selector(LK_createPreparedCellForGlobalRow:withIndexPath:) error:nil];
    
    if(IOS6)
    {
        SEL sel_2 = NSSelectorFromString(@"_createPreparedCellForItemAtIndexPath:withLayoutAttributes:");
        [UICollectionView jr_swizzleMethod:sel_2 withMethod:@selector(sy_createPreparedCellForItemAtIndexPath:withLayoutAttributes:) error:nil];
        
        SEL sel_3 = NSSelectorFromString(@"_createPreparedCellForItemAtIndexPath:withLayoutAttributes:applyAttributes:");
        [UICollectionView jr_swizzleMethod:sel_3 withMethod:@selector(sy_createPreparedCellForItemAtIndexPath:withLayoutAttributes:applyAttributes:) error:nil];
    }
}
@end