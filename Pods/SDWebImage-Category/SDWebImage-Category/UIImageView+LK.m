//
//  UIImageView+SY.m
//  LJH
//
//  Created by ljh on 14-2-13.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import "UIImageView+LK.h"
#import "LK_THProgressView.h"
#import <execinfo.h>
#import <objc/runtime.h>
#import <objc/message.h>

static char imageURLKey;
static char imageStatusKey;
static char imageTapEventKey;
static char imageLoadedModeKey;
static char imageReloadCountKey;

@implementation UIImageView (SY)
-(void)lk_cancelCurrentImageLoad
{
#ifdef dispatch_main_async_safe
    [self sd_cancelCurrentImageLoad];
#else
    [self cancelCurrentImageLoad];
#endif
}
- (LK_THProgressView *)lk_progressView:(BOOL)isCreate
{
    const int imageProgressTag = 41251;
    LK_THProgressView *progressView = (id)[self viewWithTag:imageProgressTag];
    if (isCreate)
    {
        int pwidth = ceil(self.frame.size.width * 0.76);
        if (progressView == nil)
        {
            progressView = [[LK_THProgressView alloc] initWithFrame:CGRectMake(0, 0,pwidth, 20)];
            progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
            progressView.progressTintColor = [UIColor whiteColor];
            progressView.borderTintColor = [UIColor whiteColor];
            progressView.hidden = YES;
            progressView.tag = imageProgressTag;
            
            [self addSubview:progressView];
        }
        CGRect frame = progressView.frame;
        frame.size.width = pwidth;
        progressView.frame = frame;
        progressView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        
        [self bringSubviewToFront:progressView];
    }
    return progressView;
}
-(UIViewContentMode)loadedViewContentMode
{
    NSNumber *value = objc_getAssociatedObject(self, &imageLoadedModeKey);
    if(value == nil)
    {
        return -1;
    }
    return [value intValue];
}
-(void)setLoadedViewContentMode:(UIViewContentMode)loadedViewContentMode
{
    objc_setAssociatedObject(self, &imageLoadedModeKey, @(loadedViewContentMode), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(int)reloadCount
{
    NSNumber *value = objc_getAssociatedObject(self, &imageReloadCountKey);
    return [value intValue];
}

-(void)setReloadCount:(int)count
{
    objc_setAssociatedObject(self, &imageReloadCountKey, @(count), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LKImageViewStatus)status
{
    NSNumber *value = objc_getAssociatedObject(self, &imageStatusKey);
    if (value)
    {
        return [value intValue];
    }
    return LKImageViewStatusNone;
}

- (void)setStatus:(LKImageViewStatus)status
{
    objc_setAssociatedObject(self, &imageStatusKey, @(status), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSURL*)URLWithImageURL:(id)imageURL
{
    if ([imageURL isKindOfClass:[NSString class]])
    {
        if([imageURL hasPrefix:@"http"]||[imageURL hasPrefix:@"ftp"])
        {
            imageURL = [NSURL URLWithString:imageURL];
        }
        else
        {
            imageURL = [NSURL fileURLWithPath:imageURL];
        }
    }
    if ([imageURL isKindOfClass:[NSURL class]] == NO)
    {
        imageURL = nil;
    }
    return imageURL;
}
- (void)setImageURLFromCache:(id)imageURL
{
    [self lk_loadTapEvent];
    self.status = LKImageViewStatusLoaded;
    
    imageURL = [self URLWithImageURL:imageURL];
    objc_setAssociatedObject(self, &imageURLKey, imageURL, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setImageURL:(id)imageURL
{
    [self lk_loadTapEvent];
    
    imageURL = [self URLWithImageURL:imageURL];
    if (self.imageURL && self.image && self.status == LKImageViewStatusLoaded && imageURL)
    {
        if([[self.imageURL absoluteString] isEqualToString:[imageURL absoluteString]])
        {
            ///相同的图片URL 就不在设置了
            if(self.image.duration == 0)
            {
                return;
            }
        }
    }
    
    objc_setAssociatedObject(self, &imageURLKey, imageURL, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (imageURL)
    {
        [self setReloadCount:0];
        [self reloadImageURL];
    }
    else
    {
        
        [self lk_hideProgressView];
        [self lk_cancelCurrentImageLoad];
        self.image = nil;
        self.backgroundColor = [UIColor colorWithRed:233/255.0 green:228/255.0 blue:223/255.0 alpha:1];
        self.status = LKImageViewStatusNone;
    }
}

- (void)lk_loadTapEvent
{
    static char tapEventLoadedKey;
    id loaded = objc_getAssociatedObject(self, &tapEventLoadedKey);
    if (loaded == nil)
    {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lk_handleTapEvent:)];
        [self addGestureRecognizer:tap];
        objc_setAssociatedObject(self, &tapEventLoadedKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (id)imageURL
{
    return objc_getAssociatedObject(self, &imageURLKey);
}

- (void)reloadImageURL
{
    id imageURL = self.imageURL;
    
    [self lk_cancelCurrentImageLoad];
    
    self.image = nil;
    self.backgroundColor = [UIColor colorWithRed:233/255.0 green:228/255.0 blue:223/255.0 alpha:1];
    
    __weak UIImageView *wself = self;
    
    if(self.loadedViewContentMode < 0)
    {
        self.loadedViewContentMode = self.contentMode;
    }
    
    self.status = LKImageViewStatusLoading;
    __block LK_THProgressView *pv = [self lk_progressView:YES];
    pv.progress = 0;
    pv.hidden = NO;
    [pv setNeedsDisplay];
    [self setNeedsDisplay];
#ifdef dispatch_main_async_safe
    [self sd_setImageWithURL:imageURL placeholderImage:nil options:SDWebImageRetryFailed
#else
     [self setImageWithURL:imageURL placeholderImage:nil options:SDWebImageRetryFailed
#endif
                    progress:^(NSInteger receivedSize, NSInteger expectedSize)
     {
         if(expectedSize <= 0)
         {
             return;
         }
         float pvalue = MAX(0, MIN(1, receivedSize / (float) expectedSize));
         dispatch_main_sync_safe(^{
             if(wself.image == nil)
             {
                 if(!pv)
                 {
                     pv = [wself lk_progressView:YES];
                 }
                 pv.hidden = NO;
             }
             pv.progress = pvalue;
         });
     }
#ifdef dispatch_main_async_safe
                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL* url)
#else
                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
#endif
     {
         if (image)
         {
             [wself lk_hideProgressView];
             wself.status = LKImageViewStatusLoaded;
             if(image.duration == 0)
             {
                 if(wself.loadedViewContentMode > 0 && wself.contentMode != wself.loadedViewContentMode)
                 {
                     wself.contentMode = wself.loadedViewContentMode;
                     [wself setNeedsDisplay];
                 }
                 wself.backgroundColor = [UIColor clearColor];
             }
         }
         else
         {
             if (error)
             {
                 int reloadCount = [wself reloadCount];
                 if(reloadCount < 3)
                 {
                     [wself setReloadCount:reloadCount+1];
                     [wself reloadImageURL];
                     return ;
                 }
                 
                 [wself lk_hideProgressView];
                 wself.status = LKImageViewStatusFail;
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     [pv removeFromSuperview];
                     
                     UIImage *remindNoImage = [UIImage imageNamed:@"remind_noimage.png"];
                     if (wself.bounds.size.width < remindNoImage.size.width || wself.bounds.size.height < remindNoImage.size.height)
                     {
                         wself.contentMode = UIViewContentModeScaleAspectFit;
                     }
                     else
                     {
                         wself.contentMode = UIViewContentModeCenter;
                     }
                     wself.image = remindNoImage;
                     [wself setNeedsDisplay];
                 });
             }
             else
             {
                 wself.status = LKImageViewStatusNone;
                 [wself lk_hideProgressView];
             }
         }
     }];
}
-(void)lk_hideProgressView
{
    LK_THProgressView *pv = [self lk_progressView:NO];
    pv.hidden = YES;
    pv.progress = 0;
    [pv removeFromSuperview];
}

- (void)setOnTouchTapBlock:(void (^)(UIImageView *))onTouchTapBlock
{
    [self lk_loadTapEvent];
    objc_setAssociatedObject(self, &imageTapEventKey, onTouchTapBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIImageView *))onTouchTapBlock
{
    return objc_getAssociatedObject(self, &imageTapEventKey);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.imageURL && self.status != LKImageViewStatusFail && self.onTouchTapBlock == nil)
    {
        return NO;
    }
    return [super pointInside:point withEvent:event];
}

- (void)lk_handleTapEvent:(UITapGestureRecognizer *)sender
{
    switch (self.status)
    {
        case LKImageViewStatusFail:
        {
            [self reloadImageURL];
            break;
        }
        default:
        {
            if (self.onTouchTapBlock)
            {
                self.onTouchTapBlock(self);
            }
            break;
        }
    }
}
@end