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
@optional
/**
 *  点击了返回按钮
 *
 *  @param newsDetailView 新闻详情视图.
 *  @param button         返回按钮.
 */
- (void) newsDetailView: (SNNewsDetailView *) newsDetailView didClickBackButtonAction: (UIButton *) button;

/**
 *  点击了查看评论按钮.
 *
 *  @param newsDetailView 新闻详情视图.
 *  @param button         查看评论按钮.
 */
- (void) newsDetailView:(SNNewsDetailView *)newsDetailView didClickScanReplyButtonAction:(UIButton *)button;

/**
 *  点击了分享按钮.
 *
 *  @param newsDetailView 新闻详情视图.
 *  @param button         分享按钮.
 */
- (void) newsDetailView:(SNNewsDetailView *)newsDetailView didClickShareButtonAction:(UIButton *)button;

/**
 *  点击了收藏按钮.
 *
 *  @param newsDetailView 新闻详情视图.
 *  @param button         收藏按钮.
 */
- (void) newsDetailView:(SNNewsDetailView *)newsDetailView didClickFavorButtonAction:(UIButton *)button;

@end

// !!!: 建议,此类可以设置成单例,实现复用.(或者把其设置成控制器的一个属性,持有它!即把控制器设置成一个单例!)
@interface SNNewsDetailView : UIView
@property (assign, nonatomic) id<SNNewsDetailViewDelegate> delegate; //!< 行为代理.
@property (assign, nonatomic) id<SNNewsDetailViewDataSource> dataSource; //!< 数据代理.

/**
 *   重新加载数据.
 */
// !!!: 这个方法,似乎暂时没有存在的价值.
- (void)reloadData;
@end
