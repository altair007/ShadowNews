//
//  SNNewsViewController.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-6.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

// !!!:去除所有不必要的单元格背景颜色信息.
// !!!:去除不必要的NSLog信息.
// !!!:建议给ScrollView加个好看的有意义的背景色或者背景图,最好是平铺的那种.
// !!!:当视图滑动时,此时不应该支持下拉.实测中真的会发生这种BUG?
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
