//
//  SNNewsDetailViewController.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-19.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNNewsDetailModelDelegate.h"

@interface SNNewsDetailViewController : UIViewController
@property (copy, nonatomic) NSString * docId; //!< 文章唯一标识符.
@property (retain, nonatomic) id<SNNewsDetailModelDelegate> model; //!< 数据模型.
@property (copy, nonatomic) NSString * detailHtmlStr; //!< 新闻详情,它是一个html格式的字符串.

@end
