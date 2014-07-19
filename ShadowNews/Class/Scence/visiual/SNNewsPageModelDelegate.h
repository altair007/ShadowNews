//
//  SNNewsPageModelDelegate.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-19.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  新闻页面数据模型代理.
 */
@protocol SNNewsPageModelDelegate <NSObject>
/**
 *  获取数据成功时,执行此 block.
 *
 *  @param array 一个数组,存储请求到的数据对象.
 */
typedef void(^SNNewsPageModelSuccessBlock)(id responseObject);

/**
 *  获取数据失败时,执行此 block.
 *
 *  @param error 存储有错误信息.
 */
typedef void(^SNNewsPageModelFailBlock)(NSError * error);

@required
/**
 *  获取某一新闻版块的新闻.
 *
 *  @param title   新闻版块名称.
 *  @param range   要获取的新闻范围,即新闻的起始位置和新闻条数.
 *  @param success 获取数据成功,执行此 block.
 *  @param fail    获取数据失败,执行此 block.
 */
- (void) newsForTopic: (NSString *) topic
                range: (NSRange) range
              success: (SNNewsPageModelSuccessBlock) success
                 fail: (SNNewsPageModelFailBlock) fail;
@end