//
//  SNNewsViewController.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-6.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNNewsView.h"


/**
 *  新闻页面控制器.
 */
@interface SNNewsViewControllerT : UIViewController<SNNewsViewDelegate, SNNewsViewDataSource>
@property (retain, nonatomic) id<SNNewsModelDelegateT> model; //!< 新闻数据模型.

@end
