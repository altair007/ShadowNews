//
//  SNNewsPageModel.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-19.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNNewsPageModelDelegate.h"

@interface SNNewsPageModel : NSObject <SNNewsPageModelDelegate>
@property (retain, nonatomic) NSDictionary * urlSegmentsOfAllTopics; //!< 存储所有新闻板块及其对应的url分段信息.系统将使用此分段信息请求数据.

/**
 *  初始化数据.
 */
- (void) setUpData;

/**
 *  获取某一新闻主题对应的URL.
 *
 *  @param topic 新闻主题.
 *  @param range 要获取的此主题下新闻的起始位置和条数.
 *
 *  @return 此新闻主题对应的URL.
 */
- (NSString *) urlForTopic: (NSString *) topic range: (NSRange) range;

/**
 *  获取某一新闻主题在请求数据时对应的信息.
 *
 *  @param topic 新闻主题名称.
 *
 *  @return 此某一新闻主题在请求数据时对应的信息.
 */
- (NSString *) urlSegmentForTopic: (NSString *) topic;

/**
 *  获取数据请求的基地址.
 *
 *  @return 数据请求的基地址.
 */
- (NSString *) baseUrl;

/**
 *  获取某一新闻主题进行数据请求时的基地址.
 *
 *  @param topic 新闻主题.
 *
 *  @return 此新闻主题进行数据请求时的基地址.
 */
- (NSString *) baseUrlForTopic: (NSString *) topic;

@end
