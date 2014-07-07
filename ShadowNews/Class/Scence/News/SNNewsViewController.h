//
//  SNNewsViewController.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-6.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

// !!!:去除所有不必要的单元格信息.
#import <UIKit/UIKit.h>
#import "SNNewsView.h"
@class  SNNewsModel;

// !!!:必须尽快做出"菜单"和"用户"界面.

/**
 *  新闻页面控制器.
 */
@interface SNNewsViewController : UIViewController<SNNewsViewDelegate, SNNewsViewDataSource>
@property (retain, nonatomic) SNNewsModel * model; //!< 数据模型.

@end
