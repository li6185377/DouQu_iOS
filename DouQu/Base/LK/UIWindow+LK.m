//
//  UIWindow+LK.m
//  LJHV2
//
//  Created by LK on 13-7-2.
//  Copyright (c) 2013年 LJH. All rights reserved.
//

#import "UIWindow+LK.h"
#import "UIView+Toast_LK.h"
#import <QuartzCore/QuartzCore.h>

#ifdef dispatch_main_sync_safe
#import "SDWebImageDecoder.h"
#endif

@interface LKLaunchController:UIViewController
-(void)setLaunchImage:(UIImage*)img;

@property(strong,nonatomic)UIViewController* rootViewController;
@property(strong,nonatomic)UIWindow* window;
@end

@implementation LKLaunchController
-(void)setLaunchImage:(UIImage *)img
{
    UIImageView* iv =  (UIImageView*)self.view;
    iv.image = img;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.8f;
    transition.type = kCATransitionFade;
    [iv.layer addAnimation:transition forKey:nil];
}
-(NSString*)getLaunchPath
{
    NSString* launchName = nil;
    if(iPhone6p)
    {
        launchName = @"Default@3x.png";
    }
    else if(iPhone6)
    {
        launchName = @"Default-667h@2x.png";
    }
    else if(iPhone5)
    {
        launchName = @"Default-568h@2x.png";
    }
    else if([UIScreen mainScreen].scale >=2)
    {
        launchName = @"Default@2x.png";
    }
    else
    {
        launchName = @"Default.png";
    }
    NSString* filepath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:launchName];
    if([NSFileManager isFileExists:filepath])
    {
        return filepath;
    }
    
    if(iPhone6p)
    {
        launchName = @"LaunchImage-800-Portrait-736h@3x.png";
    }
    else if(iPhone6)
    {
        launchName = @"LaunchImage-800-667h@2x.png";
    }
    else if(iPhone5)
    {
        launchName = @"LaunchImage-700-568h@2x.png";
    }
    else if([UIScreen mainScreen].scale >=2)
    {
        launchName = @"LaunchImage@2x.png";
    }
    else
    {
        launchName = @"LaunchImage.png";
    }
    
    filepath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:launchName];
    if([NSFileManager isFileExists:filepath])
    {
        return filepath;
    }
    
    return nil;
}
-(void)loadView
{
    UIImageView* imgview = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UIImage* launchImage = nil;
    
    NSString* filepath = [self getLaunchPath];
    if(filepath)
    {
        launchImage = [UIImage imageWithContentsOfFile:filepath];
    }
    else
    {
        launchImage = [UIImage imageNamed:@"Default.png"];
        if(launchImage == nil)
        {
            launchImage = [UIImage imageNamed:@"LaunchImage.png"];
        }
    }

#ifdef dispatch_main_sync_safe
    imgview.image = [UIImage decodedImageWithImage:launchImage];
#else
    imgview.image = launchImage;
#endif
    
    self.view = imgview;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    NSString* modelPath = [NSFileManager getPathForDocuments:@"splash-screen.plist" inDir:@"splash-screen"];
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:modelPath];
    
    //下载新的闪屏
    [LKLaunchController startDownloadSplashScreenInfo];
    
    
    if(dic == nil)
    {
        [self showRootViewController:0.5];
        return;
    }
    
    ///还没做
}

+(void)startDownloadSplashScreenInfo
{
    ///还没做
}
+(void)imageDownloadWithURL:(NSString*)imageURL toPath:(NSString*)imagePath
{
#ifdef dispatch_main_sync_safe
    NSString* copyImageURL = [imageURL copy];
    NSString* copyImagePath = [imagePath copy];
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:copyImageURL] options:SDWebImageDownloaderContinueInBackground progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        
        if(image && data)
        {
            if([data writeToFile:copyImagePath atomically:YES])
            {
                [LKLaunchController imageDownloadFinished];
            }
            
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [LKLaunchController imageDownloadWithURL:copyImageURL toPath:copyImagePath];
            });
        }
    }];
#endif
}
+(void)imageDownloadFinished
{
    NSFileManager* filemanager = [NSFileManager defaultManager];
    
    NSString* mainPath = [NSFileManager getPathForDocuments:@"splash-screen.plist" inDir:@"splash-screen"];
    NSString* newPath = [NSFileManager getPathForDocuments:@"splash-screen-new.plist" inDir:@"splash-screen"];
    
    [filemanager removeItemAtPath:mainPath error:nil];
    [filemanager moveItemAtPath:newPath toPath:mainPath error:nil];
}

-(void)showRootViewController:(double)delayInSeconds
{
    NSLog(@"will start show root viewController");
    UIViewController* root = _rootViewController;
    UIWindow* window = _window;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LAUNCH_START" object:nil];
        });
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
        
        window.rootViewController = root;
        NSLog(@"start show root viewController");
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.8f;
        transition.type = kCATransitionFade;
        [window.layer addAnimation:transition forKey:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LAUNCH_FINISH" object:nil];
        });
    });
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationPortrait;
}
- (BOOL)shouldAutorotate
{
    return NO;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}
@end

@implementation UIWindow (LK)
///是否有键盘弹起来的gridview
- (BOOL)findSubviewIsGridCell
{
    for (UIView* subview in self.subviews)
    {
        if([subview isKindOfClass:NSClassFromString(@"UIPeripheralHostView")])
        {
            return [UIWindow findSubviewIsGridCell:subview];
        }
    }
    return NO;
}
///是否有键盘弹起来的gridview
+ (BOOL)findSubviewIsGridCell:(UIView*)view
{
    for (UIView* subview in view.subviews)
    {
        if(IOS6)
        {
            if([subview isKindOfClass:NSClassFromString(@"UIKeyboardCandidateGridCell")])
            {
                return YES;
            }
        }
        else
        {
            if([subview isKindOfClass:NSClassFromString(@"UIKeyboardCandidateBarShadowView")])
            {
                return YES;
            }
        }
        if([self findSubviewIsGridCell:subview])
        {
            return YES;
        }
    }
    return NO;
}

+(UIWindow*)getShowWindow
{
    UIWindow *window = nil;
    NSArray *windows = [UIApplication sharedApplication].windows;
    for (UIWindow *uiWindow in windows)
    {
        //有inputView或者键盘时，避免提示被挡住，应该选择这个 UITextEffectsWindow 来显示
        if ([NSStringFromClass(uiWindow.class) isEqualToString:@"UITextEffectsWindow"])
        {
            window = uiWindow;
            break;
        }
    }
    if (!window)
    {
        window = [[UIApplication sharedApplication] keyWindow];
    }
    return window;
}

+(UILabel*)labelWithText:(NSString*)text
{
    UILabel* lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 250, 0)];
    lb.font = [UIFont systemFontOfSize:16];
    lb.textColor = [UIColor whiteColor];
    lb.backgroundColor = [UIColor clearColor];
    lb.text = text;
    [lb sizeToFit];
    return lb;
}


- (void)removeKeyboardShadow
{
    NSEnumerator* enumerator = [UIApplication sharedApplication].windows.reverseObjectEnumerator;
    for (UIWindow *window in enumerator) {
        if (![window.class isEqual:[UIWindow class]]) {
            for (UIView *view in window.subviews) {
                if (strcmp("UIPeripheralHostView", object_getClassName(view)) == 0) {
                    UIView *shadowView = view.subviews[0];
                    if ([shadowView isKindOfClass:[UIImageView class]]) {
                        shadowView.hidden = YES;
                        return;
                    }
                }
            }
        }
    }
}


static __weak UIView *lastToast = nil;

+(void)showToastCircleMessage:(NSString*)message subMes:(NSString*)subMes
{
    UIWindow *window = [self getShowWindow];
    float duration = (float)message.length*0.08 + 0.3;
    
    UILabel* row1 = nil,*row2 = nil;
    
    if(message)
        row1 = [self labelWithText:message];
    if(subMes)
        row2 = [self labelWithText:subMes];
    
    float width = MAX(row1.width, row2.width);
    if(width == 0)
        return;
    
    float height = row1.height + row2.height;
    if(row1 && row2)
    {
        height +=2;
    }
    
    float diameter = sqrtf(width*width + height*height) + 10;
    
    CAShapeLayer* layer = [[CAShapeLayer alloc]init];
    
    CGPathRef pathRef = CGPathCreateWithEllipseInRect(CGRectMake(0, 0, diameter, diameter), NULL);
    layer.path = pathRef;
    CGPathRelease(pathRef);
    
    layer.fillColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    
    if (lastToast)
    {
        [lastToast removeFromSuperview];
        lastToast = nil;
    }
    __block UIView* showView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, diameter, diameter)];
    lastToast = showView;
    [showView.layer addSublayer:layer];
    
    showView.center = CGPointMake(window.width/2, window.height/2);
    showView.alpha = 0;
    [window addSubview:showView];
    
    row1.origin = CGPointMake((diameter-row1.width)/2,(diameter - height )/2);
    row2.origin = CGPointMake((diameter-row2.width)/2, (row1?(row1.bottom + 2):(diameter - height )/2));
    
    [showView addSubview:row1];
    [showView addSubview:row2];
    
    [UIView animateWithDuration:0.2 animations:^{
        showView.alpha = 1;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MIN(MAX(1, duration), 3) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2 animations:^{
                showView.alpha = 0;
            } completion:^(BOOL finished) {
                [showView removeFromSuperview];
                showView = nil;
            }];
        });
    }];
}
+(void)showToastMessage:(NSString *)message
{
    [self showToastMessage:message withColor:nil];
}

+(void)showToastMessage:(NSString *)message withColor:(UIColor *)color
{
    UIWindow *window = [self getShowWindow];
    float duration = (float)message.length*0.08 + 0.3;
    if ([message isEqualToString:@"ERROR_DESC_QZONE_NOT_INSTALLED"])
    {
        message = @"您手机还未安装QQ软件~";
    }
    if ([message isEqualToString:@"ERROR_DESC_UNAUTH"])
    {
        message = @"未授权!";
    }
    [window makeToast:message messageColor:color duration:MIN(MAX(1, duration), 3) position:@"center"];
}
+(void)showToastMessage:(NSString *)message withColor:(UIColor *)color duration:(CGFloat)interval
{
    UIWindow *window = [self getShowWindow];
    float duration = (interval>0)?interval:1.5f;
    [window makeToast:message messageColor:color duration:MIN(MAX(1, duration), 3) position:@"center"];
}

-(void)startLaunchForRootController:(UIViewController *)rootController
{
    LKLaunchController* launch = [[LKLaunchController alloc]init];
    launch.rootViewController = rootController;
    launch.window = self;
    
    self.rootViewController = launch;
    [self makeKeyAndVisible];
}
@end
