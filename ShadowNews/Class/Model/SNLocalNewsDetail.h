//
//  SNLocalNewsDetail.h
//  ShadowNews
//
//  Created by   颜风 on 14-6-30.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  本地新闻详情.
 */
@interface SNLocalNewsDetail : NSObject
#pragma mark - 属性
@property (copy, nonatomic, readonly) NSString * title; //!< 文章标题.
@property (copy, nonatomic, readonly) NSString * source; //!< 来源.
@property (copy, nonatomic, readonly) NSString * publishTime; //!< 发表时间.
@property (assign, nonatomic, readonly) NSUInteger replyCount; //!< 跟帖数.
@property (copy, nonatomic, readonly) NSString * sourceUrl; //!< 文章原文地址.
@property (copy, nonatomic, readonly) NSString * templateType; //!< 模板类型.
@property (copy, nonatomic, readonly) NSString * body; //!< 新闻主要内容.

#pragma mark - 方法

@end
