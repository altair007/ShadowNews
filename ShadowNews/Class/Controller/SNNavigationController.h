//
//  SNNavigationController.h
//  ShadowNews
//
//  Created by 颜风 on 14-7-6.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  自定义导航控制器.
 */
@interface SNNavigationController : UINavigationController
/**
 *  获取单例对象.
 *
 *  @return 单例对象.
 */
+ (SNNavigationController *) sharedInstance;

@end
