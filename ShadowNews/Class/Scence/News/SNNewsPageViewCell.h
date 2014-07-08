//
//  SNNewsPageViewCell.h
//  ShadowNews
//
//  Created by 颜风. on 14-6-28.
//  Copyright (c) 2014年 Shadow. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SNNews;

/**
 *  用于各个新闻页面的单元格类
 */
@interface SNNewsPageViewCell : UITableViewCell
@property(nonatomic,retain) SNNews * news; //!< 单条概要新闻.

@end