//
//  NSURL+LK.m
//  DouQu
//
//  Created by ljh on 14/12/27.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import "NSURL+LK.h"
#import <objc/runtime.h>

static char lk_shouldDownloadImageKey;
@implementation NSURL (LK)
-(void)setShouldDownloadImage:(BOOL)shouldDownloadImage
{
    objc_setAssociatedObject(self, &lk_shouldDownloadImageKey, @(shouldDownloadImage), OBJC_ASSOCIATION_RETAIN);
}
-(BOOL)shouldDownloadImage
{
    return [objc_getAssociatedObject(self, &lk_shouldDownloadImageKey) boolValue];
}
@end
