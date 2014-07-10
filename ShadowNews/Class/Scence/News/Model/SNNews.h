//
//  SNNews.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-7.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <Foundation/Foundation.h>

// !!!: 重新设计新闻类型.
/**
 *  新闻对象,用于表示单条新闻概要.
 */
@interface SNNews : NSObject
@property (copy, nonatomic, readonly) NSString * imgSrc; //!< 主题图片网址.
@property (copy, nonatomic, readonly) NSString * title; //!< 新闻标题.
@property (copy, nonatomic, readonly) NSString * digest; //!< 摘要.
@property (assign, nonatomic, readonly) NSUInteger replyCount; //!< 跟帖数.
@property (copy, nonatomic, readonly) NSString * docId; //!< 文章唯一标识.

/**
 *  便利构造器.
 *
 *  @param imgSrc     主题图片网址.
 *  @param title      新闻标题.
 *  @param pulishTime 发表时间.
 *  @param replyCount 跟帖数.
 *  @param docId      文章唯一标识.
 *
 *  @return 实例对象.
 */
+ (instancetype) newsWithImgSrc: (NSString *) imgSrc
                          title: (NSString *) title
                    publishTime: (NSString *) pulishTime
                     replyCount: (NSUInteger) replyCount
                          docId: (NSString *) docId;

/**
 *  便利初始化.
 *
 *  @param imgSrc     主题图片网址.
 *  @param title      新闻标题.
 *  @param pulishTime 发表时间.
 *  @param replyCount 跟帖数.
 *  @param docId      文章唯一标识.
 *
 *  @return 实例对象.
 */
- (instancetype) initWithImgSrc: (NSString *) imgSrc
                          title: (NSString *) title
                    publishTime: (NSString *) pulishTime
                     replyCount: (NSUInteger) replyCount
                          docId: (NSString *) docId;

@end
