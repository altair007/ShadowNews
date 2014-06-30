//
//  SNShadowNewsModel.h
//  ShadowNews
//
//  Created by   颜风 on 14-6-30.
//  Copyright (c) 2014年 ShadowNews. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  数据模型类.
 */
@interface SNShadowNewsModel : NSObject

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
