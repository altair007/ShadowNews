//
//  SNNewsPageViewCell.h
//  ShadowNews
//
//  Created by 颜风. on 14-6-28.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

// !!!:使用约束语法,改造下.
#import <UIKit/UIKit.h>
@class SNNews;

@interface SNNewsPageViewCell : UITableViewCell
@property(nonatomic,retain) SNNews * news; //!< 单条概要新闻.

@end
