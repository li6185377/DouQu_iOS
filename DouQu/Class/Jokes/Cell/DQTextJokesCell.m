//
//  DQTextJokesCell.m
//  DouQu
//
//  Created by ljh on 14/12/15.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import "DQTextJokesCell.h"

@implementation DQTextJokesCell
- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.size = CGSizeMake(ScreenWidth, 44);
    
    self.selectedBackgroundView = [UIView new];
    
    self.all_content_bg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, self.width - 20, self.height - 10)];
    [self.contentView addSubview:_all_content_bg];
    
    self.lb_publisher = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 300, 16)];
    _lb_publisher.font = [UIFont systemFontOfSize:14];
    _lb_publisher.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_lb_publisher];
    
    self.lb_content = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, self.width - 40, self.height - 30)];
    _lb_content.lineBreakMode = NSLineBreakByCharWrapping;
    _lb_content.backgroundColor = [UIColor clearColor];
    _lb_content.numberOfLines = 0;
    _lb_content.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_lb_content];
    
    
    self.img_content = [[UIImageView alloc] initWithFrame:_lb_content.frame];
    _img_content.contentMode = UIViewContentModeScaleAspectFill;
    _img_content.clipsToBounds = YES;
    _img_content.loadedViewContentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_img_content];
    
    [self appThemeDidChanged];
    [[LKThemeManager shareThemeManager] addChangedListener:self];
}
-(void)appThemeDidChanged
{
    _all_content_bg.image = [UIImage imageCenterStretchName:@"all_kuang"];
    _all_content_bg.highlightedImage = [UIImage imageCenterStretchName:@"all_kuang_up"];
    
    _lb_publisher.textColor = colorWithBrown;
    _lb_content.textColor = colorWithBlack;
}
-(NSString *)reuseIdentifier
{
    return @"DQTextJokesCell";
}
-(void)setModel:(DQJokesModel *)model
{
    _model = model;
    
    if(model.type == DQJokesModelTypeYouMiAD)
    {
        _lb_content.textColor = colorWithRed__;
    }
    else
    {
        _lb_content.textColor = colorWithBlack;
    }
    
    int lastBottom = 5;
    
    if(model.publisher.length > 0)
    {
        NSString* screen_name = model.publisher;
        if([screen_name hasPrefix:@"@"] == NO)
        {
            screen_name = [@"@" stringByAppendingString:screen_name];
        }
        _lb_publisher.top = lastBottom + 10;
        _lb_publisher.text = model.publisher;
        
        lastBottom = _lb_publisher.bottom;
    }
    else
    {
        _lb_publisher.text = nil;
    }
    
    if(model.content.length > 0)
    {
        _lb_content.top = lastBottom + 10;
        _lb_content.width = self.width - 40;
        _lb_content.text = model.content;
        [_lb_content sizeToFit];
        
        lastBottom = ceil(_lb_content.bottom);
    }
    else
    {
        _lb_content.text = nil;
    }
    
    if(model.image.length > 0)
    {
        _img_content.hidden = NO;
        _img_content.top = lastBottom + 10;
        _img_content.size = dq_sizeWithImageSize(model.image.lastComponentOriginalImageSize, CGSizeMake(self.width-40, 2000));
        
        _img_content.imageURL = model.image;
        
        lastBottom = _img_content.bottom;
    }
    else
    {
        _img_content.hidden = YES;
        _img_content.image = nil;
    }
    
    model.textCellHeight = lastBottom + 15;
    _all_content_bg.height = model.textCellHeight - 10;
    self.height = model.textCellHeight;
}
+(int)cellHeightWithModel:(DQJokesModel *)model
{
    int lastBottom = 5;
    
    if(model.publisher.length > 0)
    {
        lastBottom = lastBottom + 10 + 16;
    }
    
    if(model.content.length > 0)
    {
        CGSize size = [model.content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(ScreenWidth-40, INT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
        
        lastBottom = lastBottom + 10 + ceil(size.height);
    }
    
    if(model.image.length > 0)
    {
        CGSize size = dq_sizeWithImageSize(model.image.lastComponentOriginalImageSize, CGSizeMake(ScreenWidth - 40, 2000));
        
        lastBottom = lastBottom + 10 + size.height;
    }
    model.textCellHeight = lastBottom + 15;
    return model.textCellHeight;
}
@end
