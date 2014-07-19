//
//  SNNewsDetailViewController.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-7.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNNewsDetailView.h"
@interface SNNewsDetailViewControllerT : UIViewController<SNNewsDetailViewDataSource, SNNewsDetailViewDelegate>
// ???:直接异步传一个SNNewsDetail对象进来是不是更合适?
@property (copy, nonatomic) NSString * docId; //!< 唯一新闻标识符.
@property (retain, nonatomic) SNNewsDetailView * view; //!< 重新声明视图对象.

/**
 *  便利初始化.
 *
 *  @param docId 唯一文章标志符.
 *
 *  @return 实例对象.
 */
- (instancetype) initWIthDocId: (NSString *) docId;
@end
