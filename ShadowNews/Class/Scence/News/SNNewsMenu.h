//
//  SNNewsMenu.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-6.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  新闻菜单.
 */
@interface SNNewsMenu : NSObject

@property (retain, nonatomic) NSArray * itemsAdded; //!< 用户已添加的栏目.
@property (retain, nonatomic) NSArray * itemsNotAdded; //!< 用户未添加的栏目.
@property (copy, nonatomic) NSString * itemLastScan; //!< 用户最后一次浏览的栏目.

/**
 *  便利构造器.
 *
 *  @return 新闻菜单实例对象.
 */
+(instancetype) menu;

@end
