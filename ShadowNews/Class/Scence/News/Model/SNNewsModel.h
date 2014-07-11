//
//  SNNewsModel.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-6.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SNNewsMenu;
@class YFDataBase;

// !!!: AFNetworking好像可以自动缓存请求的信息,包括图片.这样的话,如何清除缓存?
/**
 *  获取数据成功时,执行此 block.
 *
 *  @param array 一个数组,存储本地新闻对象.
 */
typedef void(^SNNewsModelSuccessBlock)(id responseObject);

/**
 *  获取数据失败时,执行此 block.
 *
 *  @param error 存储有错误信息.
 */
typedef void(^SNNewsModelFailBlock)(NSError * error);

/**
 *  新闻数据模型.
 */
@interface SNNewsModel : NSObject
@property (retain, nonatomic, readonly) SNNewsMenu * menu; //!< 新闻菜单.

/**
 *  便利构造器.
 *
 *  @return 实例对象.
 */
+ (instancetype)model;

/**
 *  获取某一新闻版块的新闻.
 *
 *  @param title   新闻版块名称.
 *  @param range   要获取的新闻范围,即新闻的起始位置和新闻条数.
 *  @param success 获取数据成功,执行此 block.
 *  @param fail    获取数据失败,执行此 block.
 */
+ (void) newsForTitle: (NSString *) title
                range: (NSRange) range
              success: (SNNewsModelSuccessBlock) success
                 fail: (SNNewsModelFailBlock) fail;

/**
 *  根据新闻唯一标识符获取新闻详情.
 *
 *  @param docId   新闻唯一标识符.
 *  @param success 获取新闻详情成功时执行的 block.
 *  @param fail    获取新闻详情失败时执行的 block.
 */
+ (void) detailModelWithDocId: (NSString *) docId
                      success: (SNNewsModelSuccessBlock) success
                         fail: (SNNewsModelFailBlock) fail;

/**
 *  获取数据库实例对象.
 *
 *  @return 应用程序公共的数据库实例对象.
 */
+ (YFDataBase *) db;

@end
