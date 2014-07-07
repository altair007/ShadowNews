//
//  SNNewsDelegate.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-7.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SNNewsViewCell;

/**
 *  新闻代理类.
 */
@interface SNNewsDelegate : NSObject <UITableViewDelegate, UITableViewDataSource>
@property (retain, nonatomic, readonly) SNNewsViewCell * cell; //!< 新闻板块名称.

/**
 *  便利构造器.
 *
 *  @param cell  新闻视图单元格对象.
 *
 *  @return 实例对象.
 */
+ (instancetype) delegateWithCell: (SNNewsViewCell *) cell;

/**
 *  便利初始化.
 *
 *  @param cell  新闻视图单元格对象.
 *
 *  @return 实例对象.
 */
- (instancetype) initWithCell: (SNNewsViewCell *) cell;

@end
