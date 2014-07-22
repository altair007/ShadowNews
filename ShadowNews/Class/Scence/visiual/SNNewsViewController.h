//
//  SNNewsViewController.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-18.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNNewsViewController : UIViewController
@property (retain, nonatomic) IBOutlet UISegmentedControl *navSC; //!< 导航栏,用于在不同新闻板块间切换.
@property (retain, nonatomic) UIViewController * embedVC; //!< 用于展示内容的控制器.
@property (retain, nonatomic) NSString * category; //!< 分类.

/**
 *  分段控件的事件响应方法.
 *
 *  @param segmentedCtl 分段控件.
 */
- (IBAction)handleSegmentedControlValueChangedAction:(UISegmentedControl *)segmentedCtl;

/**
 *  用于从其他页面直接跳转回本页面.
 *
 *  @param segue segue对象.
 */
- (IBAction) backToMainPage: (UIStoryboardSegue *) segue;

/**
 *  获取当前新闻主题.
 *
 *  @return 当前新闻主题.
 */
- (NSString *) currentTopic;

@end
