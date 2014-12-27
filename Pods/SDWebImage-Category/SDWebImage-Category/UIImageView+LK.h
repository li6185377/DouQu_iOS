//
//  UIImageView+SY.h
//  Seeyou
//
//  Created by ljh on 14-2-13.
//  Copyright (c) 2014年 linggan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LKImageViewStatus){
    ///默认
    LKImageViewStatusNone = 0,
    ///下载完成
    LKImageViewStatusLoaded = 1,
    ///下载中
    LKImageViewStatusLoading = 2,
    ///下载失败
    LKImageViewStatusFail = 3,
    ///点击下载状态
    LKImageViewStatusClickDownload = 4
};

@interface NSObject(LKImageViewDelegate)
///是否需要点击下载的回调
-(BOOL)lk_clickDownloadImageForURL:(NSURL*)imageURL;

/**
 *  @brief  当点击下载的时候(可能是失败或者处于点击下载状态） 是否更换URL
            
            比如 在2g3g状态下 你可以给URL注入一个属性 然后在SDWebImageManagerDelegate的回调中
            通过这个属性来判断是否强制下载图片
 *
 *  @param imageURL 原始URL
 *
 *  @return 新的URL
 */
-(NSURL*)lk_newURLWithClickURL:(NSURL*)imageURL;
@end



/**
 *  @brief  图片加载出错了 可以点击重试  会自动重试3次
 */
@interface UIImageView (LK)

///设置回调代理 是否显示点击下载图片
+(void)lk_setImageDownloadDelegate:(id)delegate;

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