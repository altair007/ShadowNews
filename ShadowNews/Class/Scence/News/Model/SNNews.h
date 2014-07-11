//
//  SNNews.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-7.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  跳转类型.
 */
typedef enum{
    SNNewsSkipTypeDoc, //!< 跳转至文章.
    SNNewsSkipTypePhotoSet //!< 跳转至图集.
} SNNewsSkipType;

// !!!: 或许应该加一个代理方法,来指明视图由预加载变为了加载,这样,分页视图代理就不必监测 preLoad属性了.而且,这样更灵活些.(没必要.)
// !!!: 重新设计新闻类型.
/**
 *  新闻对象,用于表示单条新闻概要.
 */
// !!!!: 方法命名不合适.
@interface SNNews : NSObject
@property (retain, nonatomic, readonly) NSArray * imgs; //!< 存储图片.
@property (copy, nonatomic, readonly) NSString * title; //!< 新闻标题.
@property (copy, nonatomic, readonly) NSString * digest; //!< 摘要.
@property (assign, nonatomic, readonly) NSUInteger replyCount; //!< 跟帖数.
@property (copy, nonatomic, readonly) NSString * docId; //!< 唯一文章标识.
@property (assign, nonatomic, readonly) SNNewsSkipType skipType; //!< 跳转类型.
@property (copy, nonatomic, readonly) NSString * photosetID; //!< 唯一图集标识.

/**
 *  便利构造器.用于创建跳转至文章的新闻概要.
 *
 *  @param docId      文章唯一标识.
 *  @param title      标题.
 *  @param digest     概要.
 *  @param replyCount 回帖数.
 *  @param imgs       新闻配图.
 *
 *  @return 实例对象.
 */
+ (instancetype) newsWithDocId: (NSString *) docId
                        tittle: (NSString *) title
                        digest: (NSString *) digest
                    replyCount: (NSUInteger) replyCount
                          imgs: (NSArray *) imgs;

/**
 *  便利构造器.用于创建跳转至图片的新闻概要.
 *
 *  @param photosetId 图集唯一标识.
 *  @param title      标题.
 *  @param digest     概要.
 *  @param replyCount 回帖数.
 *  @param imgs       新闻配图.
 *
 *  @return 实例对象.
 */
+ (instancetype) newsWithPhotosetId: (NSString *) photosetId
                             tittle: (NSString *) title
                             digest: (NSString *) digest
                         replyCount: (NSUInteger) replyCount
                               imgs: (NSArray *) imgs;
/**
 *  便利初始化.此方法将作为指定初始化方法而存在.
 *
 *  @param title      标题.
 *  @param digest     概要.
 *  @param replyCount 回帖数.
 *  @param imgs       新闻配图.
 *  @param skipType   跳转类型.
 *  @param docId      唯一文章标识.
 *  @param photosetId 唯一图集标识.
 *
 *  @return 实例对象.
 */
- (instancetype) initWithTittle: (NSString *) title
                         digest: (NSString *) digest
                     replyCount: (NSUInteger) replyCount
                           imgs: (NSArray *) imgs
                       skipType: (SNNewsSkipType) skipType
                          docId: (NSString *) docId
                     photosetId: (NSString *) photosetId;

/**
 *  便利初始化.用于初始化跳转至文章的新闻概要.
 *
 *  @param docId      唯一文章标识.
 *  @param title      标题.
 *  @param digest     概要.
 *  @param replyCount 回帖数.
 *  @param imgs       新闻配图.
 *
 *  @return 实例对象.
 */
- (instancetype) initWithDocId: (NSString *) docId
                        tittle: (NSString *) title
                        digest: (NSString *) digest
                    replyCount: (NSUInteger) replyCount
                          imgs: (NSArray *) imgs;

/**
 *  便利初始化.用于初始化跳转至图集的新闻概要.
 *
 *  @param photosetId 唯一文章标识.
 *  @param title      标题.
 *  @param digest     概要.
 *  @param replyCount 回帖数.
 *  @param imgs       新闻配图.
 *
 *  @return 实例对象.
 */
- (instancetype) initWithPhotosetId: (NSString *) photosetId
                             tittle: (NSString *) title
                             digest: (NSString *) digest
                         replyCount: (NSUInteger) replyCount
                               imgs: (NSArray *) imgs;

@end
