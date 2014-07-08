//
//  SNNewsDetailView.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-7.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SNNewsDetail;
@class SNNewsDetailView;


// !!!:所有的视图类,都应该提供 reloadData 方法.
/**
 *  新闻详情视图数据协议.
 */
@protocol SNNewsDetailViewDataSource <NSObject>
@required
/**
 *  设置用于新闻详情页面的新闻详情视图.
 *
 *  @param newsDetail 新闻详情视图对象.
 *
 *  @return 新闻详情对象.
 */
- (SNNewsDetail *) detailInNewsDetailView: (SNNewsDetailView *) newsDetailView;

@end

/**
 *  新闻详情视图行为协议.
 */
@protocol SNNewsDetailViewDelegate <NSObject>


@end
@interface SNNewsDetailView : UIView
@property (assign, nonatomic) id<SNNewsDetailViewDelegate> delegate; //!< 行为代理.
@property (assign, nonatomic) id<SNNewsDetailViewDataSource> dataSource; //!< 数据代理.

/**
 *   重新加载数据.
 */
- (void)reloadData;
@end
