//
//  SNNewsViewController.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-6.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNNewsView.h"
@class  SNNewsModel;

@protocol SNNewsModelDelegate <NSObject>
@required
- (NSString *)title;

@end

/**
 *  新闻页面控制器.
 */
@interface SNNewsViewController : UIViewController<SNNewsViewDelegate, SNNewsViewDataSource>
@property (retain, nonatomic) SNNewsModel<SNNewsModelDelegate> * model; //!< 新闻数据模型.

@end
