//
//  UIImageView+SY.h
//  LJH
//
//  Created by ljh on 14-2-13.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

typedef NS_ENUM(NSInteger, LKImageViewStatus){
    LKImageViewStatusNone = 0,
    LKImageViewStatusLoaded = 1,
    LKImageViewStatusLoading = 2,
    LKImageViewStatusFail = 3
};

///图片加载出错了 可以点击重试  会自动重试3次
@interface UIImageView (LK)

///加载的图片 url地址 可以是 NSString 或 NSURL
@property(copy, nonatomic) id imageURL;

///加载完成后 给图片设置的contentMode
@property UIViewContentMode loadedViewContentMode;

///这个不会设置 image  只会保存ImageURL
- (void)setImageURLFromCache:(id)imageURL;

///当前状态
@property(readonly,assign,nonatomic) LKImageViewStatus status;

///图片点击事件  不用再手动添加UITapGestureRecognizer
@property(copy, nonatomic) void(^onTouchTapBlock)(UIImageView *imageView);

///重新加载图片
- (void)reloadImageURL;
@end