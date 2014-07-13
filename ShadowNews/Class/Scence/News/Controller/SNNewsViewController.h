//
//  SNNewsViewController.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-6.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

// !!!:去除所有不必要的单元格背景颜色信息.
#import <UIKit/UIKit.h>
#import "SNNewsView.h"
@class  SNNewsModel;

// !!!:建议主控制器持有一个属性,表示"模式"的属性:夜间模式或者白天.
/**
 *  新闻页面控制器.
 */
@interface SNNewsViewController : UIViewController<SNNewsViewDelegate, SNNewsViewDataSource>
@property (retain, nonatomic) SNNewsModel * model; //!< 数据模型.

@end
