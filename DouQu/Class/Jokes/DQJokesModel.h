//
//  DQJokesModel.h
//  DouQu
//
//  Created by ljh on 14/12/14.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DQJokesModel : NSObject
@property(strong,nonatomic)NSString* title;
@property(strong,nonatomic)NSString* publisher;
@property(strong,nonatomic)NSString* image;
@property(strong,nonatomic)NSString* content;
@property(strong,nonatomic)NSString* url;

@property(strong,nonatomic)NSString* objectId;
@property(strong,nonatomic)NSString* createdAt;
@property(strong,nonatomic)NSString* updatedAt;

@property int textCellHeight;
@property int imageCellHeight;
@end
