//
//  NSObject+LK.m
//  LJH
//
//  Created by LK on 13-9-24.
//  Copyright (c) 2013年 Jianghuai Li. All rights reserved.
//

#import "NSObject+LK.h"

@implementation NSObject (LK)
-(id)lkObjectFromJSONData
{
    NSData* data = (NSData*)self;
    if(data.length > 0)
    {
        NSError* error = nil;
        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if(error)
        {
            NSLog(@"\n jsonData 解析出错 %@ \n",[error debugDescription]);
        }
        return object;
    }
    return nil;
}
-(id)lkObjectFromJSONString
{
    NSString* string = (NSString*)self;
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [data lkObjectFromJSONData];
}
-(id)objectFromJSONDataOrString
{
    if([self isKindOfClass:[NSData class]])
    {
        return [self lkObjectFromJSONData];
    }
    if([self isKindOfClass:[NSString class]])
    {
        return [self lkObjectFromJSONString];
    }
    return nil;
}
-(NSData *)dataFromJSONObject
{
    if([self isKindOfClass:[NSNull class]])
        return nil;
    
    if([NSJSONSerialization isValidJSONObject:self])
    {
        NSError* error = nil;
        NSData* data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        if (error) {
            NSLog(@"\n object 转换 jsonData 出错: %@ \n",error.debugDescription);
        }
        return data;
    }
    return nil;
}
-(NSString *)stringFromJSONObject
{
    NSData* data = [self dataFromJSONObject];
    if(data.length > 0)
    {
        return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}


- (id)objectAtIndexedSubscript:(NSUInteger)index
{
    if ([self respondsToSelector:@selector(objectAtIndex:)] && [self respondsToSelector:@selector(count)])
    {
        id unself = self;
        NSUInteger count = [unself count];
        if(index < count)
        {
            return [unself objectAtIndex:index];
        }
    }
    return nil;
}
- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)index
{
    if(object == nil)
    {
        return;
    }
    if ([self respondsToSelector:@selector(replaceObjectAtIndex:withObject:)] &&
        [self respondsToSelector:@selector(count)])
    {
        id unself = self;
        
        NSUInteger count = [unself count];
        if(index < count)
        {
            [unself replaceObjectAtIndex:index withObject:object];
        }
        else if([self respondsToSelector:@selector(addObject:)])
        {
            [unself addObject:object];
        }
    }
}
- (id)objectForKeyedSubscript:(id)key
{
    if ([self respondsToSelector:@selector(objectForKey:)])
    {
        id unself = self;
        return [unself objectForKey:key];
    }
    return nil;
}
- (void)setObject:(id)object forKeyedSubscript:(id)key
{
    if(key == nil)
    {
        return;
    }
    
    if ([self respondsToSelector:@selector(setObject:forKey:)])
    {
        id unself = self;
        [unself setObject:object forKey:key];
    }
}
@end
