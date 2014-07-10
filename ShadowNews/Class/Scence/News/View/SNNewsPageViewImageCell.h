//
//  SNNewsPageViewImageCell.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-10.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SNNews;

/**
 *  页面大图风格单元格,常用来显示第一条新闻.
 */
@interface SNNewsPageViewImageCell : UITableViewCell
@property(nonatomic,retain) SNNews * news; //!< 单条新闻.
@end
