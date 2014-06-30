//
//  SNLocalNewsDetailModel.h
//  ShadowNews
//
//  Created by   颜风 on 14-6-30.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SNLocalNewsDetailModel;

/**
 *  获取数据成功时,执行此 block.
 *
 *  @param model 本地新闻详情的一个实例对象.
 */
typedef void(^SNLocalNewsDetailModelSuccessBlock)(SNLocalNewsDetailModel * model);

/**
 *  获取数据失败时,执行此 block.
 *
 *  @param error 错误信息.
 */
typedef void(^SNLocalNewsDetailModelFailBlock)(NSError * error);

/**
 *  本地新闻详情数据模型.
 */
@interface SNLocalNewsDetailModel : NSObject
@property (copy, nonatomic, readonly) NSString * title; //!< 文章标题.
@property (copy, nonatomic, readonly) NSString * source; //!< 来源.
@property (copy, nonatomic, readonly) NSString * publishTime; //!< 发表时间.
@property (assign, nonatomic, readonly) NSUInteger replyCount; //!< 跟帖数.
@property (copy, nonatomic, readonly) NSString * sourceUrl; //!< 文章原文地址.
@property (copy, nonatomic, readonly) NSString * templateType; //!< 模板类型.
@property (copy, nonatomic, readonly) NSString * body; //!< 新闻主要内容.
@property (copy, nonatomic, readonly) NSString * docId; //!< 新闻唯一标识符.

/**
 *  根据新闻唯一标识符获取文章本地新闻详情.
 *
 *  @param docId   新闻唯一标识符.
 *  @param success 获取新闻详情成功时执行的 block.
 *  @param fail    获取新闻详情失败时执行的 block.
 */
+ (void) localNewsDetailModelWithDocId: (NSString *) docId
                               success: (SNLocalNewsDetailModelSuccessBlock) success
                                  fail: (SNLocalNewsDetailModelFailBlock) fail;

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
+ (instancetype) localNewsDetailModelWithDocId: (NSString *) docId
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
