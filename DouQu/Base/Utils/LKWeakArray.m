//
//  LKWeakArray.m
//  LJH
//
//  Created by ljh on 14-8-29.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import "LKWeakArray.h"
@interface LKWeakArrayObject : NSObject
@property(weak,nonatomic)id object;
@end

@interface LKWeakArray()
{
    ///具体内容
    NSMutableArray* _array;
}
@end

@implementation LKWeakArray
+ (instancetype)array
{
    return [LKWeakArray new];
}
+(instancetype)arrayWithArray:(id)array
{
    return [[LKWeakArray alloc]initWithArray:array];
}
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _singleLock = [[NSRecursiveLock alloc]init];
        _array = [[NSMutableArray alloc]init];
    }
    return self;
}
- (instancetype)initWithArray:(NSArray*)array
{
    self = [self init];
    if (self)
    {
        [self addObjectsFromArray:array];
    }
    return self;
}
-(id)objectAtIndexedSubscript:(NSUInteger)index
{
   return [self objectAtIndex:index];
}
-(void)setObject:(id)object atIndexedSubscript:(NSUInteger)index
{
    [self insertObject:object atIndex:index];
}
-(void)clearNilObject
{
    [_singleLock lock];
    
    for (int i=0; i<_array.count;)
    {
        LKWeakArrayObject* wobj = _array[i];
        if(wobj.object == nil)
        {
            [_array removeObjectAtIndex:i];
        }
        else
        {
            i++;
        }
    }
    
    [_singleLock unlock];
    
}

-(id)objectAtIndex:(NSUInteger)index
{
    [_singleLock lock];
    
    id value = nil;
    if(index < _array.count)
    {
        LKWeakArrayObject* weakObject = _array[index];
        value = weakObject.object;
    }
    
    [_singleLock unlock];
    
    return value;
}

-(NSUInteger)count
{
    [_singleLock lock];
    
    NSUInteger count = _array.count;
    
    [_singleLock unlock];
    
    return count;
}
-(id)firstObject
{
    id result = nil;
    [_singleLock lock];
    
    for (NSInteger i=0,size = _array.count; i<size; i++)
    {
        LKWeakArrayObject* wobj = _array[i];
        if(wobj.object)
        {
            result = wobj.object;
            break;
        }
    }
    
    [_singleLock unlock];
    return result;
}
-(id)lastObject
{
    id result = nil;
    [_singleLock lock];
    
    for (NSInteger i = _array.count - 1; i>=0; i--)
    {
        LKWeakArrayObject* wobj = _array[i];
        if(wobj.object)
        {
            result = wobj.object;
            break;
        }
    }
    
    [_singleLock unlock];
    return result;
}
-(NSUInteger)indexOfObject:(id)anObject
{
    if(anObject == nil)
    {
        return NSNotFound;
    }
    NSUInteger findIndex = NSNotFound;
    [_singleLock lock];
    
    for (NSInteger i=0,size = _array.count; i<size; i++)
    {
        LKWeakArrayObject* wobj = _array[i];
        if([wobj.object isEqual:anObject])
        {
            findIndex = i;
            break;
        }
    }
    
    [_singleLock unlock];
    
    return findIndex;
}
-(BOOL)containsObject:(id)anObject
{
    return ([self indexOfObject:anObject] != NSNotFound);
}

-(void)addObject:(id)anObject
{
    if(!anObject)
        return;
    
    [_singleLock lock];
    
    LKWeakArrayObject* object = [LKWeakArrayObject new];
    object.object = anObject;
    [_array addObject:object];
    
    [_singleLock unlock];
}
-(void)addObjectsFromArray:(NSArray *)otherArray
{
    if(otherArray.count == 0)
        return;
    
    [_singleLock lock];
    
    for (id anObject in otherArray)
    {
        LKWeakArrayObject* object = [LKWeakArrayObject new];
        object.object = anObject;
        [_array addObject:object];
    }
    
    [_singleLock unlock];
}
-(void)insertObject:(id)anObject atIndex:(NSUInteger)index
{
    if(!anObject)
        return;
    
    [_singleLock lock];
    
    LKWeakArrayObject* object = [LKWeakArrayObject new];
    object.object = anObject;
    if(index >= _array.count)
    {
        [_array addObject:object];
    }
    else
    {
        [_array insertObject:object atIndex:index];
    }
    
    [_singleLock unlock];
}
-(void)removeObjectAtIndex:(NSUInteger)index
{
    [_singleLock lock];
    
    [_array removeObjectAtIndex:index];
    
    [_singleLock unlock];
}
-(void)removeObject:(id)anObject
{
    if(!anObject)
        return;
    
    [_singleLock lock];
    
    id weakObject = nil;
    for (LKWeakArrayObject* wobj in _array)
    {
        if([wobj.object isEqual:anObject])
        {
            weakObject = wobj;
            break;
        }
    }
    if(weakObject)
    {
        [_array removeObject:weakObject];
    }
    
    [_singleLock unlock];
}
-(void)removeAllObjects
{
    [_singleLock lock];
    
    [_array removeAllObjects];
    
    [_singleLock unlock];
}
-(void)enumerateObjectsUsingBlock:(void (^)(id, NSUInteger, BOOL *))block
{
    if(!block)
        return;
    
    [_singleLock lock];
    
    BOOL stop = NO;
    for (NSInteger i=0,size = _array.count; i<size; i++)
    {
        LKWeakArrayObject* wobj = _array[i];
        if(wobj.object)
        {
            block(wobj.object,i,&stop);
            
            if(stop)
            {
                break;
            }
        }
    }
    
    [_singleLock unlock];
}
-(void)enumerateObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id, NSUInteger, BOOL *))block
{
    if(!block)
        return;
    
    [_singleLock lock];
    
    BOOL stop = NO;
    NSInteger i=0;
    NSUInteger size = _array.count;
    BOOL whileDo = YES;
    
    if(opts & NSEnumerationReverse)
    {
        i = size - 1;
        whileDo = i >= 0;
    }
    else
    {
        whileDo = i < size;
    }
    
    while (whileDo)
    {
        LKWeakArrayObject* wobj = _array[i];
        if(wobj.object)
        {
            block(wobj.object,i,&stop);
            
            if(stop)
            {
                break;
            }
        }
        
        if(opts & NSEnumerationReverse)
        {
            i --;
            whileDo = i >= 0;
        }
        else
        {
            i ++;
            whileDo = i < size;
        }
    }
    
    [_singleLock unlock];
}

-(void)bk_each:(void (^)(id))block
{
    if(!block)
        return;
    
    [_singleLock lock];
    
    for (NSInteger i=0,size = _array.count; i<size; i++)
    {
        LKWeakArrayObject* wobj = _array[i];
        if(wobj.object)
        {
            block(wobj.object);
        }
    }
    
    [_singleLock unlock];
}

@end

@implementation LKWeakArrayObject
@end
