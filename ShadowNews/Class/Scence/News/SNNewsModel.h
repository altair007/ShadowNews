//
//  SNNewsModel.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-6.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SNNewsMenu;

/**
 *  新闻数据模型.
 */
@interface SNNewsModel : NSObject
@property (retain, nonatomic) SNNewsMenu * menu; //!< 新闻菜单.

/**
 *  便利构造器.
 *
 *  @return 实例对象.
 */
+ (instancetype)model;

@end
