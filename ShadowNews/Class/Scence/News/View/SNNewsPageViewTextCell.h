//
//  SNNewsPageViewTextCell.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-13.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SNNews;

/**
 *  纯文本单元格.
 */
@interface SNNewsPageViewTextCell : UITableViewCell
@property(nonatomic,retain) SNNews * news; //!< 单条概要新闻.
@end
