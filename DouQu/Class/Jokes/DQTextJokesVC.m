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

@interface DQTextJokesVC ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UITableView* tableView;
@property(strong,nonatomic)NSArray* models;

@property(weak,nonatomic)AFHTTPRequestOperation* op_request;
@property(weak,nonatomic)AFHTTPRequestOperation* op_loadmore;

@property(strong,nonatomic)NSMutableArray* deleteObjectIds;

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
    self.deleteObjectIds = [NSMutableArray array];
    
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
-(DQJokesModel*)createADModel
{
    DQJokesModel* admodel = [DQJokesModel new];
    admodel.type = DQJokesModelTypeYouMiAD;
    admodel.publisher = @"推广";
    admodel.content = @"2015新应用火爆来袭，一起偷看下别人玩什么！！ ";
    admodel.image = [[NSBundle mainBundle] pathForResource:@"ad_image_640_164" ofType:@"jpg"];
    return admodel;
}
-(void)dragTableDidTriggerRefresh:(UITableView *)tableView
{
    [_op_loadmore setCompletionBlockWithSuccess:nil failure:nil];
    [_op_loadmore cancel];
    [_op_request setCompletionBlockWithSuccess:nil failure:nil];
    [_op_request cancel];
    
    weakify(self);
    self.op_request = [DQNetworkHelper method:@"get_jokes" params:@{@"type":@(_requestType)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        strongify(self);
        NSDictionary* dic = [NSData dictionaryWithJSONData:operation.responseData];
        NSArray* array = [dic objectForKey:@"result"];
        NSMutableArray* models = [NSMutableArray arrayWithArray:[array toModels:DQJokesModel.class]];
        [models enumerateObjectsUsingBlock:^(DQJokesModel* obj, NSUInteger idx, BOOL *stop) {
            strongify(self);
            if([self.deleteObjectIds containsObject:obj.objectId])
            {
                [models removeObject:obj];
            }
        }];

        if(models.count > 0)
        {
            [operation.responseData writeToFile:DQTextJokesCachePath atomically:YES];
        }
        
        if(models.count > 6)
        {
            [models insertObject:[self createADModel] atIndex:6];
        }
        
        dispatch_main_sync_safe(^{
            strongify(self);
            if(models.count > 0)
            {
                self.models = models;
                [self.tableView reloadData];
            }
            [self.tableView performSelector:@selector(finishRefresh) withObject:nil afterDelay:0.5];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        strongify(self);
        [self.tableView performSelector:@selector(stopRefresh) withObject:nil afterDelay:0.5];
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
    [params setValue:@(_requestType) forKey:@"type"];
    [params setValue:lastModel.createdAt forKey:@"lastTime"];
    [params setValue:@(lastModel.rowIndex) forKey:@"lastId"];
    weakify(self);
    self.op_loadmore = [DQNetworkHelper method:@"i_just_is_a_get_method" params:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSData dictionaryWithJSONData:operation.responseData];
        NSArray* array = [dic objectForKey:@"result"];
        NSMutableArray* models = [NSMutableArray arrayWithArray:[array toModels:DQJokesModel.class]];
        [models enumerateObjectsUsingBlock:^(DQJokesModel* obj, NSUInteger idx, BOOL *stop) {
            strongify(self);
            if([self.deleteObjectIds containsObject:obj.objectId])
            {
                [models removeObject:obj];
            }
        }];
        dispatch_main_sync_safe(^{
            strongify(self);
            if(models.count > 0)
            {
                NSMutableArray* allModels = [NSMutableArray arrayWithArray:self.models];
                [allModels addObjectsFromArray:models];
                
                self.models = allModels;
                [self.tableView reloadData];
            }
            [self.tableView performSelector:@selector(finishLoadMore) withObject:nil afterDelay:0.5];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        strongify(self);
        [self.tableView performSelector:@selector(stopLoadMore) withObject:nil afterDelay:0.5];
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
    {
        return;
    }
    DQTextJokesCell* cell = (id)sender.view;
    DQJokesModel* model = cell.model;
    
    if(model.type == DQJokesModelTypeYouMiAD)
    {
        [[DQAppInfo shareAppInfo] showADView];
    }
    else
    {
        SYSSPasteboardView* paste = [SYSSPasteboardView shareInstance];
        [paste setPasteCopyBlock:^{
            [UIPasteboard generalPasteboard].string = model.content;
            [UIWindow showToastMessage:@"已复制~ 您可以粘贴给你的小伙伴啦！！！"];
        }];
        ///假的举报
        [paste setPasteReportBlock:^{
            [DQNetworkHelper method:@"i_just_is_a_report_method" params:@{@"id":model.objectId} success:nil failure:nil];
            [UIWindow showToastMessage:@"感谢您的举报~"];
        }];
        weakify(self)
        [paste setPasteDeleteBlock:^{
            strongify(self);
            NSMutableArray* models = [NSMutableArray arrayWithArray:self.models];
            [models removeObject:model];
            
            [self.deleteObjectIds addObject:model.objectId];
            self.models = models;
            [self.tableView reloadData];
        }];
        [paste showMenuWithView:cell inView:self.tableView];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DQJokesModel* model = _models[indexPath.row];
    if(model.type == DQJokesModelTypeYouMiAD)
    {
        [[DQAppInfo shareAppInfo] showADView];
    }
    
    if(model.url.length)
    {
        TOWebViewController* vc = [[TOWebViewController alloc] initWithURLString:model.url];
        [self lk_push:vc];
    }
}
#pragma mark- photo browser
-(void)showPhotoWithImageView:(UIImageView*)imageView
{
    DQTextJokesCell* cell = [imageView findViewParentWithClass:[DQTextJokesCell class]];
    if(cell.model.type == DQJokesModelTypeYouMiAD)
    {
        [[DQAppInfo shareAppInfo] showADView];
        return;
    }
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
