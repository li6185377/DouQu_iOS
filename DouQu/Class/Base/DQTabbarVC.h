//
//  DQTabbarVC.h
//  DouQu
//
//  Created by ljh on 14/12/14.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DQTabbarVC : UITabBarController
+(instancetype)shareTabbarVC;
@end

@interface UIViewController(TabbarClickEvent)
-(void)dq_tabbarClickEvent;
@end