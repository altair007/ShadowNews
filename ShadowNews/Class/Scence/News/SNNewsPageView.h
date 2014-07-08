//
//  SNNewsPageView.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-7.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *   新闻视图的单个页面.
 */
@interface SNNewsPageView : UITableView
// !!!:分析下tableView的contentSize,看一下它是实现的cell的复用,还是tabel本身大小(高度)的复用!
@property (copy, nonatomic, readonly) NSString * title; //!< 新闻板块名称.
@property (assign, nonatomic) BOOL preLoad; //!< 是否是预加载.出于用户体验的考虑,新闻视图可能会预加载某些页面.对于预加载的页面,往往可以暂不发起网络请求,获取最新数据.

/**
 *  便利初始化.
 *
 *  @param title 新闻板块名称.
 *  @param preLoad YES,是预加载;NO,不是预加载.
 *
 *  @return 实例对象.
 */
+ (instancetype)pageWithTitle: (NSString *) title
                      preLoad: (BOOL) preLoad;

/**
 *  便利初始化.
 *
 *  @param title   新闻板块名称.
 *  @param preLoad YES,是预加载;NO,不是预加载.
 *
 *  @return 实例对象.
 */
- (instancetype)initWithTitle: (NSString *) title
                      preLoad: (BOOL) preLoad;

@end
