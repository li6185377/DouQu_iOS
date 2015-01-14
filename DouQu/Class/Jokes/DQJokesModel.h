//
//  DQJokesModel.h
//  DouQu
//
//  Created by ljh on 14/12/14.
//  Copyright (c) 2014年 Jianghuai Li. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DQJokesModelType) {
    ///文字笑话
    DQJokesModelTypeText = 1,
    ///图片
    DQJokesModelTypeImage,
    ///广告
    DQJokesModelTypeYouMiAD
};

@interface DQJokesModel : NSObject

@property DQJokesModelType type;

@property(strong,nonatomic)NSString* title;
@property(strong,nonatomic)NSString* publisher;
@property(strong,nonatomic)NSString* image;
@property(strong,nonatomic)NSString* content;
@property(strong,nonatomic)NSString* url;

@property(strong,nonatomic)NSString* objectId;
@property(strong,nonatomic)NSString* createdAt;
@property(strong,nonatomic)NSString* updatedAt;
@property int rowIndex;

@property int textCellHeight;
@property int imageCellHeight;
@end
