//
//  NSObject+LK.h
//  LJH
//
//  Created by LK on 13-9-24.
//  Copyright (c) 2013年 Jianghuai Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LK)

-(id)objectFromJSONDataOrString;

-(NSData*)dataFromJSONObject;
-(NSString*)stringFromJSONObject;
@end