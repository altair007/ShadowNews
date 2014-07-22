//
//  SNNewsPageViewController.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-18.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNNewsPageModelDelegate.h"

/**
 *  新闻单页面控制器.
 */
@interface SNNewsPageViewController : UITableViewController

@property (retain, nonatomic) NSArray * newsArray; //!< 存储新闻的数组.
@property (copy, nonatomic) NSString * topic; // !< 新闻主题.
@property (retain, nonatomic) id<SNNewsPageModelDelegate> model; //!< 数据模型.

/**
 *  初始化数据.
 */
- (void) setUpData;

/**
 *  重新加载数据.
 */
- (void) reloadData;
@end
