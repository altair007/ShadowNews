//
//  SNMainController.h
//  ShadowNews
//
//  Created by   颜风 on 14-6-30.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SNShadowNewsModel;
@class SNNavigationController;

/**
 *  主控制器.
 */
@interface SNMainController : NSObject
#pragma mark - 属性.
@property (retain, nonatomic, readonly) SNShadowNewsModel * model; //!< 数据库模型.
@property (retain, nonatomic, readonly) SNNavigationController * navigationController; //!< 页面主导航栏
#pragma mark - 方法.
/**
 *  获取单例
 *
 *  @return 单例
 */
+ (instancetype) sharedInstance;

/**
 *  获取某个城市的本地新闻.
 *
 *  @param city  城市名.
 *  @param range 新闻范围,即新闻的起始位置和新闻条数.
 */
- (void) localNews: (NSString *) city
             range: (NSRange) range
           success: (void(^)(NSArray * array)) success
              fail: (void(^)(NSError * error)) fail;

@end
