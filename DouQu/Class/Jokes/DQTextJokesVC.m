//
//  DQJokesVC.m
//  DouQu
//
//  Created by ljh on 14/12/14.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import "DQTextJokesVC.h"
#import "DQJokesModel.h"
#import "DQTextJokesCell.h"
#import "ConfigHeader.h"

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#define DQTextJokesCachePath [self cacheFilePath]

#import "SYSSPasteboardView.h"

static int isNeedShowCount;

@interface DQTextJokesVC ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UITableView* tableView;
@property(strong,nonatomic)NSArray* models;

@property(weak,nonatomic)AFHTTPRequestOperation* op_request;
@property(weak,nonatomic)AFHTTPRequestOperation* op_loadmore;
@end

@implementation DQTextJokesVC
-(NSString*)cacheFilePath
{
    return [NSFileManager getPathForDocuments:[NSString stringWithFormat:@"JokesTextCache_%d.json",_requestType] inDir:@"cache"];
}
-(void)dq_tabbarClickEvent
{
    [self.tableView setContentOffset:CGPointZero animated:NO];
    [self.tableView triggerRefresh];
}
-(void)initData
{
    NSData* data = [NSData dataWithContentsOfFile:DQTextJokesCachePath];
    if(data == nil)
    {
        int type = MAX(1,MIN(_requestType, 2));
        data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"jokes_cache_%d",type] ofType:@"json"]];
    }
    if(data)
    {
        NSDictionary* dic = [NSData dictionaryWithJSONData:data];
        NSArray* array = [dic objectForKey:@"result"];
        NSArray* models = [array toModels:[DQJokesModel class]];
        
        if(models.count > 0)
        {
            self.models = models;
            [self.tableView reloadData];
        }
    }
    
    [self.tableView triggerRefresh];
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
    [self setupRefreshAndLoadMore:_tableView];
    [self.view addSubview:_tableView];
    
    [self initData];
}
-(void)dragTableDidTriggerRefresh:(UITableView *)tableView
{
    [_op_loadmore setCompletionBlockWithSuccess:nil failure:nil];
    [_op_loadmore cancel];
    [_op_request setCompletionBlockWithSuccess:nil failure:nil];
    [_op_request cancel];
    
    weakify(self);
    self.op_request = [DQNetworkHelper method:@"i_just_is_a_get_method" params:@{@"type":@(_requestType)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSData dictionaryWithJSONData:operation.responseData];
        NSArray* array = [dic objectForKey:@"result"];
        NSArray* models = [array toModels:[DQJokesModel class]];
        
        if(models.count > 0)
        {
            [operation.responseData writeToFile:DQTextJokesCachePath atomically:YES];
        }
        dispatch_main_sync_safe(^{
            if(models.count > 0)
            {
                strongify(self);
                self.models = models;
                [self.tableView reloadData];
            }
            [self.tableView finishRefresh];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        strongify(self);
        [self.tableView stopRefresh];
    }];
    _op_request.successCallbackQueue = dispatch_get_global_queue(0, 0);
}
-(void)dragTableDidTriggerLoadMore:(UITableView *)tableView
{
    DQJokesModel* lastModel = self.models.lastObject;
    if(lastModel == nil)
    {
        [self.tableView stopLoadMore];
        return;
    }
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:@(_requestType) forKey:@"type"];
    [params setObject:lastModel.createdAt forKey:@"lastTime"];
    weakify(self);
    self.op_loadmore = [DQNetworkHelper method:@"i_just_is_a_get_method" params:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSData dictionaryWithJSONData:operation.responseData];
        NSArray* array = [dic objectForKey:@"result"];
        NSArray* models = [array toModels:[DQJokesModel class]];
        dispatch_main_sync_safe(^{
            strongify(self);
            if(models.count > 0)
            {
                NSMutableArray* allModels = [NSMutableArray arrayWithArray:self.models];
                [allModels addObjectsFromArray:models];
                self.models = allModels;
                [self.tableView reloadData];
            }
            [self.tableView finishLoadMore];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        strongify(self);
        [self.tableView stopLoadMore];
    }];
    _op_loadmore.successCallbackQueue = dispatch_get_global_queue(0, 0);
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _models.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DQJokesModel* model = _models[indexPath.row];
    if(model.textCellHeight < 10)
    {
        [DQTextJokesCell cellHeightWithModel:model];
    }
    return model.textCellHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DQTextJokesCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DQTextJokesCell"];
    if(cell == nil)
    {
        cell = [[DQTextJokesCell alloc]init];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        weakify(self)
        [cell.img_content setOnTouchTapBlock:^(UIImageView * iv) {
            strongify(self);
            [self showPhotoWithImageView:iv];
        }];
        UILongPressGestureRecognizer* longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
        [cell addGestureRecognizer:longGes];
    }
    DQJokesModel* model = _models[indexPath.row];
    cell.model = model;
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row >= self.models.count - 2)
    {
        dispatch_main_sync_safe(^{
            [tableView triggerLoadMore];
        });
    }
}
-(void)longPressed:(UIGestureRecognizer*)sender
{
    if(sender.state != UIGestureRecognizerStateBegan)
        return;
    DQTextJokesCell* cell = (id)sender.view;
    SYSSPasteboardView* paste = [SYSSPasteboardView shareInstance];
    [paste setPasteCopyBlock:^{
        [UIPasteboard generalPasteboard].string = cell.model.content;
        [UIWindow showToastMessage:@"已复制"];
    }];
    ///假的举报
    [paste setPasteReportBlock:^{
        [DQNetworkHelper method:@"i_just_is_a_report_method" params:@{@"id":cell.model.objectId} success:nil failure:nil];
        [UIWindow showToastMessage:@"已举报"];
    }];
    [paste showMenuWithView:cell inView:self.tableView];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     DQJokesModel* model = _models[indexPath.row];
    if(model.url.length)
    {
        TOWebViewController* vc = [[TOWebViewController alloc] initWithURLString:model.url];
        [self lk_push:vc];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showADView) object:nil];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showADView) object:nil];
    [self performSelector:@selector(showADView) withObject:nil afterDelay:15];
}
-(void)showADView
{
    isNeedShowCount++;
    if((isNeedShowCount%5) == 0)
    {
        BOOL isShow = [YouMiNewSpot p9Y:^(BOOL flag) {
            [MobClick event:@"showAD"];
        }];
        if(isShow)
        {
            [UIWindow showToastMessage:@"看累了~ 休息一下吧！！" withColor:nil duration:5];
        }
    }
}
#pragma mark- photo browser
-(void)showPhotoWithImageView:(UIImageView*)imageView
{
    DQTextJokesCell* cell = [imageView findViewParentWithClass:[DQTextJokesCell class]];

    MJPhoto* photo = [MJPhoto new];
    if(imageView.status == LKImageViewStatusLoaded)
    {
        photo.image = imageView.image;
    }
    photo.srcImageView = imageView;
    photo.url = [NSURL URLWithString:cell.model.url];
    
    MJPhotoBrowser* browser = [[MJPhotoBrowser alloc]init];
    browser.photos = @[photo];
    [browser show];
}

@end
