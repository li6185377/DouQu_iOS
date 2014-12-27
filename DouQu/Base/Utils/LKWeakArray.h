//
//  LKWeakArray.h
//  LJH
//
//  Created by ljh on 14-8-29.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKWeakArray : NSObject

///实例化
+ (instancetype)array;

- (instancetype)initWithArray:(NSArray*)array;
+ (instancetype)arrayWithArray:(NSArray *)array;

-(void)clearNilObject;

///线程锁
@property(strong,nonatomic)NSRecursiveLock* singleLock;

///array 的一些方法
@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly) id firstObject;
@property (nonatomic, readonly) id lastObject;


- (id)objectAtIndex:(NSUInteger)index;

- (BOOL)containsObject:(id)anObject;
- (NSUInteger)indexOfObject:(id)anObject;

- (void)addObject:(id)anObject;
- (void)addObjectsFromArray:(NSArray *)otherArray;

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index;

- (void)removeObjectAtIndex:(NSUInteger)index;

- (void)removeAllObjects;
- (void)removeObject:(id)anObject;

- (void)enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block NS_AVAILABLE(10_6, 4_0);
- (void)enumerateObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block NS_AVAILABLE(10_6, 4_0);

- (void)bk_each:(void (^)(id obj))block;
@end