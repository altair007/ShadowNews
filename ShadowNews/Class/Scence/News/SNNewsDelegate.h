//
//  SNNewsDelegate.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-7.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SNNewsPageView;
@class SNNewsModel;

/**
 *  新闻代理类.
 */
@interface SNNewsDelegate : NSObject <UITableViewDelegate, UITableViewDataSource>

/**
 *  便利构造器.
 *
 *  @param cell   新闻视图单元格对象.
 *  @param model  新闻数据模型.
 *
 *  @return 实例对象.
 */
//!!!: 不需要传Model进来.
+ (instancetype) delegateWithCell: (SNNewsPageView *) cell
                            model: (SNNewsModel *) model;

/**
 *  便利初始化.
 *
 *  @param cell  新闻视图单元格对象.
 *  @param model  新闻数据模型.
 *
 *  @return 实例对象.
 */
- (instancetype) initWithCell: (SNNewsPageView *) cell
                        model: (SNNewsModel *) model;

@end
