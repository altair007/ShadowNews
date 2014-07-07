//
//  SNNewsViewCell.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-7.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *   新闻视图单元格.
 */
@interface SNNewsViewCell : UITableView
// !!!:分析下tableView的contentSize,看一下它是实现的cell的复用,还是tabel本身大小(高度)的复用!
@property (copy, nonatomic, readonly) NSString * title; //!< 新闻板块名称.

/**
 *  便利初始化.
 *
 *  @param title 新闻板块名称.
 *
 *  @return 实例对象.
 */
+ (instancetype)cellWithTitle: (NSString *) title;

/**
 *  便利初始化.
 *
 *  @param title 新闻板块名称.
 *
 *  @return 实例对象.
 */
- (instancetype)initWithTitle: (NSString *) title;

@end
