//
//  SNNewsDetail.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-7.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <Foundation/Foundation.h>

// !!!:总感觉,"新闻详情"和"新闻",没必要分作两个不同的类.

/**
 *   新闻详情.
 */
@interface SNNewsDetail : NSObject
@property (copy, nonatomic, readonly) NSString * title; //!< 文章标题.
@property (copy, nonatomic, readonly) NSString * source; //!< 来源.
@property (copy, nonatomic, readonly) NSString * publishTime; //!< 发表时间.
@property (assign, nonatomic, readonly) NSUInteger replyCount; //!< 跟帖数.
@property (copy, nonatomic, readonly) NSString * sourceUrl; //!< 文章原文地址.
@property (copy, nonatomic, readonly) NSString * templateType; //!< 模板类型.
@property (copy, nonatomic, readonly) NSString * body; //!< 新闻主要内容.
@property (copy, nonatomic, readonly) NSString * docId; //!< 新闻唯一标识符.

/**
 *  便利构造器.
 *
 *  @param docId        新闻唯一标识符.
 *  @param title        文章标题.
 *  @param source       来源.
 *  @param publishTime  发表时间.
 *  @param replyCount   跟帖数.
 *  @param sourceUrl    文章原文地址.
 *  @param templateType 模板类型.
 *  @param body         新闻主要内容.
 *
 *  @return 实例对象.
 */
+ (instancetype) detailWithDocId: (NSString *) docId
                           title: (NSString *) title
                          source: (NSString *) source
                     publishTime: (NSString *) publishTime
                      replyCount: (NSUInteger) replyCount
                       sourceUrl: (NSString *) sourceUrl
                    templateType: (NSString *) templateType
                            body: (NSString *) body;

/**
 *  便利初始化.
 *
 *  @param docId        新闻唯一标识符.
 *  @param title        文章标题.
 *  @param source       来源.
 *  @param publishTime  发表时间.
 *  @param replyCount   跟帖数.
 *  @param sourceUrl    文章原文地址.
 *  @param templateType 模板类型.
 *  @param body         新闻主要内容.
 *
 *  @return 实例对象.
 */
- (instancetype) initWithDocId: (NSString *) docId
                         title: (NSString *) title
                        source: (NSString *) source
                   publishTime: (NSString *) publishTime
                    replyCount: (NSUInteger) replyCount
                     sourceUrl: (NSString *) sourceUrl
                  templateType: (NSString *) templateType
                          body: (NSString *) body;

@end
