//
//  SNLocalPageModel.h
//  ShadowNews
//
//  Created by   颜风 on 14-6-30.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  获取数据成功时,执行此 block.
 *
 *  @param array 一个数组,存储本地新闻对象.
 */
typedef void(^SNLocalPageModelSuccessBlock)(NSArray * localNewsArray);

/**
 *  获取数据失败时,执行此 block.
 *
 *  @param error 存储有错误信息.
 */
typedef void(^SNLocalPageModelFailBlock)(NSError * error);

/**
 *  本地新闻页面的数据模型.
 */
@interface SNLocalPageModel : NSObject

/**
*  获取某个城市的本地新闻.
*
*  @param city    城市名.
*  @param range   要获取的新闻范围,即新闻的起始位置和新闻条数.
*  @param success 获取数据成功,执行此 block.
*  @param fail    获取数据失败,执行此 block.
*/
+ (void) local: (NSString *) city
         range: (NSRange) range
       success: (SNLocalPageModelSuccessBlock) success
          fail: (SNLocalPageModelFailBlock) faill;
@end
