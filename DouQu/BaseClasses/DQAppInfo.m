//
//  DQAppInfo.m
//  DouQu
//
//  Created by ljh on 14/12/14.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import "DQAppInfo.h"
#import "DQNetworkHelper.h"
#import "ConfigHeader.h"

#define isNightKey  @"dq_is_night"
#define autoLoadingImageKey  @"dq_is_auto_loading_image"
@interface DQAppInfo()<SDWebImageManagerDelegate>
@property(weak,nonatomic)UIView* adView;
@property(weak,nonatomic)UIButton* adCloseButton;
@end

@implementation DQAppInfo
@synthesize channelID = _channelID;
@synthesize isNight = _isNight;
@synthesize autoLoadingImage2g = _autoLoadingImage2g;
+(instancetype)shareAppInfo
{
    static DQAppInfo* infos;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        infos = [[self alloc]init];
        [infos channelID];
    });
    return infos;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        //设置 wifi 下载
        [SDWebImageManager sharedManager].delegate = self;
        [UIImageView lk_setImageDownloadDelegate:self];
        
        self.isNight = [[NSUserDefaults standardUserDefaults] boolForKey:isNightKey];
        self.autoLoadingImage2g = [[NSUserDefaults standardUserDefaults] boolForKey:autoLoadingImageKey];
    }
    return self;
}
-(BOOL)lk_clickDownloadImageForURL:(NSURL *)imageURL
{
    if([DQNetworkHelper shareHelper].is2G3G && _autoLoadingImage2g == NO)
    {
        return YES;
    }
    return NO;
}
-(NSURL *)lk_newURLWithClickURL:(NSURL *)imageURL
{
    imageURL.shouldDownloadImage = YES;
    return imageURL;
}
- (BOOL)imageManager:(SDWebImageManager *)imageManager shouldDownloadImageForURL:(NSURL *)imageURL
{
    if(imageURL.shouldDownloadImage)
    {
        return YES;
    }
    if([DQNetworkHelper shareHelper].is2G3G && _autoLoadingImage2g == NO)
    {
        return NO;
    }
    return YES;
}
-(NSString *)channelID
{
    if(_channelID == nil)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"channel" ofType:@"txt"];
        NSMutableString *text = [NSMutableString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [text replaceOccurrencesOfString:@"\r" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, text.length)];
        [text replaceOccurrencesOfString:@"\n" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, text.length)];
        [text replaceOccurrencesOfString:@" " withString:@"_" options:NSCaseInsensitiveSearch range:NSMakeRange(0, text.length)];
        _channelID = [[NSString alloc] initWithString:text];
    }
    return _channelID ? :@"unknown";
}
-(void)setIsNight:(BOOL)isNight
{
    if (_isNight != isNight)
    {
        _isNight = isNight;
        
        [LKThemeManager shareThemeManager].themePath = _isNight?@"_night":nil;
        
        [[NSUserDefaults standardUserDefaults] setBool:_isNight forKey:isNightKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
-(void)setAutoLoadingImage2g:(BOOL)autoLoadingImage2g
{
    if(_autoLoadingImage2g != autoLoadingImage2g)
    {
        _autoLoadingImage2g = autoLoadingImage2g;
        [[NSUserDefaults standardUserDefaults] setBool:_autoLoadingImage2g forKey:autoLoadingImageKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
#pragma mark- show ad

-(void)showADView
{
    if(_adView)
    {
        return;
    }
    
    weakify(self);
    BOOL isShow = [YouMiNewSpot p9Y:^(BOOL flag) {
        strongify(self);
        
        self.adView = nil;
        if(flag)
        {
            [MobClick event:@"clickAD"];
        }
    }];
    _adView = nil;
    if(isShow)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           strongify(self);
                           
                           UIView* view = [[UIApplication sharedApplication].keyWindow.subviews lastObject];
                           if([view isMemberOfClass:[UIView class]])
                           {
                               self.adView = view;
                               if(view.gestureRecognizers.count == 0)
                               {
                                   UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAdView)];
                                   [view addGestureRecognizer:tap];
                               }
                               
                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                   strongify(self);
                                   [self findSubViewForCloseButton:self.adView];
                               });
                           }
                       });
        
        [MobClick event:@"showAD"];
    }
}
-(void)findSubViewForCloseButton:(UIView*)view
{
    NSArray* array = view.subviews;
    for (UIView* subview in array)
    {
        if([subview isKindOfClass:[UIButton class]] && subview.width < 60 && subview.height < 60)
        {
            self.adCloseButton = (id)subview;
            break;
        }
        
        if(subview.subviews.count)
        {
            [self findSubViewForCloseButton:subview];
        }
    }
}
-(void)closeAdView
{
    if(_adCloseButton)
    {
        [_adCloseButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [_adView removeFromSuperview];
    }
    _adCloseButton = nil;
    _adView = nil;
}
@end
