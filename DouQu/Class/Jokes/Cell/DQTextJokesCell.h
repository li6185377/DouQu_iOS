//
//  DQTextJokesCell.h
//  DouQu
//
//  Created by ljh on 14/12/15.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DQJokesModel.h"

@interface DQTextJokesCell : UITableViewCell
@property(strong,nonatomic)UILabel* lb_publisher;
@property(strong,nonatomic)UILabel* lb_content;
@property(strong,nonatomic)UIImageView* img_content;

@property(strong,nonatomic)UIImageView* all_content_bg;

@property(strong,nonatomic)DQJokesModel* model;

+(int)cellHeightWithModel:(DQJokesModel*)model;
@end
