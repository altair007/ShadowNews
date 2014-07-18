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
@class SNNewsViewControllerT;

/**
 *  新闻代理类.
 */
@interface SNNewsDelegate : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (retain, nonatomic) SNNewsViewControllerT * newsVC;

/**
 *  便利构造器.
 *
 *  @param pageView     新闻视图单元格对象.
 *  @param model        新闻数据模型.
 *
 *  @return 实例对象.
 */
+ (instancetype) delegateWithPageView: (SNNewsPageView *) pageView;

/**
 *  便利初始化.
 *
 *  @param cell  新闻视图单元格对象.
 *  @param model  新闻数据模型.
 *
 *  @return 实例对象.
 */
- (instancetype) initWithPageView: (SNNewsPageView *) cell;

@end
