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

@end
