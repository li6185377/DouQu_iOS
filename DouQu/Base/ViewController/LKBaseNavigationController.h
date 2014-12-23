//
//  LHBaseNavigationController.h
//  LaHuo
//
//  Created by ljh on 14-10-23.
//  Copyright (c) 2014年 LaHuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKBaseNavigationController : UINavigationController
@property BOOL canPop;
@property int retryCount;
@end
