//
//  DQSettingVC.m
//  DouQu
//
//  Created by ljh on 14/12/16.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import "DQSettingVC.h"
#import "KLSwitch.h"
#import "UMFeedback.h"
#import "MBProgressHUD.h"

@interface KLSwitch(DQ)
@end
@implementation KLSwitch(DQ)
-(void)appThemeDidChanged
{
    self.onTintColor = colorWithGreen;
    self.contrastColor = colorWithCellBG;
}
@end

@interface DQSettingVC ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView* tableView;
@end

@implementation DQSettingVC
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.title = @"设置";
        [self.tabBarItem lk_setFinishedSelectedImage:@"tabbar_setting_up" withFinishedUnselectedImage:@"tabbar_setting"];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell lk_setBackgroundColorForKey:colorWithCellBGKey];
        [cell.contentView lk_setBackgroundColorForKey:colorWithCellBGKey];
        
        UIView* selBg =  [UIView new];
        selBg.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
        cell.selectedBackgroundView = selBg;
        
        cell.size = CGSizeMake(ScreenWidth, 44);
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        [cell.textLabel lk_setTextColorForKey:colorWithBlackKey];
    }
    
    KLSwitch* ss = (id)[cell.contentView viewWithTag:110];
    if(indexPath.row < 2)
    {
        if(ss == nil)
        {
            ss = [[KLSwitch alloc]initWithFrame:CGRectMake(cell.width - 50 - 20, 10, 50, 24)];
            [ss appThemeDidChanged];
            [[LKThemeManager shareThemeManager] addChangedListener:ss];
        }
        ss.tag = 110;
        [cell.contentView addSubview:ss];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else
    {
        [ss removeFromSuperview];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    if(indexPath.row == 0)
    {
        cell.textLabel.text = @"2G/3G加载图片";
        ss.on = [DQAppInfo shareAppInfo].autoLoadingImage2g;
        [ss setDidChangeHandler:^(BOOL isOn){
            [DQAppInfo shareAppInfo].autoLoadingImage2g = isOn;
        }];
    }
    if(indexPath.row == 1)
    {
        cell.textLabel.text = @"夜间模式";
        ss.on = [DQAppInfo shareAppInfo].isNight;
        [ss setDidChangeHandler:^(BOOL isOn){
            [DQAppInfo shareAppInfo].isNight = isOn;
        }];
    }

    if(indexPath.row == 2)
    {
        cell.textLabel.text = @"清除图片缓存";
    }
    if(indexPath.row == 3)
    {
        cell.textLabel.text = @"意见反馈";
    }
    if(indexPath.row == 4)
    {
        cell.textLabel.text = @"关于";
    }
    [cell showLineForRow:indexPath.row leftMargin:0 rowCount:4];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 2)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [UIWindow showToastMessage:@"缓存清理完毕!!"];
        }];
    }
    if(indexPath.row == 3)
    {
        UIViewController* vc = [UMFeedback feedbackModalViewController];
        vc.view.size = CGSizeMake(ScreenWidth, ScreenHeight - 64);
        vc.title = @"意见反馈";
        [self presentModalViewController:vc animated:YES];
    }
    if(indexPath.row == 4)
    {
        TOWebViewController* vc = [[TOWebViewController alloc] initWithURLString:@"http://douqu.avosapps.com/douqu_about.html"];
        vc.showPageTitles = NO;
        vc.title = @"关于";
        [self lk_push:vc];
    }
}


@end
