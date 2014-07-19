//
//  SNNewsDetailModelDelegate.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-19.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  获取数据成功时,执行此 block.
 *
 *  @param array 一个数组,存储请求到的数据对象.
 */
typedef void(^SNNewsDetailModelSuccessBlock)(id responseObject);

/**
 *  获取数据失败时,执行此 block.
 *
 *  @param error 存储有错误信息.
 */
typedef void(^SNNewsDetailModelFailBlock)(NSError * error);

@protocol SNNewsDetailModelDelegate <NSObject>
@required
/**
 *  根据新闻唯一标识符获取新闻详情.
 *
 *  @param docId   新闻唯一标识符.
 *  @param success 获取新闻详情成功时执行的 block.
 *  @param fail    获取新闻详情失败时执行的 block.
 */
- (void) detailModelWithDocId: (NSString *) docId
                      success: (SNNewsDetailModelSuccessBlock) success
                         fail: (SNNewsDetailModelFailBlock) fail;

@end
