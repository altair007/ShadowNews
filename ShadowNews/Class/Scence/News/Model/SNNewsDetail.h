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
@property (copy, nonatomic, readonly) NSString * docId; //!< 文章唯一标识符.
@property (assign, nonatomic, readonly) NSUInteger replyCount; //!< 回帖数.
@property (copy, nonatomic, readonly) NSString * htmlStr; //!< 新闻详情.

/**
 *  便利构造器.
 *
 *  @param docId      唯一文章标识符.
 *  @param replyCount 回帖数.
 *  @param htmlStr    新闻详情.
 *
 *  @return 实例对象.
 */
+ (instancetype) detailWithDocId: (NSString *) docId
                      replyCount: (NSUInteger) replyCount
                         htmlStr: (NSString *) htmlStr;

/**
 *  便利初始化.
 *
 *  @param docId      唯一文章标识符.
 *  @param replyCount 回帖数.
 *  @param htmlStr    新闻详情.
 *
 *  @return 实例对象.
 */
- (instancetype) initWithDocId: (NSString *) docId
                    replyCount: (NSUInteger) replyCount
                       htmlStr: (NSString *) htmlStr;
@end
