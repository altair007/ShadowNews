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
- (IBAction)handleSegmentedControlValueChangedAction:(UISegmentedControl *)sender;

@property (retain, nonatomic) UIViewController * embedVC; //!< 用于展示内容的控制器.



/**
 *  获取当前新闻主题.
 *
 *  @return 当前新闻主题.
 */
- (NSString *) currentTopic;

@end
